defmodule RatelimitWeb.LimiterController do
  use RatelimitWeb, :controller

  def index(conn, _params) do
    ip = conn.remote_ip |> Tuple.to_list() |> Enum.join(".")
    {:ok, result} = Ratelimit.Server.check(ip, 5, 60)

    if result.allowed do
      text(conn, "api works (Remaining: #{result.remaining})")
    else
      conn
      |> put_status(429)
      |> text("Rate limit exceeded. Reset in #{result.reset_in}s")
    end
  end

  def check(conn, %{"key" => key, "limit" => limit, "window_seconds" => window_seconds})
      when is_binary(key) and is_integer(limit) and is_integer(window_seconds) do
    {:ok, result} = Ratelimit.Server.check(key, limit, window_seconds)

    if result.allowed do
      conn
      |> put_status(200)
      |> json(result)
    else
      conn
      |> put_status(429)
      |> json(result)
    end
  end

  def check(conn, _) do
    conn
    |> put_status(400)
    |> json(%{error: "invalid_input"})
  end
end
