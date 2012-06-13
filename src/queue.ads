-- Basic bounded queue

generic
   type Element_Type is private;
   Queue_Size : in Positive := 3;
   
package Queue is
   procedure Enqueue (Element : in Element_Type);
   -- Enque an element
   
   function Dequeue return Element_Type;
   -- Dequeue the head of the queue
    
   function Length return Natural;
   -- Returns the current number of elements in the queue
   
   function Max_Length return Natural;
   -- Returns the maximum number of elements allowed in queue

private
   subtype Index is Positive range 1 .. Queue_Size;
   Items : array(Index) of Element_Type;
   Next_Free, Head : Index := 1;
   
   subtype Queue_Length_Type is Natural range 0 .. Queue_Size;
   
   Queue_Length : Queue_Length_Type := 0;

end Queue;
   
