-- Method for running unit tests on the Raspberry Pi Pico
-- Once USB example on JeremyGrosser/pico_examples,
--    switch to using that rather than UART
with Pico;
with RP.Device;
with Test_Utilities; use Test_Utilities;

procedure Test_Trains_With_Ada is
begin
   Initialise;

   -- Continuously loop through tests
   loop
      RP.Device.Timer.Delay_Milliseconds (100);
      Pico.LED.Toggle;

      -- Call Test Function
      
      -- Default Test
      -- statement to identify test passes/fails
      declare
         Result : Boolean := True;
      begin

         if Result then
            Echo ("Pass" & ASCII.LF);
         else
            Echo ("Fail" & ASCII.LF);
         end if;

         Result := not Result;
      end;
   end loop;

end Test_Trains_With_Ada;
