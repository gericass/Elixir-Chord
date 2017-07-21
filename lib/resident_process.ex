defmodule ResidentProcess do
  import Ecto.Query, except: [preload: 2]
  import ChordDht.Repo
  import Join
  import Stabilize
  alias ChordDht.Node

  def recursion([1]) do
    num = :rand.uniform(10000000)
    #IO.puts num
    create_node()
    recursion([num])
  end

  def stab(num) do
    if num ==1 do
      stabilize()
    end
  end

  def recursion([_]) do
    num = :rand.uniform(10000000)
    num2 = :rand.uniform(300000)
    #IO.puts num
    stab(num2)
    recursion([num])
  end

end