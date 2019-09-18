#!/bin/bash
export CURL_CA_BUNDLE=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
NAMESPACE=$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)

aggregate () {

  rm -rf $GATLING_HOME/results/*
  mkdir $GATLING_HOME/results/reports
  simulation_name="$SIMULATION_ID"
  
  cpt="1"
  for d in /results/*/ ; do

    if [ -e $d/simulation.log ]
    then
      cp $d/simulation.log $GATLING_HOME/results/reports/simulation-$cpt.log
      cpt=$((cpt+1))
    fi

  done

  cd $GATLING_HOME/bin
  ./gatling.sh -ro reports

  if [ ! -d "/aggregated-reports/reports" ]
  then
    mkdir /aggregated-reports/reports
  fi

  if [ -d "/aggregated-reports/reports/$simulation_name" ]
  then
    rm -rf /aggregated-reports/reports/$simulation_name/*
    rmdir /aggregated-reports/reports/$simulation_name
  fi

  mkdir /aggregated-reports/reports/$simulation_name
  cp -a $GATLING_HOME/results/reports/.  /aggregated-reports/reports/$simulation_name/

  nginx_ip=$(curl -H "Authorization: Bearer $TOKEN" -s https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT/api/v1/namespaces/$NAMESPACE/services/static-web | jq -r '.status.loadBalancer.ingress[0].ip')
  echo "Report created. Open it http://$nginx_ip/reports/$simulation_name"

}

START=$SECONDS
TIMEOUT=$(($DURATION + 3600))

while : ; do  
  status=$(curl -H "Authorization: Bearer $TOKEN" -s https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT/apis/batch/v1/namespaces/$NAMESPACE/jobs/batch-job-${SIMULATION_ID}/status)
  nbcompletions=$(echo "$status" | jq '.spec.completions')
  nbsucceed=$(echo "$status" | jq '.status.succeeded')
  nbfailed=$(echo "$status" | jq '.status.failed')
  nbactive=$(echo "$status" | jq '.status.active')

  echo "NB JOBS TO BE COMPLETED: $nbcompletions; NB ACTIVE JOBS: $nbactive; NB SUCCEEDED JOBS: $nbsucceed; NB FAILED JOBS: $nbfailed"

  if [ "$nbfailed" != "null" ]
  then
    echo "BATCH FAILED"
    exit 0
  fi

  if [ "$nbsucceed" == "$nbcompletions" ]
  then
    echo "BATCH IS TERMINATED"
    aggregate
    exit 0
  fi

  sleep 5

  END=$SECONDS
  DIFF=$(( END - START ))
  if [ "$DIFF" -gt "$TIMEOUT" ]
  then
    echo "BATCH TIMEOUT AFTER $TIMEOUTs"
    exit 0
  fi
done
