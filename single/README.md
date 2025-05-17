
# Single STB Mining Setup

Script ini ditujukan untuk setup otomatis mining Verus Coin pada satu perangkat STB berbasis Armbian (arm64).

## Fitur

- Install dependency `libssl1.1` secara otomatis
- Download dan siapkan `ccminer`
- Meminta input wallet & nama worker
- Menjalankan mining dengan `screen`
- Menambahkan cron agar mining otomatis saat boot

## Instalasi Cepat (Inline One-liner)

Untuk instalasi langsung tanpa clone manual:

```bash
bash <(curl -sSL https://raw.githubusercontent.com/moenz-id/Mining/main/single/start-mining.sh)
```

Atau clone secara manual:

```bash
git clone https://github.com/moenz-id/Mining.git
cd Mining/single
bash start-mining.sh
```

## Persyaratan

- STB dengan Armbian (arm64)
- Internet aktif
- Wallet Verus

## Melihat Status Mining

```bash
screen -r verus
```

Tekan `Ctrl + A` lalu `D` untuk keluar tanpa menghentikan proses.

---

© moenz-id | [https://github.com/moenz-id/Mining](https://github.com/moenz-id/Mining)
