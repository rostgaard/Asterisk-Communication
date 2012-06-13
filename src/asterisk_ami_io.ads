with GNAT.Sockets;   use GNAT.Sockets;
package Asterisk_AMI_IO is
   function Read_Line (channel : Stream_Access) return String;
   --  reads a line (seperated by linefeed LF)

   function Read_Package (channel : Stream_Access) return String;
   --  Returns a package.
end Asterisk_AMI_IO;
