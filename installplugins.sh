#!/bin/bash
apt-get -y update

# Define parameters
moodleVersion="MOODLE_31_STABLE"
moodleDirectory="/d/GitHub"
moodleFolderName="htdocs"
wwwDaemonUserGroup="bitnami:daemon"


# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> #
# The following section installs the latest release of the Moodle 						#
# version specified by $moodleVersion.													#
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> #

cp $moodleDirectory/$moodleFolderName/config.php $moodleDirectory/config.php.backup
rm -rf $moodleDirectory/$moodleFolderName
cd $moodleDirectory
git clone -b $moodleVersion --single-branch https://github.com/moodle/moodle.git $moodleFolderName

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> #
# The following section installs custom plugins for this version of Moodle.				#
# Note: this code will need to be adjusted each time Moodle is upgraded. 				#
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> #

# --------- Activity Modules -----------
cd $moodleDirectory/$moodleFolderName/mod

git submodule add https://github.com/markn86/moodle-mod_customcert.git customcert
cd customcert
git checkout -b $moodleVersion origin/$moodleVersion
cd $moodleDirectory/$moodleFolderName/mod

git submodule add https://github.com/remotelearner/moodle-mod_questionnaire.git questionnaire
cd questionnaire
git checkout -b $moodleVersion origin/$moodleVersion
cd $moodleDirectory/$moodleFolderName/mod

git submodule add https://github.com/davosmith/moodle-checklist.git checklist

git submodule add https://github.com/ndunand/moodle-mod_choicegroup.git choicegroup

#---------- Quiz/Access Rules -----------
cd $moodleDirectory/$moodleFolderName/mod/quiz/accessrule

git submodule add https://github.com/jleyva/moodle-quizaccess_offlineattempts.git offlineattempts

#---------- Blocks -----------
cd $moodleDirectory/$moodleFolderName/blocks

git submodule add https://github.com/Microsoft/moodle-block_microsoft.git microsoft
cd microsoft
git checkout -b $moodleVersion origin/$moodleVersion
cd $moodleDirectory/$moodleFolderName/blocks

git submodule add https://github.com/davosmith/moodle-block_checklist.git checklist

git submodule add https://bitbucket.org/mikegrant/bcu-course-checks-block.git bcu_course_checks
cd bcu_course_checks
git checkout -b master origin/master
cd $moodleDirectory/$moodleFolderName/blocks

git submodule add https://github.com/Hipjea/studentstracker.git studentstracker

git submodule add https://github.com/deraadt/moodle-block_completion_progress.git completion_progress

git submodule add https://github.com/FMCorz/moodle-block_xp.git xp

git submodule add https://github.com/deraadt/moodle-block_heatmap.git heatmap

git submodule add https://github.com/jleyva/moodle-block_configurablereports.git configurable_reports
cd configurable_reports
git checkout -b MOODLE_30_STABLE origin/MOODLE_30_STABLE
cd $moodleDirectory/$moodleFolderName/blocks

#---------- Grade Exports -----------
cd $moodleDirectory/$moodleFolderName/grade/export

git submodule add https://github.com/davosmith/moodle-grade_checklist.git checklist

#---------- Filters -----------
cd $moodleDirectory/$moodleFolderName/filter
git submodule add https://github.com/POETGroup/moodle-filter_oembed.git oembed
cd oembed
git checkout -b $moodleVersion origin/$moodleVersion
cd $moodleDirectory/$moodleFolderName/filter

#---------- Authentication -----------
cd $moodleDirectory/$moodleFolderName/auth
git submodule add https://github.com/Microsoft/moodle-auth_oidc.git oidc
cd oidc
git checkout -b $moodleVersion origin/$moodleVersion
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

git submodule add https://github.com/markward/enrol_autoenrol.git autoenrol

#---------- Availability Restrictions -----------
# 
cd $moodleDirectory/$moodleFolderName/availability/condition

git submodule add https://github.com/moodlehq/moodle-availability_mobileapp.git mobileapp

git submodule add https://github.com/FMCorz/moodle-availability_xp.git xp

#---------- Course Formats -----------
cd $moodleDirectory/$moodleFolderName/course/format

git submodule add https://github.com/gjb2048/moodle-format_topcoll.git topcoll
cd topcoll
git checkout -b MOODLE_31 origin/MOODLE_31
cd $moodleDirectory/$moodleFolderName/course/format

git submodule add https://github.com/gjb2048/moodle-format_grid.git grid
cd grid
git checkout -b MOODLE_31 origin/MOODLE_31
cd $moodleDirectory/$moodleFolderName/course/format

git submodule add https://github.com/davidherney/moodle-format_onetopic.git onetopic
cd onetopic
git checkout -b MOODLE_31 origin/MOODLE_31
cd $moodleDirectory/$moodleFolderName/course/format

#---------- Themes -----------
cd $moodleDirectory/$moodleFolderName/theme

git submodule add https://github.com/gjb2048/moodle-theme_essential.git essential

#---------- Repositories -----------
cd $moodleDirectory/$moodleFolderName/repository
git submodule add https://github.com/Microsoft/moodle-repository_office365.git office365
cd office365
git checkout -b $moodleVersion origin/$moodleVersion
cd $moodleDirectory/$moodleFolderName/repository

#---------- Local Plugins -----------
cd $moodleDirectory/$moodleFolderName/local

git submodule add https://github.com/Microsoft/moodle-local_o365.git o365
cd o365
git checkout -b $moodleVersion origin/$moodleVersion
cd $moodleDirectory/$moodleFolderName/local

git submodule add https://github.com/moodlehq/moodle-local_mobile.git mobile
cd mobile
git checkout -b $moodleVersion origin/$moodleVersion
cd $moodleDirectory/$moodleFolderName/local

git submodule add https://github.com/markward/local_autogroup.git autogroup

git submodule add https://github.com/andrewnicols/moodle-local_usertours.git usertours
cd usertours
git checkout -b $moodleVersion origin/$moodleVersion
cd $moodleDirectory/$moodleFolderName/local

#---------- Admin Tools -----------
cd $moodleDirectory/$moodleFolderName/admin/tool

git submodule add https://github.com/moodlehq/moodle-tool_lpimportcsv lpimportcsv

#---------- Alternative Login Form -----------
# 
cd $moodleDirectory/$moodleFolderName
git submodule add https://github.com/ccmschools/learnerlink-loginform.git learnerlink-loginform

#---------- Wrapping it up -----------
# **This will currently require authentication**
cd $moodleDirectory/$moodleFolderName
git commit -a -m "Moodle and plugins installed"
git remote add mirror https://github.com/ccmschools/learnerlink.git
git push mirror $moodleVersion

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> #
