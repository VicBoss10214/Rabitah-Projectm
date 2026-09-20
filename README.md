# Rabitah

Rabitah is a Java 21 university social and academic desktop application. The repository contains a Spring Boot API and a non-modular JavaFX client.

Presentation Video link: https://www.youtube.com/watch?v=y5VeMm9slmc

## Prerequisites

- Java 21
- Maven 3.9+
- Docker with Compose, or PostgreSQL 14+

## Installation Guide

- Download the zip file or clone the project from github
- In the project folder, open your terminal and paste these commands

```
$env:RABITAH_API_BASE_URL="https://rabitah-projectm-production.up.railway.app/api/v1"
mvn -q -pl Rabitah-Frontend javafx:run
```

Thus the Project will run. The project is currently deployed in Railway free version. It may not work after 12 October.
