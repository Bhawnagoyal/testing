/*** BEGIN META {
  "name" : "add_ant_auto_installer.groovy",
  "comment" : "Add ANT automatic Installation",
  "parameters" : "Null",
  "authors" : "Bhawna Goyal"
} END META**/

import jenkins.model.*

println "Adding an auto installer for Ant 1.10.1"

def antPluginExtension = Jenkins.instance.getExtensionList(hudson.tasks.Ant.DescriptorImpl.class)[0]

def asList = (antPluginExtension.installations as List)
asList.add(new hudson.tasks.Ant.AntInstallation('ant-1.10.1', null, [new hudson.tools.InstallSourceProperty([new hudson.tasks.Ant.AntInstaller("1.10.1")])]))

antPluginExtension.installations = asList

antPluginExtension.save()

println "OK - Ant auto-installer (from Apache) added for 1.10.1"
