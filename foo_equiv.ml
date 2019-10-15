let (==>) a b = not (a && not b)

let (<==>) a b = (a ==> b) && (b ==> a)

(* I want to expand <==> in this.*)
let equiv_theorem a b c =
  [%equiv ((a <==> b) <==> c) <==> (a <==> (b <==> c))]

let _ = [%equiv true <==> false]    
