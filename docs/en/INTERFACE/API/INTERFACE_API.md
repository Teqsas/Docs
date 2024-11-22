# LAP-TEQ PLUS INTERFACE HTTP-API

## Introduction
This document describes the HTTP-API of the LAP-TEQ PLUS INTERFACE. With this API it is possible to integrate LAP-TEQ Sensors into existing control systems. To avoid confusion, the LAP-TEQ PLUS INTERFACE is referred to as LTPI in the following.
Although there is no risk involved using the API, implementing it into an existing control system is at your own risk. The API and this documentation can be subject to change, whenever the device firmware will be updated. TEQSAS GmbH does not assume liability whatsoever for any damages caused by 3rd party implementations of the API.

This documentation must not be redistributed.

This document describes the API as of today (2024/06/13).

If you find any bugs or errors using the system, please send a report to support@teqsas.de including a detailed description of the issue. 

## API-Commands

### Connecting to a LTPI
The LTPI is a TCP/IP device and listens to HTTP requests. An example request for checking the connection and the state of the LTPI would look like the following:

```GET http://{ip-adress}/lt```

This returns a response in JSON-format which could look like this:

```
{
  "0": {
    "lbl": "Amps SR",
    "s0": " ",
    "s1": "192.168.1.222",
    "s2": "v1.84c",
    "s3": "3",
    "s4": "255.255.255.0",
    "s5": "192.168.1.1",
    "st": "0"
  },
  "1": {
    "lbl": "Main L",
    "s0": "73.7&deg;F",
    "s1": "rH 37%",
    "s89": "1132 ft/s",
    "sc": "W",
    "st": "1",
    "at": "73.7°F",
    "ah": "rH 37%",
    "as": "1132 ft/s"
  },
  "2": {
    "lbl": "Side L",
    "s0": " + 3.1&deg;",
    "s1": "",
    "s89": "LASER ON",
    "sc": "W",
    "st": "1"
  },
  "3": {
    "lbl": "Subs",
    "s0": "- 0.1&deg;",
    "s1": "",
    "s89": "LASER+ FLASHING",
    "sc": "G",
    "st": "1"
  }
}

```

The JSON top level contains four objects:
0.	Information about the LTPI itself, like the LABEL, FW-Version and Network-Settings
1.	Data and Information from the sensor connected to PORT A
2.	Data and Information from the sensor connected to PORT B
3.	Data and Information from the sensor connected to PORT C

Further information on interpreting the JSON data can be found in chapter Reading Values.

## Starting Sensors
### Start a specific sensor in normal mode

HTTP-Request:

```GET http://{ip-adress}/lt?c=1{sensor-number}```

Provide the sensor number which corresponds to the XLR-port on the LTPI Hardware to turn on this sensor. Normal mode means, the sensor will start just like a single click on the webapp or reading out with a LAP-TEQ PLUS DISPLAY. E.g. if two sensors are connected in daisychain, both sensors will be started.
Returns a JSON document like in Chapter Connecting to a LTPI.

###	Start all connected sensors in normal mode

HTTP-Request:

```GET http://{ip-adress}/lt?c=17```

This starts all connected sensors. Normal mode means, the sensor will start just like a single click on the webapp or reading out with a LAP-TEQ PLUS DISPLAY. E.g. if two sensors are connected in daisychain, both sensors will be started.
Returns a JSON document like in -1.1 Connecting to a LTPI-

### Start ATMOSPHERE sensor

HTTP-Request:

```GET http://{ip-adress}/lt?c=2{sensor-number}```

Provide the sensor number which corresponds to the XLR-port on the LTPI Hardware on which the LAP-TEQ PLUS ATMOSPHERE sensor is connected. If on this sensor-line an ATMOSPHERE sensor and e.g. an INCLINOMETER is connected, only the ATMOSPHERE sensor will be turned on. This also works with 1.2.2 Start all connected sensors in normal mode.
Returns a JSON document like in -1.1 Connecting to a LTPI-

##	Reading Values
The raw data from the sensors is returned in the JSON document. This needs to be interpreted by the application. 

### 1.3.1	LTPI Data

lbl | Description
--- | ---
`"lbl"` | The name of the LTPI. Can be set in the webapp
`"s0"` | Not used
`"s1"` | IP-Address of the LTPI
`"s2"` | Firmware-Version of LTPI
`"s3"` | Number of sensor inputs
`"s4"` | Subnet-Mask
`"s5"` | Gateway-Address
`"st"` | Not used

### Sensor Data

Key | Description
--- | ---
`"lbl"` | Name of the Sensor. Can be set in the webapp
`"s0"` | Temperature/ Angle/ Height (Depends on the connected Sensor)
`"s1"` | Humidity/ None
`"s89"` | Speed of Sound/ Laser Mode
`"sc"` | "W"
`"st"` | Status (0-Off, 1-On, 2-No Sensor, 3-Calib mode, 4-Four load cells, 5-Atmosphere)
`"at"` | Temperature*
`"ap"` | Pressure*
`"ah"` | Humidity*
`"as"` | Speed of Sound*

*(Only available if LAP-TEQ PLUS ATMOSPHERE Sensor is connected)

## Stopping Sensors
###	Stopping a single sensor

HTTP-Request:

```GET http://{ip-adress}/lt?c=0{sensor-number}```

Provide the sensor number which corresponds to the XLR-port on the LTPI Hardware to turn this sensor off. 
Returns a JSON document like in -1.1 Connecting to a LTPI-
 
###	Stopping all sensors

HTTP-Request:

```GET http://{ip-adress}/lt?c=07```

Turns off all connected sensors.
Returns a JSON document like in -1.1 Connecting to a LTPI-

##	Other Functions
###	Network Scan
HTTP-Request:
```GET http://{ip-adress}/scan```

Start scanning the network for other connected LTPIs. 

###	Reading the list of connected LTPIs
HTTP-Request:

```GET http://{ip-adress}/nbors.json```

Returns a JSON object containing the LTPI information of this LTPI and other LTPIs connected to the network. To update the list please perform 1.5.1 Network Scan.

```
{
  "0": {
    "dn": "Amps SR",
    "ip": "192.168.1.222",
    "mlt": "3",
    "swv": "v1.84c",
  },
"1": {
    "dn": "Amps SL",
    "ip": "192.168.1.221",
    "mlt": "3",
    "swv": "v1.84c",
  },
"2": {
    "dn": "Amps Del",
    "ip": "192.168.1.223",
    "mlt": "3",
    "swv": "v1.84c",
  },

}
```