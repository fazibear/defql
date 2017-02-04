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
    |> Enum.map(&get_value/1)
    |> List.flatten
  end

  defp get_value({_, value}), do: value
  defp get_value(value), do: value

  defp get_indicies(params, idx \\ 1) do
    params
    |> Enum.with_index(idx)
    |> Enum.map_join(", ", fn ({_, i}) -> "$#{i}" end)
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

  defp get_conditions(params, idx \\ 0)
  defp get_conditions([], 0), do: ""
  defp get_conditions(params, idx) do
    [
      " WHERE ",
      params
      |> Enum.map_reduce(idx + 1, &get_condition/2)
      |> elem(0)
      |> Enum.join(" AND ")
    ]
  end

  defp get_condition({param, list}, i) when is_list(list), do: get_condition({param, {:in, list}}, i)
  defp get_condition({param, {:like, _}}, i), do: {"#{param} LIKE $#{i}", i + 1}
  defp get_condition({param, {:ilike, _}}, i), do: {"#{param} ILIKE $#{i}", i + 1}
  defp get_condition({param, {:in, list}}, i), do: {"#{param} IN (#{get_indicies(list, i)})", i + length(list)}
  defp get_condition({param, _}, i), do: {"#{param} = $#{i}", i + 1}

  defp get_set(params, idx \\ 1) do
    params
    |> Enum.with_index(idx)
    |> Enum.map_join(", ", fn({{a, _}, i}) -> "#{a} = $#{i}" end)
  end
end
