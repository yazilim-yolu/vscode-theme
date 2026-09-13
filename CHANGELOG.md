# Değişiklik Günlüğü

## 0.2.1

- Koyu temanın zeminleri belirgin biçimde koyulaştırıldı: editör zemini
  `#1B1E33` → `#0E1526` (ışıklılık %46 azaldı), kenar çubuğu/panel/terminal
  `#181B2D` → `#0B1221`, sekme şeridi `#16192B` → `#0A101D`,
  başlık/etkinlik/durum çubuğu ve tüm açılır pencereler `#14172A` → `#080D18`.
- Zemin tonu mora kaymayı bırakıp net laciverde çekildi. Eski zeminlerin
  kırmızı/yeşil kanal oranı (0.84) logo lacivertininkinden (0.78) yüksekti,
  yani logodan daha mor bir tondu; yeni zeminlerde bu oran 0.62–0.67'ye indi.
  Hue 232°'den ~222°'ye alınarak viyoleden uzaklaşıldı, doygunluk %31'den
  ~%46'ya çıkarıldı. Bu, logo lacivertinin literal hue'sundan bilinçli bir
  sapmadır: aynı hue geniş ve çok koyu bir zemin olarak kullanıldığında,
  özellikle mor `#7C3BED` vurguların yanında, mor okunuyordu.
- Zemine bağlı yardımcı tonlar aynı hue'ya hizalandı ve koyulaştırıldı: satır
  vurgusu ve liste/sekme hover'ı `#21253C` → `#151E34`, seçim tonları
  `#34407A` → `#344879`, pencere kenarlıkları `#2C3150` → `#212A40`, girinti
  kılavuzu/cetvel `#272D50` → `#1E2840`, boşluk işaretleri `#2E3560` →
  `#253150`, gölge `#0A0C1A` → `#04070F`.
- `sideBarSectionHeader.border` diğer kenarlıklarla aynı tona hizalandı.
- Sözdizimi renklerinin zemine karşı kontrastı bu sayede 6.2–10.5 aralığına
  çıktı (hepsi WCAG AA üstü).
- Etkinlik çubuğunda (Activity Bar) aktif ikon artık turkuaz — soldaki aktiflik
  göstergesiyle aynı renk. Koyu temada `#E1E3F0` → `#3ABACD`, açık temada
  `#2E3350` → `#1D6772`. Açık temanın aktiflik göstergesi de aynı tona
  hizalandı (`#0E8FA3` → `#1D6772`).

## 0.2.0

- Arayüz zeminleri logo lacivertine bağlı kalıp yumuşatıldı; metin ve vurgu
  renklerinin parlaklığı/doygunluğu düşürülerek göz yormayan bir kontrast
  seviyesine çekildi.
- Kod sözdizimi paleti bluloco tarzında genişletildi: mor/lavanta (anahtar
  kelime), köprü mavisi (fonksiyon), yeşil-turkuaz (string), turkuaz (regexp),
  teal (tip/sınıf), amber (sayı/sabit), sarı (dekoratör/makro), gül (etiket,
  `this`/`self`) gibi ~10 ayrı ton.
- Dile özgü kapsamlar eklendi: TypeScript/JSX, Python (f-string, dekoratör),
  Rust (makro, lifetime), Go, C/C++ (preprocessor), C#, Java, PHP, Ruby, CSS/
  SCSS/LESS, JSON, YAML, TOML, INI, SQL, GraphQL, Markdown, Dockerfile,
  Makefile, shell.
- Genel tema logoya (mor `#7C3BED`, turkuaz `#3ABACD`, lacivert `#232D5B`)
  sadık kaldı.

## 0.1.0

- İlk sürüm.
- Yazılım Yolu Dark ve Yazılım Yolu Light temaları eklendi.
- Renkler şirket logosundan alınan mor (`#7C3BED`), turkuaz (`#3ABACD`) ve
  lacivert (`#232D5B`) tonlarına dayanıyor.
- Editör, çalışma alanı (workbench), terminal, git kararları ve anlamsal
  (semantic) token renkleri tanımlandı.
