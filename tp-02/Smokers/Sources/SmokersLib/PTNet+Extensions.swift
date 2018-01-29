import PetriKit

public class MarkingGraph {

    public let marking   : PTMarking
    public var successors: [PTTransition: MarkingGraph]

    public init(marking: PTMarking, successors: [PTTransition: MarkingGraph] = [:]) {
        self.marking    = marking
        self.successors = successors
    }

}

public extension PTNet {

    public func markingGraph(from marking: PTMarking) -> MarkingGraph? {
        // noeud initial
        let noeud = MarkingGraph(marking : marking)
        // liste des noeuds déjà vu (vide à l'initialisation)
        var nodeSeen = [MarkingGraph]()
        // liste des noeuds à traiter (1 élément à l'initialisation)
        var nodeToDo = [noeud]

        // si la liste nodeToDo contient au moins 1 élément
        while let currentNode = nodeToDo.popLast() {

          nodeSeen.append(currentNode)

          for trans in self.transitions {
            if let marq = trans.fire(from: currentNode.marking) {
              // si le noeud a déjà été visité
              if nodeSeen.contains(where: {$0.marking == marq}) {
                currentNode.successors[trans] = nodeSeen.first(where: {$0.marking == marq})}
              // si le noeud doit être visité
              else if nodeToDo.contains(where: {$0.marking == marq}) {
                currentNode.successors[trans] = nodeToDo.first(where: {$0.marking == marq})}
              // sinon, il s'agit d'un nouveau noeud
              else {
                let newNode = MarkingGraph(marking: marq)
                nodeToDo.append(newNode)
                currentNode.successors[trans] = newNode}
            }
          }
        }
        return noeud
    }
}
