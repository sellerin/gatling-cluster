#!/bin/ash
GATLING_HOME=/gatling-charts-highcharts-bundle-3.0.2
RESULT_TARGET=/gatling/result

#Launch test
$GATLING_HOME/bin/gatling.sh -s computerdatabase.BasicSimulation

#Copy results to mounted volume
#mkdir $RESULT_TARGET/$HOSTNAME
#cp -a $GATLING_HOME/results/. $RESULT_TARGET/$HOSTNAME/
