defmodule Defql.Macros.Defupdate do
  @moduledoc false

  alias Defql.Connection

  @doc false
  defmacro defupdate({name, _, params}, opts \\ []) when is_atom(name) and is_list(params) and length(params) == 2 do
    [first, second | _] = params
    quote do
      def unquote(name)(unquote_splicing(params)) do
        Connection.update(
                            resolve_table(unquote(opts)),
                            unquote(first),
                            unquote(second)
                          )
      end
    end
  end

  @doc false
  defmacro defupdate(_, _) do
    quote location: :keep do
      raise ArgumentError, "wrong arguments"
    end
  end
end
