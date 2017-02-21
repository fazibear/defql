defmodule Test.Defql.Macros.Defselect do
  use ExUnit.Case
  use Defql, table: :common_table

  defselect select(params), table: :test
  defselect get(params)
  defselect get_name(params), columns: ["name"]
  defselect get_name_table(params), columns: ["name"], table: :test

  test "defselect lists" do
    {status, result} = select(a: 1)

    assert status == :ok
    assert result.query == "SELECT * FROM test"
    assert result.params == [a: 1]
  end

  test "defselect maps" do
    {status, result} = select(%{a: 1})

    assert status == :ok
    assert result.query == "SELECT * FROM test"
    assert result.params == %{a: 1}
  end

  test "takes a table name from Defql attribute (if it was specified)" do
    {status, result} = get(%{a: 1})

    assert status == :ok
    assert result.query == "SELECT * FROM common_table"
    assert result.params == %{a: 1}
  end

  test "defselect columns praram" do
    {status, result} = get_name(%{a: 1})

    assert status == :ok
    assert result.query == "SELECT name FROM common_table"
    assert result.params == %{a: 1}
  end

  test "defselect columns praram with table" do
    {status, result} = get_name_table(%{a: 1})

    assert status == :ok
    assert result.query == "SELECT name FROM test"
    assert result.params == %{a: 1}
  end
end
