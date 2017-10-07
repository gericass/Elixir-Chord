defmodule Stabilize do
    import Ecto.Query, except: [preload: 2]
    import ChordDht.Repo
    import RandomString
    alias ChordDht.Node



    def _stabilize do

      stabilize()

    end
    
    def stabilize do
        qry = "Select * from chord_dht order by rand() LIMIT 1"
        res = Ecto.Adapters.SQL.query!(ChordDht.Repo, qry, []) 
        node_hash = Enum.at(Enum.at(res.rows,0),3) #hash
        node_suc = Enum.at(Enum.at(res.rows,0),4) #successorのhash
        node_pre = Enum.at(Enum.at(res.rows,0),5) #predecessorのhash

        suc_node = get_by(Node,hash: node_suc) #successor

        node = get_by(Node,hash: node_hash) #node更新用
        
        cond do
          node_pre == "nil" ->##suc_node.predecessor < node_hash -> #自身が新しいノードだった場合
            cond do
              suc_node.predecessor > node_hash -> #自分が先頭ノードになる時
                cond do
                  suc_node.predecessor > node_hash && suc_node.predecessor < suc_node.hash ->
                    ChordDht.Node.changeset(node,%{successor: suc_node.predecessor})
                    |> update
                    estimated_successor = get_by(Node,hash: suc_node.predecessor)
                    if node_hash < estimated_successor.hash do
                      ChordDht.Node.changeset(estimated_successor,%{predecessor: node_hash})
                      |> update
                    end
                  suc_node.predecessor > node_hash && suc_node.predecessor > suc_node.hash ->
                    ChordDht.Node.changeset(suc_node,%{predecessor: node_hash})
                    |> update
                end

              node_hash > suc_node.hash -> #自分が終端になる時
                cond do
                  suc_node.predecessor < node_hash && suc_node.predecessor < suc_node.hash ->
                    ChordDht.Node.changeset(node,%{successor: suc_node.predecessor})
                    |> update
                    estimated_successor = get_by(Node,hash: suc_node.predecessor)
                    if suc_node.predecessor < node_hash do
                      ChordDht.Node.changeset(estimated_successor,%{predecessor: node_hash})
                      |> update  
                    end                    
                  suc_node.predecessor > node_hash ->
                    ChordDht.Node.changeset(node,%{successor: suc_node.predecessor})
                    |> update
                    estimated_successor = get_by(Node,hash: suc_node.predecessor)
                    if suc_node.predecessor > node_hash do
                      ChordDht.Node.changeset(estimated_successor,%{predecessor: node_hash})
                      |> update  
                    end                    
                  suc_node.predecessor < node_hash && suc_node.hash < suc_node.predecessor ->
                    ChordDht.Node.changeset(suc_node,%{predecessor: node_hash})
                    |> update
                  suc_node.predecessor == node_hash ->
                    IO.puts "me"

                end


              true ->
                cond do
                  suc_node.predecessor > node_hash ->
                    ChordDht.Node.changeset(node,%{successor: suc_node.predecessor})
                    |> update
                    estimated_successor = get_by(Node,hash: suc_node.predecessor)
                    if node_hash < estimated_successor.hash do
                      ChordDht.Node.changeset(estimated_successor,%{predecessor: node_hash})
                      |> update
                    end
                  suc_node.predecessor < node_hash ->
                    ChordDht.Node.changeset(suc_node,%{predecessor: node_hash})
                    |> update
                  suc_node.predecessor == node_hash ->
                    IO.puts "me"
                end
            end
            ##if node_hash < node_suc do #自分が終端のノードではなかった場合
            ##    IO.puts "asdasd"
            ##    ChordDht.Node.changeset(suc_node,%{predecessor: node_hash})
            ##    |> update
            ##else
            ##    ChordDht.Node.changeset(node,%{successor: suc_node.predecessor})
            ##    |> update
            ##    estimated_successor = get_by(Node,hash: suc_node.predecessor)
            ##    if node_hash > estimated_successor.hash do
            ##        ChordDht.Node.changeset(estimated_successor,%{predecessor: node_hash})
            ##        |> update
            ##    end
            ##end
          ##suc_node.predecessor > node_hash ->
          ## #新しいノードが発見された場合
          ##  if suc_node.predecessor < node_suc do
          ##      IO.puts "ok"
          ##      ChordDht.Node.changeset(node,%{successor: suc_node.predecessor})
          ##      |> update
          ##      estimated_successor = get_by(Node,hash: suc_node.predecessor)
          ##      if node_hash < estimated_successor.hash do
          ##          ChordDht.Node.changeset(estimated_successor,%{predecessor: node_hash}) #新ノードのpreを更新
          ##          |> update
          ##      end
          ##  else
          ##      IO.puts "kuso"
          ##      ChordDht.Node.changeset(suc_node,%{predecessor: node_hash})
          ##      |> update
          ##  end
          suc_node.predecessor != node_hash  ->
            ChordDht.Node.changeset(node,%{successor: suc_node.predecessor})
            |> update
            estimated_successor = get_by(Node,hash: suc_node.predecessor)
            ChordDht.Node.changeset(estimated_successor,%{predecessor: node_hash})
            |> update

          suc_node.predecessor == node_hash ->
            IO.puts "me"
        end
        _stabilize()
    end
end