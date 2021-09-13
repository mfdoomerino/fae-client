defmodule FaeClientv2Web.Live.Session.Index do
  use Phoenix.LiveView

  alias FaeClientv2.Schemas.Account
  alias FaeClientv2.API.Accounts

  def mount(_params, _session, socket) do
    assigns = %{
      changeset: %{Account.changeset(%Account{}, %{}) | action: :insert},
      valid: false
    }

    {:ok, assign(socket, assigns)}
  end

  def render(assigns),
    do: Phoenix.View.render(FaeClientv2Web.SessionView, "content.html", assigns)

  def handle_event("form_params", %{"account" => account} = _params, socket) do
    changeset = %{Account.changeset(%Account{}, account) | action: :insert}
    {:noreply, assign(socket, %{changeset: changeset, valid: changeset.valid?})}
  end

  def handle_event("sign_up", %{"account" => params}, socket) do
    socket =
      case Accounts.sign_up(params) do
        {:ok, _body} -> put_flash(socket, :info, "Sign-up successful")
        {:error, _error} -> put_flash(socket, :info, "Something went wrong")
      end

    {:noreply, socket}
  end

  def handle_event("sign_in", %{"account" => params}, socket) do
    socket =
      case Accounts.sign_in(params) do
        {:ok, body} ->
          socket
          |> put_flash(:info, "Sign-in successful")
        {:error, _error} -> put_flash(socket, :info, "Something went wrong")
      end

    {:noreply, socket}
  end
end
