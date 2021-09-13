defmodule FaeClientv2.Schemas.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @schema_fields [
    :email,
    :password
  ]
  @derive {Jason.Encoder, only: @schema_fields}

  schema "accounts" do
    field(:email, :string)
    field(:password, :string)

    timestamps()
  end

  def schema_fields, do: @schema_fields

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :email,
      :password
    ])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
    |> validate_length(:password, min: 6)
  end

  defmodule Query do
    defstruct []
  end

  def query_changeset(struct, params \\ %{}) do
    types = %{
      email: :string
    }

    cast({struct, types}, params, Map.keys(types))
  end
end
