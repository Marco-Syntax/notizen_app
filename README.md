# Notizen-App (Flutter + FastAPI + Docker)

## Projektübersicht

Dieses Projekt ist eine einfache Notizen-App, die eine Kombination aus einem **Flutter-Frontend**, einem **FastAPI-Backend** und **Docker** verwendet. Die App ermöglicht es, Notizen zu erstellen, anzuzeigen, zu bearbeiten und zu löschen. Die Anwendung wurde als Übungsprojekt entwickelt, um das Zusammenspiel zwischen verschiedenen Technologien zu demonstrieren.

### Verwendete Technologien

- **Flutter**: Für das Frontend, das eine benutzerfreundliche Oberfläche zur Verwaltung von Notizen bietet.
- **FastAPI**: Für das Backend, das eine schnelle und asynchrone API-Schnittstelle zur Verwaltung der Notizen bereitstellt.
- **SQLite**: Als Datenbank zur lokalen Speicherung der Notizen. Die Struktur kann leicht angepasst werden, um andere Datenbanken wie MySQL zu verwenden.
- **Docker**: Zur Containerisierung des Backends, um die API in einer isolierten und reproduzierbaren Umgebung zu betreiben.
- **Swagger**: Automatisch generierte API-Dokumentation, um die API-Endpunkte zu testen und zu dokumentieren.

### Umgesetzte Features

- **Notizen-Management**: Funktionen zum Erstellen, Bearbeiten, Löschen und Anzeigen von Notizen.
- **REST API**: Endpunkte für die Notizverwaltung (GET, POST, PUT, DELETE) mit FastAPI.
- **Docker-Integration**: Das Backend läuft in einem Docker-Container, was die Bereitstellung und Verwaltung der API erleichtert.
- **Swagger UI**: Automatische API-Dokumentation zur einfachen Erkundung und zum Testen der API-Endpunkte.

### Mögliche Weiterentwicklung

- Integration einer MySQL- oder PostgreSQL-Datenbank.
- Deployment des gesamten Stacks auf einer Cloud-Plattform (z.B. Heroku, AWS).
