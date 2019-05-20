package c2gwebaws

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._

class C2gwebSimulation extends Simulation {

  val nbUsers = Integer.getInteger("users", 1)
  val myRamp = java.lang.Long.getLong("ramp", 0L)
  val myDuration = java.lang.Long.getLong("duration", 0L)

  val httpProtocol = http
    .baseUrl("https://c2gweb-dev.renault.com") // Here is the root for all relative URLs
    .acceptHeader("application/json,text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8") // Here are the common headers
    .doNotTrackHeader("1")
    .acceptLanguageHeader("en-US,en;q=0.5")
    .acceptEncodingHeader("gzip, deflate")
    .userAgentHeader("Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:16.0) Gecko/20100101 Firefox/16.0")

  val headers_10 = Map("Content-Type" -> "application/x-www-form-urlencoded") // Note the headers specific to a given request

  val scn = scenario("Scenario Name").during(myDuration) {
    .exec(http("request_1")
      .get("/se/pub/docs"))
    .pause(2)
    .exec(http("request_2")
      .get("/se/pub/doc/BAh"))
    .pause(2)
    .exec(http("request_3")
      .get("/se/pub/c/BAh/A"))
    .pause(3)
    .exec(http("request_4")
      .get("/se/pub/c/BAh/AANg"))
    .pause(2)
    .exec(http("request_5")
      .get("/se/pub/c/BAh/AANg?complete=versionbase&complete=arbitrary"))
    .pause(2)
  }

  setUp(scn.inject(rampUsers(nbUsers) over (myRamp seconds)).protocols(httpProtocol))
}
