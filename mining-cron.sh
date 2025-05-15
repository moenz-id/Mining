#!/bin/bash

# Langkah 1: Menginstal dependensi yang dibutuhkan
echo "Menginstal dependensi..."
#apt update
#sudo apt install -y   # Gantilah dengan dependensi yang sesuai

# Langkah 2: Meng-cloning repository dari GitHub
echo "Meng-clone repository dari GitHub..."
#git clone https://github.com/username/repository.git  # Gantilah dengan URL repository yang sesuai

# Langkah 3: Masuk ke folder tertentu
echo "Masuk ke folder repository..."
#cd /path/to/directory  # Gantilah dengan path folder yang sesuai

# Fungsi untuk meminta input dan memastikan input tidak kosong
get_input() {
    local prompt=$1
    local input

    while true; do
        read -p "$prompt: " input
        if [[ -n "$input" ]]; then
            echo "$input"
            break
        else
            echo "Input tidak boleh kosong. Silakan coba lagi."
        fi
    done
}

# Langkah 4: Meminta input untuk alamat wallet dan nama worker
ALAMAT_WALLET=$(get_input "Masukkan ALAMAT-WALLET")
NAMA_WORKER=$(get_input "Masukkan NAMA WORKER")

# Membuat file miner.sh dan mengeditnya
echo "Membuat file miner.sh..."
cat <<EOF > miner.sh
#!/bin/bash
./ccminer/ccminer -a verus -o stratum+tcp://sg.vipor.net:5040 -u $ALAMAT_WALLET.$NAMA_WORKER -p x -t 4
EOF

# Langkah 5: Mengubah izin dari beberapa file
echo "Mengubah izin file..."
chmod +x miner.sh  # Ubah izin file miner.sh agar dapat dieksekusi

# Langkah 6: Menambahkan cron job
echo "Menambahkan cron job..."
#(crontab -l ; echo "0 3 * * * /path/to/script.sh") | crontab -  # Menjadwalkan menjalankan script setiap hari pukul 03:00

echo "Selesai!"