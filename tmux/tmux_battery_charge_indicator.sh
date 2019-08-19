#!/bin/bash

HEART='♥'

if [[ `uname` == 'Linux' ]]; then
  battery_info=$(upower -i $(upower -e | grep BAT))
  current_charge=$(echo $battery_info | grep -o 'energy: \+[0-9]\+' | awk '{print $2}')
  total_charge=$(echo $battery_info | grep -o 'energy-full-design: \+[0-9]\+' | awk '{print $2}')
  charging=$(echo $battery_info | grep -c 'state: \+charging')
  fully_charged=$(echo $battery_info | grep -c 'state: \+fully-charged')
else
  battery_info=`ioreg -rc AppleSmartBattery`
  current_charge=$(echo $battery_info | grep -o '"CurrentCapacity" = [0-9]\+' | awk '{print $3}')
  charging=$(echo $battery_info | grep -c "\"IsCharging\" = Yes")
  fully_charged=$(echo $battery_info | grep -c "\"FullyCharged\" = Yes")
  total_charge=$(echo $battery_info | grep -o '"MaxCapacity" = [0-9]\+' | awk '{print $3}')
fi

charged_slots=$(echo "(($current_charge/$total_charge)*10)+1" | bc -l | cut -d '.' -f 1)
if [[ $charged_slots -gt 10 ]]; then
  charged_slots=10
fi

if [ "$charging" == "1" ] || [ "$fully_charged" == "1" ]; then
  echo -n '#[fg=yellow]'
else
  echo -n '#[fg=red]'
fi

for i in `seq 1 $charged_slots`; do echo -n "$HEART"; done

if [[ $charged_slots -lt 10 ]]; then
  echo -n '#[fg=white]'
  for i in `seq 1 $(echo "10-$charged_slots" | bc)`; do echo -n "$HEART"; done
fi
