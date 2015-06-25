(**************************************************************************)
(*                                                                        *)
(*  This file is part of Frama-C.                                         *)
(*                                                                        *)
(*  Copyright (C) 2007-2015                                               *)
(*    CEA (Commissariat à l'énergie atomique et aux énergies              *)
(*         alternatives)                                                  *)
(*                                                                        *)
(*  you can redistribute it and/or modify it under the terms of the GNU   *)
(*  Lesser General Public License as published by the Free Software       *)
(*  Foundation, version 2.1.                                              *)
(*                                                                        *)
(*  It is distributed in the hope that it will be useful,                 *)
(*  but WITHOUT ANY WARRANTY; without even the implied warranty of        *)
(*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *)
(*  GNU Lesser General Public License for more details.                   *)
(*                                                                        *)
(*  See the GNU Lesser General Public License version 2.1                 *)
(*  for more details (enclosed in the file licenses/LGPLv2.1).            *)
(*                                                                        *)
(**************************************************************************)

open CilE

type syntactic_context =
  | SyNone
  | SyCallResult
  | SyBinOp of Cil_types.exp * Cil_types.binop * Cil_types.exp * Cil_types.exp
  | SyUnOp of  Cil_types.exp
  | SyMem of  Cil_types.lval
  | SyMemLogic of Cil_types.term
  | SySep of Cil_types.lval * Cil_types.lval

val start_stmt : Cil_types.kinstr -> unit
val end_stmt : unit -> unit
val current_stmt : unit -> Cil_types.kinstr

val set_syntactic_context : syntactic_context -> unit

val do_warn: alarm_behavior ->
  ((Emitter.t * (Format.formatter -> unit)) -> unit) -> unit

val warn_div : warn_mode -> addresses:bool -> unit
(** division. If [addresses] holds, also emit an alarm about the denominator
    not being comparable to \null. *)

val warn_shift : warn_mode -> int -> unit
val warn_shift_left_positive : warn_mode -> unit
val warn_mem_read : warn_mode -> unit
val warn_mem_write : warn_mode -> unit
val warn_integer_overflow : 
  warn_mode -> signed:bool -> min:Integer.t option -> max:Integer.t option -> unit
val warn_float_to_int_overflow: 
  warn_mode ->
  Integer.t option -> Integer.t option -> (Format.formatter -> unit) -> unit

val warn_index : warn_mode -> positive:bool -> range:string -> unit
(** [warn_index w ~positive ~range] emits a warning signaling an out of bounds
    access. The expression used as index is taken from the syntactic context.
    [range] is used to display the inferred values for the index.
    If [positive] is true, the generated assertion is of the form
    [e < upper_bound]; otherwise, two assertions are generated: [0 <= e]
    and [e < upper_bound].
*)
val warn_pointer_comparison : warn_mode -> unit
val warn_valid_string : warn_mode -> unit
val warn_pointer_subtraction : warn_mode -> unit
val warn_nan_infinite:
  warn_mode -> Cil_types.fkind option -> (Format.formatter -> unit) -> unit
val warn_uninitialized : warn_mode -> unit
val warn_escapingaddr : warn_mode -> unit
(** warning to be emitted when two incompatible accesses to a location are
    done in unspecified order. Must be called in a [SyNone] or [SySep] context.
*)
val warn_separated : warn_mode -> unit
val warn_overlap : (Format.formatter -> unit) -> warn_mode -> unit
