with Ada.Text_IO;
with Ada.Containers.Hashed_Maps;  use Ada.Containers;
with Ada.Strings.Hash;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Calendar;

-- TODO: Make this into a generic that uses protected types for accessing the map.
package Peers is
   type SIP_Peer_Status_Type is (Unregistered, Registered);
   
   type Peer_Type is
      record
	 Defined   : Boolean := False;
	 Status    : SIP_Peer_Status_Type := Unregistered;
	 Channel   : Unbounded_String;
	 Peer      : Unbounded_String;
	 Port      : Unbounded_String;
	 Address   : Unbounded_String;
	 Last_Seen : Ada.Calendar.Time := Ada.Calendar.Clock;
      end record;
   
   function Hash (Peer_Address: in Unbounded_String) return Hash_Type;
      
   package Peer_List_Type is new Ada.Containers.Hashed_Maps
     (Key_Type => Unbounded_String,
      Element_Type => Peer_type,
      Hash => Hash,
      Equivalent_Keys => "=");
   
  
   procedure Print_Peer (Peer : in Peer_Type);
end Peers;
