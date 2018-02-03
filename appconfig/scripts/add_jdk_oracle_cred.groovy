/*** BEGIN META {
  "name" : "add_jdk_oracle_cred.groovy",
  "comment" : "Add Oracle JDK Credentials for Installation",
  "parameters" : "username;password",
  "authors" : "Bhawna Goyal"
} END META**/

import jenkins.model.*
import hudson.model.*
import hudson.tools.*

String username = args[0]
String password = args[1]

def inst = Jenkins.getInstance()

def desc = inst.getDescriptor("hudson.tools.JDKInstaller")

println desc.doPostCredential(username, password)

desc.save()
inst.save()
println "OK - Oracle Credentials Updated"
