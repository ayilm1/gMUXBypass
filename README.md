# gMUXBypass

## Overview
This HDL overwrites the configuration on the Lattice XP2 on the 820-2914 and 820-2915 boards to buffer the iGPU LVDS signals directly to the LCD. It also powers down the dGPU to conserve power

## Synthesised Variants
There are two variants that can be synthesised; PWM and NoPWM. This is selectable by setting USE_PWM in the module parameter definitions. There are also pre-built JEDECs available in the repo if you don't wish to synthesise these yourself. They can be flashed using the standalone Lattice Diamond Programmer.

| Variant | USE_PWM | Pre-built JEDEC File |  Description |
| ------ | ------ | ------ | ------ |
| NoPWM | 0 | gMUXBypass_NoPWM.jed | 100% duty-cycle brightness. FPGA_N2 is tied high. |
| PWM | 1 | gMUXBypass_PWM.jed | Brightness controlled by PCH. FPGA_N2 is tied floating. Need to connect LCD_BKLT_PWM to NC_LVDS_IG_BKL_PWM. |

The NoPWM variant has no brightness control. It will never be possible to perform brightness control via the LPC interface natively, as the AppleMuxControl.kext responsible for managing the FPGA gMUX is contained within AppleGraphicsControl.kext, which in turn is only loaded if the dGPU is present on PCIe. It may be possible to write a new extension which just sends brightness control commands over the LPC interface (Lattice has a free LPC IP block [here](http://www.latticesemi.com/en/Products/DesignSoftwareAndIP/IntellectualProperty/ReferenceDesigns/ReferenceDesigns02/LPCBusController)), however this is likely a lot more work and isn't necessarily update-proof.

For this reason, the second variant has been created. This simply sets the N2 (LCD_BKLT_PWM) output of the FPGA high-impedance so an external source is free to drive it. The NC_LVDS_IG_BKL_PWM signal from the PCH is then connected up to LCD_BKLT_PWM (I used R9693-1 for my implementation) so the iGPU has full control over the panel brightness. This makes the 820-2915 functionally identical to the 820-2936 from a brightness control perspective. As far as the OS is concerned, this is a integrated-only system.

## Hardware Modification
Due to the loss of the post on advancedreworks, I have put all the critical information needed for connecting up the PWM signal from the PCH here. It is not as complete a guide as the forum post was, but this is all I have time for right now.

The location of the PCH interposer via we're interested in is as follows:

![](https://i.imgur.com/KAq5CQj.jpg)

Once you have located this point, mark it with a small nick in the solder mask. Proceed to then scratch at the mask layer until you hit the first ground plane layer.

![](https://i.imgur.com/BsqFgd3.jpg)

Cut through this with your pick and continue through the dielectric below. You should see feint evidence of the top of the via. Continue removing dielectric material until you reach the shiny copper top.

![](https://i.imgur.com/Cy9zhGx.jpg)

How you choose to connect to this via is up to you at this point. I used some copper tape mounted to the interposer, and one strand of a scrap piece of stranded wire. The copper tape gives strain relief through mechanical isolation. Images below to serve as an example.

![](https://i.imgur.com/EXfDMqz.jpg)

![](https://i.imgur.com/kMBgHvU.jpg)

![](https://i.imgur.com/sYzBekX.jpg)

![](https://i.imgur.com/qrKkgje.jpg)

I ran the connection to pin 1 of R9693 (LCD_BKLT_PWM) on my implementaion. However after updating my version of OBV, I noticed there appears to be a test point on the PCH side just below C9623 that may also be used. This should save from having to run the wire to the other side of the board.

## Disclaimer
I am not responsible for any damage this causes. This has been tested on an 820-2915 successfully, but YMMV. The FPGA's original configuration cannot be backed up. This means this process is irreversable and once reprogrammed, the original configuration programmed by Apple will be irrecoverably lost.

## License
GPL