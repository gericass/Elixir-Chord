defmodule Join do
  import Ecto.Query, except: [preload: 2]
  import ChordDht.Repo
  alias ChordDht.Node

  def join do
    name = randstr()
    hash = ChordDht.makehash(name)

    %Node{name: name,ip: "12345",hash: hash,successor: "nil",predecessor: "nil"}
  end
end