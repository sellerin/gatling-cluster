FROM openjdk:11-jre-slim

ENV GATLING_HOME=/gatling-charts-highcharts-bundle-3.0.2

COPY entrypoint.sh .
COPY gatling-charts-highcharts-bundle-3.0.2-bundle.zip .
RUN apt-get update && \
    apt-get install zip -y && \
    unzip gatling-charts-highcharts-bundle*.zip \
    && rm gatling-charts-highcharts-bundle*.zip

#ENV SIMULATION_NAME=computerdatabase.BasicSimulation
ENV SIMULATION_NAME=c2gwebaws.C2gwebSimulation
ENV NBUSERS=2
ENV RAMP=10
ENV DURATION=300

ENTRYPOINT ["/entrypoint.sh"]
