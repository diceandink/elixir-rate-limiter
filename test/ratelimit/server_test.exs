defmodule Ratelimit.ServerTest do
  use ExUnit.Case

  setup do
    # Clear state by restarting server if needed, or use unique keys
    :ok
  end

  test "server tracking" do
    {:ok, res1} = Ratelimit.Server.check("srv1", 2, 60)
    assert res1.allowed == true
    assert res1.remaining == 1

    {:ok, res2} = Ratelimit.Server.check("srv1", 2, 60)
    assert res2.allowed == true
    assert res2.remaining == 0

    {:ok, res3} = Ratelimit.Server.check("srv1", 2, 60)
    assert res3.allowed == false
  end
end
