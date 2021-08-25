with HAL.GPIO;
with HAL.UART;
with RP.Device;
with RP.GPIO;
with RP.UART;
with RP.Clock;
with Pico;

package body Test_Utilities is

   procedure Initialise is
   begin
      RP.Clock.Initialize (Pico.XOSC_Frequency);
      RP.Clock.Enable (RP.Clock.PERI);
      RP.Device.Timer.Enable;
      RP.GPIO.Enable;
      Pico.LED.Configure (RP.GPIO.Output);
      Pico.LED.Set;

      UART_TX.Configure (RP.GPIO.Output, RP.GPIO.Pull_Up, RP.GPIO.UART);
      UART_RX.Configure (RP.GPIO.Input, RP.GPIO.Floating, RP.GPIO.UART);
      UART.Configure
         (Config =>
             (Baud      => 155_200,
              Word_Size => 8,
              Parity    => False,
              Stop_Bits => 1,
              others    => <>));
   end Initialise;

   procedure Echo (Input : in String) is
      use HAL.GPIO;
      use HAL.UART;
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

end Test_Utilities;
