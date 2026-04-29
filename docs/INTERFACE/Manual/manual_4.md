# 4 Inbetriebnahme

## 4.1 Spannungsversorgung
Das Interface verfügt über ein eingebautes Netzteil (100 - 240VAC – 15W 50Hz/60Hz) welches mit Hilfe des beiliegenden Netzkabels mit Strom versorgt wird.

1. Verbinden Sie hierfür das Interface mit dem blauen Neutrik PowerCON-Stecker.
2. Verbinden Sie anschließend den Schutzkontaktstecker mit dem Stromnetz.

## 4.2 Verbindung der Sensoren mit dem Interface
Das Interface hat drei Sensor-Inputs mit einem 3-Pin XLR Steckverbinden. Diese Eingänge sind kompatibel zu allen gängigen LAP-TEQ Sensoren:

* LAP-TEQ PLUS INCLINOMETER (grüner Laser)
* LAP-TEQ PLUS ATMOSPHERE Temperatur- und Feuchtigkeitssensor
* LAP-TEQ PLUS ELEVATION Höhensensor
* Der alte „legacy" LAP-TEQ Inclinometer Sensor

!!! info "Hinweis"
    Der ATMOSPHERE besitzt zudem die Möglichkeit ohne Kabel an das Interface angeschlossen werden zu können.

LAP-TEQ ATMOSPHERE und ELEVATION können durchgeschliffen werden. So lassen sich an einem Input zwei Sensoren anschließen.

<!-- TODO: Abbildung "Verbindung Sensor – Interface über XLR" einfügen -->

## 4.3 Netzwerk Setup
Die Netzwerk-Grundeinstellungen des LAP-TEQ PLUS Interface sind:

| Einstellung      | Wert            |
|------------------|-----------------|
| IP-Adresse       | 192.168.1.222   |
| Subnetzmaske     | 255.255.255.0   |
| Gateway-Adresse  | 192.168.1.1     |

* Das Interface unterstützt kein Dynamic Host Configuration Protocol (DHCP).
* Jedem Interface muss eine eigene, feste IP-Adresse zugewiesen werden.
* Der Netzwerkadapter Ihres Endgerätes muss sich im selben Adressbereich des Interface befinden.
* Um auf die Web-Oberfläche zugreifen zu können, öffnen Sie einen Browser und geben die IP-Adresse des Interface in der URL-Leiste ein.
* Soll das Interface in ein Netzwerk in einem anderem Adressbereich eingebunden werden, kann die IP-Adresse über das SETUP Menü geändert werden. Klicken Sie dazu auf das Zahnrad-Symbol oben rechts. Ändern sie die Netzwerkeinstellungen und bestätigen Sie mit Apply+Reboot.
* Zum Zurücksetzen auf die Netzwerk-Grundeinstellungen muss der versteckte RESET-Knopf, an der Frontseite des Gerätes, mindestens fünf Sekunden gedrückt werden.

* Es können mehrere Interfaces in einem Browserfenster angezeigt werden. Nachdem Sie jedem Interface eine individuelle IP-Adresse zugewiesen haben, müssen Sie sich mit einem dieser Interfaces durch die Eingabe der IP-Adresse im Browser verbinden. Dieses Interface wird immer das Oberste in der Liste sein. Um die weiteren Interfaces zu finden, klicken Sie auf SETUP und anschließend FIND FRIENDS. Alle gefundenen Interfaces werden nach ein paar Sekunden angezeigt.
