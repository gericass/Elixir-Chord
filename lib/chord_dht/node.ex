defmodule ChordDht.Node do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chord_dht" do
    field :name, :string
    field :ip, :string
    field :hash, :string
    field :successor, :string
    field :predecessor, :string
  end
  def changeset(val, params \\ %{}) do
    val
    |> cast(params, [:ip, :successor, :predecessor])
    |> validate_required([:ip, :successor, :predecessor])
  end
end