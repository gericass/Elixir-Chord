defmodule ChordDht.Repo.Migrations.ChangeSucPre do
  use Ecto.Migration

  def change do
    alter table(:chord_dht) do
      modify :successor, :string
      modify :predecessor, :string
    end
  end
end
