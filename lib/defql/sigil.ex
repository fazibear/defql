defmodule Defql.Sigil do
  @moduledoc """
  This module define sigil for querying database.
  """
  alias Defql.Connection

  def sigil_q(query, []), do: Connection.query(query, [])
end
