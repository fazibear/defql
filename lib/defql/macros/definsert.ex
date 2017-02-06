defmodule Defql.Macros.Definsert do
  @moduledoc false

  alias Defql.Connection

  @doc false
  defmacro definsert({name, _, params}, opts \\ []) when is_atom(name) and is_list(params) and length(params) == 1 do
    [first | _] = params
    quote do
      def unquote(name)(unquote_splicing(params)) do
        Connection.insert(
                            resolve_table(unquote(opts)),
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
