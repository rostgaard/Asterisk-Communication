with Ada.Strings.Unbounded;
with Ada.Streams;
with Ada.Text_IO;
with Ada.Strings.Unbounded.Text_IO;
with Event_Parser;
--  with Ada.Containers;
--  with Ada.Containers.Ordered_Maps;
package body socket is

   function readLine (channel : Stream_Access) return String is
      use Ada.Strings.Unbounded;
      use type Ada.Streams.Stream_Element_Count;

      Offset : Ada.Streams.Stream_Element_Offset;
      Data : Ada.Streams.Stream_Element_Array (1 .. 1);
      buffer : Unbounded_String;
   begin
      --        Ada.Text_IO.Put_Line ("-Readline Called");
      Read_Next_Char :
      loop
         Ada.Streams.Read (channel.all, Data, Offset);
         exit Read_Next_Char when Offset <= 0;

         --           for I in 1 .. Offset loop
         Append (buffer, Character'Val (Data (1)));
         exit Read_Next_Char when Character'Val (Data (1)) = ASCII.LF;
         --           end loop;
      end loop Read_Next_Char;
      return To_String (buffer);
   end readLine;

   function readPackage (channel : Stream_Access) return String is
      use Ada.Strings.Unbounded;
      newlineChar : constant String := (1 => ASCII.CR, 2 => ASCII.LF);
      buffer : Unbounded_String;
   begin
      Collecting_Package :
      loop
         declare
            line : constant String := readLine (channel);
         begin
            exit Collecting_Package when line = newlineChar;
            Append (buffer, line);
         end;

      end loop Collecting_Package;
      return To_String (buffer);
   end readPackage;

   procedure start (channel : Stream_Access) is
      newlineChar : constant String := (1 => ASCII.CR, 2 => ASCII.LF);

      task type socket_Reader is
         entry Start (channel : Stream_Access);
      end socket_Reader;

      task body socket_Reader is
         channel : Stream_Access;
      begin
         accept Start (channel : Stream_Access) do
            socket_Reader.channel := Start.channel;
         end Start;

         Ada.Text_IO.Put_Line ("-Task started - DELETE ME!!");

         loop
            declare
               item : Ada.Strings.Unbounded.Unbounded_String;
            begin
               Ada.Strings.Unbounded.Text_IO.Get_Line (item);
               String'Write (channel, Ada.Strings.Unbounded.To_String (item)
                             & newlineChar);
            end;
         end loop;
      end socket_Reader;

      reader : access socket_Reader;
   begin
      Ada.Text_IO.Put_Line ("Welcome line: " & readLine (channel));
      --  Reading the welcome line;

      --  Login
      declare
         username : constant String := "admin";
         Secret : constant String := "amp111";
      begin
         String'Write (channel, "Action: Login" & newlineChar &
                       "Username: " & username & newlineChar &
                       "Secret: " & Secret & newlineChar &
                       newlineChar);
      end;

      Ada.Text_IO.Put ("login: " & readPackage (channel));
      --  Reading login confirmation.

      reader := new socket_Reader;
      reader.Start (channel);

      loop
         declare
            use Event_Parser;
            use Ada.Strings.Unbounded;
            Event : constant String := readPackage (channel);
            KeyValueList : constant EventList := parse (Event);
         begin
--              Ada.Text_IO.Put_Line ("[" & Event & "]" & newlineChar);
            for i in KeyValueList'Range loop
               Ada.Text_IO.Put_Line (
                      "Key: [" & To_String (KeyValueList (i, Key)) & "] " &
                      "Value: [" & To_String (KeyValueList (i, Value)) & "]");
            end loop;
            Ada.Text_IO.New_Line;
         end;
      end loop;

   end start;
end socket;
