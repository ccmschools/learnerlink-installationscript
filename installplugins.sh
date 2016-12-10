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

# remove prepackaed (and likely outdated) Office 365 plugins
rm -rf $moodleDirectory/htdocs/auth/oidc
rm -rf $moodleDirectory/htdocs/blocks/microsoft
rm -rf $moodleDirectory/htdocs/blocks/onenote
rm -rf $moodleDirectory/htdocs/filter/oembed
rm -rf $moodleDirectory/htdocs/local/microsoftservices
rm -rf $moodleDirectory/htdocs/local/msaccount
rm -rf $moodleDirectory/htdocs/local/o365
rm -rf $moodleDirectory/htdocs/local/o365docs
rm -rf $moodleDirectory/htdocs/local/office365
rm -rf $moodleDirectory/htdocs/local/onenote
rm -rf $moodleDirectory/htdocs/mod/assign/feedback/onenote
rm -rf $moodleDirectory/htdocs/mod/assign/submission/onenote
rm -rf $moodleDirectory/htdocs/repository/onenote
rm -rf $moodleDirectory/htdocs/repository/office365
rm -rf $moodleDirectory/htdocs/user/profile/field/o365
rm -rf $moodleDirectory/htdocs/user/profile/field/oidc

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
   
cp -r o365-moodle-$moodleVersion/* htdocs
rm -rf o365-moodle-$moodleVersion

# --------------------------------------------------------------------------------------------------------------
# Install custom plugins for this version. Note: this code will need to be adjusted each time Moodle is upgraded. Preferred method is to use git.
apt-get -y install git-all

# Activity Modules
cd $moodleDirectory/htdocs/mod

git clone -b $moodleVersion --single-branch https://github.com/markn86/moodle-mod_customcert.git customcert
git clone -b $moodleVersion --single-branch https://github.com/remotelearner/moodle-mod_questionnaire.git questionnaire
git clone -b master https://github.com/davosmith/moodle-checklist.git checklist
git clone -b master https://github.com/ndunand/moodle-mod_choicegroup.git choicegroup

# Quiz/Access Rules
cd $moodleDirectory/htdocs/mod/quiz/accessrule

git clone -b master https://github.com/jleyva/moodle-quizaccess_offlineattempts.git offlineattempts

# Blocks
cd $moodleDirectory/htdocs/blocks

git clone -b master https://github.com/davosmith/moodle-block_checklist.git checklist
git clone -b master https://bitbucket.org/mikegrant/bcu-course-checks-block.git bcu_course_checks
git clone -b master https://github.com/Hipjea/studentstracker.git studentstracker
git clone -b master https://github.com/deraadt/moodle-block_completion_progress.git completion_progress
git clone -b master https://github.com/FMCorz/moodle-block_xp.git xp
git clone -b master https://github.com/deraadt/moodle-block_heatmap.git heatmap
git clone -b MOODLE_30_STABLE --single-branch https://github.com/jleyva/moodle-block_configurablereports.git configurable_reports

# Grade Exports
cd $moodleDirectory/htdocs/grade/export

git clone -b master https://github.com/davosmith/moodle-grade_checklist.git checklist

# Filters


# Atto Plugins
cd $moodleDirectory/htdocs/lib/editor/atto/plugins

git clone -b master https://github.com/dthies/moodle-atto_fullscreen.git fullscreen
git clone -b master https://github.com/moodleuulm/moodle-atto_styles.git styles
git clone -b master https://github.com/cdsmith-umn/pastespecial.git pastespecial
git clone -b master https://github.com/dthies/moodle-atto_cloze.git cloze
git clone -b master https://github.com/damyon/moodle-atto_count.git count

# Enrolment Methods
cd $moodleDirectory/htdocs/enrol

git clone -b master https://github.com/markward/enrol_autoenrol.git autoenrol

# Availability Restrictions
cd $moodleDirectory/htdocs/availability/condition

git clone -b master https://github.com/moodlehq/moodle-availability_mobileapp.git mobileapp
git clone -b master https://github.com/FMCorz/moodle-availability_xp.git xp

# Course Formats
cd $moodleDirectory/htdocs/course/format

git clone -b MOODLE_31 --single-branch https://github.com/gjb2048/moodle-format_topcoll.git topcoll
git clone -b MOODLE_31 --single-branch https://github.com/gjb2048/moodle-format_grid.git grid
git clone -b MOODLE_31 --single-branch https://github.com/davidherney/moodle-format_onetopic.git onetopic

# Themes
cd $moodleDirectory/htdocs/theme

git clone -b master https://github.com/gjb2048/moodle-theme_essential.git essential

# Local Plugins
cd $moodleDirectory/htdocs/local

git clone -b $moodleVersion --single-branch https://github.com/moodlehq/moodle-local_mobile.git mobile
git clone -b master https://github.com/markward/local_autogroup.git autogroup
git clone -b $moodleVersion --single-branch https://github.com/andrewnicols/moodle-local_usertours.git usertours

# Admin Tools
cd $moodleDirectory/htdocs/admin/tool

git clone -b master https://github.com/moodlehq/moodle-tool_lpimportcsv lpimportcsv

# Alternative Login Form
cd $moodleDirectory/htdocs
git clone -b master https://github.com/ccmschools/learnerlink-loginform.git learnerlink-loginform

# --------------------------------------------------------------------------------------------------------------

# make the moodle directory writable for owner
cd $moodleDirectory
chown -R $wwwDaemonUserGroup htdocs
chmod -R 770 htdocs

# create datadrive directory
mkdir $moodleDirectory/datadrive
chown -R $wwwDaemonUserGroup $moodleDirectory/datadrive
chmod -R 770 $moodleDirectory/datadrive
