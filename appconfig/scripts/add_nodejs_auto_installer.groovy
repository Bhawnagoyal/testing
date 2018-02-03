/*** BEGIN META {
  "name" : "add_nodejs_auto_installer.groovy",
  "comment" : "Add NodeJS automatic Installation",
  "parameters" : "Null",
  "authors" : "Bhawna Goyal"
} END META**/

import hudson.model.*
import hudson.tools.*
import jenkins.plugins.nodejs.tools.*
import jenkins.model.*

String name = args[0]
String dir = args[1]
String version = args[2]

def inst = Jenkins.getInstance()

def desc = inst.getDescriptor(jenkins.plugins.nodejs.tools.NodeJSInstallation)

def installer = new NodeJSInstaller(version, args[3], 100)

def prop = new InstallSourceProperty([installer])

def sinst = new NodeJSInstallation(name, dir,[prop])

desc.setInstallations(sinst)

desc.save()
inst.save()
println "OK - NodeJs Installation"
