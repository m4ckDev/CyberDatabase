# Hardware and IoT Security

This section is the CyberDatabase entry point for hardware, embedded, IoT, physical-device, RF, RFID/NFC, USB and lab-device security research.

## Coverage

- embedded Linux and microcontroller platforms;
- ESP32 and related wireless development boards;
- Raspberry Pi lab systems;
- M5Stack and portable embedded platforms;
- JTAG, SWD, UART, SPI and I2C interfaces;
- USB device security and electrical resilience;
- RFID/NFC systems and access-control research;
- software-defined radio and RF analysis;
- WiFi/Bluetooth hardware;
- firmware acquisition and analysis;
- flash storage and filesystem extraction;
- hardware debugging interfaces;
- secure boot and firmware-signing concepts;
- physical attack surface and tamper resistance;
- IoT network segmentation and monitoring;
- device inventory, lifecycle and patching;
- authorized physical-security training equipment.

## Hardware purchasing directory

CyberDatabase maintains a separate purchasing/reference directory at:

`../../hardware/README.md`

It includes manufacturer and reseller links for the hardware represented in the CYBERSEC TOOLS source, including Hak5, KSEC, Hacker Warehouse, Biscuit Shop, OzHack, Raspberry Pi, M5Stack, ESP32, Proxmark3, WiFi Pineapple, ALFA adapters, USB Rubber Ducky, Bash Bunny, Shark Jack, Packet Squirrel, LAN Turtle, O.MG Cable, Flipper Zero, HackRF, iCopy-XS, KeyGrabber, USBKill and physical-security training equipment.

## Lab workflow

For hardware research, record:

```text
Device / model
Manufacturer
Firmware version
Interfaces
Power requirements
Network / radio capabilities
Storage / flash type
Debug ports
Boot chain
Test objective
Authorization / scope
Evidence
Findings
Detection / mitigation
References
```

## Safe hardware analysis

Use sacrificial equipment when testing voltage, USB electrical resilience, destructive fault conditions, firmware corruption or invasive hardware modifications. Keep RF testing within legal frequency/power constraints and isolate experiments that could affect nearby systems.

## Related sections

- `../networking/`
- `../wireless/`
- `../forensics/`
- `../malware-analysis/`
- `../reverse-engineering/`
- `../services-and-protocols/`
- `../../references/hacktricks-upstream/src/hardware-physical-access/`
