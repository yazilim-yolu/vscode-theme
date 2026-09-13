//! Rust — tema testi.
//!
//! Makrolar, lifetime'lar, trait'ler ve pattern matching burada.

#![allow(dead_code, unused_variables)]

use std::collections::{BTreeMap, HashMap};
use std::fmt::{self, Display, Formatter};
use std::sync::{Arc, Mutex};

pub const VERSION: &str = "0.2.1";
pub static BANNER: &[u8; 12] = b"YazilimYolu\0";

macro_rules! kayit {
    ($ad:expr) => {
        println!("[kayit] {}", $ad)
    };
    ($ad:expr, $($arg:tt)*) => {
        println!("[kayit] {}: {}", $ad, format!($($arg)*))
    };
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, PartialOrd, Ord)]
pub enum Level {
    Debug = 10,
    Info = 20,
    Warn = 30,
    Error = 40,
}

#[derive(Debug, Clone, Default)]
pub struct Task<'a> {
    pub id: u64,
    pub title: &'a str,
    pub done: bool,
    pub tags: Vec<String>,
}

pub union Raw {
    int: i64,
    float: f64,
}

pub trait Render {
    type Output: Display;

    fn render(&self) -> Self::Output;

    fn banner(&self) -> String
    where
        Self: Sized,
    {
        String::from(VERSION)
    }
}

impl<'a> Render for Task<'a> {
    type Output = String;

    fn render(&self) -> Self::Output {
        format!("{} {}", if self.done { '✓' } else { '·' }, self.title)
    }
}

impl<'a> Display for Task<'a> {
    fn fmt(&self, f: &mut Formatter<'_>) -> fmt::Result {
        write!(f, "Task#{}<{}>", self.id, self.title)
    }
}

#[derive(Debug)]
pub enum Hata {
    Bos,
    Gecersiz { alan: String, kod: i32 },
    Sarmalanmis(Box<dyn std::error::Error + Send + Sync>),
}

pub fn siniflandir(deger: Option<&Task<'_>>) -> &'static str {
    match deger {
        None => "yok",
        Some(Task { done: true, .. }) => "tamamlandı",
        Some(t) if t.tags.is_empty() => "etiketsiz",
        Some(Task { id: 1..=9, .. }) => "erken kayıt",
        Some(_) => "normal",
    }
}

pub async fn topla<T>(items: impl IntoIterator<Item = T>) -> Vec<T>
where
    T: Clone + Send + 'static,
{
    let mut out: Vec<T> = Vec::with_capacity(8);
    for item in items {
        out.push(item.clone());
    }
    out
}

unsafe fn ham_oku(r: &Raw) -> i64 {
    unsafe { r.int }
}

fn main() -> Result<(), Hata> {
    let sayilar: [i32; 5] = [0b1010, 0o755, 0xDEAD, 1_000_000, -42];
    let oran: f64 = 3.14e-2;
    let karakter = '\u{1F980}';
    let ham = r#"kaçış "yok" \n burada"#;

    let mut harita: HashMap<&str, Level> = HashMap::new();
    harita.insert("uyari", Level::Warn);

    let paylasilan = Arc::new(Mutex::new(BTreeMap::<u64, Task>::new()));

    let gorev = Task {
        id: 1,
        title: "tema testi",
        done: false,
        tags: vec!["mor".to_owned(), "turkuaz".into()],
    };

    kayit!("başlangıç");
    kayit!("gorev", "{} → {}", gorev, gorev.render());

    let mut toplam = 0i64;
    'dis: for (i, n) in sayilar.iter().enumerate() {
        let mut j = 0;
        while j < 3 {
            j += 1;
            if *n < 0 {
                continue 'dis;
            } else if i > 3 {
                break 'dis;
            }
        }
        toplam += *n as i64;
    }

    let mut sayac = 0;
    let sonuc = loop {
        sayac += 1;
        if sayac >= 5 {
            break sayac * 2;
        }
    };

    let etiket = if toplam > 0 { "pozitif" } else { "negatif" };
    let ilk = sayilar.first().copied().unwrap_or_default();

    if let Some(seviye) = harita.get("uyari") {
        println!("{seviye:?} {ilk} {etiket} {sonuc} {oran} {karakter} {ham}");
    }

    while let Ok(mut kilit) = paylasilan.lock() {
        kilit.insert(gorev.id, gorev.clone());
        break;
    }

    let kapanis = move |x: i32| -> i32 { x.pow(2) + ilk };
    let kareler: Vec<i32> = sayilar.iter().map(|&n| kapanis(n)).filter(|n| *n > 0).collect();

    let ham_deger = Raw { int: 7 };
    let okundu = unsafe { ham_oku(&ham_deger) };

    match siniflandir(Some(&gorev)) {
        "yok" => return Err(Hata::Bos),
        s @ ("normal" | "etiketsiz") => println!("{s} {okundu} {kareler:?}"),
        _ => return Err(Hata::Gecersiz { alan: "durum".into(), kod: 400 }),
    }

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn siniflandirma_calisir() {
        let t = Task { id: 1, title: "x", done: true, tags: vec![] };
        assert_eq!(siniflandir(Some(&t)), "tamamlandı");
        assert!(matches!(siniflandir(None), "yok"));
    }
}
