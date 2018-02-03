/*** BEGIN META {
  "name" : "set_slave_agent_port.groovy",
  "comment" : "Add agent port for slaves",
  "parameters" : "port",
  "authors" : "Bhawna Goyal"
} END META**/

import jenkins.model.*
import hudson.model.*

def instance = Jenkins.getInstance()

instance.setSlaveAgentPort(5000)

instance.save()
println "OK - Jenkins Slave Agent port Updated"
