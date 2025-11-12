# Fudo Challenge API

A simple Rack-based REST API with authentication and asynchronous product management.

## Prerequisites

- Ruby 3.2.6 or higher
- Bundler

## Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/AgustinPagotto/fchallenge/
   cd fchallenge
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Configure environment variables**
   
   Create a `.env` file in the root directory:
   ```bash
   USERNAME=admin
   PASSWORD=secret123
   ```

## Running the Application

### Development Mode

```bash
bundle exec puma
```

The server will start on `http://localhost:9292`

## API Usage

### 1. Authentication

**Get a token:**
```bash
curl -X POST http://localhost:9292/auth \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"secret123"}'
```

**Response:**
```json
{
  "token": "a1b2c3d4e5f6789..."
}
```

### 2. Create a Product (Async)

```bash
curl -X POST http://localhost:9292/products \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -d '{"name":"Laptop"}'
```

**Response:**
```json
{
  "message": "The product will be created after 5 seconds"
}
```

**Note:** The product will be created asynchronously after 5 seconds.

### 3. List All Products

```bash
curl http://localhost:9292/products \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

**Response:**
```json
[
  {
    "id": 1,
    "name": "Laptop"
  }
]
```

### 4. Get a Single Product

```bash
curl http://localhost:9292/products/1 \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

**Response:**
```json
{
  "id": 1,
  "name": "Laptop"
}
```

### 5. View API Documentation

```bash
curl http://localhost:9292/openapi.yaml
```

### 6. View Authors

```bash
curl http://localhost:9292/AUTHORS
```

## Testing

Run the test suite:
```bash
bundle exec rspec
```

5. Open a Pull Request
