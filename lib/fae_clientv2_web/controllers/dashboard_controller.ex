defmodule FaeClientv2Web.DashboardController do
  use FaeClientv2Web, :controller

  def index(conn, _) do
    IO.inspect conn
    render(conn, "index.html")
  end
end
