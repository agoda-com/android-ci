#!/bin/bash

adb devices | egrep 'device$' | cut -f 1 | while read serial
do
    echo -n | timeout 10s adb -s "$serial" shell "am broadcast -a com.agoda.PING -n com.agoda.connectionwatchdog/.PingReceiver"
done
