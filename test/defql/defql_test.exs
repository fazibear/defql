defmodule Test.Defql.Defql do
  use ExUnit.Case

  defmodule TestQuery do
    use Defql, table: :test_table_name

    def get_table, do: @table
  end

  test "allows to define and store a table name in an attribute" do
    assert TestQuery.get_table == :test_table_name
  end
end