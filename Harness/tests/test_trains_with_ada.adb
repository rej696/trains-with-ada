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
   UART_TX : RP.GPIO.GPIO_Point renames Pico.GP16;
   UART_RX : RP.GPIO.GPIO_Point renames Pico.GP17;

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

   type Result is (Correct, Incorrect, Partial);
   Count: Natural := 0;
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
      for Test in Result'Range loop
         Echo ("Test" & Count'Image & ": ");

         if Test = Correct then
            Echo ("Pass" & ASCII.CR & ASCII.LF);
         elsif Test = Partial then
            Echo ("Partial" & ASCII.CR & ASCII.LF);
         else
            Echo ("Fail" & ASCII.CR & ASCII.LF);
         end if;


         Pico.LED.Toggle;
         RP.Device.Timer.Delay_Milliseconds(100);

         if Count > 150 then
            RP.Device.Timer.Delay_Milliseconds(5000);
            Count := 1;
         else
            Count := Natural'Succ(Count);
         end if;
      end loop;
   end loop;

end Test_Trains_With_Ada;
