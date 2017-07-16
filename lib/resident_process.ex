defmodule ResidentProcess do
  import Ecto.Query, except: [preload: 2]
  import ChordDht.Repo
  import Join
  alias ChordDht.Node

  def recursion(0) do
    num = :rand.uniform(10000)
    join()
    recursion(num)
  end

  def recursion(_) do
    num = :rand.uniform(10000)
    recursion(num)
  end

end