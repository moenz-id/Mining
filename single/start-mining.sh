#!/bin/bash
set -e  # Stop jika terjadi error

echo "[STEP 1] Cek & Install libssl1.1..."
if ! dpkg -l | grep -q "libssl1.1"; then
  wget -q https://mirror.unilak.ac.id/debian/pool/main/o/openssl/libssl1.1_1.1.1n-0+deb10u3_arm64.deb
  dpkg -i libssl1.1_1.1.1n-0+deb10u3_arm64.deb || apt --fix-broken install -y
else
  echo "libssl1.1 sudah terinstal."
fi

echo "[STEP 2] Download & Install ccminer..."
mkdir -p ~/ccminer
cd ~/ccminer
wget -q https://github.com/rdsp87/dero-stb/raw/main/lib.deb -4
dpkg -i lib.deb
wget -q https://github.com/rdsp87/dero-stb/raw/main/ccminer -4
chmod +x ccminer

echo "[STEP 3] Masukkan info mining..."
read -p "Wallet Verus: " wallet
read -p "Nama Worker (mis: rig01): " worker
full_address="${wallet}.${worker}"

echo "[STEP 4] Buat script miner..."
cat > miner.sh <<EOF
#!/bin/bash
cd ~/ccminer
./ccminer -a verus -o stratum+tcp://sg.vipor.net:5040 -u ${full_address} -p x -t 4
EOF
chmod +x miner.sh

echo "[STEP 5] Tambahkan ke cron @reboot (jika belum)..."
(crontab -l 2>/dev/null | grep -v miner.sh; echo "@reboot screen -dmS verus ~/ccminer/miner.sh") | crontab -

echo "[STEP 6] Jalankan mining sekarang..."
screen -dmS verus ~/ccminer/miner.sh
sleep 1
if screen -list | grep -q "verus"; then
  echo "[OK] Mining dimulai. Gunakan 'screen -r verus' untuk melihat log."
else
  echo "[ERROR] Mining gagal dijalankan."
fi
