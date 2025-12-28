Mix.install([{:req, "~> 0.3.0"}])

defmodule CLITest do
  def run(key, limit, window, count) do
    IO.puts("Testing key: #{key} with limit: #{limit} window: #{window}s count: #{count}")
    
    Enum.each(1..count, fn i ->
      {:ok, response} = Req.post("http://localhost:4000/check", json: %{
        key: key,
        limit: limit,
        window_seconds: window
      })
      
      status = response.status
      body = response.body
      
      IO.puts("Req #{i}: HTTP #{status} - Allowed: #{body["allowed"]} Remaining: #{body["remaining"]} Reset: #{body["reset_in"]}s")
    end)
  end
end

[key, limit, window, count] = case System.argv() do
  [k, l, w, c] -> [k, String.to_integer(l), String.to_integer(w), String.to_integer(c)]
  _ -> ["test_user", 5, 60, 10]
end

CLITest.run(key, limit, window, count)
