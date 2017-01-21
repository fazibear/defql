defmodule Defql.Macros.Defselect do
  @moduledoc false

  alias Defql.Connection

  @doc false
  defmacro defselect({name, _, params}, [table: table]) when is_atom(name) and is_list(params) and length(params) == 1 and is_atom(table) do
    [first | _] = params
    quote do
      def unquote(name)(unquote_splicing(params)) do
        Connection.select(
                            unquote(table),
                            unquote(first)
                          )
      end
    end
  end

  @doc false
  defmacro defselect({name, _, params}, [table: table, columns: columns]) when is_atom(name) and is_list(params) and length(params) == 1 and is_atom(table) and is_list(columns) do
    [first | _] = params
    quote do
      def unquote(name)(unquote_splicing(params)) do
        Connection.select(
                            unquote(table),
                            unquote(first),
                            unquote(columns)
                          )
      end
    end
  end

  @doc false
  defmacro defselect(_, _) do
    quote location: :keep do
      raise ArgumentError, "wrong arguments"
    end
  end
end
