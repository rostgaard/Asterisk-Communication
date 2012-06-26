with Ada.Text_IO;
with Ada.Strings.Unbounded.Text_IO;
with Ada.Calendar;

with Peers; use Peers;

package body Socket is
   use Ada.Text_IO;
   use Asterisk_AMI_IO;
   use Ada.Strings.Unbounded;
   
   Asterisk         : Asterisk_AMI_Type;
   Last_Action      : Action := None;
   Peer_List        : Peer_List_Type.Map;
   
   -- Callback maps
   Callback_Routine : Action_Callback_Routine_Table := 
     (Login  => Login_Callback'access,
      others => null);
   
   Event_Callback_Routine : Event_Callback_Routine_Table := 
     (Dial       => Dial_Callback'access,
      PeerStatus => PeerStatus_Callback'access,
      others     => null);
   
   
   procedure PeerStatus_Callback(Event_List : in Event_List_Type) is
      Peer    : Peer_Type;
      Map_Key : Unbounded_String;
   begin
      Put_Line("Peer status update");
      for i in Event_List'First+1 .. Event_List'Last loop
	 if To_String (Event_List (i, Key)) = "Peer" then
	    Peer.Peer := Event_List (i, Value);
	    
	 elsif To_String (Event_List (i, Key)) = "ChannelType" then
	    Peer.Channel := Event_List (i, Value);
	    
	 elsif To_String (Event_List (i, Key)) = "Address" then
	    Peer.Address := Event_List (i, Value);
	    
	 elsif To_String (Event_List (i, Key)) = "Port" then
	    Peer.Port := Event_List (i, Value);
	    
	 elsif To_String (Event_List (i, Key)) = "PeerStatus" then
	   if To_String(Event_List (i, Value)) = "Unregistered"  then
	    Peer.Status := Unregistered;
	   elsif To_String(Event_List (i, Value)) = "Registered"  then
	      Peer.Status := Registered;
	   else
	      Put_Line("SIP client to unknown state: " & 
			 To_String(Event_List (i, Value)));
	   end if;
	 end if;
      end loop;
      
      -- Update the timestamp
      Peer.Last_Seen := Ada.Calendar.Clock;
      
      -- Update the peer list
      if Peer_List_Type.Contains (Container => Peer_List,
				  Key       => Map_Key) then
	 Peer_List_Type.Replace(Container => Peer_List,
				Key       => Map_Key,
				New_Item  => Peer);
      else
	 Peer_List_Type.Insert(Container => Peer_List,
				Key       => Map_Key,
				New_Item  => Peer);
      end if;
      
      Print_Peer(Peer_List_Type.Element(Container => Peer_List,
					Key       => Map_Key));
      
   end PeerStatus_Callback;
   
   procedure Login_Callback(Event_List : in Event_List_Type) is
   begin
      -- Now we play a game called; Find the message!
      for i in Event_List'First+1 .. Event_List'Last loop
	 if To_String (Event_List (i, Key)) = "Message" and 
	   then To_String (Event_List (i, Value)) = 
	      "Authentication accepted" then
	      Asterisk.Logged_In := True;
	 end if;
      end loop;
   end Login_Callback;
   
   --  Event: Dial
   --  Privilege: call,all
   --  SubEvent: Begin
   --  Channel: SIP/softphone2-0000000a
   --  Destination: SIP/softphone1-0000000b
   --  CallerIDNum: softphone2
   --  CallerIDName: <unknown>
   --  UniqueID: 1340097427.10
   --  DestUniqueID: 1340097427.11
   --  Dialstring: softphone1
   procedure Dial_Callback(Event_List : in Event_List_Type) is
   begin
      -- Now we play a game called; Find the message!
      for i in Event_List'First+1 .. Event_List'Last loop
	 if To_String (Event_List (i, Key)) = "Message" and 
	   then To_String (Event_List (i, Value)) = 
	      "Authentication accepted" then
	      Asterisk.Logged_In := True;
	 end if;
      end loop;
   end Dial_Callback;
   
   -- Lists the SIP peers. Returns a PeerEntry event for each
   -- SIP peer, and a PeerlistComplete event upon completetion
   --  Event: PeerEntry
   --  Channeltype: SIP
   --  ObjectName: softphone2
   --  ChanObjectType: peer
   --  IPaddress: 90.184.227.68
   --  IPport: 59028
   --  Dynamic: yes
   --  Natsupport: yes
   --  VideoSupport: no
   --  TextSupport: no
   --  ACL: no
   --  Status: Unmonitored
   --  RealtimeDevice: no
   --    
   --  Event: PeerlistComplete
   --  EventList: Complete
   --  ListItems: 2
   procedure SIPPeers_Callback is
   begin
      Put_line ("Not implemented");
      raise NOT_IMPLEMENTED;
   end SIPPeers_Callback;
   

   
   --  Event: Newstate
   --  Privilege: call,all
   --  Channel: SIP/softphone1-0000000b
   --  ChannelState: 5
   --  ChannelStateDesc: Ringing
   --  CallerIDNum: 100
   --  CallerIDName: 
   --  Uniqueid: 1340097427.11
   procedure NewState_Callback is
   begin
      Put_line ("Not implemented");
      raise PROGRAM_ERROR;
   end NewState_Callback;
   
   
   --  Event: Bridge
   --  Privilege: call,all
   --  Bridgestate: Link
   --  Bridgetype: core
   --  Channel1: SIP/softphone2-0000000a
   --  Channel2: SIP/softphone1-0000000b
   --  Uniqueid1: 1340097427.10
   --  Uniqueid2: 1340097427.11
   --  CallerID1: softphone2
   --  CallerID2: 100
   procedure Bridge_Callback is
   begin
      Put_line ("Not implemented");
      raise PROGRAM_ERROR;
   end Bridge_Callback;
   
   --  Event: Unlink
   --  Privilege: call,all
   --  Channel1: SIP/softphone2-0000000a
   --  Channel2: SIP/softphone1-0000000b
   --  Uniqueid1: 1340097427.10
   --  Uniqueid2: 1340097427.11
   --  CallerID1: softphone2
   --  CallerID2: 100
   procedure Unlink_Callback (Event_List : in Event_List_Type) is
   begin
      Put_line ("Not implemented");
      raise PROGRAM_ERROR;
   end Unlink_Callback;
   
   
   --  Event: Hangup
   --  Privilege: call,all
   --  Channel: SIP/softphone1-0000000b
   --  Uniqueid: 1340097427.11
   --  CallerIDNum: 100
   --  CallerIDName: <unknown>
   --  Cause: 16
   --  Cause-txt: Normal Clearing
   procedure Hangup_Callback (Event_List : in Event_List_Type) is
   begin
      Put_line ("Not implemented");
      raise PROGRAM_ERROR;
   end Hangup_Callback;
   
   -- Scaffolding
   procedure Get_Version is
   begin
      null;
      -- The following sequence will return a string with Asterisk version.
      -- Action: Command
      -- Command: core show version
      --
      -- OR!
      -- Action: CoreSettings
      -- 
      -- This can be very useful in detecting the different capabilities of 
      -- different versions of Asterisk - and perhaps even FreeSwitch?
   end Get_Version;
   
   -- Lists agents
   procedure Agents is
   begin
      Put_line ("Not implemented");
      raise PROGRAM_ERROR;
   end Agents;
   
   procedure Login (AMI      : in Asterisk_AMI_Type;
		    Username : in String; 
		    Secret   : in String; 
		    Callback : in Callback_Type := null;
		    Persist  : in boolean       := True) is
   begin
      String'Write 
	(AMI.Channel, 
	 Action_String & Login_String & Line_Termination_String &
	   "Username: " & Username & Line_Termination_String &
	   "Secret: " & Secret & Line_Termination_String &
	   Line_Termination_String);
      
      -- Update the table if we were asked to used this as standard callback
      if Callback /= null and then Persist then
	 Callback_Routine(Login) := Callback;
      end if;
      
      Last_Action := Login;
   end Login;
   
   procedure Logoff (AMI      : in     Asterisk_AMI_Type;
		     Callback : access Callback_Type := null) is
   begin
      String'Write 
	(AMI.Channel, 
	 Action_String & Logoff_String & Line_Termination_String &
	   Line_Termination_String);
      Last_Action := Logoff;
   end Logoff;
   
   
   -- TODO: comment
   procedure Ping (Asterisk_AMI : in Asterisk_AMI_Type) is
   begin
      String'Write 
	(Asterisk_AMI.Channel, 
	 Action_String & Ping_String & Line_Termination_String &
	   Line_Termination_String);
      Last_Action := Ping;
   end Ping;
   

   -- TODO: Write up and architecture that uses a queue to send requests, or blocks
   procedure Start (channel : Stream_Access) is
      --  task type Socket_Reader is
      --     entry Start (channel : Stream_Access);
      --  end socket_Reader;

      --  task body Socket_Reader is
      --     channel : Stream_Access;
      --  begin
      --     accept Start (channel : Stream_Access) do
      --        socket_Reader.channel := Start.channel;
      --     end Start;
      --     loop
      --        declare
      --           item : Ada.Strings.Unbounded.Unbounded_String;
      --        begin
      --  	       Put_Line ("Socket_reader got line:");
      --           Ada.Strings.Unbounded.Text_IO.Get_Line (item);
      --           String'Write (channel, Ada.Strings.Unbounded.To_String (item)
      --                         & Line_Termination_String);
      --        end;
      --     end loop;
      --  end socket_Reader;
      --  reader : access socket_Reader;
   begin
      Asterisk := (Greeting  => new String'(Read_Line (channel)),
		   Channel   => Channel,
		   Logged_In => False);
      
      -- Send login
      Login(AMI      => Asterisk,
	    Username => "test",
	    Secret   => "test");
      
      --      Ada.Text_IO.Put ("login: " & readPackage (channel));
      --  Reading login confirmation.

      --reader := new socket_Reader;
      --      reader.Start (channel);

      loop
         declare
            use Event_Parser;
            Event : constant String := Read_Package (channel);
            Event_List : constant Event_List_Type := parse (Event);
         begin
	    
            --  for i in Event_List'First .. Event_List'Last loop
            --     Put_Line 
	    --  	 ("Key: [" & To_String (Event_List (i, Key)) & "] " &
	    --  	    "Value: [" & To_String (Event_List (i, Value)) & "]");
            --  end loop;
            --  New_Line;
	    
	    -- Basically we have responses, or events
	    if Event_List(Event_List'First, Key)  = "Event" then
	       
	       if To_String (Event_List (Event_List'First, Value)) = "PeerStatus" then 
	    	  Event_Callback_Routine(PeerStatus)(Event_List);
	       end if;
	    elsif Event_List(Event_List'First, Key)  = "Response" then
	       -- Lookup the callback, and pass the value.
	       Callback_Routine(Last_Action)(Event_List);
	       -- Direct it to the callback associated with the previous commmand
	    end if;
	 exception
	    when others =>
	       Put_Line("Socket.Start.declare: ");
	 end;
      end loop;
   exception
      when others =>
	 Put_Line("Socket.Start: ");
   end Start;
   
end Socket;
