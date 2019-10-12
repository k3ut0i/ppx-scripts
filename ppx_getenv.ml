open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree
open Longident

let getenv s = try Sys.getenv s
               with Not_found -> ""

let getenv_mapper argv =
  { default_mapper with
    expr = fun mapper expr ->
           match expr with
           | { pexp_desc = Pexp_extension ({ txt = "getenv"; loc}, pstr)} ->
              begin match pstr with
              | PStr [{pstr_desc =
                         Pstr_eval
                           ({pexp_loc = loc;
                             pexp_desc = Pexp_constant
                                           (Pconst_string (sym, None))}, _)}] ->
                 Exp.constant ~loc (Pconst_string (getenv sym, None))
              | _ -> raise (Location.Error (
                                Location.error ~loc
                                  "[%getenv] accepts a string, e.g. [%getenv \"USER\"]"))
              end
           | x -> default_mapper.expr mapper x;
  }

let () = register "getenv" getenv_mapper
