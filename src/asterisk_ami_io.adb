with Ada.Strings.Unbounded;
with Ada.Streams;
with Ada.Strings.Unbounded.Text_IO;
-- Provides the low-level I/O routines for communicating with Asterisk AMI
package body Asterisk_AMI_IO is
   function Read_Line (channel : Stream_Access) return String is
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
   end Read_Line;

   function Read_Package (channel : Stream_Access) return String is
      use Ada.Strings.Unbounded;
      newlineChar : constant String := (1 => ASCII.CR, 2 => ASCII.LF);
      buffer : Unbounded_String;
   begin
      Collecting_Package :
      loop
         declare
            line : constant String := Read_Line (Channel);
         begin
            exit Collecting_Package when line = newlineChar;
            Append (buffer, line);
         end;

      end loop Collecting_Package;
      return To_String (buffer);
   end Read_Package;
   
end Asterisk_AMI_IO;
