defmodule Defql.Adapter.Postgres.Query do
  @moduledoc """
  Module provides a query build rules.
  """

  def select(table, params), do: select(table, params, ["*"])
  def select(table, params, columns) when is_map(params), do: select(table, Map.to_list(params), columns)
  def select(table, params, columns) do
    {
      [
        "SELECT ",
        get_columns_list(columns),
        " FROM ",
        get_table(table),
        " ",
        get_conditions(params)
      ] |> IO.iodata_to_binary,
      get_values(params)
    }
  end

  def insert(table, params) when is_map(params), do: insert(table, Map.to_list(params))
  def insert(table, params) do
    {
      [
        "INSERT INTO ",
        get_table(table),
        " (",
        get_columns(params),
        ") VALUES (",
        get_indicies(params),
        ") RETURNING *"
      ] |> IO.iodata_to_binary,
      get_values(params)
    }
  end

  def delete(table, params) when is_map(params), do: delete(table, Map.to_list(params))
  def delete(table, params) do
    {
      [
        "DELETE FROM ",
        get_table(table),
        " ",
        get_conditions(params),
        " RETURNING *"
      ] |> IO.iodata_to_binary,
      get_values(params)
    }
  end

  def update(table, params, conds) when is_map(params), do: update(table, Map.to_list(params), conds)
  def update(table, params, conds) when is_map(conds), do: update(table, params, Map.to_list(conds))
  def update(table, params, conds) when is_map(params) and is_map(conds), do: update(table, Map.to_list(params), Map.to_list(conds))
  def update(table, params, conds) do
    {
      [
        "UPDATE ",
        get_table(table),
        " SET ",
        get_set(params),
        get_conditions(conds, length(params)),
        " RETURNING *"
      ] |> IO.iodata_to_binary,
      get_values(params ++ conds)
    }
  end

  #

  defp get_table(table) do
    table
    |> Atom.to_string
  end

  defp get_values(params) do
    params
    |> Keyword.values
  end

  defp get_indicies(params, idx \\ 0) do
    params
    |> Enum.with_index(idx+1)
    |> Enum.map(fn ({_, i}) -> "$#{i}" end)
    |> Enum.join(", ")
  end

  defp get_columns_list(params) do
    params
    |> Enum.join(", ")
  end

  defp get_columns(params) do
    params
    |> Keyword.keys
    |> Enum.join(",")
  end

  defp get_conditions(params, idx \\ 0) do
    if length(params) > 0 do
      [" WHERE ",
      params
      |> Enum.with_index(idx+1)
      |> Enum.map(fn({{a, _}, i}) -> "#{a} = $#{i}" end)
      |> Enum.join(" AND ")
      ]
    else
      ""
    end
  end

  defp get_set(params, idx \\ 1) do
    params
    |> Enum.with_index(idx)
    |> Enum.map(fn({{a, _}, i}) -> "#{a} = $#{i}" end)
    |> Enum.join(", ")
  end
end
