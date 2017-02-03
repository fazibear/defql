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
    |> Enum.map(&extract_value/1)
    |> List.flatten
  end

  defp extract_value({term, value}) when is_atom(term) do
    value
  end
  defp extract_value(value) do
    value
  end

  defp get_indicies(params, idx \\ 0) do
    params
    |> Enum.with_index(idx + 1)
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


  defp get_conditions(params, idx \\ 0)
  defp get_conditions([], _), do: ""
  defp get_conditions(params, idx) do
    get_conditions(params, idx+1, [])
  end

  defp get_conditions([], _, acc) do
    [" WHERE ", acc |> Enum.reverse |> Enum.join(" AND ")]
  end
  defp get_conditions([condition | other_conds], idx, acc) do
    {next_idx, sql_fragment} = condition_to_sql(condition, idx)
    get_conditions(other_conds, next_idx, [sql_fragment | acc])
  end

  defp condition_to_sql({field, list}, idx) when is_list(list) do
    count = Enum.count(list)
    placeholders = (idx..idx+count-1) |> Enum.map_join(", ", &("$#{&1}"))
    {idx+count, "#{field} IN (#{placeholders})"}
  end
  defp condition_to_sql({field, tuple}, idx) when is_tuple(tuple) do
    case tuple do
      {:in, list} -> condition_to_sql({field, list}, idx)
      {:like, _}  -> {idx+1, "#{field} LIKE $#{idx}"}
      {:ilike, _} -> {idx+1, "#{field} ILIKE $#{idx}"}
    end
  end
  defp condition_to_sql({field, _}, idx) do
    {idx+1, "#{field} = $#{idx}"}
  end

  defp get_set(params, idx \\ 1) do
    params
    |> Enum.with_index(idx)
    |> Enum.map(fn({{a, _}, i}) -> "#{a} = $#{i}" end)
    |> Enum.join(", ")
  end
end
