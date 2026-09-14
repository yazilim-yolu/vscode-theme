# Yayınlama Yol Haritası

Tema iki mağazaya yayınlanır. İkisine de aynı `.vsix` paketi yüklenir.

| Mağaza | Kimler kullanır | Nasıl yayınlanır |
| --- | --- | --- |
| **VS Code Marketplace** | Microsoft VS Code | `.vsix` web sayfasından elle yüklenir |
| **Open VSX** | Cursor, VSCodium, Windsurf, Gitpod, Eclipse Theia | `.vsix` komut satırından yüklenir |

> **Neden `vsce publish` kullanmıyoruz?** `vsce publish`, Azure DevOps'ta "All
> accessible organizations" kapsamlı bir erişim anahtarı (global PAT) ister. Bu
> tür anahtarlar **1 Aralık 2026'da kaldırılıyor**. Microsoft'un önerdiği yeni
> yöntem (Microsoft Entra ID, `--azure-credential`) CI/CD ortamları için
> tasarlanmış. Web sayfasından yükleme resmî olarak desteklenir ve anahtar
> gerektirmez.

---

## Mevcut durum

- [x] MIT lisansı, `repository` bilgisi ve CHANGELOG hazır
- [x] `vsce package` uyarısız paket üretiyor
- [x] Azure aboneliği iptal edildi, Azure DevOps organizasyonu silindi. Web
      üzerinden yükleme için ikisi de gerekmiyor.
- [ ] Değişiklikler commit edilip GitHub'a push edildi
- [ ] Marketplace publisher'ı oluşturuldu
- [ ] Marketplace'e ilk sürüm yüklendi
- [ ] Open VSX hesabı, anlaşma ve namespace hazır
- [ ] Open VSX'e ilk sürüm yüklendi
- [ ] Open VSX namespace sahipliği onaylandı

---

## 1. Her sürümden önce: paketi hazırlama

1. **Sürümü artırın.** `package.json` içindeki `version` alanı. Aynı sürüm
   numarası iki mağazaya da ikinci kez yüklenemez.
   - Renk düzeltmesi: `1.0.0` → `1.0.1`
   - Yeni varyant veya belirgin görünüm değişikliği: `1.0.0` → `1.1.0`
   - Temayı baştan değiştiren bir yenilik: `1.0.0` → `2.0.0`
2. **CHANGELOG.md'ye giriş ekleyin.** Mağaza sayfalarında "Changelog" sekmesinde
   görünür.
3. **Temaları kontrol edin.** `F5` ile Extension Development Host'u açın, dört
   varyantı (**Ctrl+K Ctrl+T**) `samples/` dosyalarıyla gözden geçirin.
   - Extra Dark ve Soft Light elle düzenlenmez. Dark veya Light'ı
     değiştirdiyseniz `npm run build:variants` çalıştırın. `vsce package` bunu
     zaten kendiliğinden yapar, ama F5 ile bakmadan önce çalıştırmak gerekir.
4. **Commit edin, push edin, etiketleyin:**
   ```bash
   git add -A
   git commit -m "Sürüm 1.0.0"
   git push
   git tag v1.0.0
   git push origin v1.0.0
   ```
5. **Paketi üretin:**
   ```bash
   vsce package
   ```
   Proje klasöründe `yazilim-yolu-theme-1.0.0.vsix` oluşur (`.gitignore`
   sayesinde git'e girmez).
6. **Paketi yerelde deneyin (isteğe bağlı ama önerilir):**
   ```bash
   code --install-extension yazilim-yolu-theme-1.0.0.vsix
   ```
   Kontrol ettikten sonra kaldırın:
   ```bash
   code --uninstall-extension yazilim-yolu.yazilim-yolu-theme
   ```

---

## 2. VS Code Marketplace

### 2.1 İlk kurulum (bir kez)

1. **Hesabı seçin.** Marketplace bir Microsoft hesabı ister. Herhangi bir
   e-posta adresi (Gmail dahil) Microsoft hesabı olarak kaydedilebilir.
   - Publisher'ın sahibi bu hesap olur. Güvenlik ve hesap e-postaları buraya
     gider, bu yüzden **birinin gerçekten okuduğu** bir şirket adresi seçin.
   - Şu an kullanılan hesap `no-reply@yazilimyolu.com`. Bu kutu okunmuyorsa
     başka bir adres düşünün.
2. **Publisher oluşturun.** https://marketplace.visualstudio.com/manage →
   **Create publisher**
   - **ID:** `yazilim-yolu`. `package.json` içindeki `publisher` alanıyla
     birebir aynı olmalı. ID sonradan değiştirilemez.
   - **Name:** `Yazılım Yolu` (mağazada görünen ad).
   - Logo, web sitesi ve açıklama isteğe bağlı.
3. **Ekip üyelerini ekleyin (isteğe bağlı).** Yönetim sayfasında publisher
   ayarları → **Members**. Böylece yayın yetkisi tek bir hesaba bağlı kalmaz.

### 2.2 İlk yayın

1. https://marketplace.visualstudio.com/manage → **+ New extension** →
   **Visual Studio Code**
2. `yazilim-yolu-theme-1.0.0.vsix` dosyasını sürükleyip bırakın ve yükleyin.
3. Marketplace paketi doğrular. Durum birkaç dakika içinde yayında olarak
   değişir.
4. Kontrol edin:
   - Mağaza sayfası:
     https://marketplace.visualstudio.com/items?itemName=yazilim-yolu.yazilim-yolu-theme
   - VS Code → Extensions paneli → "Yazılım Yolu" araması

### 2.3 Sonraki sürümler

1. [Bölüm 1](#1-her-sürümden-önce-paketi-hazırlama)'deki adımlarla yeni `.vsix`
   dosyasını üretin.
2. https://marketplace.visualstudio.com/manage → temanın yanındaki **⋯** →
   **Update** → yeni `.vsix` dosyasını yükleyin.

---

## 3. Open VSX

### 3.1 İlk kurulum (bir kez)

1. **GitHub hesabını seçin.** Open VSX'e sadece GitHub hesabıyla girilir. Hangi
   hesabı kullanacaksanız aşağıdaki bütün adımlarda **aynı hesabı** kullanın.
2. **Eclipse Foundation hesabı açın.** https://accounts.eclipse.org/user/register
   - Profildeki **GitHub Username** alanına 1. adımdaki GitHub kullanıcı adını
     yazın. Farklı olursa anlaşma adımı çalışmaz.
3. **Open VSX'e girin.** https://open-vsx.org → GitHub ile giriş.
4. **Publisher anlaşmasını imzalayın.** open-vsx.org → profil → **Settings** →
   **Log in with Eclipse** → **Show Publisher Agreement** → okuyup **Agree**.
5. **Erişim anahtarı oluşturun.** **Settings** → **Access Tokens** →
   **Generate New Token** → açıklama yazın (ör. `yazilim-yolu-theme`) →
   **Generate Token**.
   - Anahtar pencere kapanınca **bir daha gösterilmez**, hemen güvenli bir
     yere (ör. şifre yöneticisi) kaydedin.
6. **Namespace oluşturun.** Adı `package.json` içindeki `publisher` ile aynı
   olmalı:
   ```bash
   npx ovsx create-namespace yazilim-yolu -p <OPEN_VSX_TOKEN>
   ```
7. **Namespace sahipliğini talep edin.** Bu adım yapılmazsa tema mağazada
   ⚠️ "yayıncı doğrulanmamış" uyarısıyla görünür.
   - open-vsx.org'a giriş yapmış durumdayken
     https://github.com/EclipseFdn/open-vsx.org/issues/new/choose adresinden
     namespace sahipliği için issue açın.
   - Talep herkese açık bir issue olarak değerlendirilir. Onaylanınca namespace
     "verified" olur.
8. **Ekip üyelerini ekleyin (isteğe bağlı).** **Settings** → **Namespaces**.
   - **Owner:** üye ekleyip çıkarabilir.
   - **Contributor:** sadece yayınlayabilir.

### 3.2 Yayınlama (ilk sürüm ve sonrakiler)

Anahtarı komutun içine yazmak yerine ortam değişkeni olarak vermek, anahtarın
terminal geçmişinde kalmasını önler. `ovsx`, `OVSX_PAT` değişkenini
kendiliğinden okur.

**PowerShell:**
```powershell
$env:OVSX_PAT = "<OPEN_VSX_TOKEN>"
npx ovsx publish yazilim-yolu-theme-1.0.0.vsix
```

**Bash:**
```bash
export OVSX_PAT="<OPEN_VSX_TOKEN>"
npx ovsx publish yazilim-yolu-theme-1.0.0.vsix
```

Kontrol edin: https://open-vsx.org/extension/yazilim-yolu/yazilim-yolu-theme

---

## 4. Kısa kontrol listesi (her sürüm)

1. [ ] `package.json` sürümü artırıldı
2. [ ] CHANGELOG girişi yazıldı
3. [ ] Dört varyant F5 ile kontrol edildi
4. [ ] Commit, push ve `vX.Y.Z` etiketi
5. [ ] `vsce package`
6. [ ] Marketplace → **⋯** → **Update** → `.vsix`
7. [ ] `npx ovsx publish yazilim-yolu-theme-X.Y.Z.vsix`
8. [ ] İki mağaza sayfasında yeni sürüm numarası görünüyor

---

## 5. Sık karşılaşılan sorunlar

| Sorun | Neden / Çözüm |
| --- | --- |
| Marketplace yüklemesi publisher hatası veriyor | `package.json` içindeki `publisher` ile Marketplace publisher ID'si aynı değil. |
| "Version already exists" benzeri hata | Aynı sürüm tekrar yüklenemez. `version` alanını artırıp paketi yeniden üretin. |
| `ovsx` 401/403 hatası | Anahtar hatalı veya süresi dolmuş, ya da publisher anlaşması imzalanmamış. |
| `ovsx` namespace hatası | Namespace oluşturulmamış veya adı `publisher` ile aynı değil. |
| Open VSX'te ⚠️ uyarısı | Namespace sahipliği henüz onaylanmamış (bkz. 3.1, adım 7). |
| Extra Dark / Soft Light eski görünüyor | `npm run build:variants` çalıştırılmamış. `vsce package` bunu kendiliğinden yapar. |

---

## Güvenlik notları

- Erişim anahtarlarını repoya, README'ye, sohbetlere veya ekran görüntülerine
  koymayın.
- Anahtar sızarsa open-vsx.org → **Settings** → **Access Tokens** üzerinden
  hemen iptal edip yenisini oluşturun.
- Azure DevOps'ta global PAT oluşturmaya gerek yok. Bu akış onu kullanmıyor.
