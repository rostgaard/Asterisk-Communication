with Ada.Text_IO;
with Ada.Strings.Unbounded.Text_IO;
with Event_Parser;

package body Socket is
   use Ada.Text_IO;
   use Asterisk_AMI_IO;
   
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
   
   procedure Login (AMI      : in     Asterisk_AMI_Type;
		    Username : in     String; 
		    Secret   : in     String; 
		    Callback : access Callback_Type'Class := null;
		    Persist  : in     boolean             := True) is
   begin
      String'Write 
	(AMI.Channel, 
	 Action_String & Login_String & Line_Termination_String &
	   "Username: " & Username & Line_Termination_String &
	   "Secret: " & Secret & Line_Termination_String &
	   Line_Termination_String);
   end Login;
   
   procedure Logoff (AMI      : in     Asterisk_AMI_Type;
		     Callback : access Callback_Type'Class := null) is
   begin
      String'Write 
	(AMI.Channel, 
	 Action_String & Logoff_String & Line_Termination_String &
	   Line_Termination_String);
   end Logoff;
   
   
   -- TODO
   procedure Ping (Asterisk_AMI : in Asterisk_AMI_Type) is
   begin
      String'Write 
	(Asterisk_AMI.Channel, 
	 Action_String & Ping_String & Line_Termination_String &
	   Line_Termination_String);
   end Ping;
   
   
   procedure Start (channel : Stream_Access) is
      Asterisk : Asterisk_AMI_Type := (Greeting  => null,
				       Channel   => Channel,
				       Logged_In => False);
      
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
      Ada.Text_IO.Put_Line ("Welcome line: " & Read_Line (channel));
      --  Reading the welcome line;
      
      Login(Asterisk,"test","test");
      Ping(Asterisk);
	 
      --      Ada.Text_IO.Put ("login: " & readPackage (channel));
      --  Reading login confirmation.

      --reader := new socket_Reader;
      --      reader.Start (channel);

      loop
         declare
            use Event_Parser;
            use Ada.Strings.Unbounded;
            Event : constant String := Read_Package (channel);
            KeyValueList : constant EventList := parse (Event);
         begin
	    -- Basically we have responses, or events
	    if KeyValueList(KeyValueList'First, Key)  = "Event" then
	       Put_Line("Got event");
	    elsif KeyValueList(KeyValueList'First, Key)  = "Response" then
	       Put_Line("Got Response");
	       -- Direct it to the callback associated with the previous commmand
	    end if;
	      
	    
	    
            for i in KeyValueList'First+1 .. KeyValueList'Last loop
               Put_Line 
		 ("Key: [" & To_String (KeyValueList (i, Key)) & "] " &
		    "Value: [" & To_String (KeyValueList (i, Value)) & "]");
	       
	       
	       
            end loop;
            New_Line;
         end;
      end loop;

   end Start;
end Socket;
