------------------------------------------------------------------------------
--                                                                          --
--                            GNAT2WHY COMPONENTS                           --
--                                                                          --
--                       A L F A . D E F I N I T I O N                      --
--                                                                          --
--                                  S p e c                                 --
--                                                                          --
--                        Copyright (C) 2011, AdaCore                       --
--                                                                          --
-- gnat2why is  free  software;  you can redistribute  it and/or  modify it --
-- under terms of the  GNU General Public License as published  by the Free --
-- Software  Foundation;  either version 3,  or (at your option)  any later --
-- version.  gnat2why is distributed  in the hope that  it will be  useful, --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of  MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public --
-- License for  more details.  You should have  received  a copy of the GNU --
-- General  Public License  distributed with  gnat2why;  see file COPYING3. --
-- If not,  go to  http://www.gnu.org/licenses  for a complete  copy of the --
-- license.                                                                 --
--                                                                          --
-- gnat2why is maintained by AdaCore (http://www.adacore.com)               --
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
