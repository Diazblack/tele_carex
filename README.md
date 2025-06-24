# TeleCarex

TeleCarex is an Elixir Phoenix API application designed to help users ask questions and receive personalized advice about their health. It provides a scalable, real-time backend for telehealth interactions and asynchronous medical support.

# Installation

### Elixir/Phoenix Setup

- This application requires **Elixir version 1.18.3-otp-27** and **Erlang version 27.3.1**.
- Follow the [Elixir installation guide](https://elixir-lang.org/install.html).
- If you have a different version installed, it is highly recommended to use [asdf](https://asdf-vm.com/guide/getting-started.html) for version management.
- Install Phoenix dependencies by following the [Phoenix installation guide](https://hexdocs.pm/phoenix/installation.html).

### Postgres & Database Setup

1. Ensure PostgreSQL is installed and running locally. If you're on macOS, Homebrew is one of the easiest ways to install it:  
   `brew install postgresql`  
   [Here's](https://wiki.postgresql.org/wiki/Homebrew) a wiki link with more details.

2. Follow Homebrew’s instructions to either start PostgreSQL manually or set it to start automatically:  
   `brew services start postgresql`

3. Create a PostgreSQL user if needed:  
   `createuser -s postgres`

4. Set up the database:  
   `mix ecto.setup`

5. Seed your database:  
   `mix run priv/repo/seeds.exs`

6. Start the Phoenix server:  
   `mix phx.server`  
   Or with IEx:  
   `iex -S mix phx.server`

### Quick Setup

- Run `mix setup` to install dependencies and set up the database.
- Start the Phoenix endpoint with `mix phx.server` or `iex -S mix phx.server`.

# API Endpoints

## Incoming Messages

### Create a New Conversation

POST `http://localhost:4000/api/conversations`

#### Example Request Body:

```json
{
  "conversation": {
    "title": "Stomachache",
    "username": "JohnDoe",
    "email": "johndoe@example.com",
    "content": "I've been feeling off today — my stomach hurts with a dull, cramping pain..."
  }
}
```

#### Example Response:

```json
{
  "data": {
    "id": "8f0df77a-8572-4515-9364-4bf1a24dbb34",
    "messages": [...],
    "title": "Stomachache",
    "primary_user_id": "...",
    "public_user_id": "..."
  }
}
```

The endpoint creates a user from the provided username and email and generates a message entry using the content.

---

### Reply to an Existing Conversation

POST `http://localhost:4000/api/messages`

#### Example Request Body:

```json
{
  "message": {
    "content": "Hi there! Sorry you're experiencing stomach pain...",
    "conversation_id": "8f0df77a-8572-4515-9364-4bf1a24dbb34",
    "created_by_id": "user-id",
    "internal?": true
  }
}
```

#### Example Successful Response (201):

```json
{
  "data": {
    "id": "message-id",
    "content": "Hi there! Sorry you're experiencing stomach pain...",
    "conversation_id": "...",
    "created_by_id": "...",
    "internal?": true
  }
}
```

#### Example Error Response (422):

```json
{
  "retry": false,
  "errors": {
    "conversation_id": ["does not exist"],
    "created_by_id": ["can't be blank"]
  }
}
```

---

## Conversation History

### Retrieve All Messages for a User

GET `http://localhost:4000/api/messages/:user_id`

#### Example Response:

```json
{
  "data": [
    {
      "id": "...",
      "content": "...",
      "conversation_id": "...",
      "created_by_id": "...",
      "internal?": false
    },
    ...
  ]
}
```

---

### Retrieve a Full Conversation with Messages

GET `http://localhost:4000/api/conversations/:id`

#### Example Response:

```json
{
  "data": {
    "id": "conversation-id",
    "messages": [...],
    "title": "Stomachache",
    "primary_user_id": "...",
    "public_user_id": "..."
  }
}
```

---

# Notes

- The API automatically assigns conversations to the next available internal user.
- The `internal?` field marks whether a message is internal (sent by a staff member) or public (from the user).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
