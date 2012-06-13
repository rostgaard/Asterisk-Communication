-- Protocol-specific strings and ... stuff

package Protocol is
   
   -- LF is never enough for some people..
   Line_Termination_String : constant String := ASCII.CR & ASCII.LF;
   
   -- Key part of request string
   Action_String           : constant String := "Action: ";
   Secret_String           : constant String := "Secret: ";
   
   -- Value part of request string
   Login_String            : constant String := "Login";
   Ping_String             : constant String := "Ping";
   Logoff_String           : constant String := "Logoff";
   
end Protocol;
  
