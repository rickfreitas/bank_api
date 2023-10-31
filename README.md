# BankApi

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Rotas
Todas as rotas autenticadas obrigatoriamente necessitam do envio do header de Autorização, no seguinte padroão:
{
  "Authorization": "Bearer my-secret-key"
}


Cadastro de conta (rota não autenticada): POST /api/users
enviar no body da requisição os parametros para criação do usuario:
{
  "user": {
    "name": "Henrique Manoel de Freitas Santos",
    "cpf": "12345678910",
    "balance": 300.00,
    "password": "cumbuca2023"
  }
}

retorno: 
{
    "data": {
        "id": "feb798e2-3924-4872-ba38-0d12a10d1234",
        "name": "Henrique Manoel de Freitas Santos",
        "balance": 300.0,
        "cpf": "12345678910"
    }
}

Autenticação (rota não autenticada): POST /api/auth
Enviar no body da requisição o id do usuario e a senha para que seja criada uma token de acesso:
{
  "id": "feb798e2-3924-4872-ba38-0d12a10d1234",
  "password": "cumbuca2023"
}

retorno:
{
    "authorization_key": "token_de_autorizacao"
}

Cadastro de transação (rota autenticada): POST /api/transactions
No Body da requisição devem ser enviados os dados da transação
{
  "balance_transaction": {
      "transaction_amount": 1.0,
      "receiver_user_id": "id do usuario recebedor"
  }
}

retorno:
{
    "id": "d6892694-55bb-4abe-ba36-ce3e6906ff44",
    "transaction_amount": 1.0,
    "sender_user_id": "4d3653e2-679f-4902-9e15-654d0576a134",
    "receiver_user_id": "c0a8af5d-af4d-4980-b550-cc63ce9df897"
}


Estorno de transação (rota autenticada): PUT /api/transactions/:id/revert
Não é necessário o envio de nenhum dado adicional, além do header de autenticação
