defmodule Defql.Sigil do
  alias Defql.Connection

  def sigil_q(query, []), do: Connection.query(query, [])
end
