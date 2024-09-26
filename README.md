# Infrastruktur für das JDAV Bayern Portal

Wir nutzen traefik als Reverse Proxy und Docker im Swarm Mode für die Infrastruktur. Die Konfiguration erfolgt über Docker-Compose-Files.

Um einen Docker Swarm zu starten, führe folgenden Befehl aus:

```bash
docker swarm init
```

Um den Stack zu starten, oder Änderungen zu übernehmen, führe folgenden Befehl aus:

```bash
docker stack deploy -c docker-compose.yml portal-jdav-bayern
```

Wobei `portal-jdav-bayern` der Name des Stacks ist und `docker-compose.yml` das Compose-File.

Um den Stack zu stoppen:

```bash
docker stack rm portal-jdav-bayern
```

## Rollende Updates

Der Swarm ist so konfiguriert, dass unser Anwendungsservice (`webapp` im Compose-File) repliziert gestartet wird. Das bedeutet, dass mehrere Instanzen des Services laufen und der Loadbalancer (traefik) die Anfragen auf die Instanzen verteilt.

Bei einem Rollenden Update kümmert sich der Swarm darum, dass die Instanzen nacheinander aktualisiert werden, sodass der Service immer verfügbar ist.

Um das image auf das aktuellste image unserer Anwendung zu aktualisieren, führe folgenden Befehl aus:

```bash
docker service update --image jdavbayern/portal-jdav-bayern:latest portal-jdav-bayern_webapp
```

Dieser Befehl wird am besten in einem Cron-Job ausgeführt, um die Anwendung immer auf dem neuesten Stand zu halten.
Für das Setup des Cron-Jobs, einfach die folgenden Schritte ausführen:

```bash
crontab -e
```

und folgende Zeile hinzufügen:

```bash
0 3 * * * docker service update --image jdavbayern/portal-jdav-bayern:latest portal-jdav-bayern_webapp
```

Dieser Cron-Job führt das Update jeden Tag um 3 Uhr morgens aus.
