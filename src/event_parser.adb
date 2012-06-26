with Ada.Text_IO;
package body Event_Parser is

   function CountLines (Event : String) return Natural is
      count : Integer := 0;
   begin
      for i in Event'Range loop
         if Event (i) = ASCII.LF then
            count := count + 1;
         end if;
      end loop;
      return count;
   end CountLines;

   function parse (Event_Text : String) return Event_List_Type is
      EventSize : Integer;
   begin
      EventSize := CountLines (Event_Text);
      declare
         List : Event_List_Type (1 .. EventSize, KeyValue'Range);
         List_Index : Positive := 1;
         Text_Index : Positive := 1;

      begin
--           Text_Index := 1;
--           List_Index := 1;
         loop
            exit when Event_Text'Last < Text_Index;
            declare
               Current_Text : Unbounded_String := To_Unbounded_String ("");
               Key_Seperator : constant Character := ASCII.COLON;
            begin
               ExtractKey :
               loop
                  if Event_Text (Text_Index) = Key_Seperator then
                     List (List_Index, Key) := Current_Text;
                     Text_Index := Text_Index + 2;
                     --  +2 because it needs to skip a color and a space
                     exit ExtractKey;
                  else
                     Append (Current_Text,
                             Event_Text (Text_Index));
                     Text_Index := Text_Index + 1;
                  end if;
               end loop ExtractKey;

            end;
            declare
               Current_Text : Unbounded_String;
               Value_Seperator : constant Character := ASCII.LF;
            begin
               ExtractValue :
               loop
                  if Event_Text (Text_Index) = Value_Seperator then
                     List (List_Index, Value) := Current_Text;
                     List_Index := List_Index + 1;
                     Text_Index := Text_Index + 1;
                     exit ExtractValue;
                  elsif Event_Text (Text_Index) = ASCII.CR then
                     --  Nothing
                     Text_Index := Text_Index + 1;
                  else
                     Append (Current_Text,
                             Event_Text (Text_Index));
                     Text_Index := Text_Index + 1;
                  end if;

               end loop ExtractValue;
            end;
         end loop;
         return List;
      end;
   exception
      when others =>
	 Ada.Text_IO.Put_Line("Event_Parser.Parse");
   end parse;
end Event_Parser;
