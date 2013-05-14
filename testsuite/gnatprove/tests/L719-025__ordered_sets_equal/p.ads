with Ada.Containers.Formal_Ordered_Sets;
with Ada.Containers; use Ada.Containers;
package P is

   type Element_Type is new Integer range 1 .. 100;

   function My_Eq (I1 : Element_Type; I2 : Element_Type) return Boolean is
     (I1 = I2);

   function My_Lt (I1 : Element_Type; I2 : Element_Type) return Boolean is
     (I1 < I2);

   package My_Sets is new Ada.Containers.Formal_Ordered_Sets
     (Element_Type, "<" => My_Lt, "=" => My_Eq);
   use My_Sets;

   procedure My_Include (L : in out Set; E : Element_Type) with
     Pre => Contains (L, E) or Length (L) < L.Capacity,
     Post => Element (L, Find (L, E)) = E;

   procedure Identity (L : in out Set; E : Element_Type) with
     Pre => Length (L) < L.Capacity and not Contains (L, E),
     Post => Strict_Equal (L, L'Old);

   procedure Nearly_Identity (L : in out Set; Cu : in out Cursor) with
     Pre => Has_Element (L, Cu),
     Post => L = L'Old and
     (if Cu = Cu'Old then Strict_Equal (L, L'Old));

end P;
