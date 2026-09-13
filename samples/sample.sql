-- SQL — tema testi.
-- DDL, DML, CTE, window fonksiyonları, trigger ve prosedür.

/* Blok yorum:
   şema oluşturma ve tip tanımları */

BEGIN;

CREATE SCHEMA IF NOT EXISTS yazilim_yolu AUTHORIZATION CURRENT_USER;

SET search_path TO yazilim_yolu, public;

CREATE TYPE seviye AS ENUM ('debug', 'info', 'warn', 'error');

CREATE TABLE IF NOT EXISTS kullanicilar (
    id          BIGSERIAL       PRIMARY KEY,
    eposta      VARCHAR(255)    NOT NULL UNIQUE,
    ad          TEXT            NOT NULL DEFAULT 'isimsiz',
    aktif       BOOLEAN         NOT NULL DEFAULT TRUE,
    bakiye      NUMERIC(12, 2)  NOT NULL DEFAULT 0.00 CHECK (bakiye >= 0),
    olusturuldu TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    meta        JSONB           NULL,
    CONSTRAINT eposta_gecerli CHECK (eposta LIKE '%@%')
);

CREATE TABLE gorevler (
    id           BIGINT       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    kullanici_id BIGINT       NOT NULL REFERENCES kullanicilar (id) ON DELETE CASCADE,
    baslik       TEXT         NOT NULL,
    tamamlandi   BOOLEAN      DEFAULT FALSE,
    oncelik      SMALLINT     CHECK (oncelik BETWEEN 1 AND 5),
    etiketler    TEXT[]       DEFAULT ARRAY[]::TEXT[],
    seviye_kodu  seviye       DEFAULT 'info',
    guncellendi  TIMESTAMP    WITHOUT TIME ZONE
);

CREATE UNIQUE INDEX CONCURRENTLY idx_gorev_baslik
    ON gorevler (kullanici_id, LOWER(baslik))
    WHERE tamamlandi IS FALSE;

ALTER TABLE gorevler ADD COLUMN IF NOT EXISTS notlar TEXT;

COMMENT ON TABLE gorevler IS 'Kullanıcı görevleri';

INSERT INTO kullanicilar (eposta, ad, bakiye, meta)
VALUES
    ('a@ornek.com', 'Ayşe', 120.50, '{"tema": "dark"}'::JSONB),
    ('b@ornek.com', 'Baran', 0, NULL)
ON CONFLICT (eposta) DO UPDATE
    SET ad = EXCLUDED.ad, bakiye = kullanicilar.bakiye + EXCLUDED.bakiye
RETURNING id, eposta;

UPDATE gorevler g
   SET tamamlandi = TRUE,
       guncellendi = CURRENT_TIMESTAMP
  FROM kullanicilar k
 WHERE g.kullanici_id = k.id
   AND k.aktif
   AND g.oncelik <= 2;

DELETE FROM gorevler
 WHERE tamamlandi = TRUE
   AND guncellendi < NOW() - INTERVAL '30 days';

WITH RECURSIVE sayac (n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM sayac WHERE n < 10
),
ozet AS (
    SELECT
        k.id,
        k.ad,
        COUNT(g.id)                                       AS gorev_sayisi,
        COUNT(*) FILTER (WHERE g.tamamlandi)              AS tamamlanan,
        COALESCE(AVG(g.oncelik), 0)::NUMERIC(4, 2)        AS ort_oncelik,
        STRING_AGG(DISTINCT g.baslik, ', ' ORDER BY g.baslik) AS basliklar
    FROM kullanicilar AS k
    LEFT OUTER JOIN gorevler AS g ON g.kullanici_id = k.id
    WHERE k.olusturuldu >= DATE '2026-01-01'
      AND k.eposta NOT ILIKE '%test%'
    GROUP BY k.id, k.ad
    HAVING COUNT(g.id) > 0
)
SELECT
    o.*,
    ROW_NUMBER()   OVER w                                   AS sira,
    RANK()         OVER (ORDER BY o.gorev_sayisi DESC)      AS derece,
    LAG(o.tamamlanan, 1, 0) OVER w                          AS onceki,
    SUM(o.gorev_sayisi)     OVER (PARTITION BY o.ad)        AS grup_toplam,
    CASE
        WHEN o.ort_oncelik >= 4 THEN 'yüksek'
        WHEN o.ort_oncelik >= 2 THEN 'orta'
        ELSE 'düşük'
    END                                                     AS oncelik_etiketi,
    (SELECT MAX(n) FROM sayac)                              AS ust_sinir
  FROM ozet AS o
 WHERE EXISTS (SELECT 1 FROM gorevler x WHERE x.kullanici_id = o.id)
    OR o.id IN (SELECT id FROM kullanicilar WHERE aktif IS NOT FALSE)
WINDOW w AS (ORDER BY o.gorev_sayisi DESC NULLS LAST)
 ORDER BY derece ASC, o.ad COLLATE "tr-TR"
 LIMIT 50 OFFSET 0;

CREATE OR REPLACE VIEW aktif_gorevler AS
SELECT * FROM gorevler WHERE NOT tamamlandi;

CREATE OR REPLACE FUNCTION dokunuldu()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    sayac INTEGER := 0;
BEGIN
    IF TG_OP = 'UPDATE' THEN
        NEW.guncellendi := NOW();
    ELSIF TG_OP = 'INSERT' THEN
        NEW.guncellendi := NULL;
    END IF;

    WHILE sayac < 3 LOOP
        sayac := sayac + 1;
    END LOOP;

    RETURN NEW;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'hata: %', SQLERRM;
        RETURN OLD;
END;
$$;

CREATE TRIGGER trg_gorev_dokunuldu
    BEFORE INSERT OR UPDATE ON gorevler
    FOR EACH ROW EXECUTE FUNCTION dokunuldu();

GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA yazilim_yolu TO PUBLIC;

COMMIT;
