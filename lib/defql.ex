defmodule Defql do
  @moduledoc """
  Module provides macros to create function with SQL as a body.

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
  """

  @doc false
  defmacro __using__(opts) do
    quote do
      Module.put_attribute(__MODULE__,
                           :table,
                           Keyword.get(unquote(opts),
                           :table))

      def resolve_table(opts) do
        Keyword.get(opts, :table) ||
        @table ||
        raise(ArgumentError, "table wasn't specified")
      end

      import Defql.Macros.Defquery
      import Defql.Macros.Definsert
      import Defql.Macros.Defdelete
      import Defql.Macros.Defupdate
      import Defql.Macros.Defselect
    end
  end
end
