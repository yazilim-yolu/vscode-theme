// C++ — tema testi.
// Şablonlar, concept'ler, lambda'lar, RAII ve modern anahtar kelimeler.

#include <algorithm>
#include <concepts>
#include <coroutine>
#include <cstdint>
#include <expected>
#include <iostream>
#include <map>
#include <memory>
#include <optional>
#include <ranges>
#include <string>
#include <string_view>
#include <vector>

#pragma once

#define YY_VERSION "0.2.1"

namespace yazilim::yolu {

inline constexpr std::string_view kBanner{"Yazılım Yolu"};
static thread_local int g_sayac = 0;

enum class Level : std::uint8_t { Debug = 10, Info = 20, Warn = 30, Error = 40 };

template <typename T>
concept Sayisal = std::integral<T> || std::floating_point<T>;

struct Etiket final {
    std::string ad;
    mutable bool onbellek{false};

    [[nodiscard]] auto operator<=>(const Etiket&) const = default;
};

class Task {
public:
    explicit Task(std::uint64_t id, std::string title) noexcept
        : id_{id}, title_{std::move(title)} {}

    Task(const Task&) = default;
    Task(Task&&) noexcept = default;
    Task& operator=(const Task&) = delete;
    virtual ~Task() = default;

    [[nodiscard]] virtual std::string render() const {
        return (done_ ? "✓ " : "· ") + title_;
    }

    [[nodiscard]] constexpr std::uint64_t id() const noexcept { return id_; }
    void mark(bool value = true) & noexcept { done_ = value; }

    friend std::ostream& operator<<(std::ostream& os, const Task& t) {
        return os << "Task#" << t.id_ << '<' << t.title_ << '>';
    }

protected:
    std::uint64_t id_{};
    std::string title_;

private:
    bool done_{false};
    inline static std::size_t count_ = 0;
};

class Panel : public virtual Task {
public:
    using Task::Task;

    std::string render() const override {
        return std::string{kBanner} + " :: " + Task::render();
    }
};

template <Sayisal T, std::size_t N = 8>
class Buffer {
public:
    using value_type = T;

    template <typename... Args>
    constexpr void emplace(Args&&... args) {
        items_.emplace_back(std::forward<Args>(args)...);
    }

    [[nodiscard]] constexpr T topla() const noexcept {
        T toplam{};
        for (const auto& v : items_) toplam += v;
        return toplam;
    }

private:
    std::vector<T> items_{};
};

template <>
class Buffer<bool, 8> {
public:
    bool any{false};
};

consteval std::size_t derleme_zamani(std::size_t n) { return n * 2; }

constexpr auto kare = [](Sayisal auto x) noexcept { return x * x; };

std::expected<double, std::string> bol(double a, double b) {
    if (b == 0.0) return std::unexpected{"sıfıra bölme"};
    return a / b;
}

}  // namespace yazilim::yolu

using namespace yazilim::yolu;

int main(int argc, char** argv) try {
    constexpr int kMask = 0b1010 | 0755 ^ 0xDEAD;
    constexpr double kOran = 3.14e-2;
    const auto ham = R"(kaçış "yok" \n burada)";
    auto sayilar = std::vector<int>{5, 3, 9, 1, 7, 1'000'000};

    std::unique_ptr<Task> gorev = std::make_unique<Panel>(1ULL, "tema testi");
    std::shared_ptr<Task> paylasilan{std::move(gorev)};
    std::weak_ptr<Task> zayif = paylasilan;

    std::map<std::string, Level> kayit{{"uyari", Level::Warn}, {"hata", Level::Error}};

    Buffer<double> tampon;
    for (int n : sayilar | std::views::filter([](int x) { return x % 2; }) | std::views::take(3)) {
        tampon.emplace(static_cast<double>(kare(n)));
    }

    std::sort(sayilar.begin(), sayilar.end(), [](auto a, auto b) noexcept { return a > b; });

    switch (auto seviye = kayit.at("uyari"); seviye) {
        case Level::Debug:
        case Level::Info:
            ++g_sayac;
            break;
        case Level::Warn:
            [[fallthrough]];
        case Level::Error:
            g_sayac += 10;
            break;
        default:
            throw std::runtime_error{"bilinmeyen seviye"};
    }

    if (auto it = std::ranges::find(sayilar, 9); it != sayilar.end()) {
        std::cout << *it << '\n';
    }

    for (std::size_t i = 0; i < sayilar.size(); ++i) {
        if (sayilar[i] < 0) continue;
        while (false) { break; }
        do { static_cast<void>(i); } while (false);
    }

    if (auto sonuc = bol(static_cast<double>(kMask), kOran); sonuc.has_value()) {
        std::cout << *sonuc << ' ' << derleme_zamani(4) << ' ' << ham << '\n';
    } else {
        std::cerr << sonuc.error() << '\n';
    }

    std::cout << *paylasilan << " | " << paylasilan->render() << " | "
              << tampon.topla() << " | " << zayif.use_count() << " | "
              << std::boolalpha << (argc > 1) << " | " << YY_VERSION << '\n';

    return EXIT_SUCCESS;
} catch (const std::exception& e) {
    std::cerr << "hata: " << e.what() << '\n';
    return EXIT_FAILURE;
} catch (...) {
    return -1;
}
