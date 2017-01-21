defmodule Test.Defql.Macros.Defdelete do
  use ExUnit.Case
  import Defql.Macros.Defdelete

  defdelete delete(params), table: :test

  test "defdelete lists" do
    {status, result} = delete(a: 1)

    assert status == :ok
    assert result.query == "DELETE test"
    assert result.params == [a: 1]
  end

  test "defdelete maps" do
    {status, result} = delete(%{a: 1})

    assert status == :ok
    assert result.query == "DELETE test"
    assert result.params == %{a: 1}
  end
end
