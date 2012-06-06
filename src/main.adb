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
--  with Thomas_Util;

procedure Main is
   use Ada.Text_IO;
   use type Ada.Streams.Stream_Element_Count;

   CarageReturn_NewLine : constant String := (1 => ASCII.CR, 2 => ASCII.LF);

   Client : Socket_Type;
   Address : Sock_Addr_Type;
   Channel : Stream_Access;
   server_host : constant String := "192.168.122.32";
   server_port : constant Port_Type := 5038;

begin
   Put ("Program started" & CarageReturn_NewLine);
   --     for hello in 1 .. 100 loop
   --        Put_Line ("Socket initialise");
   --        delay 0.1;
   --        if hello = 10 then
   --           return;
   --        end if;
   --     end loop;

   Create_Socket (Client);
   Address.Addr := Inet_Addr (server_host);
   Address.Port := server_port;

   Connect_Socket (Client, Address);
   Channel := Stream (Client);

   socket.start (Channel);

   Ada.Text_IO.Put_Line ("Bye Bye socket is shutting down!");
end Main;
