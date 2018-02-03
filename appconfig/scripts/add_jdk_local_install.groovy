/*** BEGIN META {
  "name" : "add_jdk_local_install.groovy",
  "comment" : "Add Oracle JDK Version for Installation",
  "parameters" : "jdkname:java_home",
  "authors" : "Bhawna Goyal"
} END META**/

import jenkins.model.*
import hudson.model.*
import hudson.tools.*

String jdk_name = args[0]
String jdk_home = args[1]

list = null;

dis = new hudson.model.JDK.DescriptorImpl();
dis.setInstallations( new hudson.model.JDK(jdk_name, jdk_home));

println "OK - JDK Installation Updated"
