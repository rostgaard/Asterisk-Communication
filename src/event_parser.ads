with Ada.Strings.Unbounded;
package Event_Parser is
   use Ada.Strings.Unbounded;
   type KeyValue is (Key, Value);
   type Event_List_Type is array (Integer range <>, KeyValue range <>)
     of Unbounded_String;

   function parse (Event_Text : String) return Event_List_Type;

private
   function CountLines (Event : String) return Natural;

end Event_Parser;
