defmodule Defql.Macros.Definsert do
  alias Defql.Connection

  @doc false
  defmacro definsert({name, _, params}, [table: table]) when is_atom(name) and is_list(params) and length(params) == 1 and is_atom(table) do
    [first | _] = params
    quote do
      def unquote(name)(unquote_splicing(params)) do
        Connection.insert(
                            unquote(table),
                            unquote(first)
                          )
      end
    end
  end

  @doc false
  defmacro definsert(_, _) do
    quote location: :keep do
      raise ArgumentError, "wrong arguments"
    end
  end
end
