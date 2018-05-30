package body Higher_Order.Fold with SPARK_Mode is

   package body Fold_Left_Acc is
      procedure Prove_Ind (A : Array_Type; X : Element_Out; I : Index_Type)
      with
        Ghost,
        Pre  => I in A'Range and then Ind_Prop (A, X, I),
        Post =>
          (if I /= A'Last then
                 Ind_Prop (A, F (A (I), X), I + 1));
      --  Axiom: Prove_Ind should be preserved when going to next index

      procedure Prove_Ind  (A : Array_Type; X : Element_Out; I : Index_Type) is
      null;

      function Fold (A : Array_Type; Init : Element_Out) return Acc_Array is
         Acc : Element_Out := Init;
      begin
         return R : Acc_Array (A'First .. A'Last) := (others => Init) do
            for I in A'Range loop
               R (I) := F (A (I), Acc);
               pragma Loop_Invariant
                 (for all K in A'First .. I =>
                    Ind_Prop (A, Prev_Val (R, K, Init), K)
                  and then
                    R (K) = F (A (K), Prev_Val (R, K, Init)));
               Acc := R (I);
               Prove_Ind (A, Prev_Val (R, I, Init), I);
            end loop;
         end return;
      end Fold;
   end Fold_Left_Acc;

   package body Fold_Left is
      function Fold (A : Array_Type; Init : Element_Out) return Element_Out is
      begin
         return R : Element_Out := Init do
            for I in A'Range loop
               R := F (A (I), R);
               pragma Loop_Invariant (R = Acc.Fold (A, Init) (I));
            end loop;
         end return;
      end Fold;
   end Fold_Left;

   package body Fold_Right_Acc is
      procedure Prove_Ind (A : Array_Type; X : Element_Out; I : Index_Type)
      with
        Ghost,
        Pre  => I in A'Range and then Ind_Prop (A, X, I),
        Post =>
          (if I /= A'First then
                 Ind_Prop (A, F (A (I), X), I - 1));
      --  Axiom: Prove_Ind should be preserved when going to previous index

      procedure Prove_Ind (A : Array_Type; X : Element_Out; I : Index_Type) is
      null;

      function Fold (A : Array_Type; Init : Element_Out) return Acc_Array is
         Acc : Element_Out := Init;
      begin
         return R : Acc_Array (A'First .. A'Last) := (others => Init) do
            for I in reverse A'Range loop
               R (I) := F (A (I), Acc);
               pragma Loop_Invariant
                 (for all K in I .. A'Last =>
                    Ind_Prop (A, Prev_Val (R, K, Init), K)
                  and then
                    R (K) = F (A (K), Prev_Val (R, K, Init)));
               Acc := R (I);
               Prove_Ind (A, Prev_Val (R, I, Init), I);
            end loop;
         end return;
      end Fold;
   end Fold_Right_Acc;

   package body Fold_Right is
      function Fold (A : Array_Type; Init : Element_Out) return Element_Out is
      begin
         return R : Element_Out := Init do
            for I in reverse A'Range loop
               R := F (A (I), R);
               pragma Loop_Invariant (R = Acc.Fold (A, Init) (I));
            end loop;
         end return;
      end Fold;
   end Fold_Right;

   package body Fold_2_Acc is
      function Fold (A : Array_Type; Init : Element_Out) return Acc_Array is
         procedure Prove_Ind_Row
           (A : Array_Type; X : Element_Out; I : Index_1)
         with
           Ghost,
           Pre  => I in A'Range (1) and then A'Length (2) > 0
           and then Ind_Prop (A, X, I, A'Last (2)),
           Post =>
             (if I /= A'Last (1) then
                    Ind_Prop (A, F (A (I, A'Last (2)), X), I + 1, A'First (2)));
         --  Axiom: Prove_Ind should be preserved when going to next row

         procedure Prove_Ind_Col
           (A : Array_Type; X : Element_Out; I : Index_1; J : Index_2)
         with
           Ghost,
           Pre  => I in A'Range (1) and then J in A'Range (2)
           and then Ind_Prop (A, X, I, J),
           Post =>
             (if J /= A'Last (2) then
                    Ind_Prop (A, F (A (I, J), X), I, J + 1));
         --  Axiom: Prove_Ind should be preserved when going to next column

         procedure Prove_Last (A : Array_Type; X : Element_Out) with
           Ghost,
           Pre  => A'Length (1) > 0 and then A'Length (2) > 0
           and then Ind_Prop (A, X, A'Last (1), A'Last (2)),
           Post => Final_Prop (A, F (A (A'Last (1), A'Last (2)), X));
         --  Axiom: Final_Prop should be provable at the last iteration from
         --  Ind_Prop.

         procedure Prove_Ind_Row
           (A : Array_Type; X : Element_Out; I : Index_1)
         is null;

         procedure Prove_Ind_Col
           (A : Array_Type; X : Element_Out; I : Index_1; J : Index_2)
         is null;

         procedure Prove_Last (A : Array_Type; X : Element_Out) is null;

         Acc : Element_Out := Init;
      begin
         return R : Acc_Array (A'Range (1), A'Range (2)) :=
           (others => (others => Init))
         do
            for I in A'Range (1) loop
               pragma Loop_Invariant (Acc = Prev_Val (R, I, A'First (2), Init));
               pragma Loop_Invariant
                 (if I > A'First (1) then
                      (for all K in A'First (1) .. I - 1 =>
                         (for all L in A'Range (2) =>
                              Ind_Prop (A, Prev_Val (R, K, L, Init), K, L)
                          and then
                          R (K, L) = F (A (K, L), Prev_Val (R, K, L, Init)))));
               for J in A'Range (2) loop
                  R (I, J) := F (A (I, J), Acc);
                  Acc := R (I, J);
                  pragma Loop_Invariant
                    (if I > A'First (1) then
                      (for all K in A'First (1) .. I - 1 =>
                         (for all L in A'Range (2) =>
                              Ind_Prop (A, Prev_Val (R, K, L, Init), K, L)
                          and then
                          R (K, L) = F (A (K, L), Prev_Val (R, K, L, Init)))));
                  pragma Loop_Invariant
                    (for all L in A'First (2) .. J =>
                         Ind_Prop (A, Prev_Val (R, I, L, Init), I, L)
                     and then
                     R (I, L) = F (A (I, L), Prev_Val (R, I, L, Init)));
                  pragma Loop_Invariant (Acc = R (I, J));
                  Prove_Ind_Col (A, Prev_Val (R, I, J, Init), I, J);
               end loop;
               Prove_Ind_Row (A, Prev_Val (R, I, A'Last (2), Init), I);
            end loop;
            Prove_Last (A, Prev_Val (R, A'Last (1), A'Last (2), Init));
         end return;
      end Fold;
   end Fold_2_Acc;

   package body Fold_2 is
      function Fold (A : Array_Type; Init : Element_Out) return Element_Out is
      begin
         return R : Element_Out := Init do
            if A'Length (2) > 0 then
               for I in A'Range (1) loop
                  pragma Loop_Invariant
                    (R = Acc.Prev_Val
                       (Acc.Fold (A, Init), I, A'First (2), Init));
                  for J in A'Range (2) loop
                     pragma Assert (Ind_Prop (A, R, I, J));
                     R := F (A (I, J), R);
                     pragma Loop_Invariant (R = Acc.Fold (A, Init) (I, J));
                  end loop;
               end loop;
            end if;
         end return;
      end Fold;
   end Fold_2;

end Higher_Order.Fold;
