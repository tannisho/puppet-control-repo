#!/bin/bash
AI=`/opt/local_scripts/fact_scripts/main_interface.py`

ip addr show $AI|grep ether|awk '{print $2}'
