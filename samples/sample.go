// Package sample — Go tema testi.
// Bütün anahtar kelimeler, goroutine'ler, kanallar ve generic'ler burada.
package main

import (
	"context"
	"errors"
	"fmt"
	"os"
	"strings"
	"sync"
	"time"
)

//go:generate stringer -type=Level

const (
	Version           = "0.2.1"
	MaxRetry    int   = 3
	Ratio       float64 = 3.14e-2
	Mask              = 0b1010 | 0o755 ^ 0xDEAD
)

const (
	Debug Level = iota * 10
	Info
	Warn
	Error
)

var (
	ErrBos      = errors.New("boş kayıt")
	ErrGecersiz = fmt.Errorf("geçersiz: %w", ErrBos)
	registry    = map[string]Level{"uyari": Warn, "hata": Error}
	_           Renderer = (*Task)(nil)
)

type Level int

func (l Level) String() string {
	switch l {
	case Debug:
		return "DEBUG"
	case Info:
		return "INFO"
	case Warn, Error:
		fallthrough
	default:
		return "OTHER"
	}
}

type Renderer interface {
	Render() string
	fmt.Stringer
}

type Sayisal interface {
	~int | ~int64 | ~float64
}

type Task struct {
	ID    uint64   `json:"id"`
	Title string   `json:"title"`
	Done  bool     `json:"done,omitempty"`
	Tags  []string `json:"tags"`
	meta  struct {
		created time.Time
		ptr     *Task
	}
}

type Board struct {
	sync.Mutex
	Tasks []*Task
	index map[uint64]int
}

func (t *Task) Render() string {
	mark := "·"
	if t.Done {
		mark = "✓"
	}
	return fmt.Sprintf("%s %-20s %v", mark, t.Title, t.Tags)
}

func (t Task) String() string { return "Task#" + fmt.Sprint(t.ID) }

func (b *Board) Add(tasks ...*Task) (n int, err error) {
	b.Lock()
	defer b.Unlock()
	defer func() {
		if r := recover(); r != nil {
			err = fmt.Errorf("panik: %v", r)
		}
	}()

	if b.index == nil {
		b.index = make(map[uint64]int, len(tasks))
	}
	for _, t := range tasks {
		if t == nil {
			panic("nil görev")
		}
		b.index[t.ID] = len(b.Tasks)
		b.Tasks = append(b.Tasks, t)
		n++
	}
	return n, nil
}

func Topla[T Sayisal](items []T) T {
	var toplam T
	for _, v := range items {
		toplam += v
	}
	return toplam
}

func siniflandir(v any) string {
	switch x := v.(type) {
	case nil:
		return "yok"
	case bool:
		return fmt.Sprint(!x)
	case int, int64:
		return "tamsayı"
	case string:
		return strings.ToUpper(x)
	case *Task:
		return x.Render()
	case error:
		return x.Error()
	default:
		return fmt.Sprintf("%T", x)
	}
}

func uret(ctx context.Context, limit int) <-chan int {
	out := make(chan int, limit)
	go func() {
		defer close(out)
		for i := range limit {
			select {
			case out <- i * i:
			case <-ctx.Done():
				return
			}
		}
	}()
	return out
}

func main() {
	ctx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
	defer cancel()

	board := &Board{}
	gorev := &Task{ID: 1, Title: "tema testi", Tags: []string{"mor", "turkuaz"}}
	if _, err := board.Add(gorev, &Task{ID: 2, Title: "gözden geçir", Done: true}); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}

	var wg sync.WaitGroup
	sonuclar := make([]int, 0, 8)
	var mu sync.Mutex

	wg.Add(1)
	go func() {
		defer wg.Done()
		for v := range uret(ctx, 5) {
			mu.Lock()
			sonuclar = append(sonuclar, v)
			mu.Unlock()
		}
	}()
	wg.Wait()

	matris := [3][2]int{{1, 2}, {3, 4}, {5, 6}}
	dilim := matris[1][:]
	kopya := make([]int, len(dilim))
	copy(kopya, dilim)

	toplam := Topla(sonuclar)
	oran := float64(toplam) * Ratio

dis:
	for i, satir := range matris {
		for j := range satir {
			if j > 0 && i == 2 {
				break dis
			} else if satir[j]%2 == 0 {
				continue
			}
			goto isaret
		isaret:
			_ = j
		}
	}

	ptr := &gorev
	fmt.Printf("%s | %v | %.4f | %d | %s | %q\n",
		(*ptr).Render(), kopya, oran, Mask, siniflandir(gorev), Version)
	fmt.Println(registry["uyari"], errors.Is(ErrGecersiz, ErrBos), len(board.Tasks), cap(sonuclar))
}
