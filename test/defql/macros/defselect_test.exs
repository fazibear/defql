defmodule Test.Defql.Macros.Defselect do
  use ExUnit.Case
  use Defql, table: :common_table

  defselect select(params), table: :test
  defselect get(params)

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
  
  test "takes a table name from Defql attribute (if it was specified)" do
    {_status, result} = get(%{a: 1})
    assert result.query == "SELECT common_table"
  end
end
