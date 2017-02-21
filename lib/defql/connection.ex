defmodule Defql.Connection do
  @moduledoc """
  Delegates database connection to specific adapter.
  """

  use Application

  @adapter Application.get_env(:defql, :connection)[:adapter]

  # unless @adapter do
  #   raise ArgumentError, ":dapter not configured in :defql's :connection"
  # end

  defdelegate start(type, args), to: @adapter
  defdelegate select(table, params, columns), to: @adapter
  defdelegate insert(table, params), to: @adapter
  defdelegate delete(table, params), to: @adapter
  defdelegate update(table, params, conds), to: @adapter
  defdelegate query(query, params), to: @adapter
end
