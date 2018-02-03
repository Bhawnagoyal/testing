/*** BEGIN META {
  "name" : "AddCredentialJenkinsMasterCertificate.groovy",
  "comment" : "Add Credential by using Master Jenkins Certificate",
  "parameters" : "keyfile;description;password",
  "authors" : "Bhawna Goyal"
} END META**/

import com.cloudbees.plugins.credentials.impl.*;
import com.cloudbees.plugins.credentials.*;
import com.cloudbees.plugins.credentials.domains.*;

String keyfile = args[0]
String description = args[1]
String password = args[2]

def ksm1 = new CertificateCredentialsImpl.FileOnMasterKeyStoreSource(keyfile)
Credentials ck1 = new CertificateCredentialsImpl(CredentialsScope.GLOBAL,UUID.randomUUID().toString(), description, password, ksm1)

SystemCredentialsProvider.getInstance().getStore().addCredentials(Domain.global(), ck1)
