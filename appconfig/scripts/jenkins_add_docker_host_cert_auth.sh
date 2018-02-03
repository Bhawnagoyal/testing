#########################################################################################
#  Description:	 Script to Add Docker Host Certificate Directory in Jenkins-
#  Author: Bhawna Goyal
#  Date: 19/03/2017
#  Action History
#  Date 	Version	 Author	     	  Description
#  ----------	-------	 ------------     ---------------
#  19/03/2017	1.0	 Bhawna Goyal	  Version initial
# Rights reserved
#########################################################################################
#set -x

SCRIPTS_PATH=`pwd`

exit_error_parameter() {
	echo "Script to Add Jenkins Credentials Docker Cert Directory- "
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
DOCKER_Auth=${SCRIPTS_PATH}/../config/Docker_Host_Cert_Auth.xml

#Config file
if [ ! -f ${Jenkins_Cfg} ]
then
	exit_error_cfg
fi

if [ ! -f ${DOCKER_Auth} ]
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
JENKINS_STORE=$(cat ${Jenkins_Cfg} | grep Jenkins_STORE | cut -d= -f2)
JENKINS_DOMAIN=$(cat ${Jenkins_Cfg} | grep Jenkins_DOMAIN | cut -d= -f2)

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

Description=$(grep description ${DOCKER_Auth}|cut -d'>' -f2|cut -d'<' -f1)

echo "Adding Docker Host Certificate Authorization with Description- ${Description}...." | tee -a $FILE_LOG
cat ${DOCKER_Auth} | java -jar ${SCRIPTS_PATH}/jenkins-cli.jar -s ${JENKINS_URL} create-credentials-by-xml ${JENKINS_STORE} ${JENKINS_DOMAIN} --username ${JENKINS_USER} --password ${JENKINS_PWD} | tee -a $FILE_LOG
sleep 5
java -jar ${SCRIPTS_PATH}/jenkins-cli.jar -s ${JENKINS_URL} list-credentials ${JENKINS_STORE} --username ${JENKINS_USER} --password ${JENKINS_PWD} | grep ${Description} | tee -a $FILE_LOG
sleep 5
echo "                                                                             " | tee -a $FILE_LOG
exit 0
