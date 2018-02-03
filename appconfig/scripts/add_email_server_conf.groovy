/*** BEGIN META {
  "name" : "add_email_server_conf.groovy",
  "comment" : "Add EMAIL Server automatic Installation",
  "parameters" : "Null",
  "authors" : "Bhawna Goyal"
} END META**/

import jenkins.model.*

String smtp_user = args[0]
String smtp_pwd = args[1]
String reply_mailid = args[2]
String smtp_host = args[3]
boolean usessl = false
String smtp_port = args[4]
String char_set = args[5]

def inst = Jenkins.getInstance()

def desc = inst.getDescriptor("hudson.tasks.Mailer")

desc.setSmtpAuth(smtp_user, smtp_pwd)
desc.setReplyToAddress(reply_mailid)
desc.setSmtpHost(smtp_host)
desc.setUseSsl(usessl)
desc.setSmtpPort(smtp_port)
desc.setCharset(char_set)

desc.save()
inst.save()
println "OK - Email Server Configuration Updated"
