# event-registration-api
# Sports Event Registration System

Registration and management system for sports events using MariaDB and Docker.

## Features

- Event management (create, update, delete events)
- Category management (age groups, weight classes)
- Participant registration
- Results tracking
- Statistics and reporting

## Tech Stack

- MariaDB
- Docker
- Docker Compose

## Setup

1. Install Docker Desktop
2. Clone repository
```bash
git clone https://github.com/BrigitaKasemets/event-registration-api.git
cd sports-event-registration
```

3. Start containers
```bash
docker-compose up -d
```

4. Initialize database
```bash
docker-compose exec db mysql -u root -p < init.sql
```

## Database Schema

- `competitions` - Event details and status
- `categories` - Event categories and rules
- `participants` - Participant information
- `registrations` - Event registrations
- `results` - Competition results
- `statistics` - Statistical view
