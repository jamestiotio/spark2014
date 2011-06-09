------------------------------------------------------------------------------
--                                                                          --
--                         GNAT BACK-END COMPONENTS                         --
--                                                                          --
--                       A L F A . D E F I N I T I O N                      --
--                                                                          --
--                                  S p e c                                 --
--                                                                          --
--             Copyright (C) 2011, Free Software Foundation, Inc.           --
--                                                                          --
-- GNAT is free software;  you can  redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion.  GNAT is distributed in the hope that it will be useful, but WITH- --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License --
-- for  more details.  You should have  received  a copy of the GNU General --
-- Public License  distributed with GNAT; see file COPYING3.  If not, go to --
-- http://www.gnu.org/licenses for a complete copy of the license.          --
--                                                                          --
-- GNAT was originally developed  by the GNAT team at  New York University. --
-- Extensive contributions were provided by Ada Core Technologies Inc.      --
--                                                                          --
------------------------------------------------------------------------------

with Sem_Util; use Sem_Util;

with Why.Inter; use Why.Inter;

package Alfa.Definition is

   type Unique_Entity_Id is new Entity_Id;
   --  Type of unique entities shared between different views, in contrast to
   --  GNAT entities which may be different between views in GNAT AST:
   --  * package spec and body have different entities;
   --  * subprogram declaration, subprogram stub and subprogram body all have
   --    a different entity;
   --  * private view and full view have a different entity.

   function Unique (E : Entity_Id) return Unique_Entity_Id is
      (Unique_Entity_Id (Unique_Entity (E)));

   type Violation_Kind is (

      --  NYI: Not Yet Implemented
      --  These constructs should be supported in Alfa one day

      NYI_Aggregate,        --  aggregate
      NYI_Arith_Operation,  --  arithmetic operation
      NYI_Array_Subtype,    --  array subtype
      NYI_Attribute,        --  attribute
      NYI_Block_Statement,  --  block declare statement
      NYI_Concatenation,    --  concatenation
      NYI_Conversion,       --  conversion
      NYI_Container,        --  formal containers
      NYI_Discriminant,     --  discriminant record
      NYI_Dispatch,         --  dispatching
      NYI_Expr_With_Action, --  expression with action
      NYI_Float,            --  float
      NYI_Generic,          --  generics
      NYI_Impure_Function,  --  impure functions
      NYI_Logic_Function,   --  logic functions
      NYI_Modular,          --  modular type and subtype
      NYI_Non_Static_Range, --  non static range in type
      NYI_Old_Attribute,    --  'Old attribute
      NYI_Pragma,           --  pragma
      NYI_Qualification,    --  qualification
      NYI_Rep_Clause,       --  representation clause
      NYI_Slice,            --  array slice
      NYI_Standard_Lib,     --  standard library
      NYI_String_Literal,   --  string literal
      NYI_Tagged,           --  tagged type
      NYI_XXX,              --  all other cases

      --  NIR: Not In Roadmap
      --  These constructs are not in Alfa in the foreseeable future

      NIR_Access,           --  access types
      NIR_Ambiguous_Expr,   --  ambiguous expr
      NIR_Dealloc,          --  deallocation
      NIR_Dynamic_Alloc,    --  dynamic allocation
      NIR_Exception,        --  exception
      NIR_Indirect_Call,    --  indirect call
      NIR_Tasking,          --  tasks and protected objects
      NIR_Unchecked_Conv,   --  unchecked conversion
      NIR_XXX);             --  all other cases

   subtype Not_Yet_Implemented is
     Violation_Kind range NYI_Aggregate .. NYI_XXX;
   subtype Known_Not_Yet_Implemented is Not_Yet_Implemented range
     Not_Yet_Implemented'First ..
       Not_Yet_Implemented'Val
         (Not_Yet_Implemented'Pos (Not_Yet_Implemented'Last) - 1);
   subtype Not_In_Roadmap is
     Violation_Kind range NIR_Access .. NIR_XXX;
   subtype Known_Not_In_Roadmap is Not_In_Roadmap range
     Not_In_Roadmap'First ..
       Not_In_Roadmap'Val
         (Not_In_Roadmap'Pos (Not_In_Roadmap'Last) - 1);

   procedure Mark_Compilation_Unit (N : Node_Id);
   --  Put marks on a compilation unit. This should be called after all
   --  compilation units on which it depends have been marked.

   procedure Mark_Standard_Package;
   --  Put marks on package Standard

   function Standard_Is_In_Alfa (Id : Unique_Entity_Id) return Boolean;
   --  Return whether standard entity Id is in Alfa or not

   procedure Create_Alfa_Output_File (Filename : String);
   --  Create the file in which to generate output about subprogram in/out of
   --  the Alfa subset.

   procedure Close_Alfa_Output_File;
   --  Close the file created by Create_Alfa_Output_File

   type Alfa_Decl is
     (Alfa_Object,
      Alfa_Type,
      Non_Alfa_Object,  --  Entities, not declarations
      Non_Alfa_Type,    --  Entities, not declarations
      Alfa_Subprogram_Spec,
      Alfa_Subprogram_Body);

   type Alfa_Decls is array (Alfa_Decl) of List_Of_Nodes.List;

   Decls_In_Spec : Alfa_Decls;
   Decls_In_Body : Alfa_Decls;

end Alfa.Definition;
