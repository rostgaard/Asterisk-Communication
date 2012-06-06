with Ada.Strings.Maps;
with Ada.Strings.Maps.Constants;
package body Thomas_Util is

   procedure Try_Parse (Item : in Unbounded_String;
                        Number : out Integer; Is_Valid : out Boolean) is
      use Ada.Strings.Maps;
   begin
      Is_Valid := Is_Subset (Ada.Strings.Maps.To_Set (To_String (Item))
                             , Constants.Decimal_Digit_Set);
      if Is_Valid then
         Number := Integer'Value (Ada.Strings.Unbounded.To_String (Item));
      else
         Number := 0;
      end if;

   exception
      when others =>
         Is_Valid := False;
         Number := 0;

   end Try_Parse;

end Thomas_Util;
