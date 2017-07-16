defmodule Join do
  import Ecto.Query, except: [preload: 2]
  import ChordDht.Repo
  import RandomString
  alias ChordDht.Node


  def search_successor(node,suc_node) do
    
  end

  def create_node do
    name = randstr()
    hash = ChordDht.makehash(name)
    node = %Node{name: name,ip: "12345",hash: hash,successor: "nil",predecessor: "nil"}
    first_search_node = get(Node,81)
    search_successor(node,first_search_node)
  end
end