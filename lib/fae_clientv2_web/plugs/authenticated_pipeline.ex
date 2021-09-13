defmodule FaeClientv2Web.Plugs.AuthenticatedPipeline do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, :access_token) do
      nil ->
        conn
        |> halt()

      access_token ->
        conn
        |> assign(:access_token, access_token)
        |> assign(:path_info, conn.path_info)
        |> put_session(:path_info, conn.path_info)
        |> put_req_header("authorization", "Bearer #{access_token}")
    end
  end
end
