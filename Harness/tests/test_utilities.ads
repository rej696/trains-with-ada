with HAL.GPIO;
with HAL.UART;
with RP.Device;
with RP.GPIO;
with RP.UART;
with Pico;

package Test_Utilities is

   procedure Initialise;

   procedure Echo (Input : in String);

private
   UART       : RP.UART.UART_Port renames RP.Device.UART_0;
   UART_TX    : RP.GPIO.GPIO_Point renames Pico.GP16;
   UART_RX    : RP.GPIO.GPIO_Point renames Pico.GP17;
end Test_Utilities;
