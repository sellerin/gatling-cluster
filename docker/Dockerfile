FROM openjdk:8u181-jdk-alpine3.8

COPY entrypoint.sh .
COPY gatling-charts-highcharts-bundle-3.0.2-bundle.zip .
RUN unzip gatling-charts-highcharts-bundle*.zip \
    && rm gatling-charts-highcharts-bundle*.zip

#CMD ["./gatling-charts-highcharts-bundle-3.0.2/bin/gatling.sh","-s","computerdatabase.BasicSimulation"]
ENTRYPOINT ["/entrypoint.sh"]