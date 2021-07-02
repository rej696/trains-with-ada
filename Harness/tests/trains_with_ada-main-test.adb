with AUnit.Assertions; use AUnit.Assertions;

package body Trains_With_Ada.Main.Test is

   function Name (T : Test) return AUnit.Message_String is
      pragma Unreferenced (T);
   begin
      return AUnit.Format ("Test Trains_With_Ada Main package");
   end Name;

   procedure Run_Test (T : in out Test) is
      pragma Unreferenced (T);
   begin
      null;
      -- Assert (condition, "<Message if condition failed>")
      Assert (False, "This is a failing condition");
      Assert (True, "This is a passing condition");
   end Run_Test;

end Trains_With_Ada.Main.Test;
