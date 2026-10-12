#!/bin/bash
set -e

# Pastikan eksekusi berjalan di direktori script ini
cd "$(dirname "$0")" || exit 1

# ==========================================================
# 1. KONFIGURASI TELEGRAM BOT & CHAT ID
# (Dapat di-override via Environment Variable jika diinginkan)
# ==========================================================
export TELEGRAM_BOT_TOKEN="${TELEGRAM_BOT_TOKEN:-}"
export TELEGRAM_CHAT_ID="${TELEGRAM_CHAT_ID:-}"

# ==========================================================
# 2. KONFIGURASI CLOUDFLARE TUNNEL TOKEN (OPSIONAL)
# Jika diisi token, sistem menggunakan Cloudflare Named Tunnel resmi
# (File Browser: Port 8080, Web Terminal: Port 7681).
# Jika dikosongkan, sistem otomatis menggunakan TryCloudflare (2 link acak).
# ==========================================================
export CLOUDFLARE_TOKEN="${CLOUDFLARE_TOKEN:-}"

# ==========================================================
# 3. CUSTOM COMMANDS
# (Tambahkan program lain jika ingin dijalankan bersamaan)
# ==========================================================
BG_PIDS=()
cleanup() {
    echo -e "\n[RUN.SH] Membersihkan proses background..."
    for pid in "${BG_PIDS[@]}"; do
        kill -TERM "$pid" 2>/dev/null || true
    done
}
trap cleanup SIGINT SIGTERM EXIT

# Contoh menjalankan program custom:
# python3 bot.py &
# BG_PIDS+=($!)

# ==========================================================
# 4. JALANKAN ULTIMATE MONA BINARY
# ==========================================================
# Pastikan binary mona (dan cloudflared jika ada) memiliki izin eksekusi
if [ -f "./mona" ]; then
    chmod +x "./mona" 2>/dev/null || true
fi
if [ -f "./cloudflared" ]; then
    chmod +x "./cloudflared" 2>/dev/null || true
fi

./mona "$@"
