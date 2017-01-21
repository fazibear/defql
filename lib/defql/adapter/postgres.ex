if Code.ensure_loaded?(Postgrex) do
  extensions = if Code.ensure_loaded?(Ecto) do
    Ecto.Adapters.Postgres.extensions()
  else
    []
  end ++ [
    {Defql.Adapter.Postgres.Extension.UUID, []}
  ]

  Postgrex.Types.define(Defql.Adapters.Postgres.Type, extensions)

  defmodule Defql.Adapter.Postgres do
    @moduledoc """
    Postgres adapter for defql.
    """

    @behaviour Defql.Adapter
    @connection Application.get_env(:defql, :connection)

    alias Defql.Adapter.Postgres.Query

    def start(_type, _args) do
      params()
      |> Postgrex.start_link
    end

    def query(query, params) do
      Postgrex.query(__MODULE__, query,  params, @connection)
      |> result()
    end

    def result(result) do
      case result do
        {:ok, result} -> {:ok, output(result)}
        {:error, error} -> {:error, error.postgres.message}
      end
    end

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

    defp params() do
      Application.get_env(:defql, :connection)
      |> Keyword.put(:name, __MODULE__)
      |> Keyword.put(:type, Defql.Adapters.Postgres.Type)
    end

    defp output(%{rows: nil}), do: []
    defp output(%{rows: rows, columns: cols}) do
      for row <- rows, cols = atomize_columns(cols) do
        match_columns_to_row(row,cols) |> to_map
      end
    end

    defp atomize_columns(cols), do: for col <- cols, do: String.to_atom(col)
    defp match_columns_to_row(row, cols), do: List.zip([cols, row])
    defp to_map(list),do: Enum.into(list,%{})
  end
end
