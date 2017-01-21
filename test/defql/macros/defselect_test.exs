defmodule Test.Defql.Macros.Defselect do
  use ExUnit.Case
  import Defql.Macros.Defselect

  defselect select(params), table: :test

  test "defselect lists" do
    {status, result} = select(a: 1)

    assert status == :ok
    assert result.query == "SELECT test"
    assert result.params == [a: 1]
  end

  test "defselect maps" do
    {status, result} = select(%{a: 1})

    assert status == :ok
    assert result.query == "SELECT test"
    assert result.params == %{a: 1}
  end
end
