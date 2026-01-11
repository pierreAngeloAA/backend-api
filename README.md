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


## Requirements

- Ruby 3.4.6
- Rails 8.0.4
- PostgreSQL
- Redis

## Setup

```bash
bundle install
rails db:create
rails db:migrate

