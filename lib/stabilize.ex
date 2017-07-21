defmodule Stabilize do
    import Ecto.Query, except: [preload: 2]
    import ChordDht.Repo
    import RandomString
    alias ChordDht.Node



    def stabilize do
        qry = "Select * from chord_dht order by random() LIMIT 1"
        res = Ecto.Adapters.SQL.query!(ChordDht.Repo, qry, []) 
        node_hash = Enum.at(Enum.at(res.rows,0),3) #hash
        node_suc = Enum.at(Enum.at(res.rows,0),4) #successorのhash
        node_pre = Enum.at(Enum.at(res.rows,0),5) #predecessorのhash

        suc_node = get_by(Node,hash: node_suc) #successor

        node = get_by(Node,hash: node_hash) #node更新用
        
        if suc_node.predecessor <= node_hash do #自身が新しいノードだった場合
            ChordDht.Node.changeset(suc_node,%{predecessor: node_hash})
            |> update
        else #新しいノードが発見された場合
            if suc_node.predecessor < node_suc && suc_node.predecessor != "nil" do
                ChordDht.Node.changeset(node,%{successor: suc_node.predecessor})
                |> update
                estimated_successor = get_by(Node,hash: suc_node.predecessor)
                if node_hash < estimated_successor.hash do
                    ChordDht.Node.changeset(estimated_successor,%{predecessor: node_hash})
                    |> update
                end
            else
                ChordDht.Node.changeset(suc_node,%{predecessor: node_hash})
                |> update
            end
        end
    end
end