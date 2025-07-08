# 🛡️ Domowy Audyt Bezpieczeństwa Sieci LAN (2025)

📍 Autor: **AdrianJ & ALEX**  
📆 Rok: **2025**  
🐧 OS: Parrot Security OS  
🎯 Cel: Identyfikacja hostów, analiza urządzeń, wykrycie podatności w domowej sieci lokalnej (192.168.1.0/24)

---

## 🔍 Opis

Ten projekt wykonuje **pełen pasywny i aktywny audyt bezpieczeństwa LAN**, przy użyciu Nmapa, prostego AI-wnioskowania i danych z zewnętrznych źródeł (macvendors.com).  
Dzięki temu skryptowi możesz zidentyfikować:
- wszystkie aktywne urządzenia w sieci,
- usługi i porty, które wystawiają,
- producenta sprzętu (na podstawie MAC),
- potencjalne zagrożenia (np. Telnet, RTSP, CVE).

---

## 🧠 Co robi skrypt `audit_domowy_adrianj_2025.sh`

1. Skanuje sieć lokalną (`nmap -sn`) i zapisuje żywe hosty
2. Dla każdego hosta:
   - Pobiera adres MAC
   - Odczytuje producenta (API `macvendors.com`)
   - Skanuje wszystkie porty i usługi (`nmap -sV -p-`)
   - Na podstawie usług zgaduje **typ urządzenia (AI-style logika)**:
     - Kamera IP 📸
     - Router/Panel Admina 💻
     - Apple 🍏
     - Niebezpieczny Telnet 🧨
   - Wykonuje skan luk (`nmap --script vuln`)
3. Zapisuje całość do raportu `audit_domowy_adrianj_2025.txt`

---

## 📂 Struktura

.
├── audit_domowy_adrianj_2025.sh # Główny skrypt audytu
├── audit_domowy_adrianj_2025.txt # Wygenerowany raport
├── live_hosts.txt # Lista aktywnych IP
├── nmap_<ip>.txt # Skan portów każdego hosta
├── vuln_<ip>.txt # Wyniki skanów podatności
└── README.md


---

## 🧪 Wymagania

- `nmap`
- `curl`
- `bash`
- Uprawnienia sudo (jeśli chcesz dokładniejszych danych ARP)
- Dostęp do internetu (dla zapytań do macvendors)

---

## ✅ Przykład uruchomienia

```bash
chmod +x audit_domowy_adrianj_2025.sh
./audit_domowy_adrianj_2025.sh

📌 Przykładowe Wykrycia
IP	Typ	Otwarte porty	Wykryto lukę?
192.168.1.1	💻 Router	53, 80, 5555	✅ Slowloris (CVE-2007-6750)
192.168.1.102	❓ Niezidentyfikowany	6667	brak
192.168.1.115	💻 Możliwy JBoss/Tomcat	8443, 8080	brak