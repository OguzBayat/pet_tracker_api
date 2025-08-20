# Pet Tracking API

A Rails 8 API application for tracking pets (dogs and cats) and calculating statistics about pets outside the power saving zone.

## Features

- **Single Table Inheritance (STI)** for Pet types (Cat and Dog)
- **RESTful API** with comprehensive CRUD operations
- **Statistics endpoint** for pets outside the power saving zone
- **Comprehensive test coverage** using Minitest and Factory Bot
- **API serialization** using Active Model Serializers
- **Swagger documentation** for API reference

## Pet Types and Tracker Types

### Cats

- **Tracker Types**: small, big
- **Special Feature**: Can lose trackers (`lost_tracker` attribute)

### Dogs

- **Tracker Types**: small, medium, big
- **Special Feature**: Cannot lose trackers (always `lost_tracker: false`)

## Technology Stack

- **Rails 8.0.2** - Web framework
- **Ruby 3.2.2** - Programming language
- **SQLite3** - Database (easily replaceable)
- **Minitest** - Testing framework
- **Factory Bot** - Test data generation
- **Active Model Serializers** - API response serialization
- **Rswag** - Swagger documentation

## Setup Instructions

### Prerequisites

- Ruby 3.2.2 or higher
- Rails 8.0.2
- SQLite3

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd pet_tracker_api
   ```

2. **Install dependencies**

   ```bash
   bundle install
   ```

3. **Setup database**

   ```bash
   rails db:create
   rails db:migrate
   ```

4. **Load sample data (optional)**

   ```bash
   rails db:seed
   ```

   This will create sample pets for testing:

   - 4 cats (2 with small trackers, 2 with big trackers, 1 with lost tracker)
   - 5 dogs (2 small, 2 medium, 1 big trackers)
   - Mix of pets in and outside the power saving zone

5. **Start the server**
   ```bash
   rails server
   ```

The API will be available at `http://localhost:3000`

## Running Tests

```bash
# Run all tests
rails test

# Run specific test files
rails test test/models/pet_test.rb
rails test test/controllers/api/v1/pets_controller_test.rb

# Run tests with verbose output
rails test -v
```

## API Endpoints

### Base URL

```
http://localhost:3000/api/v1
```

### 1. List All Pets

```bash
curl -X GET http://localhost:3000/api/v1/pets
```

### 2. Create a Pet

#### Create a Cat

```bash
curl -X POST http://localhost:3000/api/v1/pets \
  -H "Content-Type: application/json" \
  -d '{
    "pet": {
      "type": "Cat",
      "tracker_type": "small",
      "owner_id": 123,
      "in_zone": true,
      "lost_tracker": false
    }
  }'
```

#### Create a Dog

```bash
curl -X POST http://localhost:3000/api/v1/pets \
  -H "Content-Type: application/json" \
  -d '{
    "pet": {
      "type": "Dog",
      "tracker_type": "medium",
      "owner_id": 456,
      "in_zone": false,
      "lost_tracker": false
    }
  }'
```

### 3. Get a Specific Pet

```bash
curl -X GET http://localhost:3000/api/v1/pets/1
```

### 4. Update a Pet

```bash
curl -X PATCH http://localhost:3000/api/v1/pets/1 \
  -H "Content-Type: application/json" \
  -d '{
    "pet": {
      "in_zone": false,
      "lost_tracker": true
    }
  }'
```

### 5. Delete a Pet

```bash
curl -X DELETE http://localhost:3000/api/v1/pets/1
```

### 6. Get Statistics for Pets Outside Zone

```bash
curl -X GET http://localhost:3000/api/v1/pets/statistics/outside_zone
```

**Example Response:**

```json
{
  "total_pets_outside_zone": 3,
  "by_pet_type": {
    "Cat": 2,
    "Dog": 1
  },
  "by_tracker_type": {
    "small": 1,
    "big": 1,
    "medium": 1
  },
  "by_pet_and_tracker_type": {
    "[\"Cat\", \"small\"]": 1,
    "[\"Cat\", \"big\"]": 1,
    "[\"Dog\", \"medium\"]": 1
  },
  "cats_with_lost_tracker": 1,
  "cats_with_tracker": 1,
  "dogs_by_size": {
    "small": 0,
    "medium": 1,
    "big": 0
  }
}
```

## API Documentation

### Swagger UI

Access the interactive API documentation at:

```
http://localhost:3000/swagger.html
```

This provides a complete interactive documentation for all API endpoints with examples and testing capabilities.

## Data Models

### Pet (Base Class)

- `id` - Unique identifier
- `type` - Pet type (Cat or Dog)
- `tracker_type` - Type of tracker
- `owner_id` - Owner's ID
- `in_zone` - Whether pet is in power saving zone
- `lost_tracker` - Whether tracker is lost
- `created_at` - Creation timestamp
- `updated_at` - Last update timestamp

### Cat (Subclass)

- Inherits all Pet attributes
- `tracker_type` must be 'small' or 'big'
- `lost_tracker` can be true or false

### Dog (Subclass)

- Inherits all Pet attributes
- `tracker_type` must be 'small', 'medium', or 'big'
- `lost_tracker` must always be false

## Validation Rules

### Pet (Base)

- `tracker_type` - Required
- `owner_id` - Required, must be positive integer
- `in_zone` - Required, must be boolean
- `lost_tracker` - Required, must be boolean

### Cat

- `tracker_type` - Must be 'small' or 'big'
- `lost_tracker` - Can be true or false

### Dog

- `tracker_type` - Must be 'small', 'medium', or 'big'
- `lost_tracker` - Must be false

## Statistics Endpoint Details

The `/api/v1/pets/statistics/outside_zone` endpoint provides:

- **total_pets_outside_zone**: Total count of pets outside the zone
- **by_pet_type**: Count grouped by pet type (Cat/Dog)
- **by_tracker_type**: Count grouped by tracker type
- **by_pet_and_tracker_type**: Count grouped by both pet and tracker type
- **cats_with_lost_tracker**: Cats outside zone with lost trackers
- **cats_with_tracker**: Cats outside zone with working trackers
- **dogs_by_size**: Dogs outside zone grouped by tracker size

## Storage Layer

The application uses **SQLite3** for persistent pet data storage and **Rails.cache (memory store)** for pet count statistics as per task requirements. The storage layer is designed to be easily replaceable with any other database supported by Rails (PostgreSQL, MySQL, etc.).

### Pet Data Storage

- Pet records are stored in SQLite3 database (persistent)
- Supports full CRUD operations for pets

### Pet Count Data Storage (In-Memory)

- Pet count statistics are stored in Rails.cache (in-memory)
- Automatically invalidated when pets are created/updated/deleted
- 5-minute cache expiry for performance optimization
- Perfect for real-time statistics as per task requirements

To switch to a different database:

1. Update the `Gemfile` with the appropriate database gem
2. Update `config/database.yml` with connection details
3. Run `rails db:create db:migrate`

## Testing Strategy

- **Unit Tests**: Model validations, scopes, and methods
- **Integration Tests**: API endpoints and responses
- **Factory Bot**: Test data generation with realistic scenarios
- **Test Coverage**: All critical paths and edge cases

## Error Handling

The API returns appropriate HTTP status codes:

- `200` - Success
- `201` - Created
- `204` - No Content (for deletions)
- `404` - Not Found
- `422` - Unprocessable Entity (validation errors)

Error responses include detailed error messages:

```json
{
  "errors": ["Tracker type can't be blank", "Owner id must be greater than 0"]
}
```

## Development

### Code Quality

- Follows Rails conventions
- Uses RuboCop for code style
- Comprehensive test coverage
- Clear separation of concerns

### Adding New Features

1. Write tests first (TDD approach)
2. Implement the feature
3. Ensure all tests pass
4. Update documentation if needed

## License

This project is licensed under the MIT License.
