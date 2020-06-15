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

## Disclaimer
I am not responsible for any damage this causes. This has been tested on an 820-2915 successfully, but YMMV. The FPGA's original configuration cannot be backed up. This means this process is irreversable and once reprogrammed, the original configuration programmed by Apple will be irrecoverably lost.

## License
GPL