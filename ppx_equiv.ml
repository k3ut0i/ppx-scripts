open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree
open Longident
open Location
let (==>) a b = not (a && not b)

let (<==>) a b = (a ==> b) && (b ==> a)

exception Equiv_no_two_args
let rec split_equiv args = match args with
  | a1 :: a2 :: []
    -> let a1' = (fst a1, expand_equiv (snd a1)) in
       let a2' = (fst a2, expand_equiv (snd a2)) in
       let lr = Exp.mk
                  (Pexp_apply (Exp.mk
                                 (Pexp_ident {txt = Lident "==>";
                                              loc = (!default_loc)}),
                               (a1' :: a2' :: [])))
       in
       let rl = Exp.mk
                  (Pexp_apply (Exp.mk
                                 (Pexp_ident {txt = Lident "==>";
                                              loc = (!default_loc)}),
                               (a2' :: a1' :: [])))
       in Exp.mk (Pexp_apply (Exp.mk
                                (Pexp_ident {txt = Lident "&&";
                                              loc = (!default_loc)}),
                                ((Nolabel, lr) :: (Nolabel, rl) :: [])))
       
  | _ -> raise Equiv_no_two_args
               
and expand_equiv e = match e with
  | {pexp_desc = Pexp_apply
                   ({pexp_desc = Pexp_ident {txt = Lident "<==>"}},
                    args)}
    -> split_equiv args
  | _ -> e
           
let equiv_mapper argv =
  {default_mapper with
    expr = fun mapper expr ->
           match expr with
           | {pexp_desc = Pexp_extension ({txt = "equiv"; loc}, pstr)} ->
              begin match pstr with
              | PStr [{pstr_desc = Pstr_eval (e, _)}] -> expand_equiv e
              | _ -> raise (Location.Error(
                                Location.error ~loc
                                  "[%equiv error]"))
              end
           | x -> default_mapper.expr mapper x;
  }

let () = register "equiv" equiv_mapper
