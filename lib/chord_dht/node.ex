defmodule ChordDht.Node do
  use Ecto.Schema

  schema "node" do
    field :name, :string
    field :ip, :string
    field :hash, :string
    field :successor, :integer
    field :predecessor, :integer
  end
end