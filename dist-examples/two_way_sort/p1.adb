package body P1 is
   procedure Swap (A : in out Arr; I, J : Index) with
     Pre  => I in A'Range
               and then J in A'Range,
     Post => A(I) = A(J)'Old
               and then A(J) = A(I)'Old
               and then (for all K in A'Range =>
                           (if K /= I and K /= J then A(K) = A'Old(K)));

   procedure Swap (A : in out Arr; I, J : Index) is
      T : constant Boolean := A(I);
   begin
      A(I) := A(J);
      A(J) := T;
   end Swap;

   procedure Two_Way_Sort (A : in out Arr) is
      I : Index;
      J : Index;
   begin
      if A'Last < A'First then
         return;
      end if;

      I := A'First;
      J := A'Last;
      while I <= J loop
         pragma Assert (I in A'Range
                          and then J in A'Range
                          and then I <= J);
         if not A(I) then
            I := I+1;
         elsif A(J) then
            J := J-1;
         else
            Swap (A, I, J);
            I := I+1;
            J := J-1;
         end if;
      end loop;
   end Two_Way_Sort;
end P1;
