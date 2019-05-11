FROM openjdk:11-jre-slim
#FROM azul/zulu-openjdk-alpine:11

ENV GATLING_HOME=/gatling-charts-highcharts-bundle-3.0.2

COPY entrypoint.sh .
COPY gatling-charts-highcharts-bundle-3.0.2-bundle.zip .
RUN unzip gatling-charts-highcharts-bundle*.zip \
    && rm gatling-charts-highcharts-bundle*.zip

#ENV SIMULATION_NAME=computerdatabase.BasicSimulation
ENV SIMULATION_NAME=c2gwebaws.C2gwebSimulation

ADD c2gwebaws /gatling-charts-highcharts-bundle-3.0.2/user-files/simulations

ENTRYPOINT ["/entrypoint.sh"]
