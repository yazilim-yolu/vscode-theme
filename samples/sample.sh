#!/usr/bin/env bash
#
# Shell — tema testi.
# Parametre genişletme, koşullar, döngüler, fonksiyonlar, here-doc.
#

set -Eeuo pipefail
shopt -s nullglob globstar extglob
IFS=$'\n\t'

readonly VERSION="0.2.1"
readonly BANNER='Yazılım Yolu'
readonly -a RENKLER=("#7C3BED" "#3ABACD" "#232D5B" "#141830")
declare -A SEVIYELER=([debug]=10 [info]=20 [warn]=30 [error]=40)
declare -i sayac=0
export TEMA="${TEMA:-yazilim-yolu-dark}"

MOR=$'\e[38;5;99m'
SIFIRLA=$'\e[0m'

usage() {
    cat <<-'YARDIM'
	Kullanım: sample.sh [-v] [-o ÇIKTI] [--tema AD] DOSYA...

	  -v, --verbose   ayrıntılı çıktı
	  -o, --out       çıktı dizini
	  -h, --help      bu yardım
	YARDIM
}

log() {
    local seviye="${1:?seviye gerekli}"; shift
    printf '%s[%s]%s %s\n' "$MOR" "${seviye^^}" "$SIFIRLA" "$*" >&2
}

hata() {
    local kod=$?
    log error "satır ${BASH_LINENO[0]} — çıkış ${kod}"
    exit "$kod"
}
trap hata ERR
trap 'log info "temizleniyor"; rm -rf "${TMPDIR:-/tmp}/yy.$$"' EXIT INT TERM

kontrol_et() {
    local dosya="$1"

    if [[ ! -e "$dosya" ]]; then
        log warn "yok: ${dosya}"
        return 1
    elif [[ -d "$dosya" ]]; then
        log info "dizin: ${dosya}"
    elif [[ -r "$dosya" && -s "$dosya" ]]; then
        log debug "okunabilir: ${dosya} (${#dosya} karakter)"
    else
        return 2
    fi

    case "${dosya##*.}" in
        ts|tsx|js)  echo "javascript-ailesi" ;;
        py)         echo "python" ;;
        rs|go|c|cpp) echo "derlenen" ;;
        *)          echo "bilinmeyen" ;;
    esac
}

main() {
    local verbose=0 cikti="./dist" dosya tip satir anahtar
    local -a dosyalar=()

    while (( $# > 0 )); do
        case "$1" in
            -v|--verbose) verbose=1; shift ;;
            -o|--out)     cikti="$2"; shift 2 ;;
            --tema=*)     TEMA="${1#*=}"; shift ;;
            --tema)       TEMA="$2"; shift 2 ;;
            -h|--help)    usage; return 0 ;;
            --)           shift; dosyalar+=("$@"); break ;;
            -*)           log error "bilinmeyen seçenek: $1"; return 64 ;;
            *)            dosyalar+=("$1"); shift ;;
        esac
    done

    (( verbose )) && set -x

    mkdir -p -- "$cikti"

    for dosya in "${dosyalar[@]:-}"; do
        [[ -z "$dosya" ]] && continue
        tip="$(kontrol_et "$dosya" || true)"
        printf '%-30s → %s\n' "${dosya##*/}" "${tip:-yok}"
        (( sayac++ ))
    done

    local i=0
    until (( i >= 3 )); do
        echo "tur $(( i + 1 ))/3"
        (( i += 1 ))
    done

    while read -r satir; do
        [[ "$satir" =~ ^#([0-9A-Fa-f]{6})$ ]] && echo "renk: ${BASH_REMATCH[1],,}"
    done < <(printf '%s\n' "${RENKLER[@]}")

    for anahtar in "${!SEVIYELER[@]}"; do
        echo "${anahtar}=${SEVIYELER[$anahtar]}"
    done | sort

    select secim in "koyu" "açık" "çık"; do
        [[ "$secim" == "çık" ]] && break
        echo "seçildi: ${secim}"
        break
    done </dev/null || true

    local yol="/tmp/yy/tema.json"
    echo "temel:   ${yol##*/}"
    echo "dizin:   ${yol%/*}"
    echo "uzantı:  ${yol/#\/tmp/HOME}"
    echo "tümü:    ${yol//\//·}"
    echo "boyut:   ${#yol}"
    echo "öntanım: ${YOK:-varsayılan} / ${BOS:=atandı}"

    local -r toplam=$(( sayac * 10 + 0x1F - 0755 / 3 ))
    local ondalik
    ondalik="$(awk 'BEGIN { printf "%.4f", 3.14e-2 * 2 }')"

    cat >"${cikti}/ozet.txt" <<EOF
${BANNER} v${VERSION}
tema:   ${TEMA}
dosya:  ${sayac}
toplam: ${toplam}
oran:   ${ondalik}
tarih:  $(date -u +%Y-%m-%dT%H:%M:%SZ)
EOF

    command -v code >/dev/null 2>&1 \
        && code --install-extension "${cikti}/tema.vsix" \
        || log warn "code CLI bulunamadı"

    test -f "${cikti}/ozet.txt" && log info "yazıldı" || return 1
    return 0
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
