defmodule ResidentProcess do
  import Ecto.Query, except: [preload: 2]
  import ChordDht.Repo
  import Join
  alias ChordDht.Node

  def recursion([1]) do
    num = :rand.uniform(50000000)
    #IO.puts num
    create_node()
    recursion([num])
  end

  def recursion([_]) do
    num = :rand.uniform(50000000)
    #IO.puts num
    recursion([num])
  end

end