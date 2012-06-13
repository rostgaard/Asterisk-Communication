with Ada.Text_IO;
with Ada.Strings.Unbounded.Text_IO;

package body Socket is
   use Ada.Text_IO;
   use Asterisk_AMI_IO;
   use Ada.Strings.Unbounded;
   
   Asterisk         : Asterisk_AMI_Type;
   
   Last_Action      : Action := None;
   
   Callback_Routine : Action_Callback_Routine_Table := 
     (Login => Login_Callback'access,
      others => null);
   
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
   
   
   -- Scaffolding
   procedure Get_Version is
   begin
      null;
      -- The following sequence will return a string with Asterisk version.
      -- Action: Command
      -- Command: core show version
      
      -- This can be very useful in detecting the different capabilities of 
      -- different versions of Asterisk - and perhaps FreeSwitch?
   end Get_Version;
   
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
	    -- Basically we have responses, or events
	    if Event_List(Event_List'First, Key)  = "Event" then
	       Put_Line("Got event");
	    elsif Event_List(Event_List'First, Key)  = "Response" then
	       Put_Line("Got Response");
	       -- Lookup the callback, and pass the value.
	       Callback_Routine(Last_Action)(Event_List);
	       -- Direct it to the callback associated with the previous commmand
	    end if;
	    
            --  for i in Event_List'First+1 .. Event_List'Last loop
            --     Put_Line 
	    --  	 ("Key: [" & To_String (Event_List (i, Key)) & "] " &
	    --  	    "Value: [" & To_String (Event_List (i, Value)) & "]");
            --  end loop;
            --  New_Line;
         end;
      end loop;
   end Start;
end Socket;
