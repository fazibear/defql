defmodule Defql.Macros.Defselect do
  @moduledoc false

  alias Defql.Connection

  @doc false
  defmacro defselect(_name_params, _opts \\ [])
  @doc false
  defmacro defselect({name, _, params}, [columns: columns] = opts) when is_atom(name) and is_list(params) and length(params) == 1 and is_list(columns) do
    [first | _] = params
    quote do
      def unquote(name)(unquote_splicing(params)) do
        Connection.select(
                            resolve_table(unquote(opts)),
                            unquote(first),
                            unquote(columns)
                          )
      end
    end
  end

  @doc false
  defmacro defselect({name, _, params}, opts) when is_atom(name) and is_list(params) and length(params) == 1 do
    [first | _] = params
    quote do
      def unquote(name)(unquote_splicing(params)) do
        Connection.select(
                            resolve_table(unquote(opts)),
                            unquote(first)
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
