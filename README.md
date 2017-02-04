# Defql [![Package Version](https://img.shields.io/hexpm/v/defql.svg)](https://hex.pm/packages/defql) [![Code Climate](https://codeclimate.com/github/fazibear/defql/badges/gpa.svg)](https://codeclimate.com/github/fazibear/defql) [![Build Status](https://travis-ci.org/fazibear/defql.svg?branch=master)](https://travis-ci.org/fazibear/defql)

Create elixir functions with SQL as a body.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `defql` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:defql, "~> 0.1.0"}]
end
```


### Configuration

It requires `adapter` key, and adapter specific options.

Use with ecto:

```elixir
config :defql, connection: [
  adapter: Defql.Adapter.Ecto.Postgres,
  repo: Taped.Repo
]
```

Use standalone connection:

```elixir
config :defql, connection: [
  hostname: "localhost",
  username: "username",
  password: "password",
  database: "my_db",
  pool: DBConnection.Poolboy,
  pool_size: 1
]
```

## Usage

We can define module to have access to our database:

```elixir
defmodule UserQuery do
  use Defql

  defselect get(conds), table: :users
  definsert add(params), table: :users
  defupdate update(params, conds), table: :users
  defdelete delete(conds), table: :users

  defquery get_by_name(name, limit) do
    "SELECT * FROM users WHERE name = $name LIMIT $limit"
  end
end
```

Right now we have easy access to `users` in database:

```elixir
UserQuery.get(id: "3") # => {:ok, [%{...}]}
UserQuery.add(name: "Smbdy") # => {:ok, [%{...}]}
UserQuery.update([name: "Other"],[id: "2"]) # => {:ok, [%{...}]}
UserQuery.delete(id: "2") # => {:ok, [%{...}]}

UserQuery.get_by_name("Ela", 4) # => {:ok, [%{...}, %{...}]}
```

`%{...}` It's a hash with user properties straight from database.

Supported condition statements:
- `[user_id: [1,2,3,4]]`
- `[user_id: {:in, [1,2,3,4,5]}`
- `[name: {:like, "%john%"]`
- `[name: {:ilike, "%john"]`

## TODO

- [ ] MySQL support
- [ ] Cleanup ECTO adapter
- [ ] Support database errors
- [ ] Transactions
