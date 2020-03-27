------------------------------------------------------------------------------
--                                                                          --
--                            GNAT2WHY COMPONENTS                           --
--                                                                          --
--                    W H Y - G E N - H A R D C O D E D                     --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                     Copyright (C) 2020-2020, AdaCore                     --
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

with Einfo;                use Einfo;
with Gnat2Why.Util;        use Gnat2Why.Util;
with SPARK_Util;           use SPARK_Util;
with SPARK_Util.Hardcoded; use SPARK_Util.Hardcoded;
with Types;                use Types;
with Why.Ids;              use Why.Ids;
with Why.Sinfo;            use Why.Sinfo;

package Why.Gen.Hardcoded is

   procedure Emit_Hardcoded_Type_Declaration
     (P : W_Section_Id;
      E : Entity_Id)
   with
     Pre => Is_Type (E) and then Is_Hardcoded_Entity (E);
   --  Emit declaration of a Why3 type whose representative type is
   --  hardcoded.
   --  @param Theory the theory where the declaration will be emitted.
   --  @param Entity corresponding to the type declaration.

   function Transform_Hardcoded_Function_Call
     (Subp     : Entity_Id;
      Args     : W_Expr_Array;
      Domain   : EW_Domain;
      Ada_Node : Node_Id)
      return     W_Expr_Id
   with
     Pre => Is_Subprogram (Subp) and then Is_Hardcoded_Entity (Subp);
   --  Transform a hardcoded function call

end Why.Gen.Hardcoded;