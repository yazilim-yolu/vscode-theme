// C# — tema testi.
// Nullable referanslar, LINQ, record'lar, pattern matching ve async.

#nullable enable
#define IZLEME

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json.Serialization;
using System.Threading;
using System.Threading.Tasks;

namespace YazilimYolu.Samples;

public enum Level : byte
{
    Debug = 10,
    Info = 20,
    Warn = 30,
    Error = 40,
}

[Flags]
public enum Izin
{
    Yok = 0,
    Oku = 1 << 0,
    Yaz = 1 << 1,
    Calistir = 1 << 2,
    Tumu = Oku | Yaz | Calistir,
}

public interface IRenderer<out T>
{
    T Render();
    static abstract string Banner { get; }
}

public delegate void TaskHandler(object? sender, Task task);

public readonly record struct Point(double X, double Y)
{
    public double Length => Math.Sqrt(X * X + Y * Y);
    public static Point operator +(Point a, Point b) => new(a.X + b.X, a.Y + b.Y);
}

public record Task(ulong Id, string Title)
{
    [JsonPropertyName("done")]
    public bool Done { get; init; }

    public required IReadOnlyList<string> Tags { get; init; }

    public void Deconstruct(out ulong id, out string title) => (id, title) = (Id, Title);
}

public abstract class Component : IRenderer<string>, IDisposable, IAsyncDisposable
{
    protected internal const string Version = "0.2.1";
    private static int _instances;
    private readonly List<Task> _tasks = new();
    private bool _disposed;

    public static string Banner => "Yazılım Yolu";
    public event TaskHandler? Changed;

    protected Component() => Interlocked.Increment(ref _instances);

    public abstract string Render();

    public virtual void Add(params Task[] tasks)
    {
        ArgumentNullException.ThrowIfNull(tasks);
        _tasks.AddRange(tasks);
        Changed?.Invoke(this, tasks[^1]);
    }

    public IEnumerable<Task> Pending() =>
        from t in _tasks
        where !t.Done && t.Tags.Any()
        orderby t.Id descending
        select t with { Title = t.Title.ToUpperInvariant() };

    public void Dispose()
    {
        if (_disposed) return;
        _disposed = true;
        GC.SuppressFinalize(this);
    }

    public async ValueTask DisposeAsync()
    {
        await System.Threading.Tasks.Task.Yield();
        Dispose();
    }
}

public sealed class Board : Component
{
    public override string Render() =>
        string.Join(Environment.NewLine, Pending().Select(static t => $"· {t.Title}"));

    public static string Classify(object? value) => value switch
    {
        null => "yok",
        true => "doğru",
        int and > 0 and < 100 => "küçük pozitif",
        Task { Done: true, Tags.Count: > 0 } t => $"tamam: {t.Title}",
        Point(var x, var y) when x > y => "x baskın",
        string s => s.Trim(),
        _ => value.ToString() ?? "bilinmiyor",
    };
}

public static class Program
{
    private static unsafe int RawSize()
    {
        int local = 0b1010 | 0xDEAD;
        int* ptr = stackalloc int[4];
        fixed (char* c = "abc") { local += *c; }
        ptr[0] = local;
        return ptr[0];
    }

    public static async System.Threading.Tasks.Task<int> Main(string[] args)
    {
        checked
        {
            const long buyuk = 1_000_000L;
            var oran = 3.14e-2d;
            decimal para = 19.99m;
            var ham = @"kaçış ""yok"" \n burada";
            var enterpolasyon = $"{Component.Banner,-20} v{Component.Version} → {para:C}";

            using var board = new Board();
            board.Changed += (sender, task) => Console.WriteLine($"eklendi: {task.Id}");
            board.Add(new Task(1, "tema testi") { Tags = new[] { "mor", "turkuaz" } },
                      new Task(2, "gözden geçir") { Done = true, Tags = Array.Empty<string>() });

            var kareler = Enumerable.Range(0, 10)
                                    .Where(n => n % 2 is 0)
                                    .Select(n => (double)n * n * oran)
                                    .ToDictionary(k => (int)k, v => v);

            foreach (var (key, value) in kareler)
            {
                if (key < 0) continue;
                if (key > 50) break;
                Console.Write($"{key}:{value:F2} ");
            }

            for (int i = 0; i < 3; i++)
            {
                switch ((Level)(i * 10 + 10))
                {
                    case Level.Debug:
                    case Level.Info:
                        goto case Level.Warn;
                    case Level.Warn:
                        break;
                    default:
                        throw new InvalidOperationException("olmaz");
                }
            }

            int sayac = 0;
            do { sayac++; } while (sayac < 3);
            while (sayac-- > 0) { }

            try
            {
                var izin = Izin.Oku | Izin.Yaz;
                if (!izin.HasFlag(Izin.Calistir))
                    throw new UnauthorizedAccessException(nameof(Izin.Calistir));
            }
            catch (UnauthorizedAccessException ex) when (ex.Message.Length > 0)
            {
                Console.Error.WriteLine(ex.Message);
            }
            finally
            {
                await System.Threading.Tasks.Task.Delay(TimeSpan.FromMilliseconds(1));
            }

            var nokta = new Point(3, 4) + new Point(1, 1);
            object? kutu = board is Component c ? c.Render() : default;

            Console.WriteLine($"{enterpolasyon} | {ham} | {buyuk} | {nokta.Length:0.###} | " +
                              $"{Board.Classify(nokta)} | {kutu as string} | {RawSize()}");

            await using var kaynak = board;
            return args.Length switch { 0 => 0, _ => args.Length };
        }
    }
}
