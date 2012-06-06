with GNAT.Sockets;   use GNAT.Sockets;
package socket is
   procedure start (channel : Stream_Access);
   --  Her starter det enlige socket program.
private
   function readLine (channel : Stream_Access) return String;
   --  reads a line (seperated by linefeed LF)

   function readPackage (channel : Stream_Access) return String;
   --  Returns a package.
end socket;
