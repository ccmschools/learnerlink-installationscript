#!/bin/bash
apt-get -y update

# Define parameters
moodleVersion="MOODLE_31_STABLE"
moodleDirectory="/opt/bitnami/apps/moodle"
moodleFolderName="htdocs"
wwwDaemonUserGroup="bitnami:daemon"

# Install additional requirements and change folder permisions (yes=1/no=0)? Do this only if deploying to a server (i.e. don't run on local git repo)
additionalReqsPerms="no"

if [$additionalReqsPerms = yes]
	# install moodle additional requirements
	apt-get -y install git-all ghostscript
fi

# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> #
# The following section installs custom plugins for this version of Moodle.				#
# Note: this code will need to be adjusted each time Moodle is upgraded. 				#
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> #

# --------- Activity Modules -----------
cd $moodleDirectory/$moodleFolderName/mod

git submodule add https://github.com/markn86/moodle-mod_customcert.git customcert
cd customcert
git checkout -b $moodleVersion origin/$moodleVersion
cd ../

git submodule add https://github.com/remotelearner/moodle-mod_questionnaire.git questionnaire
cd questionnaire
git checkout -b $moodleVersion origin/$moodleVersion
cd ../

git submodule add https://github.com/davosmith/moodle-checklist.git checklist
cd checklist
git checkout -b master origin/master
cd ../

git submodule add https://github.com/ndunand/moodle-mod_choicegroup.git choicegroup
cd choicegroup
git checkout -b master origin/master
cd ../

#---------- Quiz/Access Rules -----------
cd $moodleDirectory/$moodleFolderName/mod/quiz/accessrule

git submodule add https://github.com/jleyva/moodle-quizaccess_offlineattempts.git offlineattempts
cd offlineattempts
git checkout -b master origin/master
cd ../

#---------- Blocks -----------
cd $moodleDirectory/$moodleFolderName/blocks

git submodule add https://github.com/Microsoft/moodle-block_microsoft.git microsoft
cd microsoft
git checkout -b $moodleVersion origin/$moodleVersion
cd ../

git submodule add https://github.com/davosmith/moodle-block_checklist.git checklist
cd checklist
git checkout -b master origin/master
cd ../

git submodule add https://bitbucket.org/mikegrant/bcu-course-checks-block.git bcu_course_checks
cd bcu_course_checks
git checkout -b master origin/master
cd ../

git submodule add https://github.com/Hipjea/studentstracker.git studentstracker
cd studentstracker
git checkout -b master origin/master
cd ../

git submodule add https://github.com/deraadt/moodle-block_completion_progress.git completion_progress
cd completion_progress
git checkout -b master origin/master
cd ../

git submodule add https://github.com/FMCorz/moodle-block_xp.git xp
cd xp
git checkout -b master origin/master
cd ../

git submodule add https://github.com/deraadt/moodle-block_heatmap.git heatmap
cd heatmap
git checkout -b master origin/master
cd ../

git submodule add https://github.com/jleyva/moodle-block_configurablereports.git configurable_reports
cd configurable_reports
git checkout -b MOODLE_30_STABLE origin/MOODLE_30_STABLE
cd ../

#---------- Grade Exports -----------
cd $moodleDirectory/$moodleFolderName/grade/export

git submodule add https://github.com/davosmith/moodle-grade_checklist.git checklist
cd checklist
git checkout -b master origin/master
cd ../

#---------- Filters -----------
cd $moodleDirectory/$moodleFolderName/filter
git submodule add https://github.com/POETGroup/moodle-filter_oembed.git oembed
cd oembed
git checkout -b $moodleVersion origin/$moodleVersion
cd ../

#---------- Authentication -----------
cd $moodleDirectory/$moodleFolderName/auth
git submodule add https://github.com/Microsoft/moodle-auth_oidc.git oidc
cd oidc
git checkout -b $moodleVersion origin/$moodleVersion
cd ../

#---------- Atto Plugins -----------
cd $moodleDirectory/$moodleFolderName/lib/editor/atto/plugins

git submodule add https://github.com/dthies/moodle-atto_fullscreen.git fullscreen
cd fullscreen
git checkout -b master origin/master
cd ../

git submodule add https://github.com/moodleuulm/moodle-atto_styles.git styles
cd styles
git checkout -b master origin/master
cd ../

git submodule add https://github.com/cdsmith-umn/pastespecial.git pastespecial
cd pastespecial
git checkout -b master origin/master
cd ../

git submodule add https://github.com/dthies/moodle-atto_cloze.git cloze
cd cloze
git checkout -b master origin/master
cd ../

git submodule add https://github.com/damyon/moodle-atto_count.git count
cd count
git checkout -b master origin/master
cd ../

#---------- Enrolment Methods -----------
cd $moodleDirectory/$moodleFolderName/enrol

git submodule add https://github.com/markward/enrol_autoenrol.git autoenrol
cd autoenrol
git checkout -b master origin/master
cd ../

#---------- Availability Restrictions -----------
# 
cd $moodleDirectory/$moodleFolderName/availability/condition

git submodule add https://github.com/moodlehq/moodle-availability_mobileapp.git mobileapp
cd mobileapp
git checkout -b master origin/master
cd ../

git submodule add https://github.com/FMCorz/moodle-availability_xp.git xp
cd xp
git checkout -b master origin/master
cd ../

#---------- Course Formats -----------
cd $moodleDirectory/$moodleFolderName/course/format

git submodule add https://github.com/gjb2048/moodle-format_topcoll.git topcoll
cd topcoll
git checkout -b MOODLE_31 origin/MOODLE_31
cd ../

git submodule add https://github.com/gjb2048/moodle-format_grid.git grid
cd grid
git checkout -b MOODLE_31 origin/MOODLE_31
cd ../

git submodule add https://github.com/davidherney/moodle-format_onetopic.git onetopic
cd onetopic
git checkout -b MOODLE_31 origin/MOODLE_31
cd ../

#---------- Themes -----------
cd $moodleDirectory/$moodleFolderName/theme

git submodule add https://github.com/gjb2048/moodle-theme_essential.git essential
cd essential
git checkout -b master origin/master
cd ../

#---------- Repositories -----------
cd $moodleDirectory/$moodleFolderName/repository
git submodule add https://github.com/Microsoft/moodle-repository_office365.git office365
cd office365
git checkout -b $moodleVersion origin/$moodleVersion
cd ../

#---------- Local Plugins -----------
cd $moodleDirectory/$moodleFolderName/local

git submodule add https://github.com/Microsoft/moodle-local_o365.git o365
cd o365
git checkout -b $moodleVersion origin/$moodleVersion
cd ../

git submodule add https://github.com/moodlehq/moodle-local_mobile.git mobile
cd mobile
git checkout -b $moodleVersion origin/$moodleVersion
cd ../

git submodule add https://github.com/markward/local_autogroup.git autogroup
cd autogroup
git checkout -b master origin/master
cd ../

git submodule add https://github.com/andrewnicols/moodle-local_usertours.git usertours
cd usertours
git checkout -b $moodleVersion origin/$moodleVersion
cd ../

#---------- Admin Tools -----------
cd $moodleDirectory/$moodleFolderName/admin/tool

git submodule add https://github.com/moodlehq/moodle-tool_lpimportcsv lpimportcsv
cd lpimportcsv
git checkout -b master origin/master
cd ../

#---------- Alternative Login Form -----------
# 
cd $moodleDirectory/$moodleFolderName
git submodule add https://github.com/ccmschools/learnerlink-loginform.git learnerlink-loginform
cd learnerlink-loginform
git checkout -b master origin/master
cd ../

#---------- Wrapping it up -----------
# **This will currently require authentication**
cd cd $moodleDirectory/$moodleFolderName
git commit -a -m "Plugins added as submodules"
git remote add mirror https://github.com/ccmschools/learnerlink.git
git push mirror $moodleVersion
 
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> #

if [$additionalReqsPerms = yes]
	# make the moodle directory writable for owner
	cd $moodleDirectory
	chown -R $wwwDaemonUserGroup $moodleFolderName
	chmod -R 770 $moodleFolderName

	# create datadrive directory
	mkdir $moodleDirectory/datadrive
	chown -R $wwwDaemonUserGroup $moodleDirectory/datadrive
	chmod -R 770 $moodleDirectory/datadrive
fi
