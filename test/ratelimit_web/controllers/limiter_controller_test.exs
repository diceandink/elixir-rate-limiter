defmodule RatelimitWeb.LimiterControllerTest do
  use RatelimitWeb.ConnCase

  test "allows request within limit", %{conn: conn} do
    conn = post(conn, "/check", %{key: "user1", limit: 2, window_seconds: 60})
    assert json_response(conn, 200)["allowed"] == true
    assert json_response(conn, 200)["remaining"] == 1
  end

  test "denies request over limit", %{conn: conn} do
    post(conn, "/check", %{key: "user2", limit: 1, window_seconds: 60})
    conn = post(conn, "/check", %{key: "user2", limit: 1, window_seconds: 60})
    assert json_response(conn, 429)["allowed"] == false
    assert json_response(conn, 429)["remaining"] == 0
  end

  test "resets window", %{conn: conn} do
    post(conn, "/check", %{key: "user3", limit: 1, window_seconds: 1})
    Process.sleep(1100)
    conn = post(conn, "/check", %{key: "user3", limit: 1, window_seconds: 1})
    assert json_response(conn, 200)["allowed"] == true
  end

  test "handles invalid input", %{conn: conn} do
    conn = post(conn, "/check", %{key: 123, limit: "a", window_seconds: 60})
    assert json_response(conn, 400)["error"] == "invalid_input"
  end

  test "handles concurrent requests" do
    tasks = for _i <- 1..10 do
      Task.async(fn ->
        conn = Phoenix.ConnTest.build_conn()
        post(conn, "/check", %{key: "concurrent", limit: 5, window_seconds: 60})
      end)
    end

    results = Enum.map(tasks, &Task.await/1)
    allowed_count = Enum.count(results, fn conn -> conn.status == 200 end)
    denied_count = Enum.count(results, fn conn -> conn.status == 429 end)

    assert allowed_count == 5
    assert denied_count == 5
  end
end
