# STB Mining Automation Script

Script ini dibuat untuk memudahkan proses mining Verus Coin di perangkat STB yang sudah terinstall **Armbian**.

Cukup dengan meng-clone repository ini dan menjalankan satu script, maka STB akan otomatis:

- Menginstall dependensi yang dibutuhkan (`libssl1.1`)
- Mengunduh dan menyiapkan `ccminer`
- Meminta input alamat wallet dan nama worker
- Menjalankan mining di background menggunakan `screen`
- Menambahkan mining agar otomatis berjalan saat boot (`cron`)

---

## Cara Menggunakan

1. Pastikan STB kamu sudah menggunakan **Armbian** dan memiliki koneksi internet.

2. Clone repository:

```bash
git clone https://github.com/moenz-id/Mining.git
cd Mining
```

3. Jalankan script:

```bash
bash start-mining.sh
```

4. Masukkan **alamat wallet Verus** dan **nama worker** saat diminta.

---

## Melihat Status Mining

Script ini menjalankan `ccminer` dalam session `screen` bernama `verus`.

Untuk melihat status mining:

```bash
screen -r verus
```

Untuk keluar dari screen tanpa menghentikan proses:

- Tekan `Ctrl + A`, lalu `D`

---

## Persyaratan

- STB dengan Armbian (arm64)
- Koneksi internet
- Alamat wallet Verus Coin

---

## Catatan

Script ini tidak melakukan overclock atau modifikasi sistem. Hanya fokus pada instalasi `ccminer` dan menjalankan mining secara otomatis.

---

## Credits

- ccminer & library dari [rdsp87/dero-stb](https://github.com/rdsp87/dero-stb)
