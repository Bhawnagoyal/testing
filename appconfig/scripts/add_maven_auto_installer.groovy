/*** BEGIN META {
  "name" : "add_maven_auto_installer.groovy",
  "comment" : "Add MAVEN automatic Installation",
  "parameters" : "Null",
  "authors" : "Bhawna Goyal"
} END META**/

import jenkins.model.*

println "Adding an auto installer for Maven 3.3.9"

def mavenPluginExtension = Jenkins.instance.getExtensionList(hudson.tasks.Maven.DescriptorImpl.class)[0]

def asList = (mavenPluginExtension.installations as List)
asList.add(new hudson.tasks.Maven.MavenInstallation('maven-3.3.9', null, [new hudson.tools.InstallSourceProperty([new hudson.tasks.Maven.MavenInstaller("3.3.9")])]))

mavenPluginExtension.installations = asList

mavenPluginExtension.save()

println "OK - Maven auto-installer (from Apache) added for 3.3.9"
