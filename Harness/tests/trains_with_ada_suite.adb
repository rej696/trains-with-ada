with Trains_With_Ada.Main.Test;

package body Trains_With_Ada_Suite is 

   function Suite return Access_Test_Suite is
      Ret : constant Access_Test_Suite := new Test_Suite;
   begin
      Ret.Add_Test (new Main.Test.Test);
      return Ret;
   end Suite;

end Trains_With_Ada_Suite;
