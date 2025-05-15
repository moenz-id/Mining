#!/bin/bash

# Cek apakah libssl1.1 sudah terinstal
if ! dpkg -l | grep -q "libssl1.1"; then
  echo "libssl1.1 belum terinstal, mengunduh dan menginstal..."
  wget -q https://mirror.unilak.ac.id/debian/pool/main/o/openssl/libssl1.1_1.1.1n-0+deb10u3_arm64.deb
  sudo dpkg -i libssl1.1_1.1.1n-0+deb10u3_arm64.deb
  sudo apt --fix-broken install -y
else
  echo "libssl1.1 sudah terinstal, melanjutkan ke langkah berikutnya..."
fi

# Fungsi untuk meminta input dengan validasi
get_input() {
  while true; do
    read -p "$1: " input
    input=$(echo $input | xargs)  # Menghapus spasi tambahan di awal dan akhir
    if [[ -z "$input" ]]; then
      echo "Input tidak boleh kosong, coba lagi."
    else
      echo "$input"
      break
    fi
  done
}

# Meminta input alamat wallet dan nama worker dari pengguna
while true; do
  wallet_address=$(get_input "Masukkan alamat wallet Verus")
  worker_name=$(get_input "Masukkan nama worker")

  # Gabungkan alamat wallet dan nama worker dengan titik
  full_address="$wallet_address.$worker_name"

  # Menampilkan hasil gabungan untuk konfirmasi
  echo "Alamat wallet dan nama worker yang digabungkan: $full_address"
  read -p "Apakah informasi ini benar? (y/n): " confirmation
  if [[ "$confirmation" == "y" || "$confirmation" == "Y" ]]; then
    break
  else
    echo "Silakan masukkan ulang alamat wallet dan nama worker."
  fi
done

# Download dan install ccminer
echo "Downloading ccminer..."
mkdir -p ~/ccminer
cd ~/ccminer
wget https://github.com/rdsp87/dero-stb/raw/main/lib.deb -4
sudo dpkg -i lib.deb
wget https://github.com/rdsp87/dero-stb/raw/main/ccminer -4
chmod +x ccminer

# Membuat skrip mining
echo "Creating mining script..."
cat > miner.sh <<EOF
#!/bin/bash
./ccminer -a verus -o stratum+tcp://sg.vipor.net:5040 -u $full_address -p x -t 4
EOF

# Memberikan izin eksekusi pada skrip mining
chmod +x miner.sh

# Menjalankan miner
echo "Running miner..."
./miner.sh

# Mengatur mining untuk otomatis berjalan saat boot
echo "Setting up mining to run on boot..."
(crontab -l 2>/dev/null; echo "@reboot screen -dmS verus ~/ccminer/miner.sh") | crontab -

screen -r verus
echo "Mining setup completed successfully!"
