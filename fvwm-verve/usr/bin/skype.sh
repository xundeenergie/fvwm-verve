#!/bin/bash

# Manchmal ist das Skype-Fenster außerhalb des Desktops. Dieses Wrapper-Skript bringt Skype bei JEDEM Start in die linke obere Ecke des Desktops
#
sed -i -e 's/\(<[xX]>\)-*[0-9][0-9]*\(<\/[xX]>\)/\10\2/;s/\(<[yY]>\)-*[0-9][0-9]*\(<\/[yY]>\)/\10\2/' ~/.Skype/shared.xml
/usr/bin/skype
