defmodule FaeClientv2.API.Accounts do
  alias Ecto.Changeset

  alias FaeClientv2.Schemas.Account
  alias FaeClientV2.API.Accounts

  @success_codes 200..399

  def sign_up(params) do
    url = "/users/signup"

    with {:ok, %{body: body, status: status}} when status in @success_codes <-
           Tesla.post(client(), url, %{:user => %{:email => params["email"], :password => params["password"]}}) do
      {:ok, body}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end

  def sign_in(params) do
    url = "/users/signin"

    with {:ok, %{body: body, status: status}} when status in @success_codes <-
           Tesla.post(client(), url, %{:email => params["email"], :password => params["password"]}) do
      {:ok, body}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end

  def log_out(params) do
    url = "/users/logout"

    with {:ok, %{body: body, status: status}} when status in @success_codes <-
           Tesla.post(client(), url, %{:token => params["token"]})|> IO.inspect() do
      {:ok, body}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end

  defp client() do
    url = "http://api:5000/api"

    middlewares = [
      {Tesla.Middleware.BaseUrl, url},
      Tesla.Middleware.JSON,
      Tesla.Middleware.PathParams,
      Tesla.Middleware.Logger
    ]

    Tesla.client(middlewares)
  end
end
