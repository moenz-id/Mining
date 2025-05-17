#!/bin/bash
set -e

PASSWORD="passwodstb"

read -p "Masukkan IP segmen (contoh: 192.168.1): " IP_SEGMENT
read -p "Masukkan alamat wallet Verus: " WALLET

LIB_PATH="./lib/aarch64-linux-gnu"
CCMINER_PATH="./ccminer"

if [ ! -d "$LIB_PATH" ] || [ ! -f "$CCMINER_PATH/ccminer" ]; then
  echo "[ERROR] Folder lib atau ccminer tidak ditemukan di direktori script."
  exit 1
fi

echo "[INFO] Mulai scan IP di segmen $IP_SEGMENT.0/24"

count=1
for i in {1..254}; do
  IP="$IP_SEGMENT.$i"

  # Tes SSH koneksi
  sshpass -p "$PASSWORD" ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no root@"$IP" "echo 'OK'" >/dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "[SKIP] $IP tidak bisa diakses SSH."
    continue
  fi

  echo "[CHECK] Cek mining sudah jalan di $IP ..."
  # Cek ccminer sudah jalan atau folder ccminer ada
  sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no root@"$IP" '
    pgrep -f ccminer >/dev/null || test -d /root/ccminer
  '
  if [ $? -eq 0 ]; then
    echo "[SKIP] Mining sudah berjalan atau ccminer sudah terinstall di $IP."
    continue
  fi

  echo "[SETUP] Setup mining di $IP ..."

  # Copy semua lib ke system
  sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no root@"$IP" "mkdir -p /usr/lib/aarch64-linux-gnu"
  sshpass -p "$PASSWORD" scp -o StrictHostKeyChecking=no -r "$LIB_PATH"/* root@"$IP":/usr/lib/aarch64-linux-gnu/

  # Copy ccminer dan buat folder ccminer
  sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no root@"$IP" "mkdir -p /root/ccminer"
  sshpass -p "$PASSWORD" scp -o StrictHostKeyChecking=no "$CCMINER_PATH/ccminer" root@"$IP":/root/ccminer/
  sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no root@"$IP" "chmod +x /root/ccminer/ccminer"

  # Buat script miner.sh dengan worker sesuai urutan
  WORKER="stb-$count"
  sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no root@"$IP" bash -c "'
    cat > /root/ccminer/miner.sh << EOF
#!/bin/bash
cd /root/ccminer
./ccminer -a verus -o stratum+tcp://sg.vipor.net:5040 -u ${WALLET}.${WORKER} -p x -t 4
EOF
    chmod +x /root/ccminer/miner.sh
  '"

  # Jalankan miner di screen bernama verus
  sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no root@"$IP" "screen -dmS verus /root/ccminer/miner.sh"

  echo "[DONE] Mining started on $IP with worker $WORKER"

  count=$((count+1))
done

echo "[FINISH] Proses selesai."
