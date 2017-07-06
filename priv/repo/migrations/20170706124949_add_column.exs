defmodule ChordDht.Repo.Migrations.AddColumn do
  use Ecto.Migration

  def change do
    alter table(:chord_dht) do
      add :hash, :string
    end
    
  end
end
