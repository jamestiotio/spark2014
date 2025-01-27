procedure Main (W : Natural;
                X : Natural;
                Y : out Integer;
                Z : out Integer) with
  Pre => W < Integer'Last,
  Depends => (Y => X, Z => W),
  Post => Y = X and Z = W + 1
  --  Contract is correct
is
   --  Use of simple expressions ensure dependency relations
   --  are not (quite) trivial.
   type T (D : Integer := W) is record
      C : Integer := D + 1; --  ??? Overflow check should be prevented by precondition
   end record;

   A : T (D => X - 1);
   B : T;

   --  The extended return statement exercises another path in GNATProve
   function F return T
     with Post => F'Result.C = W + 1
   is
   begin
      return Result : T do
        null;
      end return;
   end F;
begin
   Y := A.C;
   Z := B.C;
   pragma Assert (F.C = W + 1);
end;
