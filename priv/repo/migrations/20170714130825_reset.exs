defmodule ChordDht.Repo.Migrations.Reset do
  use Ecto.Migration

  def change do
    drop table(:chord_dht)
    create table(:chord_dht) do
        add :name, :string
        add :ip, :string
        add :hash, :string
        add :successor, :string
        add :predecessor, :string
      end
  end
end
