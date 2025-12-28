defmodule RatelimitWeb.ConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use RatelimitWeb, :controller
      import Plug.Conn
      import Phoenix.ConnTest
      @endpoint RatelimitWeb.Endpoint
    end
  end

  setup _tags do
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
