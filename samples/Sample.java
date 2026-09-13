/*
 * Java — tema testi.
 * Record'lar, sealed hiyerarşi, generics, stream'ler ve switch pattern'leri.
 */
package com.yazilimyolu.samples;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.EnumSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.concurrent.CompletableFuture;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import static java.util.Map.entry;

public final class Sample {

    public enum Level {
        DEBUG(10), INFO(20), WARN(30), ERROR(40);

        private final int weight;

        Level(int weight) { this.weight = weight; }

        public int weight() { return this.weight; }
    }

    @FunctionalInterface
    interface Renderer<T extends CharSequence> {
        T render();

        default String banner() { return BANNER; }
    }

    public sealed interface Node permits Leaf, Branch {}

    public record Leaf(long id, String title) implements Node {
        public Leaf {
            Objects.requireNonNull(title, "title null olamaz");
        }
    }

    public record Branch(Node left, Node right) implements Node {}

    public static class Task implements Renderer<String>, Comparable<Task>, Serializable, Cloneable {
        private static final long serialVersionUID = 1L;
        protected transient volatile boolean dirty;
        private final long id;
        private String title;
        private boolean done;
        private final List<String> tags = new ArrayList<>();

        public Task(long id, String title, String... tags) {
            this.id = id;
            this.title = title;
            for (var tag : tags) this.tags.add(tag);
        }

        @Override
        public String render() {
            return (done ? "✓ " : "· ") + title + " " + tags;
        }

        @Override
        public int compareTo(Task other) { return Long.compare(this.id, other.id); }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (!(o instanceof Task t)) return false;
            return id == t.id && done == t.done && Objects.equals(title, t.title);
        }

        @Override
        public int hashCode() { return Objects.hash(id, title, done); }

        @Override
        protected Task clone() throws CloneNotSupportedException {
            return (Task) super.clone();
        }

        synchronized void toggle() { this.done = !this.done; }
    }

    abstract static class Component<T> {
        abstract T render() throws IllegalStateException;

        static <U extends Comparable<? super U>> U max(List<? extends U> items) {
            return items.stream().max(Comparator.naturalOrder()).orElseThrow();
        }
    }

    public static final String BANNER = "Yazılım Yolu";
    static final Map<String, Level> REGISTRY = Map.ofEntries(
            entry("uyari", Level.WARN), entry("hata", Level.ERROR));

    private static int counter;

    static { counter = 0; }

    static String classify(Object value) {
        return switch (value) {
            case null -> "yok";
            case Integer i when i > 0 && i < 100 -> "küçük pozitif " + i;
            case Leaf(long id, String title) -> "yaprak %d/%s".formatted(id, title);
            case Branch b -> "dal: " + classify(b.left());
            case String s -> s.strip().toUpperCase();
            case Task t -> t.render();
            default -> value.getClass().getSimpleName();
        };
    }

    @SafeVarargs
    public static <T> List<T> listOf(T... items) { return List.of(items); }

    public static void main(String[] args) throws Exception {
        final int mask = 0b1010 | 0755 ^ 0xDEAD;
        long buyuk = 1_000_000L;
        double oran = 3.14e-2d;
        float kucuk = 1.5f;
        char kacis = '\t';
        byte bayt = (byte) 0xFF;
        short kisa = 42;
        boolean bayrak = true;
        String ham = """
                Metin bloğu: "tırnak" ve \\ kaçışı.
                İkinci satır — %s
                """.formatted(BANNER);

        var tasks = new ArrayList<>(listOf(
                new Task(1, "tema testi", "mor", "turkuaz"),
                new Task(2, "gözden geçir", "gri")));

        var seviyeler = EnumSet.of(Level.WARN, Level.ERROR);
        Function<Task, String> baslik = t -> t.title;

        outer:
        for (int i = 0; i < tasks.size(); i++) {
            for (var t : tasks) {
                if (t.done) continue outer;
                if (t.id > 10) break outer;
            }
            counter += i;
        }

        int n = 0;
        do { n++; } while (n < 3);
        while (n-- > 0) { assert n >= -1 : "negatif"; }

        try (var scope = new java.io.StringWriter()) {
            scope.write(ham);
            synchronized (Sample.class) { tasks.get(0).toggle(); }
            throw new UnsupportedOperationException("deneme");
        } catch (UnsupportedOperationException | IllegalArgumentException e) {
            System.err.println(e.getMessage());
        } finally {
            counter++;
        }

        var kareler = IntStream.rangeClosed(1, 10)
                .filter(x -> x % 2 == 0)
                .mapToObj(x -> x * oran)
                .collect(Collectors.toUnmodifiableList());

        var future = CompletableFuture
                .supplyAsync(() -> Component.max(tasks))
                .thenApply(baslik)
                .exceptionally(t -> "hata");

        Optional<Task> ilk = tasks.stream().filter(t -> !t.done).findFirst();

        System.out.printf("%s | %d | %d | %.4f | %.1f | %d | %d | %b | %c%n",
                BANNER, mask, buyuk, oran, kucuk, bayt, kisa, bayrak, kacis);
        System.out.println(classify(new Branch(new Leaf(1, "x"), null))
                + " | " + kareler + " | " + future.get()
                + " | " + ilk.map(Task::render).orElse("boş")
                + " | " + seviyeler + " | " + REGISTRY.get("uyari").weight()
                + " | " + counter);
    }
}
