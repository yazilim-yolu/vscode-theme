---
title: Yazılım Yolu Tema Testi
version: 0.2.1
tags: [mor, turkuaz, lacivert]
draft: false
---

# Yazılım Yolu — Markdown Tema Testi

Bu belge Markdown'ın **kalın**, _italik_, **_kalın italik_**, ~~üstü çizili~~ ve
`satır içi kod` biçimlerini içerir. Ayrıca <kbd>Ctrl</kbd>+<kbd>K</kbd> gibi ham
HTML de var.

## Başlık Seviyeleri

### Üçüncü seviye

#### Dördüncü seviye

##### Beşinci seviye

###### Altıncı seviye

Alternatif başlık sözdizimi
============================

İkinci seviye alternatif
------------------------

## Bağlantılar ve Görseller

[Satır içi bağlantı](https://yazilimyolu.example "Başlık metni") ve
[referans bağlantı][tema] ile <https://otomatik.example> biçimi.

![Logo](../assets/logo_e.png "Yazılım Yolu logosu")

[tema]: https://marketplace.visualstudio.com/ "Marketplace"

## Listeler

- Sırasız madde
- İkinci madde
  - İç içe madde
    - Üçüncü seviye
* Yıldız işaretli
+ Artı işaretli

1. Sıralı madde
2. İkinci
   1. İç içe sıralı
10. Onuncu

- [x] Tamamlanmış görev
- [ ] Bekleyen görev

Terim
: Tanım listesi (bazı ayrıştırıcılarda)

## Alıntı

> Tek seviye alıntı.
>
> > İç içe alıntı — **kalın** ve `kod` içerir.
>
> — *Yazılım Yolu*

## Tablo

| Renk     | Hex       | Kullanım                    | Ağırlık |
| :------- | :-------: | --------------------------- | ------: |
| Mor      | `#7C3BED` | Ana vurgu                   |     100 |
| Turkuaz  | `#3ABACD` | İkincil vurgu               |      75 |
| Lacivert | `#232D5B` | Zemin tonu                  |      50 |

## Kod Blokları

```typescript
export async function main(argv: string[]): Promise<number> {
  const tasks = argv.filter((a) => !a.startsWith("--"));
  for (const [i, task] of tasks.entries()) {
    console.log(`${i}: ${task.toUpperCase()}`);
  }
  return tasks.length > 0 ? 0 : 1;
}
```

```python
@dataclass(slots=True)
class Task:
    id: int
    title: str = "isimsiz"
    tags: list[str] = field(default_factory=list)
```

```bash
#!/usr/bin/env bash
set -euo pipefail
for f in samples/*.ts; do
  printf '%s\n' "${f##*/}"
done
```

```diff
- "editor.background": "#1B1E33",
+ "editor.background": "#141830",
```

    Girintili kod bloğu (dört boşluk)
    ikinci satır

## Ayraçlar

---

***

___

## Kaçış ve Özel Karakterler

\*yıldız kaçtı\*, \_alt çizgi\_, \`ters tırnak\`, \# diyez, 100\% ve
HTML varlıkları: &copy; &amp; &lt;etiket&gt; &#8212;

Sonda iki boşlukla satır sonu  
yeni satıra geçti.

## Dipnot ve Kısaltma

Metin içinde dipnot[^1] kullanımı.

[^1]: Dipnot açıklaması — `kod` da içerebilir.

*[HTML]: HyperText Markup Language

<details>
<summary>Ham HTML bloğu</summary>

Katlanabilir içerik. **Markdown** burada da çalışır.

</details>
