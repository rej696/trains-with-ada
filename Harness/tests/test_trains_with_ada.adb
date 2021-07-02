with AUnit.Reporter.Text;
with AUnit.Run;
with Trains_With_Ada_Suite; use Trains_With_Ada_Suite;

procedure Test_Trains_With_Ada is
   procedure Runner is new AUnit.Run.Test_Runner (Suite);
   Reporter : AUnit.Reporter.Text.Text_Reporter;
begin
   Runner (Reporter);
end Test_Trains_With_Ada;
