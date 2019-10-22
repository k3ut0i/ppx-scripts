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

let structure_mapper mapper decl =
  match decl with
  | {pstr_desc = Pstr_type (_, [type_decl])} ->
     begin
       match type_decl with
       | {ptype_name = {txt = "t";_};
          ptype_kind = Ptype_variant con_decls;
          ptype_attributes;_} ->
          begin
            match
              List.filter (fun ({attr_name; _}) -> attr_name.txt = "id_of")
            with
            | _ -> default_mapper.structure mapper [decl]
          end
     end
  | _ -> default_mapper.structure mapper [decl]

(* What is the sequence of mappers executed?
If type_dec_mapper and con_dec_mapper remove attributes before 
structure_mapper then wont the structure_mapper default?*)
            
let id_of_mapper = {
    default_mapper with
    structure = structure_mapper;
    type_declaration = type_dec_mapper;
    constructor_declaration = con_dec_mapper
  }

let () = register "id_of" id_of_mapper           
