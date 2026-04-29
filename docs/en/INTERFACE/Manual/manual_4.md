# 4 Commissioning

## 4.1 Power supply
The interface has a built-in power supply (100 - 240VAC - 15W 50Hz/60Hz) which is powered by the included power cable.

1. To do this, connect the interface to the blue Neutrik PowerCON connector.
2. Then connect the safety plug to the mains.

## 4.2 Connecting the sensors to the interface
The interface has three sensor inputs with a 3-pin XLR connector. These inputs are compatible with all common LAP-TEQ sensors:

* LAP-TEQ PLUS INCLINOMETER (green laser)
* LAP-TEQ PLUS ATMOSPHERE Temperature & Humidity Sensor
* LAP-TEQ PLUS ELEVATION Height Sensor
* The old "legacy" LAP-TEQ Inclinometer Sensor

!!! info "Note"
    The ATMOSPHERE also has the possibility to be connected to the interface without cables.

LAP-TEQ ATMOSPHERE and ELEVATION can be sanded through. This allows two sensors to be connected to one input.

<!-- TODO: Insert image "Sensor – Interface connection via XLR" -->

## 4.3 Network Setup
The basic network settings of the LAP-TEQ PLUS interface are:

| Setting          | Value           |
|------------------|-----------------|
| IP address       | 192.168.1.222   |
| Subnet           | 255.255.255.0   |
| Gateway Address  | 192.168.1.1     |

* The interface does not support Dynamic Host Configuration Protocol (DHCP).
* Each interface must be assigned its own fixed IP address.
* The network adapter of your device must be in the same address range of the interface.
* To access the web interface, open a browser and enter the IP address of the interface in the URL bar.
* If the interface is to be integrated into a network in a different address range, the IP address can be changed via the SETUP menu. To do this, click on the gear icon in the top right. Change the network settings and confirm with Apply+Reboot.
* To reset to the basic network settings, the hidden RESET button on the front of the device must be pressed for at least five seconds.

* Multiple interfaces can be displayed in one browser window. Once you have assigned an individual IP address to each interface, you will need to connect to one of these interfaces by entering the IP address in the browser. This interface will always be the top of the list. To find the other interfaces, click on SETUP and then FIND FRIENDS. All found interfaces will be displayed after a few seconds.
