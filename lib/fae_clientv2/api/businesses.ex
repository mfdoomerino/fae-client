defmodule FaeClient.API.Businesses do
  alias Ecto.Changeset

  alias FaeClient.Schemas.Business, as: Business

  @success_codes 200..399

  def all_businesses(params) do
    token = "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJmYWVfc2VydmljZSIsImV4cCI6MTYzMzQ5MTIwNCwiaWF0IjoxNjMxMDcyMDA0LCJpc3MiOiJmYWVfc2VydmljZSIsImp0aSI6ImNiOGQ3YzVlLWJkY2QtNDI4ZS1hZTRjLWE4NTcyYzhhZTRlMCIsIm5iZiI6MTYzMTA3MjAwMywic3ViIjoiMSIsInR5cCI6ImFjY2VzcyJ9.hymGZ16x9vBtkXOCeTDpgYSzJI4klGikYc9scwm7oVxPMAuQ0xpX7KRsVfDEnegRO46y7iQsa7T-XnpAQX7Ntg"
    params = Map.merge(params, %{
      "access_token" => token
    })

    url = "/businesses"
    {access_token, params} = Map.pop(params, "access_token")

    with %{valid?: true} = changeset <- Business.query_changeset(%Business.Query{}, params),
         query =
           changeset
           |> Changeset.apply_changes()
           |> Map.from_struct(),
         client = client(access_token),
         {:ok, %{body: body, status: status}} when status in @success_codes <-
           Tesla.get(client, url, query: query)|>IO.inspect() do
      {:ok, Enum.map(body, &from_response/1)}
    else
      {:ok, %{body: body}} -> {:error, body}
      %Changeset{} = changeset -> {:error, changeset}
      error -> error
    end
  end

  defp client(access_token) do
    url = "http://api:5000/api"

    middlewares = [
      {Tesla.Middleware.BaseUrl, url},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"authorization", "Bearer #{access_token}"}]},
      Tesla.Middleware.PathParams,
      Tesla.Middleware.Logger
    ]

    Tesla.client(middlewares)
  end

  defp from_response(response),
    do: %Business{} |> Business.changeset(response) |> Changeset.apply_changes()
end
