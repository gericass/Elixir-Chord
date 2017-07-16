defmodule ResidentProcess do
  import Ecto.Query, except: [preload: 2]
  import ChordDht.Repo
  import Join
  alias ChordDht.Node

  def recursion(1) do
    num = :rand.uniform(1000)
    create_node()
    recursion(num)
  end

  def recursion(_) do
    num = :rand.uniform(1000)
    IO.puts num
    recursion(num)
  end

end