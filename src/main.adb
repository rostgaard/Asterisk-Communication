-------------------------------------------------------------------------------
--                                                                           --
--                                  socket                                   --
--                                                                           --
--                      Copyright (C) 2012-, Thomas Pedersen                 --
--                                                                           --
--  This is free software;  you can redistribute it and/or modify it         --
--  under terms of the  GNU General Public License  as published by the      --
--  Free Software  Foundation;  either version 3,  or (at your  option) any  --
--  later version. This library is distributed in the hope that it will be   --
--  useful, but WITHOUT ANY WARRANTY;  without even the implied warranty of  --
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                     --
--  You should have received a copy of the GNU General Public License and    --
--  a copy of the GCC Runtime Library Exception along with this program;     --
--  see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
--  <http://www.gnu.org/licenses/>.                                          --
--                                                                           --
-------------------------------------------------------------------------------

with Ada.Text_IO;
with GNAT.Sockets;
use GNAT.Sockets;
with socket;
with Ada.Streams;
with Ada.Exceptions;  use Ada.Exceptions;

procedure Main is
   use Ada.Text_IO;
   use type Ada.Streams.Stream_Element_Count;

   Line_Termination : constant String := ASCII.CR & ASCII.LF;

   Client : Socket_Type;
   Addr    : Sock_Addr_Type;
   Channel : Stream_Access;
   Server_Host : constant String := "asterisk1.adaheads.com";
   Server_Port : constant Port_Type := 5038;
   
   procedure Connect is
   begin
      Put ("Connecting to: " & Server_Host & 
	     " on port" & Port_Type'Image(Server_Port) &
	     " ... ");

      Create_Socket (Client);
      Addr.Addr := Addresses (Get_Host_By_Name (Server_Host),1);
      Addr.Port := Server_Port;
      Connect_Socket (Client, Addr);
      Put_Line (" Done!");

      Channel := Stream (Client);

      Socket.Start (Channel);

      Put_Line ("Bye Bye socket is shutting down!");
   end Connect;
begin
   Connect;
  exception
     when Error: GNAT.SOCKETS.SOCKET_ERROR =>
        Put_Line("Could not connect, reason: " & 
		   Exception_Message(Error));
	delay 1.0;
	Connect;
end Main;
