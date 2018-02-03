/*** BEGIN META {
  "name" : "AddUserPwdCred.groovy",
  "comment" : "Add Credential Username with Password",
  "parameters" : "id;description;user;password",
  "authors" : "Bhawna Goyal"
} END META**/

import jenkins.model.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.common.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.plugins.credentials.impl.*
import com.cloudbees.jenkins.plugins.sshcredentials.impl.*
import hudson.plugins.sshslaves.*;

String id = args[0]
String description = args[1]
String user = args[2]
String password = args[3]

domain = Domain.global()
store = Jenkins.instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()

usernameAndPassword = new UsernamePasswordCredentialsImpl(
  CredentialsScope.GLOBAL,
  id, description,
  user,
  password
)

store.addCredentials(domain, usernameAndPassword)
