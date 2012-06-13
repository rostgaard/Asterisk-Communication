with Ada.Text_IO; use Ada.Text_IO;
Package body Queue is
   procedure Enqueue (Element: in Element_Type) is
   begin
      if Queue_Length < Queue_Size then 
	 Items(Next_Free) := Element;
	 Next_Free := (Next_Free mod Queue_Size)+1;
	 Queue_Length := Queue_Length +1;
	 Put_Line("Queue: Next_Index:" & Index'Image(Next_Free));
	 
      else
	 -- Queue is full!
	 raise PROGRAM_ERROR;
      end if;
   end Enqueue;
   
   function Dequeue return Element_Type is 
      -- Save this for actually dequeing
      Current_Head : Index := Head;
   begin
      if Queue_Length > 0 then
	 Head := (Head mod Queue_Size)+1;
	 -- And decrement the bookkeeping count
	 Queue_Length := Queue_Length -1;
	 return Items (Current_Head);
      else
	 --TODO, build a real exception
	 raise PROGRAM_ERROR;
      end if;
	 
   end Dequeue;
   
   function Length return Natural is 
   begin
      return Queue_Length;
   end Length;
   
   function Max_Length return Natural is 
   begin
      return Queue_Size;
   end Max_Length;

end Queue;
