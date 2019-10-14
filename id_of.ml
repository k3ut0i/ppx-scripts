open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree
open Longident

let structure_mapper mapper structure = _

let id_of_mapper = {
    default_mapper with structure = structure_mapper
  }

let () = register "id_of" id_of_mapper           
