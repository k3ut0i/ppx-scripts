open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree
open Longident

(* type op_type = Add | Sub | Mul | Div *)
exception Unknown_operator
let op_map (op_str : string) : string =
  match op_str with
  | "+" -> "Add"
  | "-" -> "Sub"
  | "*" -> "Mul"
  | "/" -> "Div"
  | _ -> raise Unknown_operator

let rec translate_arith_exp e =
  match e with
  | {pexp_desc = Pexp_apply ({pexp_desc = Pexp_ident
                                            {txt = Lident fn_str; loc};
                              pexp_loc;
                              pexp_loc_stack;
                              pexp_attributes},
                             args)} ->
     let trans_arg (l1, e1) = (l1, translate_arith_exp e1) in
     {e with pexp_desc = Pexp_apply
                           ({pexp_desc = Pexp_ident
                                           {txt=Lident (op_map(fn_str));
                                            loc = loc};
                             pexp_attributes = pexp_attributes;
                             pexp_loc = pexp_loc;
                             pexp_loc_stack = pexp_loc_stack},
                            List.map trans_arg args)}
  | _ -> e
       
let arith_mapper argv =
  {default_mapper with
    expr = fun mapper exp ->
           match exp with
           | {pexp_desc = Pexp_extension ({txt="arith";_},
                                          PStr [{pstr_desc=Pstr_eval(arith_exp, _)}])} ->
              translate_arith_exp arith_exp
           | _ -> exp
  }       
let () = register "arith" arith_mapper
