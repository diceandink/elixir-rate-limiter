# Ratelimit Service

A simple, in-memory rate limiter service built with Elixir and Phoenix. State is managed using GenServer.

## Features
- IP or key-based rate limiting (fixed window).
- In-memory state (GenServer).
- No external database required.

## Quick Start
Install dependencies:
```bash
mix deps.get
```

Start the server:
```bash
mix phx.server
```

## API
### POST /check
Request Body:
```json
{
  "key": "user_123",
  "limit": 10,
  "window_seconds": 60
}
```

Response:
```json
{
  "allowed": true,
  "remaining": 9,
  "reset_in": 45
}
```

### GET /
A simple health check that also applies rate limiting based on your IP (5 requests per 60 seconds).

## Testing
Run ExUnit tests:
```bash
mix test
```

CLI test tool (Run while server is active):
```bash
elixir cli_test.exs [key] [limit] [window] [count]
# Example: elixir cli_test.exs mykey 5 60 10
```

## Design Decisions
- Persistence: State is lost on application restart.
- Distribution: No support for distributed Erlang/Redis (single node only).
- Simplicity: Uses fixed window algorithm.

## License
MIT
