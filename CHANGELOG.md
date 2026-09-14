# Değişiklik Günlüğü

## 1.0.0

İlk sürüm.

- Dört varyant:
  - **Yazılım Yolu Dark**
  - **Yazılım Yolu Extra Dark**: Dark'ın daha koyu zeminli hâli, sözdizimi
    renkleri aynı.
  - **Yazılım Yolu Light**
  - **Yazılım Yolu Soft Light**: Light'ın daha az parlak, daha düşük
    kontrastlı hâli.
- Renkler şirket logosundaki mor (`#7C3BED`), turkuaz (`#3ABACD`) ve lacivert
  (`#232D5B`) tonlarına dayanır.
- Arayüz:
  - Koyu temaların zeminleri logo lacivertinden türetilmiştir.
  - Mor ana vurgu rengidir: butonlar, odak çerçevesi, kenar çubuğu sayaçları.
  - Turkuaz aktiflik vurgusudur: etkinlik çubuğundaki aktif ikon ve bildirim
    rozeti, aktif sekme çizgisi, imleç, bağlantılar, arama eşleşmeleri.
  - VS Code'un modern arayüz düzeninde de aktif ikon rengi temadan gelir
    (`modernActivityBarItem.activeForeground`).
- Sözdizimi paleti ~10 ayrı tondan oluşur: mor/lavanta (anahtar kelime), köprü
  mavisi (fonksiyon), yeşil-turkuaz (string), turkuaz (regexp), teal
  (tip/sınıf), amber (sayı/sabit), sarı (dekoratör/makro), gül (etiket,
  `this`/`self`). Koyu temada renkli sözdizimi tokenlarının tümü editör
  zeminine karşı 5:1 kontrastın üzerindedir.
- Dile özgü kapsamlar: TypeScript/JSX, Python, Rust, Go, C/C++, C#, Java, PHP,
  Ruby, CSS/SCSS/LESS, JSON, YAML, TOML, INI, SQL, GraphQL, Markdown,
  Dockerfile, Makefile, shell.
- Anlamsal (semantic) token renkleri, terminal ANSI renkleri, git dekorasyonları
  ve diff renkleri tanımlıdır.
