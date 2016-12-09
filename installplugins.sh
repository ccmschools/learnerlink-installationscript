#!/bin/bash
apt-get -y update

moodleVersion="MOODLE_31_STABLE"
moodleDirectory="/opt/bitnami/apps/moodle"
wwwDaemonUserGroup="bitnami:daemon"

# install moodle additional requirements
apt-get -y install ghostscript

# install unzip
apt-get install unzip

cd $moodleDirectory

# install Office 365 plugins
curl -k --max-redirs 10 https://github.com/Microsoft/o365-moodle/archive/$moodleVersion.zip -L -o o365.zip
unzip o365.zip
    
# The plugins below are not required for new installations
rm -rf o365-moodle-$moodleVersion/blocks/onenote
rm -rf o365-moodle-$moodleVersion/local/m*
rm -rf o365-moodle-$moodleVersion/local/o365docs
rm -rf o365-moodle-$moodleVersion/local/office365
rm -rf o365-moodle-$moodleVersion/local/onenote
rm -rf o365-moodle-$moodleVersion/mod/assign
rm -rf o365-moodle-$moodleVersion/user/profile/
rm -rf o365-moodle-$moodleVersion/repository/onenote	
    
#Copy office plugins to moodle and remove office unzipped folder
   
cp -r o365-moodle-$moodleVersion/* html
rm -rf o365-moodle-$moodleVersion
fi

# --------------------------------------------------------------------------------------------------------------
# Install custom plugins for this version. Note: this code will need to be adjusted each time Moodle is upgraded. Preferred method is to use git.
apt-get -y install git-all

# Activity Modules
cd $moodleDirectory/html/mod

git clone -b $moodleVersion --single-branch https://github.com/markn86/moodle-mod_customcert.git customcert
git clone -b $moodleVersion --single-branch https://github.com/remotelearner/moodle-mod_questionnaire.git questionnaire
git clone -b master https://github.com/davosmith/moodle-checklist.git checklist
git clone -b master https://github.com/ndunand/moodle-mod_choicegroup.git choicegroup

# Quiz/Access Rules
cd $moodleDirectory/html/mod/quiz/accessrule

git clone -b master https://github.com/jleyva/moodle-quizaccess_offlineattempts.git offlineattempts

# Blocks
cd $moodleDirectory/html/blocks

git clone -b master https://github.com/davosmith/moodle-block_checklist.git checklist
git clone -b master https://bitbucket.org/mikegrant/bcu-course-checks-block.git bcu_course_checks
git clone -b master https://github.com/Hipjea/studentstracker.git studentstracker
git clone -b master https://github.com/deraadt/moodle-block_completion_progress.git completion_progress
git clone -b master https://github.com/FMCorz/moodle-block_xp.git xp


# Grade Exports
cd $moodleDirectory/grade/export

git clone -b master https://github.com/davosmith/moodle-grade_checklist.git checklist

# Filters


# Atto Plugins
cd $moodleDirectory/html/lib/editor/atto/plugins

git clone -b master https://github.com/dthies/moodle-atto_fullscreen.git fullscreen
git clone -b master https://github.com/moodleuulm/moodle-atto_styles.git styles
git clone -b master https://github.com/cdsmith-umn/pastespecial.git pastespecial
git clone -b master https://github.com/dthies/moodle-atto_cloze.git cloze
git clone -b master https://github.com/damyon/moodle-atto_count.git count

# Enrolment Methods
cd $moodleDirectory/html/enrol

git clone -b master https://github.com/markward/enrol_autoenrol.git autoenrol

# Availability Restrictions
cd $moodleDirectory/html/availability/condition

git clone -b master https://github.com/moodlehq/moodle-availability_mobileapp.git mobileapp
git clone -b master https://github.com/FMCorz/moodle-availability_xp.git xp

# Course Formats
cd cd $moodleDirectory/html/course/format

git clone -b MOODLE_31 --single-branch https://github.com/gjb2048/moodle-format_topcoll.git topcoll
git clone -b MOODLE_31 --single-branch https://github.com/gjb2048/moodle-format_grid.git grid

# Themes
cd cd $moodleDirectory/html/theme

git clone -b master https://github.com/gjb2048/moodle-theme_essential.git essential

# Local Plugins
cd $moodleDirectory/html/local

git clone -b $moodleVersion --single-branch https://github.com/moodlehq/moodle-local_mobile.git mobile
git clone -b master https://github.com/markward/local_autogroup.git autogroup

# Admin Tools
cd $moodleDirectory/admin/tool

git clone -b master https://github.com/moodlehq/moodle-tool_lpimportcsv lpimportcsv

# Alternative Login Form
cd $moodleDirectory/html
git clone -b master https://github.com/ccmschools/learnerlink-loginform.git learnerlink-loginform



# --------------------------------------------------------------------------------------------------------------

# make the moodle directory writable for owner
cd $moodleDirectory
chown -R $wwwDaemonUserGroup html
chmod -R 770 html

# create moodledata directory
mkdir $moodleDirectory/moodledata
chown -R $wwwDaemonUserGroup $moodleDirectory/moodledata
chmod -R 770 $moodleDirectory/moodledata

# create cron entry
# It is scheduled for once per day. It can be changed as needed.
echo '0 0 * * * php /var/www/html/admin/cli/cron.php > /dev/null 2>&1' > cronjob
crontab cronjob

# restart Apache
apachectl restart
