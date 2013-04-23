(*
 * Copyright (C) 2006-2009 Citrix Systems Inc.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation; version 2.1 only. with the special
 * exception on linking described in file LICENSE.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *)
(** Called in the autogenerated DM_to_string module *)

module D=Debug.Debugger(struct let name="xapi" end)
open D

(* We need to ensure that there are no nasty characters in the set/map marshalling below.
   The autogenerated db_actions.ml file, calls these directly in a few scenarios, including when
   someone does a Db.*_set of a structure field (i.e. set or map). The bug that triggered
   this realisation was: CA-22302. *) 

let ensure_utf8_xml string =
  let length = String.length string in
  let prefix = Encodings.UTF8_XML.longest_valid_prefix string in
  if length > String.length prefix then
    warn "Whilst doing 'set' of structured field, string truncated to: '%s'." prefix;
  prefix

let set f ks =
  SExpr.string_of
    (SExpr.Node (List.map (fun x -> SExpr.String (ensure_utf8_xml (f x))) ks))

let map f g kv = 
  SExpr.string_of
    (SExpr.Node (List.map (fun (k, v) -> 
			     SExpr.Node [ SExpr.String (ensure_utf8_xml (f k)); SExpr.String (ensure_utf8_xml (g v)) ]) kv))
