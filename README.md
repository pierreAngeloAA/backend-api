# Backend API – Technical Test (Rails)

This repository contains the backend API developed as part of a technical test using Ruby on Rails in API-only mode.

The API handles authentication, customer management, and CSV imports processed asynchronously.  
A separate frontend application (Angular) is expected to consume this API.

## Tech Stack

- Ruby on Rails (API-only)
- PostgreSQL
- JWT authentication
- Redis + Sidekiq (background jobs)
- CarrierWave (file uploads)
- RSpec (testing setup)
- Service Objects (application architecture)

## Project Structure

app/
- controllers/
- models/
- services/
  - auth/
- jobs/
- uploaders/

The project follows a service-oriented architecture.  
Controllers are kept thin, business logic is encapsulated in service objects, and background jobs delegate work to services.

## Authentication (JWT + Device)

Authentication is implemented using JWT without Devise.

Each successful login generates a JWT token that is associated with a `Device` record.  
This allows handling multiple active sessions per user and revoking tokens individually.

### Authentication flow

1. User logs in with email and password
2. A JWT token is generated
3. A `Device` record is created with the token and user reference
4. Protected endpoints require the token in the request header

### Logout

On logout, the related device is marked as revoked and the token becomes invalid.

## CSV Import

CSV files are uploaded using CarrierWave and processed asynchronously with Sidekiq.

Each row in the CSV is iterated and used to create a customer record.  
Errors are tracked per import.


1. CSV file is uploaded via POST /imports
2. File is stored using CarrierWave
3. A Sidekiq job is enqueued
4. Each CSV row is processed via a service object
5. Valid rows create or update customers
6. Invalid rows are stored in the import error report


## Requirements

- Ruby 3.2.4
- Rails 8.0.4
- PostgreSQL
- Redis

## API Endpoints (Main)

### Authentication
- POST /auth/login
- POST /auth/logout

### Customers
- GET /customers
- POST /customers
- PUT /customers/:id
- DELETE /customers/:id

### Imports
- POST /imports
- GET /imports/:id
- GET /imports/:id/errors


## Setup

```bash
# Option 1: Using Rails directly
rails db:create
rails db:migrate
rails db:seed
rails s

# Option 2: Using bundle exec
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:seed
bundle exec rails s
bundle exec sidekiq

### Sidekiq dashboard

`/sidekiq` is protected with HTTP basic auth. Set both variables to open it; without a password it stays closed:

```bash
SIDEKIQ_WEB_USERNAME=admin SIDEKIQ_WEB_PASSWORD=change-me bundle exec rails s
```

### Tokens

Login returns a JWT valid for **24 hours**. Logging in again or calling `DELETE /api/v1/logout` revokes the previous token.

### First user seed
Email: test@example.com  
Password: password123
