with Ada.Text_IO;
use Ada.Text_IO;

procedure arrman is

   array_length : constant Integer := 1000;
   type my_array is array (1 .. array_length) of Integer;
   a : my_array;
   task_count : constant Integer := array_length / 10;

   function part_sum (left : Integer; Right : Integer) return long_Integer is
      sum : long_Integer := 0;
      i   : Integer;
   begin
      i := left;
      while i <= Right loop
            sum := sum + Long_Integer(a(i));
         i := i + 1;
      end loop;
      return sum;
   end part_sum;

   procedure create_array is
   begin
      for i in a'Range loop
         a (i) := i;
      end loop;
   end create_array;

   protected task_manager is
      procedure set_res (sum : in Long_Integer);
      entry get_res (sum : out Long_Integer);
   private
      sum          : Long_Integer := 0;
      task_counter : Integer      := 0;
   end task_manager;

   protected body task_manager is

      procedure set_res (sum : in Long_Integer) is
      begin
         task_manager.sum := task_manager.sum + sum;
         task_counter := task_counter + 1;
      end set_res;

      entry get_res (sum : out Long_Integer) when task_counter = task_count is
      begin
         sum := task_manager.sum;
      end get_res;

   end task_manager;

   task type my_task is
      entry start(left, RigHt : in Integer);
   end my_task;

   task body my_task is
      left, RigHt : Integer;
      sum : long_Integer := 0;

   begin
      accept start(left, RigHt : in Integer) do
         my_task.left := left;
         my_task.right := Right;
      end start;
      sum := part_sum (left, right);
      task_manager.set_res(sum);
   end my_task;

   tasks : array(1..task_count) of my_task;

   sum00 : integer;
begin
   create_array;
   sum00 := 0;
   --find simple sum
   for i in a'Range loop
      sum00 := sum00 + a(i);
   end loop;
   Put_Line("Simple sum: " & sum00'img);
	--start tasks
   for i in tasks'Range loop
      tasks(i).start(array_length / task_count * (i - 1) + 1,
        array_length / task_count * i);
   end loop;
   --get sum from manager
   task_manager.get_res(long_integer(sum00));
   Put_Line("Multi thread sum: " & sum00'img);

end arrman;
