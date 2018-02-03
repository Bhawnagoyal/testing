/*** BEGIN META {
  "name" : "ldapconfigurator.groovy",
  "comment" : "Add Jenkins LDAP",
  "parameters" : "ldap_cong.cfg file",
  "authors" : "Bhawna Goyal"
} END META**/

import jenkins.model.*
import hudson.security.*
import org.jenkinsci.plugins.*

String server = args[0]
String rootDN = args[1]
String userSearchBase = args[2]
String userSearch = args[3]
String groupSearchBase = args[4]
String managerDN = args[5]
String managerPassword = args[6]
boolean inhibitInferRootDN = args[7]

SecurityRealm ldap_realm = new LDAPSecurityRealm(server, rootDN, userSearchBase, userSearch, groupSearchBase, managerDN, managerPassword, inhibitInferRootDN)
Jenkins.instance.setSecurityRealm(ldap_realm)
Jenkins.instance.save()
