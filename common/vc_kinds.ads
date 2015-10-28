------------------------------------------------------------------------------
--                                                                          --
--                            GNATPROVE COMPONENTS                          --
--                                                                          --
--                              V C _ K I N D S                             --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                       Copyright (C) 2010-2015, AdaCore                   --
--                                                                          --
-- gnatprove is  free  software;  you can redistribute it and/or  modify it --
-- under terms of the  GNU General Public License as published  by the Free --
-- Software  Foundation;  either version 3,  or (at your option)  any later --
-- version.  gnatprove is distributed  in the hope that  it will be useful, --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of  MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public --
-- License for  more details.  You should have  received  a copy of the GNU --
-- General Public License  distributed with  gnatprove;  see file COPYING3. --
-- If not,  go to  http://www.gnu.org/licenses  for a complete  copy of the --
-- license.                                                                 --
--                                                                          --
-- gnatprove is maintained by AdaCore (http://www.adacore.com)              --
--                                                                          --
------------------------------------------------------------------------------

--  This package defines the different kinds of VCs that we generate in
--  Gnat2why. The run-time checks correspond to Ada RM checks, for which the
--  front-end defines distinct constants in types.ads. Here, we use a new
--  enumeration instead of these constants, because we are only interested in
--  run-time errors that can happen in SPARK code (e.g. it excludes
--  Access_Check), and which GNATprove can detect (it excludes
--  Storage_Check), plus various assertions that we want to distinguish.

--  Changes in VC_Kind should be reflected in
--    - file gnat_expl.ml in gnatwhy3
--    - GPS plug-in spark2014.py
--    - 2 tables in the section of SPARK User's Guide on GNATprove

package VC_Kinds is

   type VC_Kind is
      --  VC_RTE_Kind - run-time checks

     (VC_Division_Check,
      VC_Index_Check,
      VC_Overflow_Check,
      VC_Range_Check,
      VC_Predicate_Check,
      VC_Length_Check,
      VC_Discriminant_Check,
      VC_Tag_Check,
      VC_Ceiling_Interrupt,
      VC_Interrupt_Reserved,
      VC_Ceiling_Priority_Protocol,
      VC_Task_Termination,

      --  VC_Assert_Kind - assertions

      VC_Initial_Condition,
      VC_Default_Initial_Condition,
      VC_Precondition,               --  the precondition of a call
      VC_Precondition_Main,          --  the precondition of a main program
      VC_Postcondition,              --  a postcondition
      VC_Refined_Post,               --  a refined_post
      VC_Contract_Case,
      VC_Disjoint_Contract_Cases,
      VC_Complete_Contract_Cases,
      VC_Loop_Invariant,             --  internal check kind, transformed
                                     --  by gnatwhy3 into
                                     --    VC_Loop_Invariant_Init
                                     --  or
                                     --    VC_Loop_Invariant_Preserv
      VC_Loop_Invariant_Init,
      VC_Loop_Invariant_Preserv,
      VC_Loop_Variant,
      VC_Assert,
      VC_Raise,

      --  VC_LSP_Kind - Liskov Substitution Principle

      VC_Weaker_Pre,                  --  pre weaker than classwide pre
      VC_Trivial_Weaker_Pre,          --  specialization of VC_Weaker_Pre when
                                      --  there is no classwide or inherited
                                      --  precondition
      VC_Stronger_Post,               --  post stronger than classwide post
      VC_Weaker_Classwide_Pre,        --  classwide pre weaker than inherited
      VC_Stronger_Classwide_Post);    --  classwide post stronger t/ inherited

   subtype VC_RTE_Kind is VC_Kind range
     VC_Division_Check .. VC_Task_Termination;

   subtype VC_Assert_Kind is  VC_Kind range
     VC_Initial_Condition .. VC_Raise;

   subtype VC_LSP_Kind is  VC_Kind range
     VC_Weaker_Pre .. VC_Stronger_Classwide_Post;

   type Flow_Tag_Kind is
     (Empty_Tag,
      --  Used when a tag is not specified

      Aliasing,
      --  Used for aliasing checks

      Dead_Code,
      --  Statement is never reached

      Default_Initialization_Missmatch,
      --  A type marked as Fully_Default_Initialized is not fully initialized

      Depends_Null,
      --  There is a missing dependency of the format "null => something"

      Depends_Missing,
      --  There is a variable missing from the RHS of a dependency

      Depends_Missing_Clause,
      --  There is an entire clause missing from the Depends contract

      Depends_Wrong,
      --  User provided an incorrect dependency

      Global_Missing,
      --  There is a variable missing from the Globals

      Global_Wrong,
      --  User provided a wrong global

      Export_Depends_On_Proof_In,
      --  A Proof_In variable has been used in the computation of an export

      Hidden_Unexposed_State,
      --  Some hidden state has not been exposed through a state abstraction

      Illegal_Update,
      --  Writing to a variable which is not a global Output

      Impossible_To_Initialize_State,
      --  A state abstraction cannot possibly be initialized

      Ineffective,
      --  Code has no effect on any exports

      Initializes_Wrong,
      --  User provided an incorrect Initializes contract

      Inout_Only_Read,
      --  Inout could have been an In

      Missing_Return,
      --  Function has a path without a return statement

      Not_Constant_After_Elaboration,
      --  Variable that has been marked as Constant_After_Elaboration
      --  can potentially be updated.

      Pragma_Elaborate_All_Needed,
      --  A remote state abstraction has been used during elaboration
      --  so a pragma Elaborate_All is needed.

      Side_Effects,
      --  A function with side-effects has been found

      Stable,
      --  Found a stable element inside a loop (this has not been
      --  implemented yet).

      Uninitialized,
      --  Use of an uninitialized variable

      Unused,
      --  A parameter has not been used

      Unused_Initial_Value,
      --  Initial value has not been used

      Non_Volatile_Function_With_Volatile_Effects,
      --  Non Volatile_Function refers to globals with volatile effects

      Volatile_Function_Without_Volatile_Effects,
      --  Function has been marked as volatile but has no volatile effects

      Reference_To_Non_CAE_Variable
      --  The precondition of a protected operation refers to a global variable
      --  that does not have Constant_After_Elaboration set.
     );

   --  Returns True if this kind of VC should be considered like an assertion
   --  when positioning the message to the left-most subexpression of the
   --  checked expression. For example, this is not true for VC_Precondition,
   --  which should be positioned on the location of the call.
   function Locate_On_First_Token (V : VC_Kind) return Boolean is
     (case V is when VC_RTE_Kind    => False,
                when VC_Assert_Kind => V /= VC_Precondition,
                when VC_LSP_Kind    => True);

   SPARK_Suffix : constant String := "spark";
   Flow_Suffix  : constant String := "flow";
   Proof_Suffix : constant String := "proof";

   --  A few labels are used to communicate information from gnat2why to
   --  gnatwhy3. Changes here should be propagated to the code of gnatwhy3.

   GP_Id_Marker         : constant String := "GP_Id:";
   GP_Pretty_Ada_Marker : constant String := "GP_Pretty_Ada:";
   GP_Reason_Marker     : constant String := "GP_Reason:";
   GP_Shape_Marker      : constant String := "GP_Shape:";
   GP_Sloc_Marker       : constant String := "GP_Sloc:";
   GP_Subp_Marker       : constant String := "GP_Subp:";

   --  A few labels are used in Why3 to identify variables and terms whose
   --  value is interesting in counter-examples.

   Model_Label          : constant String := "model";
   Model_Trace_Label    : constant String := "model_trace:";
   Model_Proj_Label     : constant String := "model_projected";
   Model_VC_Label       : constant String := "model_vc";
   Model_VC_Post_Label  : constant String := "model_vc_post";

   --  A meta that is used in Why3 to mark a function as projection.
   Model_Proj_Meta : constant String := "model_projection";

end VC_Kinds;
