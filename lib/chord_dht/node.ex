defmodule ChordDht.Node do
  use Ecto.Schema

  schema "chord_dht" do
    field :name, :string
    field :ip, :string
    field :hash, :string
    field :successor, :integer
    field :predecessor, :integer
  end
end