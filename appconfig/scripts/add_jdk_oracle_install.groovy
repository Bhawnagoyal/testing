/*** BEGIN META {
  "name" : "add_jdk_oracle_install.groovy",
  "comment" : "Add Oracle JDK Version for Installation",
  "parameters" : "jdkname:java_version",
  "authors" : "Bhawna Goyal"
} END META**/

import jenkins.model.*
import hudson.model.*
import hudson.tools.*

String jdk_name = args[0]
String jdk_version = args[1]

def inst = Jenkins.getInstance()

def desc = inst.getDescriptor("hudson.model.JDK")

def versions = [
  jdk_name: jdk_version
]
def installations = [];

for (v in versions) {
  def installer = new JDKInstaller(v.value, true)
  def installerProps = new InstallSourceProperty([installer])
  def installation = new JDK(v.key, "", [installerProps])
  installations.push(installation)
}

desc.setInstallations(installations.toArray(new JDK[0]))

desc.save()
inst.save()
println "OK - Oracle JDK Installation Updated"
