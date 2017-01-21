defmodule Defql.Adapter.Test do
  @behaviour Defql.Adapter

  defstruct query: "",
            params: %{}

  def start(_type, _args) do
    {:ok, self()}
  end

  def query(query, params) do
    {:ok, %{query: query, params: params}}
  end

  def result(result) do
    {:ok, result}
  end

  def select(table, params) do
    query("SELECT #{table}", params)
  end

  def insert(table, params) do
    query("INSERT #{table}", params)
  end

  def delete(table, params) do
    query("DELETE #{table}", params)
  end

  def update(table, params, conds) do
    query("UPDATE #{table}", params)
  end
end
