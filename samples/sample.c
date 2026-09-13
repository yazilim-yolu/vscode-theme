/*
 * C — tema testi.
 * Preprocessor yönergeleri, storage class'lar ve bütün anahtar kelimeler.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>
#include <signal.h>
#include <errno.h>

#define VERSION "0.2.1"
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define KAYIT(fmt, ...) fprintf(stderr, "[kayit] " fmt "\n", __VA_ARGS__)
#define DIZI_BOYU(x) (sizeof(x) / sizeof((x)[0]))

#ifndef YAZILIM_YOLU_H
#define YAZILIM_YOLU_H

#if defined(__GNUC__) && !defined(__clang__)
#  define DAHILI __attribute__((always_inline)) inline
#elif defined(_MSC_VER)
#  define DAHILI __forceinline
#else
#  define DAHILI inline
#endif

#ifdef DEBUG
#  define IZLE(x) printf("%s = %d\n", #x, (x))
#else
#  define IZLE(x) ((void)0)
#endif

typedef enum Level {
    LEVEL_DEBUG = 10,
    LEVEL_INFO  = 20,
    LEVEL_WARN  = 30,
    LEVEL_ERROR = 40
} Level;

typedef struct Task {
    uint64_t id;
    char title[64];
    bool done;
    char **tags;
    size_t tag_count;
    struct Task *next;
} Task;

typedef union Raw {
    int64_t as_int;
    double  as_float;
    uint8_t bytes[8];
} Raw;

typedef void (*Callback)(const Task *task, void *user_data);

static const char *const BANNER = "Yazilim Yolu";
static volatile sig_atomic_t g_kesildi = 0;
extern char **environ;

static unsigned long hash(const char *restrict s)
{
    register unsigned long h = 5381UL;
    int c;
    while ((c = *s++) != '\0') {
        h = ((h << 5) + h) ^ (unsigned long)c;
    }
    return h;
}

DAHILI int karsilastir(const void *a, const void *b)
{
    const Task *ta = (const Task *)a;
    const Task *tb = (const Task *)b;
    return (ta->id > tb->id) - (ta->id < tb->id);
}

Task *task_olustur(uint64_t id, const char *title)
{
    Task *t = (Task *)calloc(1u, sizeof *t);
    if (t == NULL) {
        perror("calloc");
        return NULL;
    }
    t->id = id;
    strncpy(t->title, title, sizeof t->title - 1u);
    t->done = false;
    t->next = NULL;
    return t;
}

const char *seviye_adi(Level level)
{
    switch (level) {
        case LEVEL_DEBUG: return "DEBUG";
        case LEVEL_INFO:  return "INFO";
        case LEVEL_WARN:  /* fallthrough */
        case LEVEL_ERROR: return "CIDDI";
        default:          return "BILINMEYEN";
    }
}

int main(int argc, char *argv[])
{
    static int cagri_sayisi = 0;
    auto int yerel = 0;
    signed char kucuk = -128;
    unsigned short bayrak = 0xFFFFu;
    long long buyuk = 1000000LL;
    short int kisa = 0b1010;
    float oran = 3.14e-2f;
    double kesin = 2.718281828;
    long double cok_kesin = 1.0L;
    char kacis = '\t';
    const char *ham = "satir\nsonu\t\"tirnak\"\\";

    int sayilar[] = {0755, 0xDEAD, 42, -7, 0};
    Raw ham_deger = {.as_int = 7};

    Task *bas = task_olustur(1u, "tema testi");
    if (!bas) return EXIT_FAILURE;
    bas->next = task_olustur(2u, "gozden gecir");

    KAYIT("%s v%s (argc=%d)", BANNER, VERSION, argc);
    IZLE(kisa);

    for (size_t i = 0; i < DIZI_BOYU(sayilar); ++i) {
        if (sayilar[i] < 0) {
            continue;
        } else if (sayilar[i] == 0) {
            break;
        }
        yerel += sayilar[i];
    }

    do {
        ++cagri_sayisi;
    } while (cagri_sayisi < 3);

    while (bayrak > 0u) {
        bayrak >>= 4u;
        if (bayrak & 0x0Fu) goto temizle;
    }

temizle:
    for (Task *it = bas, *sonraki = NULL; it != NULL; it = sonraki) {
        sonraki = it->next;
        printf("%llu %-20s %s\n", (unsigned long long)it->id, it->title,
               it->done ? "tamam" : "bekliyor");
        free(it);
    }

    qsort(sayilar, DIZI_BOYU(sayilar), sizeof sayilar[0], karsilastir);

    printf("%s | %lu | %d | %hhd | %lld | %hd | %.4f | %.6f | %.1Lf | %c%s\n",
           seviye_adi(LEVEL_WARN), hash(BANNER), MAX(yerel, cagri_sayisi),
           kucuk, buyuk, kisa, (double)oran, kesin, cok_kesin, kacis, ham);
    printf("union: %lld / %f\n", (long long)ham_deger.as_int, ham_deger.as_float);

    return argc > 1 ? EXIT_SUCCESS : (int)sizeof(union Raw) - (int)sizeof(Raw);
}

#endif /* YAZILIM_YOLU_H */
