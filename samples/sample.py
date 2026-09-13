#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Python — tema testi.

Neredeyse bütün anahtar kelimeler, f-string'ler, dekoratörler,
tip ipuçları ve match/case burada.
"""

from __future__ import annotations

import asyncio
import enum
import re
from abc import ABC, abstractmethod
from collections.abc import AsyncIterator, Iterator, Sequence
from contextlib import contextmanager, suppress
from dataclasses import dataclass, field
from functools import cached_property, lru_cache, wraps
from typing import Any, ClassVar, Final, Generic, Protocol, TypeVar, overload

T = TypeVar("T")
PATTERN: Final[re.Pattern[str]] = re.compile(r"^(?P<ad>\w+)\s*=\s*(?P<deger>[-+]?\d+(?:\.\d+)?)$")
DEFAULTS: dict[str, int | float | str | None] = {"a": 0b1010, "b": 0o755, "c": 0xDEAD, "d": 1_000_000, "e": 3.14e-2, "f": None}

global_counter = 0


class Level(enum.IntEnum):
    DEBUG = 10
    INFO = 20
    WARNING = 30
    ERROR = 40


class Renderer(Protocol):
    def render(self) -> str: ...


def trace(prefix: str = ">>"):
    """Basit dekoratör fabrikası."""

    def decorator(func):
        @wraps(func)
        def wrapper(*args: Any, **kwargs: Any):
            print(f"{prefix} {func.__name__}({args!r}, {kwargs!s})")
            return func(*args, **kwargs)

        return wrapper

    return decorator


@dataclass(slots=True, frozen=False, order=True)
class Task:
    id: int
    title: str = "isimsiz"
    done: bool = False
    tags: list[str] = field(default_factory=list)
    registry: ClassVar[dict[int, "Task"]] = {}

    def __post_init__(self) -> None:
        Task.registry[self.id] = self

    @cached_property
    def slug(self) -> str:
        return "-".join(self.title.lower().split())

    def __repr__(self) -> str:
        return f"Task(id={self.id!r}, title={self.title!r}, done={self.done})"


class Base(ABC, Generic[T]):
    __slots__ = ("_items",)

    def __init__(self, items: Sequence[T] | None = None) -> None:
        self._items: list[T] = list(items or [])

    @abstractmethod
    def render(self) -> str:
        raise NotImplementedError

    @property
    def items(self) -> list[T]:
        return self._items

    @staticmethod
    def banner() -> str:
        return "Yazılım Yolu"

    @classmethod
    def empty(cls) -> "Base[T]":
        return cls()

    def __iter__(self) -> Iterator[T]:
        yield from self._items

    def __len__(self) -> int:
        return len(self._items)


class Board(Base[Task]):
    def render(self) -> str:
        satirlar = [f"{'✓' if t.done else '·'} {t.title:<20} {t.tags}" for t in self]
        return "\n".join(satirlar) or "boş"


@contextmanager
def timer(label: str):
    import time

    start = time.perf_counter()
    try:
        yield start
    finally:
        print(f"{label}: {time.perf_counter() - start:.4f}s")


@lru_cache(maxsize=128)
def fib(n: int, /) -> int:
    assert n >= 0, "negatif olamaz"
    return n if n < 2 else fib(n - 1) + fib(n - 2)


@overload
def coerce(value: str) -> float: ...
@overload
def coerce(value: None) -> None: ...
def coerce(value: str | None) -> float | None:
    if value is None:
        return None
    elif (m := PATTERN.match(value)) is not None:
        return float(m.group("deger"))
    else:
        return float("nan")


def classify(value: object) -> str:
    match value:
        case None:
            return "yok"
        case bool() as b if b is True:
            return "doğru"
        case int() | float() as n if n > 0:
            return f"pozitif {n}"
        case [first, *rest]:
            return f"liste: {first} + {len(rest)}"
        case {"ad": str(ad), **kalan}:
            return f"sözlük: {ad} ({kalan})"
        case Task(title=t):
            return f"görev: {t}"
        case _:
            return "bilinmiyor"


async def produce(limit: int = 5) -> AsyncIterator[int]:
    for i in range(limit):
        await asyncio.sleep(0)
        yield i * i


async def main() -> int:
    global global_counter
    board = Board([Task(1, "tema testi", tags=["mor", "turkuaz"]), Task(2, "gözden geçir", True)])

    with timer("render"), suppress(ValueError):
        print(board.render(), Base.banner(), sep="\n")

    async with asyncio.TaskGroup() as tg:
        tg.create_task(asyncio.sleep(0))

    values = [x async for x in produce() if x % 2 == 0]
    squares = {k: v**2 for k, v in DEFAULTS.items() if isinstance(v, int)}
    lazy = (n for n in range(10) if n not in {3, 5})

    try:
        del DEFAULTS["f"]
        result = fib(20) / (len(values) or 1)
    except (ZeroDivisionError, KeyError) as exc:
        raise RuntimeError("hesaplama hatası") from exc
    except Exception:
        raise
    else:
        global_counter += 1
    finally:
        pass

    while global_counter < 3:
        global_counter += 1
        if global_counter == 2:
            continue
        elif global_counter > 5:
            break
    else:
        print("döngü tamamlandı")

    print(classify(board.items[0]), squares, list(lazy), result, sep=" | ")
    lam = lambda a, b=2, *c, d, **e: (a + b, c, d, e)
    print(lam(1, d=4), Level.WARNING.name, coerce("x = 12.5"), not False and True or False, sep=" | ")
    return 0


if __name__ == "__main__":
    raise SystemExit(asyncio.run(main()))
