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