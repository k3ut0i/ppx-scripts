open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree
open Longident
open List

let arith_ops = ["+"; "*"; "-"; "/"]

let addone_to_string i = string_of_int ((int_of_string i) + 1)

let addone_to_arg arg = match arg with
  | (label, {pexp_desc = Pexp_constant (Pconst_integer (i_str, i_op))})
    -> (label, Exp.mk (Pexp_constant (Pconst_integer
                                        (addone_to_string i_str , i_op))))
  | _ -> arg
       
let addone_to_args args = map addone_to_arg args
              
let addone e = match e with
  | { pexp_desc = Pexp_apply
                    ({pexp_desc = Pexp_ident {txt = Lident id_str}}, args)}
    -> {e with pexp_desc = Pexp_apply
                             ({pexp_desc = Pexp_ident {txt = Lident id_str;
                                                       loc = (!default_loc)};
                               pexp_loc = (!default_loc);
                               pexp_loc_stack = [];
                               pexp_attributes = []
                              },
                              (addone_to_args args))}
  | _ -> e

let addone_mapper argv =
  {default_mapper with
    expr = fun mapper expr ->
           match expr with
           | {pexp_desc = Pexp_extension ({txt = "addone"; loc}, pstr)} ->
              begin match pstr with
              | PStr [{pstr_desc = Pstr_eval (e, _)}] ->
                 (addone e)
              | _ -> raise (Location.Error (
                                Location.error ~loc
                                  "[%addone] accepts arith expressions"))
              end
           | x -> default_mapper.expr mapper x;
  }
                              

let () = register "addone" addone_mapper
