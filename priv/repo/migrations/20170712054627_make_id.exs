defmodule ChordDht.Repo.Migrations.MakeId do
  use Ecto.Migration

  def change do
    alter table(:chord_dht) do
      add :id, :integer
    end
  end
end
