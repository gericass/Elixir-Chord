defmodule Join do
  import Ecto.Query, except: [preload: 2]

  import ChordDht.Repo
  import RandomString
  alias ChordDht.Node

  def search_successor(node, suc_node) do
    IO.inspect node
    cond do
      suc_node.predecessor == "nil" ->
        next = get_by(Node, hash: suc_node.successor)
        search_successor(node, next)
      suc_node.predecessor < suc_node.hash && suc_node.hash < suc_node.successor -> #suc_nodeが円の開始、終端ノードではなかった場合
        cond do
          suc_node.hash < node.hash && node.hash < suc_node.successor ->
            %Node{node | successor: suc_node.successor}#%Node{node|successor: suc_node.hash}
            |> insert
          suc_node.predecessor < node.hash && node.hash < suc_node.hash ->
            %Node{node | successor: suc_node.hash}#%Node{node|successor: suc_node.hash}
            |> insert
          true ->
            next = get_by(Node, hash: suc_node.successor)
            search_successor(node, next)
        end
      suc_node.predecessor > suc_node.hash -> #suc_nodeが円の開始ノードだった場合
        cond do
          node.hash < suc_node.hash -> #nodeが円の開始点になる場合
            %Node{node | successor: suc_node.hash} #%Node{node|successor: suc_node.hash}
            |> insert
          suc_node.hash < node.hash && node.hash < suc_node.successor ->
            %Node{node | successor: suc_node.successor}
            |> insert
          suc_node.predecessor < node.hash -> #nodeが円の終端になる場合
            %Node{node | successor: suc_node.hash}
            |> insert
          true ->
            next = get_by(Node, hash: suc_node.successor)
            search_successor(node, next)
        end
      suc_node.successor < suc_node.hash -> #suc_nodeが円の終端ノードだった場合
        cond do
          node.hash > suc_node.hash -> #終端に挿入
            %Node{node | successor: suc_node.successor}
            |> insert
          suc_node.successor < node.hash -> #先頭に挿入
            %Node{node | successor: suc_node.successor}
            |> insert
          suc_node.predecessor < node.hash && node.hash < suc_node.hash ->
            %Node{node | successor: suc_node.hash}
            |> insert
          true ->
            next = get_by(Node, hash: suc_node.successor)
            search_successor(node, next)
        end
      true ->
        IO.inspect suc_node
    end
  end

  def _create_node do
    create_node()
  end

  def create_node do
    :timer.sleep(1000)
    if length(
         Node
         |> all
       ) < 10 do
      name = randstr()
      hash = ChordDht.makehash(name)
      node = %Node{name: name, ip: "12345", hash: hash, successor: "nil", predecessor: "nil"}
      first_search_node = Node
                          |> first
                          |> one
      search_successor(node, first_search_node)
      _create_node()
    end
  end
end