defmodule ChordDht.Repo.Migrations.RemakeTable do
  use Ecto.Migration

  def change do
    create table(:chord_dht,primary_key: false) do
        add :name, :string
        add :ip, :string
        add :hash, :string
        add :successor, :string
        add :predecessor, :string
      end
  end
end
