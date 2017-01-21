defmodule Test.Defql.Macros.Definsert do
  use ExUnit.Case
  import Defql.Macros.Definsert

  definsert insert(params), table: :test

  test "definsert lists" do
    {status, result} = insert(a: 1)

    assert status == :ok
    assert result.query == "INSERT test"
    assert result.params == [a: 1]
  end

  test "definsert maps" do
    {status, result} = insert(%{a: 1})

    assert status == :ok
    assert result.query == "INSERT test"
    assert result.params == %{a: 1}
  end
end
