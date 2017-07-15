defmodule ChordDht do
  import Ecto.Query, except: [preload: 2]
  import ChordDht.Repo
  import RandomString
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

  def makehash(str) do #ハッシュ計算を行う
    :crypto.hash(:sha256,str)
      |> Base.encode16(case: :lower) 
  end

  def mklist(str) do
    hashedstr = makehash(str)
     _mklist([hashedstr],hashedstr) #与えられた引数を元にリストを作成
  end

  defp _mklist(list,_) when length(list)>=4, do: list
 
  defp _mklist(list,str) when length(list)<4 do
    head = makehash(str)
    _mklist([head|list],head)
  end

  def init(str) do #DBの初期化 実行はmix run -e 'ChordDht.init("moji")'
    delete_all Node
    Enum.each(mklist(str),fn (hash) -> #初期ノードを挿入
        insert(%Node{name: randstr(),ip: "12345",hash: hash,successor: "nil",predecessor: "nil"})
      end
    )

    sorted = Node 
            |> all
            |> Enum.sort(&(&1.hash <= &2.hash)) #ノードの取得とhash値でのソート
    
    Enum.each(sorted,fn (s)-> #successorとpredecessorを設定
        ind = Enum.find_index(sorted,fn (i) -> i.hash == s.hash end)
        case ind do
          3 -> 
            ChordDht.Node.changeset(s,%{successor: Enum.at(sorted,0).hash, predecessor: Enum.at(sorted,ind-1).hash})
            |> update
          0 ->
            ChordDht.Node.changeset(s,%{successor: Enum.at(sorted,ind+1).hash, predecessor: Enum.at(sorted,length(sorted)-1).hash})
            |> update
          _ ->
            ChordDht.Node.changeset(s,%{successor: Enum.at(sorted,ind+1).hash, predecessor: Enum.at(sorted,ind-1).hash})
            |> update
        end
      end
    )
    
    nd2 = Node |> all
    IO.inspect nd2
  end
end
