# RaceDay - Event Management System

## Description

RaceDay is a full-stack web-based event management system designed specifically for the South African road running, walking, and cycling community. The platform allows Event Organisers to create and manage events, categories, and participant results, while Participants can browse upcoming events, enter events, track their personal performance history, and prepare for race day using live weather and route information.

This project is built progressively across three parts, demonstrating real-world software development practices used in the sports technology industry.

---

## User Roles

### 1. Event Organiser

- Create and manage events
- Add categories to events (e.g., Elite Men, Open Women)
- View participant enrolments
- Upload and manage results
- Update event details and status

### 2. Participant

- Browse and search for upcoming events
- Register/enrol for events
- View personal performance history
- Track race results
- Update personal profile information

---

## Project Structure
RaceDay/
├── .github/
│ └── workflows/
│ └── validate-docs.yml
├── docs/
│ ├── ERD.png
│ ├── endpoint-plan.md
│ └── raceday-db-schema.sql
├── src/
├── README.md
└── .gitignore

---

## Database Schema

The database consists of 7 entities:

| Entity | Description |
|--------|-------------|
| User | Stores user account information |
| OrganiserProfile | Extended user profile for organisers |
| ParticipantProfile | Extended user profile for participants |
| Event | Stores event details |
| Category | Event categories (e.g., Elite Men, Open Women) |
| Enrolment | Tracks participant registrations |
| Result | Stores race results for participants |

### Entity Relationship Diagram (ERD)

![ERD Diagram](docs/ERD.png)

The ERD shows all entities, attributes, primary keys, foreign keys, and cardinality relationships.

---

## API Endpoints

The system exposes RESTful API endpoints for:

- Authentication - Register and Login
- User Management - Profile management
- Event Management - CRUD operations for events
- Category Management - CRUD operations for categories
- Enrolment Management - Register for events
- Result Management - Upload and view results

See the complete [API Endpoint Plan](docs/endpoint-plan.md) for detailed specifications.

### Sample Endpoints

| Method | Route | Description |
|--------|-------|-------------|
| POST | /api/auth/register | Register a new user |
| POST | /api/auth/login | Login and receive JWT |
| GET | /api/events | List all events |
| POST | /api/events | Create a new event (Organiser only) |
| POST | /api/enrolments | Enrol in an event (Participant only) |
| POST | /api/results | Upload results (Organiser only) |

---


---

## Project Structure
