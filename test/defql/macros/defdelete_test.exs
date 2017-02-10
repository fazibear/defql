defmodule Test.Defql.Macros.Defdelete do
  use ExUnit.Case
  use Defql, table: :common_table

  defdelete delete(params), table: :test
  defdelete remove(params)

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

  test "takes a table name from Defql attribute (if it was specified)" do
    {_status, result} = remove(%{a: 1})
    assert result.query == "DELETE common_table"
  end
end
