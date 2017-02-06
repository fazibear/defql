defmodule Test.Defql.Macros.Definsert do
  use ExUnit.Case
  use Defql, table: :common_table

  definsert insert(params), table: :test
  definsert add(params)

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

  test "takes a table name from Defql attribute (if it was specified)" do
    {_status, result} = add(%{a: 1})
    assert result.query == "INSERT common_table"
  end
end
