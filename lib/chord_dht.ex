defmodule ChordDht do
  import Ecto.Query, except: [preload: 2]
  import ChordDht.Repo
  alias ChordDht.Node

  @moduledoc """
  Documentation for ChordDht.
  """

  @doc """
  Hello world.

  ## Examples

      iex> ChordDht.hello
      :world

  """
  
  def hello do
    :world
  end
  
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(ChordDht.Repo, []),
    ]

    opts = [strategy: :one_for_one, name: ChordDht.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def hash(str) do
    :crypto.hash(:sha256,str)
      |> Base.encode16(case: :lower) 
  end

  def mklist(str), do: _mklist([str],str)

  defp _mklist(list,_) when length(list)>=4 do
    list
  end

  defp _mklist(list,str) when length(list)<4 do
    head = hash(str)
    _mklist([head|list],head)
  end

  def init(str) do
    #str = "unko"
    delete_all Node
    
    Enum.each(mklist(str),fn (hs) ->
          insert(%Node{name: "node1",ip: "12345",hash: hs,successor: 123,predecessor: 456})
        end
    )
    
  end



end
