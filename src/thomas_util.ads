with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Thomas_Util is
   procedure Try_Parse (Item : in Unbounded_String;
                        Number : out Integer; Is_Valid : out Boolean);
   --  Tjekker om Item er et hel tal, og s�tter v�rdien p� Numbers hvis det er
   --   og s�tter Is_Valid, alt efter om det er et tal eller ej.

end Thomas_Util;
