defmodule ChordDht.Repo.Migrations.CreateNode do
  use Ecto.Migration

  def change do
    create table(:chord_dht) do
        add :name, :string
        add :ip, :string
        add :hash, :string
        add :successor, :integer
        add :predecessor, :integer
      end
  end
end
