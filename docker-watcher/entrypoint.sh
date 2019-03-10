#!/bin/bash
export CURL_CA_BUNDLE=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)

aggregate () {

  rm -rf $GATLING_HOME/results/*
  mkdir $GATLING_HOME/results/reports

  cpt="1"
  for d in /results/*/ ; do

    if [ -e $d/simulation.log ]
    then
      if [ "$cpt" == "1" ]
      then
        [[ "$d" =~ ^.*/(.*-.*)/$ ]]
        simulation_name="${BASH_REMATCH[1]}"
      fi

      cp $d/simulation.log $GATLING_HOME/results/reports/simulation-$cpt.log
      cpt=$((cpt+1))
    fi

  done

  cd $GATLING_HOME/bin
  ./gatling.sh -ro reports

  if [ ! -d "/results/reports" ]
  then
    mkdir /results/reports
  fi

  if [ -d "/results/reports/$simulation_name" ]
  then
    rm -rf /results/reports/$simulation_name/*
    rmdir /results/reports/$simulation_name
  fi

  mkdir /results/reports/$simulation_name
  cp -a $GATLING_HOME/results/reports/.  /results/reports/$simulation_name/

  nginx_ip=$(curl -H "Authorization: Bearer $TOKEN" -s https://kubernetes/api/v1/namespaces/default/services/static-web | jq -r '.status.loadBalancer.ingress[0].ip')
  echo "Report created. Open it http://$nginx_ip/reports/$simulation_name"

}

START=$SECONDS

while : ; do
  status=$(curl -H "Authorization: Bearer $TOKEN" -s https://kubernetes/apis/batch/v1/namespaces/default/jobs/batch-job/status)
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
  if [ "$DIFF" -gt "300" ]
  then
    echo "BATCH TIMEOUT AFTER 300s"
    exit 0
  fi
done
