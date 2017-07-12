defmodule ChordDht.Repo.Migrations.ResetTable do
  use Ecto.Migration

  def change do
    drop table(:chord_dht)
  end
end
