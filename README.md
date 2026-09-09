# Yazılım Yolu — VS Code Teması

Yazılım Yolu şirket logosunun üç renginden türetilmiş bir VS Code tema paketi.
Hem **koyu** hem **açık** varyant içerir.

## Marka renkleri

| Renk        | Hex       | Kullanım                                    |
| ----------- | --------- | ------------------------------------------- |
| Mor         | `#7C3BED` | Ana vurgu — butonlar, rozetler, imleç çizgisi, sekme üst çizgisi |
| Turkuaz     | `#3ABACD` | İkincil vurgu — imleç, bağlantılar, arama eşleşmeleri |
| Lacivert    | `#232D5B` | Koyu temanın zemin tonu, açık temada gölge/kaydırma |

Arayüz (workbench) kroması bu üç tona sadık kalır; zeminler logo lacivertinden
türetilip göz yormayacak biçimde yumuşatılmıştır.

Kod dosyalarında ise bluloco tarzı, daha zengin bir sözdizimi paleti kullanılır —
üç marka tonundan yola çıkıp okunabilirlik için açık/koyu zemine göre parlaklık
ve doygunluğu ayarlanmış ~10 ayrı renk: mor/lavanta (anahtar kelime), köprü
mavisi (fonksiyon), yeşil-turkuaz (string), turkuaz (regexp), teal (tip/sınıf),
amber (sayı/sabit), sarı (dekoratör/makro), gül (etiket, `this`/`self`).
Palet TypeScript/JSX, Python, Rust, Go, C/C++, C#, Java, PHP, Ruby, CSS/SCSS,
JSON, YAML, TOML, SQL, GraphQL, Markdown, Dockerfile ve shell kapsamları için
ayrıca ayarlanmıştır.

## İçindekiler

- **Yazılım Yolu Dark**
- **Yazılım Yolu Light**

## Kurulum (yerel)

```bash
npm install -g @vscode/vsce
cd vscode-theme
vsce package
code --install-extension yazilim-yolu-theme-0.2.0.vsix
```

Ya da geliştirme için: klasörü VS Code'da açıp `F5` ile Extension Development
Host başlatın, ardından **Ctrl+K Ctrl+T** ile temayı seçin.

## Yayınlama

`package.json` içindeki `publisher` alanını kendi Marketplace publisher kimliğinizle
güncelleyin, sonra `vsce publish`.
