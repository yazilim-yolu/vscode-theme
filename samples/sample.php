<?php
/**
 * PHP — tema testi.
 *
 * @package YazilimYolu\Samples
 * @author  Yazılım Yolu
 */

declare(strict_types=1);

namespace YazilimYolu\Samples;

use ArrayAccess;
use Countable;
use InvalidArgumentException;
use JsonSerializable;
use RuntimeException;
use Stringable;
use Throwable;

use function array_filter;
use function array_map;
use const PHP_EOL;

require_once __DIR__ . '/bootstrap.php';

const VERSION = '0.2.1';
define('BANNER', 'Yazılım Yolu');

enum Level: int
{
    case Debug = 10;
    case Info = 20;
    case Warn = 30;
    case Error = 40;

    public function label(): string
    {
        return match ($this) {
            Level::Debug, Level::Info => 'bilgi',
            Level::Warn => 'uyarı',
            Level::Error => 'hata',
        };
    }
}

interface Renderer extends Stringable
{
    public function render(): string;
}

trait HasTags
{
    /** @var list<string> */
    protected array $tags = [];

    public function addTag(string ...$tags): static
    {
        foreach ($tags as $tag) {
            $this->tags[] = $tag;
        }
        return $this;
    }
}

abstract class Component implements Renderer, Countable
{
    use HasTags;

    public const KIND = 'component';
    protected static int $instances = 0;

    public function __construct(
        public readonly int $id,
        protected string $title = 'isimsiz',
        private bool $done = false,
    ) {
        static::$instances++;
    }

    abstract public function render(): string;

    public function __toString(): string
    {
        return sprintf('%s#%d<%s>', static::class, $this->id, $this->title);
    }

    public function count(): int
    {
        return count($this->tags);
    }

    public function __get(string $name): mixed
    {
        return property_exists($this, $name) ? $this->$name : null;
    }

    final public static function instances(): int
    {
        return self::$instances;
    }
}

final class Task extends Component implements JsonSerializable, ArrayAccess
{
    public function render(): string
    {
        $mark = $this->done ? '✓' : '·';
        return "{$mark} {$this->title} [" . implode(', ', $this->tags) . ']';
    }

    public function jsonSerialize(): array
    {
        return ['id' => $this->id, 'title' => $this->title, 'tags' => $this->tags];
    }

    public function offsetExists(mixed $offset): bool { return isset($this->tags[$offset]); }
    public function offsetGet(mixed $offset): mixed { return $this->tags[$offset] ?? null; }
    public function offsetSet(mixed $offset, mixed $value): void { $this->tags[$offset] = $value; }
    public function offsetUnset(mixed $offset): void { unset($this->tags[$offset]); }
}

function siniflandir(mixed $value): string
{
    return match (true) {
        $value === null => 'yok',
        is_bool($value) => $value ? 'doğru' : 'yanlış',
        is_int($value) && $value > 0 => "pozitif {$value}",
        is_array($value) => 'dizi(' . count($value) . ')',
        $value instanceof Renderer => $value->render(),
        default => gettype($value),
    };
}

$sayilar = [0b1010, 0o755, 0xDEAD, 1_000_000, -42, 3.14e-2];
$harita = ['uyari' => Level::Warn, 'hata' => Level::Error];

$gorev = (new Task(1, 'tema testi'))->addTag('mor', 'turkuaz');
$ikinci = new Task(id: 2, title: 'gözden geçir', done: true);

$kapanis = static fn(int $x): int => $x ** 2;
$eski = function (array $items) use ($kapanis, &$sayilar): array {
    return array_map($kapanis, array_filter($items, static fn($n) => is_int($n) && $n > 0));
};

$heredoc = <<<METIN
    {$gorev->render()} — sürüm {$_SERVER['HTTP_HOST']}
    Değişken enterpolasyonu: {$harita['uyari']->name}
    METIN;

$nowdoc = <<<'HAM'
    $degisken genişletilmez, \n kaçmaz.
    HAM;

try {
    foreach ($sayilar as $index => $sayi) {
        if ($sayi < 0) {
            continue;
        } elseif ($index > 4) {
            break;
        }
        echo siniflandir($sayi), ' ';
    }

    $i = 0;
    do {
        $i++;
    } while ($i < 3);

    while ($i-- > 0) {
        switch (true) {
            case $i === 1:
            case $i === 2:
                break;
            default:
                break 1;
        }
    }

    for ($j = 0; $j < 3; $j++) {
        printf('%d%s', $j, $j < 2 ? ', ' : PHP_EOL);
    }

    if (!isset($yok) && empty($bos) || $gorev instanceof Component) {
        $kareler = $eski($sayilar);
    }

    throw new InvalidArgumentException('deneme', 400);
} catch (InvalidArgumentException | RuntimeException $e) {
    error_log($e->getMessage() . ':' . $e->getCode());
} catch (Throwable) {
    exit(1);
} finally {
    unset($eski);
}

echo BANNER, ' v', VERSION, PHP_EOL;
echo $heredoc, PHP_EOL, $nowdoc, PHP_EOL;
echo json_encode([$gorev, $ikinci], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE), PHP_EOL;
echo Task::instances(), ' | ', count($gorev), ' | ', $gorev[0] ?? 'boş', PHP_EOL;

?>
<article class="task" data-id="<?= htmlspecialchars((string) $gorev->id, ENT_QUOTES) ?>">
    <?php if ($gorev instanceof Renderer): ?>
        <h2><?php echo $gorev->render(); ?></h2>
    <?php else: ?>
        <p>Görev yok.</p>
    <?php endif; ?>
</article>
