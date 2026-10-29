#!/bin/bash
find . -type f -name "*.gd" -not -path "*/addons/*" -exec wc -l {} \; | awk '{sum+=$1} END {printf "Gesamtzeilen aller .gd-Dateien (ohne addons): %d\n", sum}'
