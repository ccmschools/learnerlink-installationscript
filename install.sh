#!/bin/bash
apt-get -y update

# Define parameters
moodleVersion="MOODLE_32_STABLE"
moodleDirectory="/opt/bitnami/apps/moodle"
moodleFolderName="htdocs"
wwwDaemonUserGroup="bitnami:daemon"
adminUser="Peter Sercombe"
adminEmail="peter.sercombe@groves.qld.edu.au"

# install moodle additional requirements
apt-get -y install git-all

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> #
# The following section installs the latest release of the Moodle 			#
# version specified by $moodleVersion.							#
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> #

# Backup the config.php file that shipped with the Bitnami image (might need the database password from it)
cp $moodleDirectory/$moodleFolderName/config.php $moodleDirectory/config.php.backup
# Remove existing Moodle software
rm -rf $moodleDirectory/$moodleFolderName
# Install/clone the latest stable branch of the desired Moodle version from the official git repository
cd $moodleDirectory
git clone -b $moodleVersion --single-branch https://github.com/moodle/moodle.git $moodleFolderName

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> #
# The following section installs custom plugins for this version of Moodle.		#
# Note: this code will need to be adjusted each time Moodle is upgraded. 		#
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> #

# --------- Activity Modules -----------
cd $moodleDirectory/$moodleFolderName/mod

git submodule add https://github.com/markn86/moodle-mod_customcert.git customcert
cd customcert
git checkout -b $moodleVersion origin/$moodleVersion
git commit -a -m "Branch Checked Out"
cd $moodleDirectory/$moodleFolderName/mod

git submodule add https://github.com/remotelearner/moodle-mod_questionnaire.git questionnaire
cd questionnaire
git checkout -b $moodleVersion origin/$moodleVersion
git commit -a -m "Branch Checked Out"
cd $moodleDirectory/$moodleFolderName/mod

git submodule add https://github.com/davosmith/moodle-checklist.git checklist

git submodule add https://github.com/ndunand/moodle-mod_choicegroup.git choicegroup

#---------- Blocks -----------
cd $moodleDirectory/$moodleFolderName/blocks

git submodule add https://github.com/Microsoft/moodle-block_microsoft.git microsoft
cd microsoft
git checkout -b $moodleVersion origin/$moodleVersion
git commit -a -m "Branch Checked Out"
cd $moodleDirectory/$moodleFolderName/blocks

git submodule add https://github.com/davosmith/moodle-block_checklist.git checklist

git submodule add https://bitbucket.org/mikegrant/bcu-course-checks-block.git bcu_course_checks

git submodule add https://github.com/Hipjea/studentstracker.git studentstracker

git submodule add https://github.com/deraadt/moodle-block_completion_progress.git completion_progress

git submodule add https://github.com/FMCorz/moodle-block_xp.git xp

git submodule add https://github.com/deraadt/moodle-block_heatmap.git heatmap

git submodule add https://github.com/jleyva/moodle-block_configurablereports.git configurable_reports
cd configurable_reports
git checkout -b MOODLE_30_STABLE origin/MOODLE_30_STABLE
git commit -a -m "Branch Checked Out"
cd $moodleDirectory/$moodleFolderName/blocks

#---------- Grade Exports -----------
cd $moodleDirectory/$moodleFolderName/grade/export

git submodule add https://github.com/davosmith/moodle-grade_checklist.git checklist

#---------- Filters -----------
cd $moodleDirectory/$moodleFolderName/filter
git submodule add https://github.com/PoetOS/moodle-filter_oembed.git oembed
cd oembed
git checkout -b $moodleVersion origin/$moodleVersion
git commit -a -m "Branch Checked Out"
cd $moodleDirectory/$moodleFolderName/filter

# The following plugin doesn't have a git repository. Instead the .zip file is downloaded from the Moodle plugins directory and uploaded to the ccmschools github account.
git submodule add https://github.com/ccmschools/learnerlink-filter_fontawesome.git fontawesome

#---------- Authentication -----------
cd $moodleDirectory/$moodleFolderName/auth
git submodule add https://github.com/Microsoft/moodle-auth_oidc.git oidc
cd oidc
git checkout -b $moodleVersion origin/$moodleVersion
git commit -a -m "Branch Checked Out"
cd $moodleDirectory/$moodleFolderName/auth

#---------- Atto Plugins -----------
cd $moodleDirectory/$moodleFolderName/lib/editor/atto/plugins

git submodule add https://github.com/dthies/moodle-atto_fullscreen.git fullscreen

git submodule add https://github.com/moodleuulm/moodle-atto_styles.git styles

git submodule add https://github.com/cdsmith-umn/pastespecial.git pastespecial

git submodule add https://github.com/dthies/moodle-atto_cloze.git cloze

git submodule add https://github.com/damyon/moodle-atto_count.git count

#---------- Enrolment Methods -----------
cd $moodleDirectory/$moodleFolderName/enrol

# I've changed the following repository to one that has been developed more from the original.
git submodule add https://github.com/bobopinna/moodle-enrol_autoenrol.git autoenrol

#---------- Availability Restrictions -----------
# 
cd $moodleDirectory/$moodleFolderName/availability/condition

# The following plugin now has a version-specific branch
git submodule add https://github.com/moodlehq/moodle-availability_mobileapp.git mobileapp
cd mobileapp
git checkout -b $moodleVersion origin/$moodleVersion
git commit -a -m "Branch Checked Out"
cd $moodleDirectory/$moodleFolderName/availability/condition

git submodule add https://github.com/FMCorz/moodle-availability_xp.git xp

#---------- Course Formats -----------
cd $moodleDirectory/$moodleFolderName/course/format

git submodule add https://github.com/gjb2048/moodle-format_topcoll.git topcoll
cd topcoll
git checkout -b MOODLE_32 origin/MOODLE_32
git commit -a -m "Branch Checked Out"
cd $moodleDirectory/$moodleFolderName/course/format

git submodule add https://github.com/gjb2048/moodle-format_grid.git grid
cd grid
git checkout -b MOODLE_32 origin/MOODLE_32
git commit -a -m "Branch Checked Out"
cd $moodleDirectory/$moodleFolderName/course/format

git submodule add https://github.com/davidherney/moodle-format_onetopic.git onetopic

#---------- Themes -----------
cd $moodleDirectory/$moodleFolderName/theme

#---------- Repositories -----------
cd $moodleDirectory/$moodleFolderName/repository
git submodule add https://github.com/Microsoft/moodle-repository_office365.git office365
cd office365
git checkout -b $moodleVersion origin/$moodleVersion
git commit -a -m "Branch Checked Out"
cd $moodleDirectory/$moodleFolderName/repository

#---------- Local Plugins -----------
cd $moodleDirectory/$moodleFolderName/local

git submodule add https://github.com/Microsoft/moodle-local_o365.git o365
cd o365
git checkout -b $moodleVersion origin/$moodleVersion
git commit -a -m "Branch Checked Out"
cd $moodleDirectory/$moodleFolderName/local

git submodule add https://github.com/moodlehq/moodle-local_mobile.git mobile
cd mobile
git checkout -b $moodleVersion origin/$moodleVersion
git commit -a -m "Branch Checked Out"
cd $moodleDirectory/$moodleFolderName/local

git submodule add https://github.com/ccmschools/local_autogroup.git autogroup

#---------- Alternative Login Form -----------
# 
cd $moodleDirectory/$moodleFolderName
git submodule add https://github.com/ccmschools/learnerlink-loginform.git loginform

#--------- Tell git to ignore the axcelerate plugin ------
cd $moodleDirectory/$moodleFolderName
echo '/auth/axcelerate/' >> .git/info/exclude
echo '/local/axcelerate*/' >> .git/info/exclude

#---------- Wrapping it up -----------
# **This will currently require authentication**
cd $moodleDirectory/$moodleFolderName
git config --global user.email "$adminEmail"
git config --global user.name "$adminUser"
git commit -a -m "Moodle and plugins installed"
git remote add mirror https://github.com/ccmschools/learnerlink.git
 
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> #

# Copy original config.php back into directory
cp $moodleDirectory/config.php.backup $moodleDirectory/$moodleFolderName/config.php

# make the moodle directory writable for owner
cd $moodleDirectory
chown -R $wwwDaemonUserGroup $moodleFolderName
find $moodleFolderName -type d -exec chmod 755 {} \;
find $moodleFolderName -type f -exec chmod 644 {} \;

# create datadrive directory
mkdir $moodleDirectory/datadrive
chown -R $wwwDaemonUserGroup $moodleDirectory/datadrive
chmod -R 750 $moodleDirectory/datadrive
