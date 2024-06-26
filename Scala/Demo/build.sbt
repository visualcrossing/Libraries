ThisBuild / version := "0.1.0-SNAPSHOT"

ThisBuild / scalaVersion := "3.3.3"

lazy val root = (project in file("."))
  .settings(
    name := "Demo"
  )

libraryDependencies ++= Seq(
  "org.json4s" %% "json4s-native" % "4.0.6",
  "org.json4s" %% "json4s-jackson" % "4.0.6"
)
