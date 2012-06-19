package body Peers is 
   
   function Hash (Peer_Address: in Unbounded_String) return Hash_Type is
   begin
      return Ada.Strings.Hash(To_String(Peer_Address));
   end Hash;
   
   procedure Print_Peer (Peer : in Peer_Type) is
      use Ada.Text_IO;
   begin
      
      
      Put("Peer => "   & To_String(Peer.Peer) & ", ");
      case Peer.Status is
	 when Unregistered => 
	    Put ("Status => Unregistered");
	 when Registered => 
	    Put ("Status => Registered");
	 when others =>
	    raise PROGRAM_ERROR;
      end case; 
      
      Put("Address => " & To_String(Peer.Address) & ", ");
      Put("ChanneType => " & To_String(Peer.Channel) & ", ");
      Put("Port => " & To_String(Peer.Port));
      New_Line;
      
   end Print_Peer;
end Peers;
