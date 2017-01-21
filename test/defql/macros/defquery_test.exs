defmodule Test.Defql.Macros.Defquery do
  use ExUnit.Case
  import Defql.Macros.Defquery

  defquery query(param1, param2) do
    "SELECT * FROM users WHERE param1 = $param1 AND param2 = $param2"
  end

  test "defquery" do
    {status, result} = query(1,2)

    assert status == :ok
    assert result.query == "SELECT * FROM users WHERE param1 = $1 AND param2 = $2"
    assert result.params == [1,2]
  end
end
