# Dockerize-PostgreSQL-DB1

## PostGIS database (recommended reproducible setup)

### Option 1 (BEST): Docker command in README

Run this command to start PostGIS/PostgreSQL:

```bash
docker run -d --name agent-1-postgres-db \
  -e POSTGRES_USER=ishan \
  -e POSTGRES_PASSWORD=YOUR_STRONG_PASSWORD \
  -e POSTGRES_DB=agent_1_db \
  -p 5434:5432 \
  postgis/postgis
```

> Note: don’t hardcode real passwords in public repos. Prefer Option 2 below.

---

### Option 2 (PROPER DEV WAY): Docker Compose

This repo includes `docker-compose.yml` configured to read credentials from `.env`.

1) Copy the example env file:

```bash
copy .env.example .env
```

2) Edit `.env` with your values.

3) Start the database:

```bash
docker compose up -d
```

4) Verify:

```bash
docker ps
```

---

## Connection details
- Host: `localhost`
- Port: `5434`
- Database: `agent_1_db`
- Username/Password: from your `.env`
