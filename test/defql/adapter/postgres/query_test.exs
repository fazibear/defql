defmodule Test.Defql.Adapter.Postgres.Query do
  use ExUnit.Case
  alias Defql.Adapter.Postgres.Query

  test "select with list" do
    {query, params} = Query.select(:users, [a: 1, b: 2])

    assert query == "SELECT * FROM users  WHERE a = $1 AND b = $2"
    assert params == [1,2]
  end

  test "select with map" do
    {query, params} = Query.select(:users, %{a: 1, b: 2})

    assert query == "SELECT * FROM users  WHERE a = $1 AND b = $2"
    assert params == [1,2]
  end

  test "select with IN array condition" do
    {query, params} = Query.select(:users, [a: [1, 5, 7], b: 2])

    assert query == "SELECT * FROM users  WHERE a IN ($1, $2, $3) AND b = $4"
    assert params == [1, 5, 7, 2]
  end

  test "insert with list" do
    {query, params} = Query.insert(:users, [a: 1, b: 2])

    assert query == "INSERT INTO users (a,b) VALUES ($1, $2) RETURNING *"
    assert params == [1,2]
  end

  test "insert with map" do
    {query, params} = Query.insert(:users, %{a: 1, b: 2})

    assert query == "INSERT INTO users (a,b) VALUES ($1, $2) RETURNING *"
    assert params == [1,2]
  end

  test "delete with list" do
    {query, params} = Query.delete(:users, [a: 1, b: 2])

    assert query == "DELETE FROM users  WHERE a = $1 AND b = $2 RETURNING *"
    assert params == [1,2]
  end

  test "delete with map" do
    {query, params} = Query.delete(:users, %{a: 1, b: 2})

    assert query == "DELETE FROM users  WHERE a = $1 AND b = $2 RETURNING *"
    assert params == [1,2]
  end

  test "update with list" do
    {query, params} = Query.update(:users, [a: 1, b: 2], [c: 3, d: 4])

    assert query == "UPDATE users SET a = $1, b = $2 WHERE c = $3 AND d = $4 RETURNING *"
    assert params == [1,2,3,4]
  end

  test "update with map" do
    {query, params} = Query.update(:users, %{a: 1, b: 2}, %{c: 3, d: 4})

    assert query == "UPDATE users SET a = $1, b = $2 WHERE c = $3 AND d = $4 RETURNING *"
    assert params == [1,2,3,4]
  end

end
