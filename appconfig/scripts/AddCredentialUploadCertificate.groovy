/*** BEGIN META {
  "name" : "AddCredentialUploadCertificate.groovy",
  "comment" : "Add Credential by Uploading Certificate",
  "parameters" : "keyfile;description;password",
  "authors" : "Bhawna Goyal"
} END META**/

import com.cloudbees.plugins.credentials.impl.*;
import com.cloudbees.plugins.credentials.*;
import com.cloudbees.plugins.credentials.domains.*;

String keyfile = args[0]
String description = args[1]
String password = args[2]

def ksm2 = new CertificateCredentialsImpl.UploadedKeyStoreSource(keyfile)
Credentials ck2 = new CertificateCredentialsImpl(CredentialsScope.GLOBAL,UUID.randomUUID().toString(), description, password, ksm2)

SystemCredentialsProvider.getInstance().getStore().addCredentials(Domain.global(), ck2)
