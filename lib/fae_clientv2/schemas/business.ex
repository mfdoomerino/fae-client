defmodule FaeClient.Schemas.Business do
  use Ecto.Schema
  import Ecto.Changeset

  schema "businesses" do
    field(:tag, :string)
    field(:descripton, :string)
    field(:name, :string)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :description,
      :name,
      :tag
    ])
  end

  defmodule Query do
    defstruct []
  end

  def query_changeset(struct, params \\ %{}) do
    types = %{
      name: :string
    }

    cast({struct, types}, params, Map.keys(types))
  end
end
