# 8 Kalibrierung

!!! info "Hinweis"
    Das Sensormodul ist ab Werk für den Betrieb mit der Bodenplatte nach unten kalibriert.

    Ist der Betrieb des Sensors mit einer anderen Ausrichtung der Bodenplatte gewünscht (oben, links oder rechts), ist hierzu eine Kalibrierung in der gewünschten Position notwendig.

    Sind alle Positionen einmal vollständig kalibriert worden, lässt sich der Sensor ohne weitere Kalibrierungen in allen Positionen nutzen.

Eine neue Kalibrierung kann notwendig werden, wenn das Sensormodul extremen Stößen ausgesetzt wurde (z. B. durch Herabfallen). Eine Kalibrierung ist notwendig, wenn das Sensormodul nicht mit der Bodenplatte nach unten betrieben werden soll, also Bodenplatte nach oben, Bodenplatte nach links oder rechts. Der Kalibriervorgang ist in allen Positionen bis auf die Ausrichtung der Bodenplatte identisch und wird daher in dieser Anleitung exemplarisch für die Variante Bodenplatte nach unten beschrieben.

Zusätzlich zu dem zu kalibrierenden Sensormodul wird folgendes Material benötigt:

* Displaymodul
* Kalibrier-Kabel (siehe Abbildung in [Kapitel 3.2](manual_3.md#32-ihr-gerat-im-uberblick)). Normale XLR-Kabel sind nicht geeignet.
* Wasserwaage
* Geodreieck

### Schritt 1
* Sensormodul mit dem Kalibrier-Kabel an das Displaymodul anschließen.

### Schritt 2

<!-- TODO: Abbildung "Schritt 2 – Sensormodul auf Bezugsfläche, Laseraustritt nach links" einfügen -->

* Prüfen, ob die Bezugsfläche, auf der die Kalibrierung durchgeführt werden soll, in Waage ist.
* Sensormodul mit der Bodenplatte auf der Bezugsfläche positionieren. Der Laseraustritt zeigt nach links.

### Schritt 3
* „CAL-Taste" auf dem Displaymodul drücken und halten.
* „Power-Taste" auf dem Displaymodul drücken.
* Sobald der „Welcome"-Schriftzug am unteren Displayrand erscheint, beide Tasten loslassen.

Das System befindet sich jetzt im Kalibriermodus und zeigt dies im oberen Displaybereich durch **„start calibrte?"** an.

!!! info "Hinweis"
    Wird die „CAL-Taste" am Displaymodul im laufenden Betrieb betätigt, wird das Sensormodul nicht in den Kalibriermodus versetzt. Stattdessen erscheint auf dem Display eine Kurzanleitung zur Kalibrierung. Die Anzeige wechselt nach einigen Sekunden selbstständig wieder zur Winkelanzeige.

* „CAL-Taste" erneut drücken, um die eigentliche Kalibrierung zu starten.

Im Display erscheint die Frage **„calibrte 0.0° A?"**.

* „CAL-Taste" erneut drücken, um die Kalibrierung in „A"-Richtung zu starten.

Erscheint im Display der Hinweis **„Sens pos incorrect"**, bitte die Ausrichtung der Bodenplatte prüfen.

Bei korrekter Vorgehensweise erscheint im Display **„don't move"** – gefolgt von einem Zahlenwert für „A" und der Frage **„calibrte 0.0° B?"**.

### Schritt 4

<!-- TODO: Abbildung "Schritt 4 – Sensormodul drehen, Laseraustritt nach rechts" einfügen -->

* Sensormodul so drehen, dass der Laseraustritt nach rechts zeigt.
* „CAL-Taste" erneut drücken, um die Kalibrierung in „B"-Richtung zu starten.

Wieder erscheint im Display **„don't move"** – gefolgt von einem Zahlenwert für „B" und der Frage **„calibrte +45.0°?"**.

### Schritt 5

<!-- TODO: Abbildung "Schritt 5 – Sensormodul mit Geodreieck auf +45° ausrichten" einfügen -->

* Sensormodul mit Hilfe des Geodreiecks so ausrichten, dass der Laser in einem 45°-Winkel nach oben scheint.
* „CAL-Taste" erneut drücken, um die Kalibrierung in „+45.0°" zu starten.

Im Display erscheint **„don't move"** – gefolgt von einem Zahlenwert für „+45.0°" und der Frage **„calibrte −45.0°?"**.

### Schritt 6

<!-- TODO: Abbildung "Schritt 6 – Sensormodul mit Geodreieck auf -45° ausrichten" einfügen -->

* Sensormodul mit Hilfe des Geodreiecks so ausrichten, dass der Laser in einem 45°-Winkel nach unten scheint.
* „CAL-Taste" drücken, um die Kalibrierung in „−45.0°" zu starten.

Im Display erscheint **„don't move"** – gefolgt von einem Zahlenwert für „−45.0°".

Die Kalibrierung für die Ausrichtung mit Bodenplatte nach unten ist nun abgeschlossen. Im Display erscheint **„Calb Data stored"**.

### Schritt 7
Wird das Sensormodul ausschließlich mit der Bodenplatte nach unten betrieben, muss nichts weiter gemacht werden.

Wird ein Betrieb mit einer anderen Ausrichtung gewünscht, sind die folgenden Arbeiten ab Schritt 8 durchzuführen!

Um den Kalibriermodus zu verlassen, schalten Sie das Displaymodul durch Drücken der „Power-Taste" aus.
Beim erneuten Einschalten – ohne die „CAL-Taste" zu drücken – befindet sich das Gerät wieder in seinem normalen Betriebsmodus.

### Schritt 8
Wird der Betrieb des Sensormoduls gewünscht, bei der die Bodenplatte eine andere Position einnimmt, muss die Kalibrierung fortgesetzt werden.

Die Reihenfolge der vier möglichen Positionen ist wie folgt festgelegt (Sichtweise auf den XLR-Stecker vom Sensormodul):

| Ausrichtung                                       | Displaytext   |
|---------------------------------------------------|---------------|
| I. Bodenplatte unten (Werkskalibrierung)          | Mpl Down¹     |
| II. Bodenplatte oben                              | Mpl Up        |
| III. Bodenplatte links                            | Mpl Left      |
| IV. Bodenplatte rechts                            | Mpl Right     |

¹ Mpl: Mounting plate.

!!! info "Hinweis"
    Für eine bessere Übersichtlichkeit, welche der Ausrichtungen (I.–IV.) im Moment kalibriert wird, zeigt das Display kurzzeitig den in der Tabelle angegebenen Displaytext an.

!!! info "Hinweis"
    Anmerkung zu Schritt 3: Da sich das System bereits im Kalibriermodus befindet, entfällt die Betätigung der „Power-Taste". Die Kalibrierung startet unmittelbar mit der Kalibrierung von Position „A", wenn die „CAL-Taste" gedrückt wird.

Wurden Schritt 2 bis Schritt 6 mit der geänderten Ausrichtung der Bodenplatte korrekt durchgeführt, ohne zwischenzeitlichen Hinweis im Display **„Sens pos incorrect"**, schließt die Kalibrierung dieser Ausrichtung mit der Displayanzeige **„Calb Data stored"**.

Jetzt kann das Sensormodul mit der Bodenplatte nach unten und der Bodenplatte nach oben betrieben werden. Genügen diese Positionen, kann der Kalibriermodus durch Abschalten mit der „Power-Taste" verlassen werden.

Werden auch die seitlichen Positionen gewünscht, müssen Schritt 2 bis Schritt 6 zunächst mit der Bodenplatte nach links (Sichtweise auf den XLR-Stecker am Sensormodul) wiederholt werden. Für die Ausrichtung mit Bodenplatte nach rechts (Sichtweise auf den XLR-Stecker am Sensormodul) muss die Kalibrierung Schritt 2 bis Schritt 6 ein weiteres Mal durchlaufen werden.

Nun kann das Sensormodul in allen vier Positionen betrieben werden.

## 8.1 Kalibrierung von 2 Achsen
* „CAL-Taste" auf dem Displaymodul drücken und halten.
* „Power-Taste" auf dem Displaymodul drücken.
* Sobald der „Welcome"-Schriftzug am unteren Displayrand erscheint, beide Tasten loslassen.

Das System befindet sich jetzt im Kalibriermodus und zeigt dies im oberen Displaybereich durch **„start calibrte?"** an.

* „CAL-Taste" auf dem Displaymodul für ca. 20 Sekunden drücken und halten, um in den **„2-axis mode"** zu gelangen.

Im Display erscheint die Frage **„calibrte 0.0° A?"**.

* Für die weitere Kalibrierung folgen Sie der Beschreibung wie in Schritt 3, Punkt 5 bis einschließlich Schritt 6 aufgeführt.

Zusätzlich folgt noch die Kalibrierung der X-Achse +45°/−45°.

Nach Beendigung der Kalibrierung erscheinen im Display die Werte der X- und Y-Achse. Nach Ausschalten und erneutem Einschalten ist die „Libelle" zu sehen.
