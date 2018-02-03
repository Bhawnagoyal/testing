#########################################################################################
#  Description:	 Script to add LDAP Configuration- jenkins_ldap_conf.sh
#  Author: Bhawna Goyal
#  Date: 19/03/2017
#  Action History
#  Date 	Version	 Author	     	  Description
#  ----------	-------	 ------------     ---------------
#  19/03/2017	1.0	 Bhawna Goyal	  Version initial
#
#########################################################################################
#set -x

SCRIPTS_PATH=`pwd`

exit_error_parameter() {
	echo "Script to add LDAP Configuration - "
	echo "Usage: $(basename $0)"
	echo "	-h: Help"
	exit 1
}

exit_error_log() {
        echo  "Error in creation of log: ${FILE_LOG}"
        exit 2
}

exit_error_validation() {
        echo "Errors in validation !!!" | tee -a  $FILE_LOG
        exit 3
}

exit_error_cfg() {
        echo "Error : config file is not available "
        exit 4
}

#Parameters
Jenkins_Cfg=${SCRIPTS_PATH}/../config/jenkins_conf.cfg
LOGDIR=${SCRIPTS_PATH}/../logs
LDAP_CFG=${SCRIPTS_PATH}/../config/ldap_conf.cfg

#Config file
if [ ! -f ${Jenkins_Cfg} ]
then
	exit_error_cfg
fi

#Config file
if [ ! -f ${LDAP_CFG} ]
then
	exit_error_cfg
fi

#Log
DATE=`date +%Y%m%d%H%M%S`
FILE_LOG=$LOGDIR/$(basename $0)_${DATE}.log
if [ -f ${FILE_LOG} ] ; then rm ${FILE_LOG} ; fi
touch ${FILE_LOG}
if [ $? -ne 0 ]
then
     exit_error_log
fi

#Extract Variables
JENKINS_URL=$(cat ${Jenkins_Cfg} | grep Jenkins_URL | cut -d= -f2)
JENKINS_USER=$(cat ${Jenkins_Cfg} | grep Jenkins_Admin_User | cut -d= -f2)
JENKINS_PWD=$(cat ${Jenkins_Cfg} | grep Jenkins_Admin_Pwd | cut -d= -f2)

echo "-----------------------------------------------------------------------------" | tee -a  $FILE_LOG
echo "-                           $(basename $0)                                  -" | tee -a  $FILE_LOG
echo "-----------------------------------------------------------------------------" | tee -a  $FILE_LOG
echo " Parameters Entered:" | tee -a  $FILE_LOG
echo " - Jenkins URL  		-> ${JENKINS_URL}" | tee -a  $FILE_LOG
echo " - Jenkins User    	-> ${JENKINS_USER}" | tee -a  $FILE_LOG
echo "-----------------------------------------------------------------------------" | tee -a  $FILE_LOG
echo "                                                                             " | tee -a $FILE_LOG

#verifying Jenkins-cli.jar
if [ ! -f ${SCRIPTS_PATH}/jenkins-cli.jar ]
then
	echo "jenkins-cli.jar not found. Please download jenkins-cli.jar from console........" | tee -a $FILE_LOG
  #wget ${JENKINS_URL}jenkins/jnlpJars/jenkins-cli.jar  | tee -a $FILE_LOG
	echo "                                                                             " | tee -a $FILE_LOG
  exit 5
fi

#Executing Jenkins CLI
echo "Current Jenkins Version" | tee -a $FILE_LOG
java -jar ${SCRIPTS_PATH}/jenkins-cli.jar -s ${JENKINS_URL} version --username ${JENKINS_USER} --password ${JENKINS_PWD} | tee -a $FILE_LOG
if [ $? -ne 0 ]
then
     exit_error_validation
fi
echo "																																									" | tee -a $FILE_LOG

Server=$(cat ${LDAP_CFG} | grep server | cut -d$ -f2)
RootDN=$(cat ${LDAP_CFG} | grep rootDN | cut -d$ -f2)
UserSearchBase=$(cat ${LDAP_CFG} | grep userSearchBase | cut -d$ -f2)
User_Search=$(cat ${LDAP_CFG} | grep user_Search | cut -d$ -f2)
GroupSearchBase=$(cat ${LDAP_CFG} | grep groupSearchBase | cut -d$ -f2)
ManagerDN=$(cat ${LDAP_CFG} | grep managerDN | cut -d$ -f2)
ManagerPassword=$(cat ${LDAP_CFG} | grep managerPassword | cut -d$ -f2)
InhibitInferRootDN=$(cat ${LDAP_CFG} | grep inhibitInferRootDN | cut -d$ -f2)


echo "Adding LDAP Configuration....." | tee -a $FILE_LOG
#echo "$Server" "$RootDN" "$UserSearchBase" "$User_Search" "$GroupSearchBase" "$ManagerDN" "$ManagerPassword" "$InhibitInferRootDN"
java -jar ${SCRIPTS_PATH}/jenkins-cli.jar -s ${JENKINS_URL} groovy ${SCRIPTS_PATH}/ldapconfigurator.groovy "$Server" "$RootDN" "$UserSearchBase" "$User_Search" "$GroupSearchBase" "$ManagerDN" "$ManagerPassword" "$InhibitInferRootDN" --username ${JENKINS_USER} --password ${JENKINS_PWD} | tee -a $FILE_LOG
echo "																																									" | tee -a $FILE_LOG

exit 0
