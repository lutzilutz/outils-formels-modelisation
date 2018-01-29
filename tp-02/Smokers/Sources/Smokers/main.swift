import PetriKit
import SmokersLib
import Foundation

// Instantiate the model.
let model = createModel()

// Retrieve places model.
guard let r  = model.places.first(where: { $0.name == "r" }),
      let p  = model.places.first(where: { $0.name == "p" }),
      let t  = model.places.first(where: { $0.name == "t" }),
      let m  = model.places.first(where: { $0.name == "m" }),
      let w1 = model.places.first(where: { $0.name == "w1" }),
      let s1 = model.places.first(where: { $0.name == "s1" }),
      let w2 = model.places.first(where: { $0.name == "w2" }),
      let s2 = model.places.first(where: { $0.name == "s2" }),
      let w3 = model.places.first(where: { $0.name == "w3" }),
      let s3 = model.places.first(where: { $0.name == "s3" })
else {
    fatalError("invalid model")
}

var onlyOneSmoker = true // pour la question 2
var onlyOneIngredient = true // pour la question 3

// compteur du nombre de marquages possibles
// et analyseur du nombre de fumeurs simultanés et d'ingrédients
func countMark(markingGraph : MarkingGraph) -> Int {
  var markToDo = [markingGraph]
  var markSeen = [markingGraph]

  while let currentMark = markToDo.popLast(){
    for (_, successor) in currentMark.successors {
      if !markSeen.contains(where: { $0 === successor}){
        markSeen.append(successor)
        markToDo.append(successor)
        var howManySmokers = 0
        // pour chaque place, et son nombre de jetons
        for (currentPlace, nbJetons) in currentMark.marking{
          if currentPlace == s1 || currentPlace == s2 || currentPlace == s3 {
            howManySmokers = howManySmokers + 1
          }
          // si nous avons plus d'un jeton en p, t ou m
          if nbJetons>1 && (currentPlace==p || currentPlace==t || currentPlace==m) {
            onlyOneIngredient = false
          }
        }
        if nbSmokers > 1 {
          onlyOneSmoker = false
        }
      }
    }
  }
    return markSeen.count
}
// Create the initial marking.
let initialMarking: PTMarking = [r: 1, p: 0, t: 0, m: 0, w1: 1, s1: 0, w2: 1, s2: 0, w3: 1, s3: 0]

// Create the marking graph (if possible).
if let markingGraph = model.markingGraph(from: initialMarking) {

  // question 1
  // nombre d'états possibles = nombre de marquages possibles
  print("Question 1 : nombre de marquages possibles ?")
  print("Nombre de marquages possibles :",countMark(markingGraph: markingGraph),"\n")

  // question 2
  // plus de deux fumeurs simultanés ?
  print("Question 2 : nombre de fumeurs simultanés ?")
  if onlyOneSmoker == true {
    print("Nous avons seulement 1 fumeur simultané.\n")}
  else {
    print("Nous avons au moins 2 fumeurs simultanés.\n")}

  // question 3
  // plus de deux même ingrédients ?
  print("Question 3 : deux fois le même ingrédient ?")
  if onlyOneIngredient == true {
    print("Nous n'avons pas 2x le même ingrédient.")}
  else {
    print("Nous avons 2x le même ingrédient.")}

}


//let pn = PTNet(places: [r,p,t,m,w1,s1,w2,s2,w3,s3], transitions: [tpt,tpm,ttm,ts1,ts2,ts3,tw1,tw2,tw3])
//try pn.saveAsDot(to: URL(fileURLWithPath: "pn.dot"), withMarking: [r: 1, p: 0, t: 0, m: 0, w1: 1, s1: 0, w2: 1, s2: 0, w3: 1, s3: 0])
