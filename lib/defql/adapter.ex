defmodule Defql.Adapter do
  @moduledoc """
  This module specifies the adapter API that an adapter is required to
  implement.
  """

  @type return :: keyword()

  @type query :: String.t
  @type table :: String.t

  @type params :: List.t

  @doc """
  Start specific adapter
  """
  @callback start(Application.start_type, Application.start_args :: term) ::
    {:ok, pid} |
    {:ok, pid, Application.state} |
    {:error, reason :: term}

  @doc """
  The callback for querying database, and parse result.
  """
  @callback query(query :: query, params :: params) :: return

  @doc """
  The callback to build select query.
  """
  @callback select(table :: query, params :: params) :: return

  @doc """
  The callback to build insert query.
  """
  @callback insert(table :: table, params :: params) :: return

  @doc """
  The callback to build delete query.
  """
  @callback delete(table :: table, params :: params) :: return

  @doc """
  The callback to build delete query.
  """
  @callback update(table :: table, params :: params, conds :: params) :: return
end
