defmodule Defql.Macros.Defquery do
  @moduledoc false

  alias Defql.Connection

  @doc false
  defmacro defquery({name, _, params}, [do: query]) when is_atom(name) and is_list(params) and is_bitstring(query) do
    query = process_query(query, params)
    quote do
      def unquote(name)(unquote_splicing(params)) do
        Connection.query(
                          unquote(query),
                          unquote(params)
                        )
      end
    end
  end

  @doc false
  defmacro defquery(_, _) do
    quote location: :keep do
      raise ArgumentError, "wrong arguments"
    end
  end


  defp process_query(query, params) do
    params
    |> index_and_param
    |> Enum.reduce(query, fn ({index, param}, query) ->
      query
      |> String.replace("$#{param}", "$#{index}")
    end)
  end

  defp index_and_param(params) do
    params = params
             |> Enum.map(&process_param/1)

    length = params
             |> length

    Enum.zip(Range.new(1,length), params)
  end

  defp process_param({param, _, _}), do: param
end
