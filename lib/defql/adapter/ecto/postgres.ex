if Code.ensure_loaded?(Ecto) do
  defmodule Defql.Adapter.Ecto.Postgres do
    @behaviour Defql.Adapter
    @repo Application.get_env(:defql, :connection)[:repo]

    alias Defql.Adapter.Postgres
    alias Defql.Adapter.Postgres.Query

    def start(_type, _args), do: @repo.start_link

    def select(table, params) do
      {query, params} = Query.select(table, params)
      query(query, params)
    end

    def insert(table, params) do
      {query, params} = Query.insert(table, params)
      query(query, params)
    end

    def delete(table, params) do
      {query, params} = Query.delete(table, params)
      query(query, params)
    end

    def update(table, params, conds) do
      {query, params} = Query.update(table, params, conds)
      query(query, params)
    end

    def query(query, params) do
      Ecto.Adapters.SQL.query(@repo, query, params)
      |> Postgres.result
    end
  end
end
