# QFieldCloud auf Synology DS1517+ (Ubuntu-24.04-VM)

Selbst gehosteter QFieldCloud-Server hinter dem DSM-Reverse-Proxy
(`https://qfield.example.com/`). Dokumentation, Konfiguration und
Testprojekt, um den Server spaeter neu aufsetzen zu koennen.

## Inhalt
| Pfad | Beschreibung |
|---|---|
| [`docs/QFieldCloud_Deployment_Dokumentation.md`](docs/QFieldCloud_Deployment_Dokumentation.md) | Komplette Installations-, Betriebs-, Backup- und Restore-Doku (inkl. Netzwerkgrafiken), direkt auf GitHub lesbar |
| `docs/QFieldCloud_Deployment_Dokumentation.docx` | Dieselbe Doku als Word-Dokument (mit Inhaltsverzeichnis und Seitenzahlen) |
| `docs/Reverse_Proxy_Checkliste.docx` | Generische 5-Schritte-Checkliste: neues Projekt ueber DSM-Reverse-Proxy veroeffentlichen |
| `docs/QGIS_Authentifizierung_Hauptkennwort.docx` | QGIS-Hauptkennwort-Dialog bei QFieldCloud-Anmeldung |
| `config/` | Override-Compose, nginx-Snippet, Netplan, fstab, systemd-Units, `.env`-Vorlage |
| `scripts/qfc-backup.sh` | Taegliches Backup (PostgreSQL, RustFS, Konfiguration) auf NFS-Share |
| `testprojekt/qfieldtest_neu.zip` | QField-Testprojekt (Punkt/Linie/Polygon + OSM) |

## Architektur in Kurzform
Internet -> Router (80/443) -> DSM-Reverse-Proxy (TLS, Let's Encrypt, SNI) ->
Ubuntu-VM `192.168.1.20` (HTTPS/443) -> nginx -> Django/Gunicorn, PostGIS, RustFS,
QGIS-Worker-Container.

## Hinweise
- Alle Hostnamen und IPs sind anonymisiert: `example.com` (Domain), `meinnas.synology.me` (DDNS), `192.168.1.10` (NAS), `192.168.1.20` (QFieldCloud-VM). Bitte durch eigene Werte ersetzen.
- Dateien mit `RECONSTRUCTED` im Kopf wurden aus der Doku rekonstruiert und sollten
  gegen den laufenden Server geprueft werden.
- Keine Geheimnisse committen (`.env`, `SECRET_KEY`, `SALT_KEY`, Passwoerter,
  mkcert-`rootCA-key.pem`). `.gitignore` deckt die gaengigen Faelle ab.
- Backup-Archive der Konfiguration enthalten den mkcert-CA-Key: nur privat und sicher ablegen.
