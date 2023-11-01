# BankApi

## Introduction

BankApi is a Phoenix application that provides a set of RESTful API endpoints for banking operations. This README provides an overview of the project and the available API routes.

## Getting Started

To start your Phoenix server:

1. Run `mix setup` to install and set up dependencies.
2. Start the Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`.
3. Visit [`localhost:4000`](http://localhost:4000) from your browser.

For deployment instructions, please check our [deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Authentication

All authenticated routes require the inclusion of an Authorization header in the following format:

```json
{
  "Authorization": "Bearer my-secret-key"
}
```

# Routes
## User Registration (Unauthenticated)

### POST /api/users

    Register a new user by sending the following parameters in the request body:

```json
{
  "user": {
    "name": "Henrique Manoel de Freitas Santos",
    "cpf": "12345678910",
    "balance": 300.00,
    "password": "cumbuca2023"
  }
}
```

Response:
```json
    {
      "data": {
          "id": "feb798e2-3924-4872-ba38-0d12a10d1234",
          "name": "Henrique Manoel de Freitas Santos",
          "balance": 300.0,
          "cpf": "12345678910"
      }
    }
```

## Authentication (Unauthenticated)

### POST /api/auth

    Authenticate a user by sending the user ID and password in the request body:
```json
{
  "id": "feb798e2-3924-4872-ba38-0d12a10d1234",
  "password": "cumbuca2023"
}
```

Response:
```json
    {
      "authorization_key": "token_de_autorizacao"
    }
```

## Transaction Registration (Authenticated)

### POST /api/transactions

    Register a new transaction by sending the transaction data in the request body:
```json
{
  "balance_transaction": {
      "transaction_amount": 1.0,
      "receiver_user_id": "id do usuario recebedor"
  }
}
```

Response:
```json
    {
      "id": "d6892694-55bb-4abe-ba36-ce3e6906ff44",
      "transaction_amount": 1.0,
      "sender_user_id": "4d3653e2-679f-4902-9e15-654d0576a134",
      "receiver_user_id": "c0a8af5d-af4d-4980-b550-cc63ce9df897"
    }
```

## Transaction Reversion (Authenticated)

### PUT /api/transactions/:id/revert

    Revert a transaction by sending a request with the appropriate transaction ID in the URL and the Authorization header.

    Response:
```json
    {
      "id": "b28a55a6-6229-4869-a592-0d91c1f6f891",
      "transaction_amount": 1.0,
      "sender_user_id": "4d3653e2-679f-4902-9e15-654d0576a134",
      "receiver_user_id": "c0a8af5d-af4d-4980-b550-cc63ce9df897",
      "reverted": true
    }
```

## Transaction Search by Date (Authenticated)

### GET /api/user_transactions

    Retrieve user transactions within a specific date range by including the start and end dates in the URL. For example:

    /api/user_transactions?start=28/10/2023&end=31/10/2023

    Response:

```json
    {
      "user": {
          "id": "4d3653e2-679f-4902-9e15-654d0576a134",
          "name": "Henrique Manoel de Freitas Santos",
          "balance": 299.0,
          "cpf": "12345678910"
      },
      "transactions": {
          "received_transactions": [],
          "sended_transactions": [
              {
                  "receiver_user_id": "c0a8af5d-af4d-4980-b550-cc63ce9df897",
                  "sender_user_id": "4d3653e2-679f-4902-9e15-654d0576a134",
                  "transaction_amount": 1.0,
                  "reverted": false,
                  "transaction_date": "2023-10-31T23:35:26Z",
                  "transaction_id": "e872f475-ceee-40a0-a8f0-d1870b9f8b79"
              }
          ]
      }
    }
```

## View User Balance (Authenticated)

### GET /api/user_balance

    Retrieve the user's balance by including the Authorization header in the request.

    Response:
```json
{
  "user": {
      "id": "4d3653e2-679f-4902-9e15-654d0576a134",
      "name": "Henrique Manoel de Freitas Santos",
      "balance": 298.0,
      "cpf": "12345678910"
  }
}
```