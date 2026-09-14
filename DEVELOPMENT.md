# Geliştirme Notları

Bu belge temayı geliştiren ekip içindir. Marketplace'te görünen kullanıcı
belgesi [README.md](README.md), yayınlama adımları [PUBLISHING.md](PUBLISHING.md)
dosyasındadır. Bu dosya `.vscodeignore` ile pakete dahil edilmez.

## Marka renkleri ve tasarım kararları

| Renk     | Hex       | Kullanım                                                                              |
| -------- | --------- | ------------------------------------------------------------------------------------- |
| Mor      | `#7C3BED` | Ana vurgu: butonlar, odak çerçevesi, kenar çubuğu sayaçları, anahtar kelimeler        |
| Turkuaz  | `#3ABACD` | Aktiflik vurgusu: etkinlik çubuğu, aktif sekme, imleç, bağlantılar, arama eşleşmeleri |
| Lacivert | `#232D5B` | Koyu temanın zemin tonu, açık temada gölge/kaydırma                                   |

Arayüz (workbench) kroması bu üç tona sadık kalır. Koyu temanın zeminleri logo
lacivertinden türetilmiştir; doygunluğu korunur (~%46) ama hue'su bir miktar
maviye alınır (232° → ~222°) ve açıklığı düşürülür. Bu sapma bilinçlidir:
lacivertin kendi hue'su geniş ve çok koyu bir zemin olarak, üstelik mor
vurguların yanında kullanıldığında mora kayıyor.

Kod dosyalarında ise bluloco tarzı, daha zengin bir sözdizimi paleti kullanılır:
üç marka tonundan yola çıkıp okunabilirlik için açık/koyu zemine göre parlaklık
ve doygunluğu ayarlanmış ~10 ayrı renk. Mor/lavanta (anahtar kelime), köprü
mavisi (fonksiyon), yeşil-turkuaz (string), turkuaz (regexp), teal (tip/sınıf),
amber (sayı/sabit), sarı (dekoratör/makro), gül (etiket, `this`/`self`).

## Varyantlar

- **Yazılım Yolu Dark** ve **Yazılım Yolu Light** elle düzenlenen ana temalardır.
- **Yazılım Yolu Extra Dark** ve **Yazılım Yolu Soft Light** elle düzenlenmez;
  [`scripts/build-variants.js`](scripts/build-variants.js) ile ana temalardan
  üretilir.

Ana temalardan birini değiştirdikten sonra:

```bash
npm run build:variants
```

`vsce package` bu adımı `vscode:prepublish` ile kendiliğinden de çalıştırır.
Koyulaştırma oranları betiğin içindeki `VARIANTS` dizisindedir.

## Test dosyaları

[`samples/`](samples/) klasöründe 23 dilin her biri için, ilgili dilin neredeyse
tüm anahtar kelimelerini ve sözdizimi yapılarını kapsayan birer örnek dosya var.
Temayı seçtikten sonra bu dosyaları açarak renklendirmeyi bir bütün olarak
görebilirsiniz. Ayrıntı için [samples/README.md](samples/README.md).

## Yerelde çalıştırma

Geliştirme için klasörü VS Code'da açıp `F5` ile Extension Development Host
başlatın, ardından **Ctrl+K Ctrl+T** ile temayı seçin.

Paketi yerelde kurup denemek için:

```bash
npm install -g @vscode/vsce
vsce package
code --install-extension yazilim-yolu-theme-1.0.0.vsix
```

## Yayınlama

Adım adım yol haritası için [PUBLISHING.md](PUBLISHING.md).
