#! /bin/sh -p
# Commented out for debugging and error trapping
#set -x
#************************************************************************
#
# (c) 2011 NU-TEKK Ltd All Rights Reserved 
#
#************************************************************************
# MODULE NAME:          7126_07_01.sh
# ORIGINAL AUTHOR:      Andy Penver
# DATE:                 15-FEB-2012
# DESCRIPTION:
#
# Installation Script for Chapter 7 to be installed within APPS database schema
#
# PARAMETERS:
#
# NAME            TYPE        DESCRIPTION
# -------------   ------      -------------------------------------------
# ID_PSWD         CHAR        Schema username and password (e.g. apps/apps123)
# INSTALL_FROM    CHAR        Installation Directory
#
# CHANGE HISTORY:
#
# VERSION  DATE           AUTHOR              DESCRIPTION
# -------- -----------    ------------------  -------------------------------
# 1.0      15-FEB-2012    Andy Penver         Initial Version
#************************************************************************
#
#+------------------------------------------------------+
#+ Parameters obtained from concurrent request          +
#+------------------------------------------------------+
#
echo "Started Script"
l_apps_user_pswd=${1}

l_install_from=${2}

CUST_TOP=$XXHR_TOP

l_reference="7126_01_01"

if [ -z "${l_reference}" ] ; then
   echo
   echo "Extension reference is not set"
   echo
   exit
fi

l_log_file=XXHR_${l_reference}.log

rm -f ${l_log_file} 1>/dev/null 2>/dev/null

if [ -z "${l_apps_user_pswd}" ] ; then
   echo
   echo "Must supply username and password for APPS e.g. apps/apps123"
   echo
   exit
fi

#
#+------------------------------------------------------+
#+ Check that we have access to FNDLOAD                 +
#+------------------------------------------------------+
#
whence FNDLOAD 1>/dev/null 2>/dev/null
status=$?
if [ ${status} -ne 0 ] ; then
   echo "ERROR :- Unable to access FNDLOAD.  Please add the FNDLOAD to PATH"
   exit 
fi

l_control_file_list=""

l_profile_list=""

l_value_set_list=""

l_conc_progs_list=""

l_seed_list=""

l_db_object_list="XXHR_PARTY_UPLOAD.sql \
                  XXHR_PARTY_UPLOAD_SEQ.sql"

l_trigger_list=""

l_db_pkg_list="XXHR_PARTY_IPLOAD_PKG.pks \
               XXHR_PARTY_UPLOAD_PKG.pkb"

l_wf_list=""

l_shell_list=""

l_ctl_list=""

l_rep_list=""

l_sql_list=""

l_file_list="${l_profile_list} ${l_seed_list} ${l_db_object_list}  \
             ${l_db_pkg_list} ${l_wf_list} ${l_shell_list} ${l_ctl_list} \
             ${l_rep_list} ${l_trigger_list} ${l_sql_list} ${l_value_set_list} \
             ${l_conc_progs_list}" 

if [ -z "${l_install_from}" ] ; then
   echo
   echo "Assuming all files are in the current directory"
   echo
   l_install_from=`pwd`
fi

#
#+------------------------------------------------------+
#+ Declare any functions for this script                +
#+------------------------------------------------------+
#
#+------------------------------------------------------+
#+ Name:        WRITE_MESSAGE                           +
#+ Description: Display a message to the log file       +
#+ Parameters:  message                                 +
#+------------------------------------------------------+
#
USAGE="usage: WRITE_MESSAGE message"
function WRITE_MESSAGE
{
 echo
 echo `date +"%X > "` $1
 echo

 echo                    >>${l_log_file}
 echo `date +"%X > "` $1 >>${l_log_file}
 echo                    >>${l_log_file}
}
#
#+------------------------------------------------------+
#+ Name:        CHECK_CONNECTION                        +
#+ Description: Checks the connection details           +
#+ Parameters:  username and password                   +
#+------------------------------------------------------+
#
USAGE="usage: CHECK_CONNECTION username/password"
function CHECK_CONNECTION
{
 WRITE_MESSAGE "Checking database connection details"

 l_uname_passwd=${1}

 sqlplus ${l_uname_passwd} <<+EOF+ | grep 01017
+EOF+

 l_status=${?}

 if [ ${l_status} = 0 ] ; then
    WRITE_MESSAGE "Invalid username and password"
    return 1
 fi

 WRITE_MESSAGE "Password details OK - Retrieving database name"
 
        sqlplus -s ${l_uname_passwd} <<+EOF+ >tmp.dat
         set head off
         set define off
         select 'XXX '||name
         from v\$database
         ;
+EOF+

 export SID=`cat tmp.dat|grep XXX|awk '{print $2}'`

 WRITE_MESSAGE "Installing on database $SID"

 rm -f tmp.dat
}
#
#+------------------------------------------------------+
#+ Name:        BANNER                                  +
#+ Description: Display Banner                          +
#+ Parameters:  None                                    +
#+------------------------------------------------------+
USAGE="usage: BANNER"
function BANNER
{
 #clear
 echo "++++++++++++++++++++++++++++++++++++++++++++++++++++" | tee -a ${l_log_file}
 echo "+                                                   " | tee -a ${l_log_file}
 echo "+Installation Script for XXHR${l_reference}                   " | tee -a ${l_log_file}
 echo "+                                                   " | tee -a ${l_log_file}
 echo "+Installing from ${l_install_from}                  " | tee -a ${l_log_file}
 echo "+Installing into ${SID}                             " | tee -a ${l_log_file}
 echo "++++++++++++++++++++++++++++++++++++++++++++++++++++" | tee -a ${l_log_file}
 echo
 echo
}
#
#+------------------------------------------------------+
#+ Name:        CONTINUE                                +
#+ Description: Request a response                      +
#+ Parameters:  None                                    +
#+------------------------------------------------------+
USAGE="usage: CONTINUE"
function CONTINUE
{
 echo "\n\n Continue Installation Y/N  [Y]: \c "
 read ANS
 if [ "X${ANS}" = "X" ]
    then
    ANS=Y
      else
    if [ ${ANS} = "Y" -o ${ANS} = "y" ] ; then
       ANS=Y
    else
       ANS=N
    fi
      fi

 if [ "${ANS}" = "Y" ] ; then
    WRITE_MESSAGE "Instalation will proceed"
    l_ret_code=0
 else
   WRITE_MESSAGE "Installation cancelled"
   l_ret_code=1
 fi

 return ${l_ret_code}
}
#
#+------------------------------------------------------+
#+ Name:        CHECK_FILES                             +
#+ Description: Checks the connection details           +
#+ Parameters:  username and password                   +
#+------------------------------------------------------+
USAGE="usage: CHECK_FILES"
function CHECK_FILES
{
 WRITE_MESSAGE "Checking if all required files are present in the ${l_install_from} directory"

 l_ret_status=0

 for file in ${l_file_list} ; do
     WRITE_MESSAGE "Checking ${file}"
     if [ -f ${l_install_from}/${file} ] ; then
        WRITE_MESSAGE "${file} OK"
               chmod 644 ${file}
     else
        WRITE_MESSAGE "Cannot find file ${file}"
        l_ret_status=1
     fi
 done
 
 for file in ${l_control_file_list} ; do
          l_ldt=`echo ${file} | cut -d '|' -f2`

     WRITE_MESSAGE "Checking ${l_ldt}"
     if [ -f ${l_ldt} ] ; then
        WRITE_MESSAGE "${l_ldt} OK"
               chmod 644 ${l_ldt}
     else
        WRITE_MESSAGE "Cannot find file ${l_ldt}"
        l_ret_status=1
     fi
 done
 
 return ${l_ret_status}
}
#
#+------------------------------------------------------+
#+ Name:        DO_DB                                   +
#+ Description: Runs an SQL File                        +
#+ Parameters:  Filename                                +
#+------------------------------------------------------+
#
USAGE="usage: DO_DB filename <param1> <param2>"
function DO_DB
{
 l_user_pswd=$1
 l_file=$2

 if [ -z ${l_file} ] ; then
    WRITE_MESSAGE "No script passed to run"
         return
 fi

 l_tmp_file=$$.dat

 rm -f ${l_tmp_file}

 WRITE_MESSAGE "Installing ${l_file} into the database"

 sqlplus ${l_user_pswd} >${l_tmp_file} 2>&1 <<+EOF+
set define off
@${l_install_from}/${l_file}
exit
+EOF+

 cat ${l_tmp_file}  | tee -a ${l_log_file}

 rm -f ${l_tmp_file}
}
#
#+------------------------------------------------------+
#+ Name:        DO_FNDLOAD                              +
#+ Description: Imports data via FNDLOAD                +
#+ Parameters:  FNDLOAD Control File                    +
#               FNDLOAD Data Filename                   +
#+------------------------------------------------------+
#
USAGE="usage: DO_FNDLOAD <param1> <param2>"
function DO_FNDLOAD
{
 l_control_file=$1
 l_file=$2
 l_tmp_file=$$.dat
 
 if [ -z ${l_control_file} ] ; then
    WRITE_MESSAGE "No Control File passed to run"
    return
 fi

 if [ -z ${l_file} ] ; then
    WRITE_MESSAGE "No Data File passed to import"
    return
 fi
#
#+------------------------------------------------------+
#+ Check that we have access to the Control File        +
#+------------------------------------------------------+
#
 if [ ! -f ${l_control_file} ] ; then
    WRITE_MESSAGE "Unable to access Control File ${l_control_file}"
    return
 fi

 WRITE_MESSAGE "Installing ${l_file} into the database via FNDLOAD"

 FNDLOAD ${l_apps_user_pswd} 0 Y UPLOAD ${l_control_file} ${l_file} 2> ${l_tmp_file}

 l_fnd_log_file=`cat ${l_tmp_file}|grep Log|awk -F':' '{print $2}'`
 
 WRITE_MESSAGE "Displaying contents of FNDLOAD Log File ${l_fnd_log_file}"

 cat ${l_fnd_log_file} | tee -a  ${l_log_file}

 rm -f ${l_tmp_file} 1>/dev/null 2>/dev/null
 rm -f ${l_fnd_log_file} 1>/dev/null 
}
#
#+------------------------------------------------------+
#+ Name:        INSTALL_SEED_DATA                       +
#+ Description: Installs Seed Data                      +
#+ Parameters:  None                                    +
#+------------------------------------------------------+
#
USAGE="usage: INSTALL_SEED_DATA"  
function INSTALL_SEED_DATA  
{
 WRITE_MESSAGE "Installing Seed Data"

 for file in ${l_control_file_list} ; do
          l_lct=`echo ${file} | cut -d '|' -f1`
          l_ldt=`echo ${file} | cut -d '|' -f2`

     WRITE_MESSAGE "Installing from ${l_ldt}"
            DO_FNDLOAD  ${l_lct} ${l_install_from}/${l_ldt}
 done
}
#
#+------------------------------------------------------+
#+ Name:        INSTALL_TRIGGERS                        +
#+ Description: Installs Triggers                       +
#+ Parameters:  None                                    +
#+------------------------------------------------------+
USAGE="usage: INSTALL_TRIGGERS"   
function INSTALL_TRIGGERS
{
 WRITE_MESSAGE "Installing Triggers"

 for file in ${l_trigger_list} ; do
    WRITE_MESSAGE "Installing Trigger from ${file}"
       DO_DB ${l_apps_user_pswd} ${file}
       cp -f ${l_install_from}/${file} ${CUST_TOP}/admin/sql/
 done
}
#
#+------------------------------------------------------+
#+ Name:        INSTALL_DB_OBJECTS                      +
#+ Description: Installs tables and Triggers            +
#+ Parameters:  None                                    +
#+------------------------------------------------------+
USAGE="usage: INSTALL_DB_OBJECTS"  
function INSTALL_DB_OBJECTS  
{
 WRITE_MESSAGE "Installing Database Objects"

 for file in ${l_db_object_list} ; do
    WRITE_MESSAGE "Installing Database Object from ${file}"
       DO_DB ${l_apps_user_pswd} ${file}
       cp -f ${l_install_from}/${file} ${CUST_TOP}/admin/sql/
 done
}
#
#+------------------------------------------------------+
#+ Name:        INSTALL_PACKAGES                        +
#+ Description: Installs Packages                       +
#+ Parameters:  None                                    +
#+------------------------------------------------------+
USAGE="usage: INSTALL_PACKAGES"  
function INSTALL_PACKAGES  
{
 WRITE_MESSAGE "Installing Database Packages"

 for file in ${l_db_pkg_list} ; do
    WRITE_MESSAGE "Installing Database Package from ${file}"
       DO_DB ${l_apps_user_pswd} ${file}
       cp -f ${l_install_from}/${file} ${CUST_TOP}/admin/sql/
 done
}
#
#+------------------------------------------------------+
#+ Name:        INSTALL_WORKFLOWS                       +
#+ Description: Installs Workflows                      +
#+ Parameters:  None                                    +
#+------------------------------------------------------+
USAGE="usage: INSTALL_WORKFLOWS"  
function INSTALL_WORKFLOWS  
{
 WRITE_MESSAGE "Installing Workflows"

 for file in ${l_wf_list} ; do
    WRITE_MESSAGE "Installing Workflow from ${file}"
       WFLOAD ${l_apps_user_pswd} 0 Y FORCE ${l_install_from}/${file} 2>&1 | tee -a ${l_log_file}
       cp -f ${l_install_from}/${file} ${CUST_TOP}/workflow/
 done

 WRITE_MESSAGE "Fixing invalid workflow versions"

 sqlplus -s ${l_apps_user_pswd} @${FND_TOP}/sql/wfverupd.sql 2>&1 | tee -a ${l_log_file}
}
#
#+------------------------------------------------------+
#+ Name:        INSTALL_SHELL_SCRIPTS                   +
#+ Description: Installs Shell Scripts                  +
#+ Parameters:  None                                    +
#+------------------------------------------------------+
USAGE="usage: INSTALL_SHELL_SCRIPTS"  
function INSTALL_SHELL_SCRIPTS  
{
 WRITE_MESSAGE "Installing Shell Scripts"

 for file in ${l_shell_list} ; do
    WRITE_MESSAGE "Installing Shell Script ${file}"
       chmod a+rx ${l_install_from}/${file}
       cp -f ${l_install_from}/${file} ${CUST_TOP}/bin/
       l_link_name=`echo ${file}|awk -F'.' '{print $1}'`

    WRITE_MESSAGE "Creating symbolic link for ${l_link_name}"
       if [ -h ${CUST_TOP}/bin/${l_link_name} ] ; then
          WRITE_MESSAGE "Link already exists - it will not be updated"
       else
          ln -s $FND_TOP/bin/fndcpesr ${CUST_TOP}/bin/${l_link_name} 2>&1 | tee -a ${l_log_file}
       fi
 done
}
#
#+------------------------------------------------------+
#+ Name:        INSTALL_CTL_SCRIPTS                     +
#+ Description: Installs Control Files                  +
#+ Parameters:  None                                    +
#+------------------------------------------------------+
USAGE="usage: INSTALL_CTL_SCRIPTS"  
function INSTALL_CTL_SCRIPTS  
{
 WRITE_MESSAGE "Installing SQL Loader Scripts"

 for file in ${l_ctl_list} ; do
    WRITE_MESSAGE "Installing SQL Loader Script ${file}"
       cp -f ${l_install_from}/${file} ${CUST_TOP}/bin/
 done
}
#
#+------------------------------------------------------+
#+ Name:        INSTALL_RDF_FILES                       +
#+ Description: Installs Report Files                   +
#+ Parameters:  None                                    +
#+------------------------------------------------------+
USAGE="usage: INSTALL_RDF_FILES"    
function INSTALL_RDF_FILES  
{
 WRITE_MESSAGE "Installing Report Files"

 for file in ${l_rep_list} ; do
    WRITE_MESSAGE "Installing Report File ${file}"
       cp -f ${l_install_from}/${file} ${CUST_TOP}/reports/US/
 done
}
#
#+------------------------------------------------------+
#+ Name:        INSTALL_SQL_FILES                       +
#+ Description: Installs SQL Files                      +
#+ Parameters:  None                                    +
#+------------------------------------------------------+
USAGE="usage: INSTALL_SQL_FILES"    
function INSTALL_SQL_FILES  
{
 WRITE_MESSAGE "Installing SQL Files"

 for file in ${l_sql_list} ; do
    WRITE_MESSAGE "Installing SQL File ${file}"
       cp -f ${l_install_from}/${file} ${CUST_TOP}/sql/
 done
}
#
#+------------------------------------------------------+
#+ Name:        PERFORM_INSTALL                         +
#+ Description: Performs the installation               +
#+ Parameters:  None                                    +
#+------------------------------------------------------+
USAGE="usage: PERFORM_INSTALL"
function PERFORM_INSTALL
{
 WRITE_MESSAGE "Performing installation"

 INSTALL_DB_OBJECTS

 INSTALL_PACKAGES 

 INSTALL_TRIGGERS

 INSTALL_SEED_DATA

 INSTALL_WORKFLOWS 

 INSTALL_SHELL_SCRIPTS

 INSTALL_CTL_SCRIPTS

 INSTALL_RDF_FILES

 INSTALL_SQL_FILES
}
#
#+------------------------------------------------------+
#+ M A I N                                              +
#+------------------------------------------------------+
#
WRITE_MESSAGE "Checking APPS database connection"

CHECK_CONNECTION ${l_apps_user_pswd}

if [ ${?} != 0 ] ; then
   exit
fi

WRITE_MESSAGE "Checking database connection"

if [ ${?} != 0 ] ; then
   exit
fi

BANNER

CONTINUE

if [ ${?} != 0 ] ; then
   exit
fi

CHECK_FILES

if [ ${?} != 0 ] ; then
   WRITE_MESSAGE "Not all required files are present"
   exit
fi

PERFORM_INSTALL

WRITE_MESSAGE "Completed Installation.  The log file is ${l_log_file}"

