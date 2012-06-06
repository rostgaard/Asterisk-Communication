with Ada.Strings.Unbounded;
package Event_Parser is
   use Ada.Strings.Unbounded;
   type KeyValue is (Key, Value);
   type EventList is array (Integer range <>, KeyValue range <>)
     of Unbounded_String;

   function parse (EventText : String) return EventList;

private
   function CountLines (Event : String) return Natural;

end Event_Parser;
