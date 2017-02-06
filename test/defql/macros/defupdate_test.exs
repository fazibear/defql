defmodule Test.Defql.Macros.Defupdate do
  use ExUnit.Case
  use Defql, table: :common_table

  defupdate update(params, conds), table: :test
  defupdate edit(params, conds)

  test "defupdate lists" do
    {status, result} = update([a: 1], [b: 2])

    assert status == :ok
    assert result.query == "UPDATE test"
    assert result.params == [a: 1]
  end

  test "defupdate maps" do
    {status, result} = update(%{a: 1}, %{b: 2})

    assert status == :ok
    assert result.query == "UPDATE test"
    assert result.params == %{a: 1}
  end

  test "defupdate map and list" do
    {status, result} = update(%{a: 1}, [b: 2])

    assert status == :ok
    assert result.query == "UPDATE test"
    assert result.params == %{a: 1}
  end

  test "defupdate list and map" do
    {status, result} = update([a: 1], %{b: 2})

    assert status == :ok
    assert result.query == "UPDATE test"
    assert result.params == [a: 1]
  end

  test "takes a table name from Defql attribute (if it was specified)" do
    {_status, result} = edit(%{a: 1}, %{b: 2})
    assert result.query == "UPDATE common_table"
  end
end
