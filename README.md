# Yazılım Yolu — VS Code Teması

Yazılım Yolu şirket logosunun üç renginden türetilmiş bir VS Code tema paketi.
Hem **koyu** hem **açık** varyant içerir.

## Marka renkleri

| Renk        | Hex       | Kullanım                                    |
| ----------- | --------- | ------------------------------------------- |
| Mor         | `#7C3BED` | Ana vurgu — butonlar, rozetler, imleç çizgisi, sekme üst çizgisi |
| Turkuaz     | `#3ABACD` | İkincil vurgu — imleç, bağlantılar, arama eşleşmeleri |
| Lacivert    | `#232D5B` | Koyu temanın zemin tonu, açık temada gölge/kaydırma |

Sözdizimi renkleri bu üç tondan üretilmiş, okunabilirlik için açık/koyu zemine
göre parlaklık ve doygunlukları ayarlanmış bir paletle tamamlanır (fonksiyonlar
için köprü mavisi, tip/sınıf için yeşil-turkuaz, sayı/sabit için sıcak amber).

## İçindekiler

- **Yazılım Yolu Dark**
- **Yazılım Yolu Light**

## Kurulum (yerel)

```bash
npm install -g @vscode/vsce
cd vscode-theme
vsce package
code --install-extension yazilim-yolu-theme-0.1.0.vsix
```

Ya da geliştirme için: klasörü VS Code'da açıp `F5` ile Extension Development
Host başlatın, ardından **Ctrl+K Ctrl+T** ile temayı seçin.

## Yayınlama

`package.json` içindeki `publisher` alanını kendi Marketplace publisher kimliğinizle
güncelleyin, sonra `vsce publish`.
