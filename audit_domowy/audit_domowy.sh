#!/bin/bash
# Author: AdrianJ & ALEX (2025)
# Audit domowy: sieć LAN + analiza AI

NETWORK="192.168.1.0/24"
REPORT="audit_domowy_adrianj_2025.txt"
TMP="tmp_audit_scan.txt"

echo "[*] Rozpoczynam skanowanie sieci domowej: $NETWORK" | tee $REPORT
echo "" > $TMP

# 1. Odkryj hosty
nmap -sn $NETWORK -oG - | awk '/Up$/{print $2}' > live_hosts.txt
echo "[*] Wykryto $(wc -l < live_hosts.txt) aktywnych hostów." | tee -a $REPORT
echo "" >> $REPORT

# 2. Dla każdego hosta - zbierz dane
for ip in $(cat live_hosts.txt); do
  echo "[+] Analiza hosta: $ip" | tee -a $REPORT
  echo "--------------------------------------------" >> $REPORT
  
  # MAC + producent
  MAC=$(arp -an $ip | grep -oE "([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}")
  echo "IP: $ip" >> $REPORT
  echo "MAC: $MAC" >> $REPORT

  # Wyszukiwanie producenta (MAC OUI)
  VENDOR=$(curl -s "https://api.macvendors.com/$MAC")
  echo "Producent: $VENDOR" >> $REPORT
  
  # Skan portów i usług
  nmap -sV -T4 -Pn -p- --min-rate=1000 $ip -oN nmap_$ip.txt
  echo "Otwartych portów: $(grep open nmap_$ip.txt | wc -l)" >> $REPORT

  # AI analiza typu urządzenia
  TYPE=$(grep open nmap_$ip.txt | awk '{print $3}' | tr '\n' ',' | sed 's/,$//')
  echo "Usługi: $TYPE" >> $REPORT

  if [[ $TYPE == *"rtsp"* ]]; then
    echo "Typ: 📸 Kamera IP (prawdopodobnie)" >> $REPORT
  elif [[ $TYPE == *"http"* && $TYPE == *"ssh"* ]]; then
    echo "Typ: 💻 Serwer lub router z panelem admina" >> $REPORT
  elif [[ $TYPE == *"telnet"* ]]; then
    echo "Typ: 🧨 Niebezpieczny sprzęt (Telnet!)" >> $REPORT
  elif [[ $TYPE == *"mdns"* || $VENDOR == *"Apple"* ]]; then
    echo "Typ: 🍏 Urządzenie Apple" >> $REPORT
  else
    echo "Typ: ❓ Niezidentyfikowany (sprawdź ręcznie)" >> $REPORT
  fi

  # Podstawowe skrypty luk
  echo "[*] Skanowanie podatności..." >> $REPORT
  nmap --script vuln -Pn $ip -oN vuln_$ip.txt
  grep "VULNERABLE" vuln_$ip.txt >> $REPORT || echo "Brak oczywistych luk." >> $REPORT
  
  echo "" >> $REPORT
done

echo "[✔] Audyt zakończony. Raport zapisany do: $REPORT"
