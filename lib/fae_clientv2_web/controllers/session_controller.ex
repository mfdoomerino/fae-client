defmodule FaeClientv2Web.SessionController do
  use FaeClientv2Web, :controller
  alias FaeClientv2.API.Accounts

  def index(conn, _) do
    render(conn, "index.html")
  end

  def sign_in(conn, %{"account" => params}) do
    case Accounts.sign_in(params) do
      {:ok, body} ->
        conn
        |> put_session(:current_user_id, body["user_id"])
        |> put_session(:access_token, body["token"])
        |> put_session(:email, body["email"])
        |> put_req_header("authorization", "Bearer #{body["token"]}")
        |> redirect(to: Routes.dashboard_path(conn, :index))
      {:error, _body} ->
        conn
        |> put_flash(:error, "Invalid credentials")
    end
  end
end
