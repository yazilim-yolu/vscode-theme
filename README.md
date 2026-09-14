# Yazılım Yolu — VS Code Teması

Yazılım Yolu şirket logosunun üç renginden türetilmiş bir VS Code tema paketi.
İki koyu ve iki açık olmak üzere dört varyant içerir.

## Marka renkleri

| Renk     | Hex       | Kullanım                                                                                 |
| -------- | --------- | ---------------------------------------------------------------------------------------- |
| Mor      | `#7C3BED` | Ana vurgu: butonlar, odak çerçevesi, kenar çubuğu sayaçları, anahtar kelimeler           |
| Turkuaz  | `#3ABACD` | Aktiflik vurgusu: etkinlik çubuğu, aktif sekme, imleç, bağlantılar, arama eşleşmeleri    |
| Lacivert | `#232D5B` | Koyu temanın zemin tonu, açık temada gölge/kaydırma                                      |

Arayüz (workbench) kroması bu üç tona sadık kalır. Koyu temanın zeminleri logo
lacivertinden türetilmiştir; doygunluğu korunur (~%46) ama hue'su bir miktar
maviye alınır (232° → ~222°) ve açıklığı düşürülür. Bu sapma bilinçlidir:
lacivertin kendi hue'su geniş ve çok koyu bir zemin olarak, üstelik mor
vurguların yanında kullanıldığında mora kayıyor.

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
- **Yazılım Yolu Extra Dark**: Dark'ın daha koyu zeminli hâli, sözdizimi renkleri aynı.
- **Yazılım Yolu Light**
- **Yazılım Yolu Soft Light**: Light'ın daha az parlak, daha düşük kontrastlı hâli.

Extra Dark ve Soft Light dosyaları elle düzenlenmez, Dark ve Light'tan
[`scripts/build-variants.js`](scripts/build-variants.js) ile üretilir. Ana temalardan
birini değiştirdikten sonra `npm run build:variants` çalıştırın. `vsce package`
bu adımı `vscode:prepublish` ile kendiliğinden de çalıştırır.

## Test dosyaları

[`samples/`](samples/) klasöründe 23 dilin her biri için, ilgili dilin neredeyse
tüm anahtar kelimelerini ve sözdizimi yapılarını kapsayan birer örnek dosya var.
Temayı seçtikten sonra bu dosyaları açarak renklendirmeyi bir bütün olarak
görebilirsiniz — ayrıntı için [samples/README.md](samples/README.md).
Klasör `.vscodeignore` ile paketleme dışında tutulur.

## Kurulum (yerel)

```bash
npm install -g @vscode/vsce
cd vscode-theme
vsce package
code --install-extension yazilim-yolu-theme-1.0.0.vsix
```

Ya da geliştirme için: klasörü VS Code'da açıp `F5` ile Extension Development
Host başlatın, ardından **Ctrl+K Ctrl+T** ile temayı seçin.

## Yayınlama

Tema iki mağazaya yayınlanır: VS Code için **VS Code Marketplace**, Cursor,
VSCodium ve Windsurf gibi editörler için **Open VSX**.

`package.json` içindeki `publisher` alanı, iki mağazadaki publisher/namespace
kimliğiyle aynı olmalıdır. Yayınlamadan önce `version` alanını artırın ve
CHANGELOG'a giriş ekleyin.

```bash
# VS Code Marketplace (Azure DevOps PAT gerekir, kapsam: Marketplace → Manage)
vsce login yazilim-yolu
vsce publish

# Open VSX (open-vsx.org erişim anahtarı gerekir)
npx ovsx create-namespace yazilim-yolu -p <TOKEN>   # yalnızca ilk sefer
npx ovsx publish -p <TOKEN>
```

Lisans: [MIT](LICENSE)
