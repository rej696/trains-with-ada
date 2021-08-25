-- Method for running unit tests on the Raspberry Pi Pico
-- Once USB example on JeremyGrosser/pico_examples,
--    switch to using that rather than UART
with HAL.GPIO; use HAL.GPIO;
with HAL.UART; use HAL.UART;
with RP.Device;
with RP.GPIO; use RP.GPIO;
with RP.UART;
with Pico;
with RP.Clock;
-- with Test_Utilities; use Test_Utilities;

procedure Test_Trains_With_Ada is
   UART    : RP.UART.UART_Port renames RP.Device.UART_0;
   UART_TX : RP.GPIO.GPIO_Point renames Pico.GP12;
   UART_RX : RP.GPIO.GPIO_Point renames Pico.GP13;

   procedure Echo (Input : in String) is
      Buffer : UART_Data_8b (1 .. Input'Length);
      Status : UART_Status;
   begin
      for I in Input'Range loop
         Buffer (I) := Character'Pos (Input (I));
      end loop;

      UART.Transmit (Buffer, Status);
      if Status /= Ok then
         Echo ("Echo transmit failed with status " & Status'Image);
      end if;
   end Echo;
begin
   -- Initialisation preamble
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   RP.Clock.Enable (RP.Clock.PERI);
   RP.Device.Timer.Enable;
   RP.GPIO.Enable;
   Pico.LED.Configure (Output);
   Pico.LED.Set;

   UART_TX.Configure (Output, Pull_Up, RP.GPIO.UART);
   UART_RX.Configure (Input, Floating, RP.GPIO.UART);
   UART.Configure
      (Config =>
         (Baud      => 115_200,
          Word_Size => 8,
          Parity    => False,
          Stop_Bits => 1,
          others    => <>));

   -- Main Loop
   -- Continuously loop over test results
   loop
      -- Call Test Function/Procedure
      -- Default Test
      declare
         Result : Boolean := True;
      begin

         Echo ("Test1: ");

         if Result then
            Echo ("Pass" & ASCII.LF);
         else
            Echo ("Fail" & ASCII.LF);
         end if;

         Result := not Result;
      end;

      declare
         Hello : constant String := "Hello, Pico!" & ASCII.CR & ASCII.LF;
      begin
         Echo (Hello);
      end;
      Pico.LED.Toggle;
      RP.Device.Timer.Delay_Milliseconds(100);
   end loop;

end Test_Trains_With_Ada;
