/*** BEGIN META {
  "name" : "AddSSHUserPrivateKey.groovy",
  "comment" : "Add Credential SSH User private Key",
  "parameters" : "id;username;description",
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
String username = args[2]

domain = Domain.global()
store = Jenkins.instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()

priveteKey = new BasicSSHUserPrivateKey(
CredentialsScope.GLOBAL,
id,
username,
new BasicSSHUserPrivateKey.UsersPrivateKeySource(),
"",
description
)

store.addCredentials(domain, priveteKey)
