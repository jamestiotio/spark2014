package non_tagged_parent_14 is

--  No change to parent.

   type Pair is private;

   -- Sums the component values of a Pair.
   function Sum (Value : in Pair) return Integer;

private

   type Pair is
      record
         Value_One : Integer;
         Value_Two : Integer;
      end record;

    Inc_Value : constant Integer := 1;

end non_tagged_parent_14;

