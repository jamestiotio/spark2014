------------------------------------------------------------------------------
--                                                                          --
--                            GNAT2WHY COMPONENTS                           --
--                                                                          --
--                        W H Y - G E N - E N U M S                         --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                       Copyright (C) 2010-2011, AdaCore                   --
--                                                                          --
-- gnat2why is  free  software;  you can redistribute it and/or modify it   --
-- under terms of the  GNU General Public License as published  by the Free --
-- Software Foundation;  either version  2,  or  (at your option) any later --
-- version. gnat2why is distributed in the hope that it will  be  useful,   --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHAN-  --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public --
-- License  for more details. You  should  have  received a copy of the GNU --
-- General Public License  distributed with GNAT; see file COPYING. If not, --
-- write to the Free Software Foundation,  51 Franklin Street, Fifth Floor, --
-- Boston,                                                                  --
--                                                                          --
-- gnat2why is maintained by AdaCore (http://www.adacore.com)               --
--                                                                          --
------------------------------------------------------------------------------

with String_Utils;  use String_Utils;
with Why.Ids;       use Why.Ids;

package Why.Gen.Enums is

   --  This package provides ways to declare enumeration types

   procedure Declare_Abstract_Boolean_Type (File : W_File_Id; Name : String);
   --  This creates a new boolean type with the given name; it generates
   --  an abstract type for it, conversions from/to int and from/to bool
   --  and the corresponding axioms.

   procedure Declare_Ada_Enum_Type
     (File         : W_File_Id;
      Name         : String;
      Constructors : String_Lists.List);
   --  This creates a new enumeration type with the given name and given
   --  constructor names. It generates the type definition itself, but also
   --  conversions from/to int and the corresponding axioms.
   --  There are two special cases:
   --  * for a type of name "boolean", the function does nothing
   --  * if the list of constructors is empty, no conversion to integers is
   --    generated

end Why.Gen.Enums;
