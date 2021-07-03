-- Method for running unit tests on the Raspberry Pi Pico
-- Once USB example on JeremyGrosser/pico_examples,
--    switch to using that rather than UART

with HAL.GPIO; use HAL.GPIO;
with HAL.UART; use HAL.UART;
with RP.Device; use RP.Device;
with RP.GPIO; use RP.GPIO;
with RP.UART;
with RP.Clock;
with Pico;

procedure Test_Trains_With_Ada is
   Test_Error : exception;
   UART       : RP.UART.UART_Port renames RP.Device.UART_0;
   UART_TX    : RP.GPIO.GPIO_Point renames Pico.GP16;
   UART_RX    : RP.GPIO.GPIO_Point renames Pico.GP17;
   Buffer     : UART_Data_8b (1 .. 1);
   Status     : UART_Status;

   procedure Send_String (Input : in String) is
      Input_Bytes : UART_Data_8b (1 .. Input'Length);
   begin
      for I in Input'Range loop
         Input_Bytes (I) := Character'Pos (Input (I));
      end loop;

      UART.Transmit (Input_Bytes, Status);
      if Status /= Ok then
         raise Test_Error with "Send_String transmit failed with status " & Status'Image;
      end if;
   end Send_String;

   procedure Echo is
   begin
      loop
         UART.Receive (Buffer, Status, Timeout => 0);
         case Status is
            when Err_Error =>
               raise Test_Error with "Echo receive failed with status " & Status'Image;
            when Err_Timeout =>
               raise Test_Error with "Unexpected Err_Timeout with timeout disabled!";
            when Busy =>
               raise Test_Error with "Unexpected Busy status in UART receive";
            when Ok =>
               UART.Transmit (Buffer, Status);
               if Status /= Ok then
                  raise Test_Error with "Echo transmit failed with status " & Status'Image;
               end if;
               Pico.LED.Toggle;
         end case;
      end loop;
   end Echo;
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   RP.GPIO.Enable;
   RP.Device.Timer.Enable;
   RP.GPIO.Enable;
   Pico.LED.Configure (Output);
   Pico.LED.Set;

   UART_TX.Configure (Output, Pull_Up, RP.GPIO.UART);
   UART_RX.Configure (Input, Floating, RP.GPIO.UART);
--   UART.Configure
--      (Config =>
--          (Baud      => 9600,
--           Word_Size => 8,
--           Parity    => False,
--           Stop_Bits => 1,
--           others    => <>));
   UART.Enable (115_200);

   -- Loop
   -- Call Test Function
   
   -- Default Test
   -- statement to identify test passes/fails
   if True then
      Send_String ("Pass" & ASCII.LF);
   else
      Send_String ("Fail" & ASCII.LF);
   end if;

   -- UART.Send_Break (RP.Device.Timer'Access, UART.Frame_Time * 2);

   Echo;
end Test_Trains_With_Ada;
