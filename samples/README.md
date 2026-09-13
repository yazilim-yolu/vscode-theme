# Tema Test Dosyaları

Bu klasör temanın gerçek kodda nasıl göründüğünü denemek için hazırlanmış örnek
dosyaları içerir. Her dosya ilgili dilin **neredeyse tüm anahtar kelimelerini**,
sayı/metin literal biçimlerini, yorum türlerini ve tipik sözdizimi yapılarını
kapsar.

Bunlar derlenmek veya çalıştırılmak için değil, **renklendirmeyi görmek** için
yazılmıştır.

## Dosyalar

| Dosya | Dil | Öne çıkanlar |
| --- | --- | --- |
| [sample.ts](sample.ts) | TypeScript | tipler, generic, decorator, enum, namespace, `satisfies`, `using` |
| [sample.tsx](sample.tsx) | React / JSX | bileşenler, hook'lar, JSX öznitelikleri, koşullu render |
| [sample.py](sample.py) | Python | f-string, dekoratör, `match/case`, tip ipuçları, async |
| [sample.rs](sample.rs) | Rust | makro, lifetime, trait, `impl`, pattern matching, `unsafe` |
| [sample.go](sample.go) | Go | goroutine, kanal, interface, generic, `defer/recover` |
| [sample.c](sample.c) | C | preprocessor, storage class, union, fonksiyon işaretçisi |
| [sample.cpp](sample.cpp) | C++ | template, concept, lambda, `constexpr`, RAII |
| [sample.cs](sample.cs) | C# | record, LINQ, pattern matching, `async`, nullable |
| [Sample.java](Sample.java) | Java | record, sealed, stream, metin bloğu, generic |
| [sample.php](sample.php) | PHP | enum, trait, attribute, heredoc/nowdoc, HTML karışımı |
| [sample.rb](sample.rb) | Ruby | modül, mixin, blok/proc/lambda, sembol, heredoc |
| [sample.css](sample.css) | CSS | custom property, at-rule, seçici çeşitleri, `@layer` |
| [sample.scss](sample.scss) | SCSS | değişken, mixin, `@each/@for/@while`, iç içe kural |
| [sample.json](sample.json) | JSON | tüm değer tipleri, iç içe nesne ve dizi |
| [sample.yaml](sample.yaml) | YAML | anchor/alias, blok skaler, akış stili, etiket |
| [sample.toml](sample.toml) | TOML | tablo dizisi, satır içi tablo, tarih, çok satırlı metin |
| [sample.ini](sample.ini) | INI | bölüm, yorum çeşitleri, değişken genişletme |
| [sample.sql](sample.sql) | SQL | DDL/DML, CTE, window fonksiyonu, trigger, `plpgsql` |
| [sample.graphql](sample.graphql) | GraphQL | şema, direktif, fragment, sorgu/mutasyon/abonelik |
| [sample.md](sample.md) | Markdown | başlık, tablo, kod bloğu, dipnot, ham HTML |
| [Dockerfile](Dockerfile) | Dockerfile | çok aşamalı derleme, `ARG/ENV`, `HEALTHCHECK` |
| [sample.sh](sample.sh) | Shell | parametre genişletme, `trap`, here-doc, dizi |
| [Makefile](Makefile) | Make | otomatik değişken, `define`, koşullu blok, desen kuralı |

## Kullanım

1. Temayı seç: **Ctrl+K Ctrl+T** → *Yazılım Yolu Dark* / *Light*.
2. Bu klasördeki dosyaları sırayla aç.
3. Bir kapsamın rengini merak edersen imleci üstüne koyup
   **Ctrl+Shift+P → Developer: Inspect Editor Tokens and Scopes** komutunu çalıştır;
   TextMate kapsamını ve hangi kuralın eşleştiğini gösterir.

> Bu klasör `.vscodeignore` ile paketleme dışında tutulur; yayınlanan eklentiye
> dahil edilmez.
