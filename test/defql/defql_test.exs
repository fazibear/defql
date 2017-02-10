defmodule Test.Defql.Defql do
  use ExUnit.Case

  defmodule TestQuery do
    use Defql, table: :test_table_name

    def get_table, do: @table
  end

  defmodule TestQueryWithError do
    use Defql

    defselect select(params)
  end

  test "allows to define and store a table name in an attribute" do
    assert TestQuery.get_table == :test_table_name
  end

  test "if throws error when table name not specified" do
    assert_raise ArgumentError, fn ->
      TestQueryWithError.select({})
    end
  end

end
