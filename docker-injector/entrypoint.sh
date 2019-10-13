#!/bin/bash

export JAVA_OPTS="-Dusers=$NBUSERS -Dramp=$RAMP -Dduration=$DURATION -Ddata=$DATA"

#Launch test
$GATLING_HOME/bin/gatling.sh -s $SIMULATION_NAME
