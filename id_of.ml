open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree
open Longident

let type_dec_mapper mapper decl =
  match decl with
  | {ptype_name = {txt = "t";_};
     ptype_kind = constructor_declarations;
     ptype_attributes; _} ->
     let (_, attrs) =
       List.partition (fun ({attr_name;_}) -> attr_name.txt="id_of") ptype_attributes in
     {(default_mapper.type_declaration mapper decl)
     with ptype_attributes = attrs}
  | _ -> default_mapper.type_declaration mapper decl

let con_dec_mapper mapper decl =
  match decl with
  | {pcd_name={loc;_}; pcd_attributes; _} ->
     let (_, attrs) =
       List.partition (fun ({attr_name;_}) -> attr_name.txt="id")
         pcd_attributes in
     {(default_mapper.constructor_declaration mapper decl)
     with pcd_attributes = attrs}
  (* | _ -> default_mapper.constructor_declaration mapper decl *)
       
let id_of_mapper = {
    default_mapper with
    structure = structure_mapper;
    type_declaration = type_dec_mapper;
    constructor_declaration = con_dec_mapper
  }

let () = register "id_of" id_of_mapper           
