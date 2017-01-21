defmodule Test.Defql.Macros.Defupdate do
  use ExUnit.Case
  import Defql.Macros.Defupdate

  defupdate update(params, conds), table: :test

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
end
