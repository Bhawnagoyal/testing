#########################################################################################
#  Description:	 Script to add JDK Installation
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
	echo "Script to add JDK Installation - "
	echo "Usage: $(basename $0)  <ORACLE/LOCAL>"
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
JDKCFG=${SCRIPTS_PATH}/../config/jdk_install.cfg

#Config file
if [ ! -f ${Jenkins_Cfg} ]
then
	exit_error_cfg
fi

#Config file
if [ ! -f ${JDKCFG} ]
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
ORACLE_ID=$(cat ${JDKCFG} | grep Oracle_ID | cut -d= -f2)
ORACLE_PWD=$(cat ${JDKCFG} | grep Oracle_PWD | cut -d= -f2)

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
if [ $1 = "ORACLE" ];then
grep 'ORACLE_JDK' ${JDKCFG} | while IFS=: read -r f1 f2 f3
    do
			echo "Adding JDK Installation $f1....." | tee -a $FILE_LOG
			java -jar ${SCRIPTS_PATH}/jenkins-cli.jar -s ${JENKINS_URL} groovy ${SCRIPTS_PATH}/add_jdk_oracle_cred.groovy "$ORACLE_ID" "$ORACLE_PWD" --username ${JENKINS_USER} --password ${JENKINS_PWD} | tee -a $FILE_LOG
			sleep 5
			java -jar ${SCRIPTS_PATH}/jenkins-cli.jar -s ${JENKINS_URL} groovy ${SCRIPTS_PATH}/add_jdk_oracle_install.groovy "$f2" "$f3" --username ${JENKINS_USER} --password ${JENKINS_PWD} | tee -a $FILE_LOG
			sleep 5
			echo "																																									" | tee -a $FILE_LOG
		done
fi

if [ $1 = "LOCAL" ];then
grep 'LOCAL_JDK' ${JDKCFG} | while IFS=: read -r f1 f2 f3
		do
			echo "Adding JDK Installation $f1....." | tee -a $FILE_LOG
			java -jar ${SCRIPTS_PATH}/jenkins-cli.jar -s ${JENKINS_URL} groovy ${SCRIPTS_PATH}/add_jdk_local_install.groovy "$f2" "$f3" --username ${JENKINS_USER} --password ${JENKINS_PWD} | tee -a $FILE_LOG
			sleep 5
			echo "																																									" | tee -a $FILE_LOG
		done
fi
exit 0
