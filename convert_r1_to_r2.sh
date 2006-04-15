#!/bin/bash
echo Converts packages from R1 to R2 to simplfy some of the tedious steps involved
echo
# Validate Input
if [ $# == 0 ]
then
	echo "Usage: convert_r1_to_r2.sh [options]
Options:
    -tables   De-tikify all bitweaver tables
              Bitweaver now uses <pkg>_ prefix instead of the old tiki_<pkg> we
              used to.  Here we deal with all renamed liberty tables.  You will
              still have to deal with the tablenames of your own package.
    -perms    Change the names of permissions
              R2 now uses p_<pkg>_<verb>_[<noun>] as standard
    -prefs    Change the names of preferences found in kernel_config (previously
              tiki_preferences) R2 now uses underscore preference names as
              standard
    -recent   recent changes pref name changes

Notes:
    Run this file from your package directory.
    Make sure to create a backup of your package first!
"
	exit
fi

# there has to be an admin dir in the package, otherwise it's not a valid package
if [ ! -d "admin" ]
then
echo "I couldn't find an admin/ directory therefore i assume you are not running this
script from within your package.  Please move this script into your package
before running it.
"
	exit
fi

args=`echo "$@" | perl -ne "print lc"`
for p in $args
do
	if [ $p == "-tables" ]
	then
		TABLES=1
	elif [ $p == "-prefs" ]
	then
		PREFS=1
	elif [ $p == "-recent" ]
	then
		RECENT=1
	elif [ $p == "-perms" ]
	then
		PERMS=1
	fi
done

if [ $TABLES ]
then
	echo rename liberty tables
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\btiki_content\b/liberty_content/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\btc\b/lc/g' {} \;

	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\btiki_attachments\b/liberty_attachments/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\btat\b/la/g' {} \;

	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\btiki_files\b/liberty_files/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\btf\b/lf/g' {} \;

	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\btiki_structures\b/liberty_structures/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bts\b/ls/g' {} \;

	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\btiki_comments\b/liberty_comments/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\btcm\b/lcom/g' {} \;

	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\btiki_plugins\b/liberty_plugins/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\btiki_content_types\b/liberty_content_types/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\btiki_link_cache\b/liberty_link_cache/g' {} \;
fi


if [ $PREFS ]
then
	echo change preference names in php files
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bbitIndex\b/bit_index/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\ballowRegister\b/allow_register/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bforgotPass\b/forgot_pass/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\beponymousGroups\b/eponymous_groups/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bregisterPasscode\b/register_passcode/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\buseRegisterPasscode\b/use_register_passcode/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bvalidateUsers\b/validate_user/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bvalidateEmail\b/validate_email/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\btmpDir\b/temp_dir/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bmaxRecords\b/max_records/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\burlIndex\b/url_index/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\banonCanEdit\b/anon_can_edit/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bmaxVersions\b/max_versions/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bwikiHomePage\b/wiki_home_page/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bwikiLicensePage\b/wiki_license_page/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bwikiSubmitNotice\b/wiki_submit_notice/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bsiteTitle\b/site_title/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_lastChanges\b/feature_last_changes/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_likePages\b/feature_like_pages/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_listPages\b/feature_list_pages/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_userPreferences\b/feature_user_preferences/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_allow_dup_wiki_page_names\b/allow_dup_wiki_page_names/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_article_submissions\b/article_submissions/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_autolinks\b/autolinks/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_babelfish\b/babelfish/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_babelfish_logo\b/babelfish_logo/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_backlinks\b/backlinks/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_banning\b/banning/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_bidi\b/bidirectional_text/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_blogposts_comments\b/blogposts_comments/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_blog_rankings\b/blog_rankings/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_bot_bar\b/bot_bar/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_clear_passwords\b/clear_passwords/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_cms_rankings\b/cms_rankings/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_contact\b/site_contact/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_custom_home\b/custom_home/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_dump\b/wiki_dump/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_help\b/help/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_helpnotes\b/help_notes/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_helppopup\b/help_popup/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_history\b/content_history/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_hotwords\b/hotwords/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_hotwords_nw\b/hotwords_nw/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_jstabs\b/jstabs/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_lastChanges\b/last_changes/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_left_column\b/left_column/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_likePages\b/like_pages/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_listPages\b/list_pages/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_page_title\b/page_title/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_ranking\b/wiki_ranking/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_referer_stats\b/referer_stats/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_right_column\b/right_column/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_sandbox\b/sandbox/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_search_fulltext\b/search_fulltext/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_search_stats\b/search_stats/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_theme_control\b/theme_control/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_top_bar\b/themes_top_bar/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_top_bar_dropdown\b/top_bar_dropdown/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_user_bookmarks\b/user_bookmarks/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_userfiles\b/user_files/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_usermenu\b/usermenu/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_userPreferences\b/user_preferences/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_user_watches\b/user_watches/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_warn_on_edit\b/warn_on_edit/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_attachments\b/wiki_attachments/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_books\b/wiki_books/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_comments\b/wiki_comments/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_description\b/wiki_description/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_discuss\b/wiki_discuss/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_footnotes\b/wiki_footnotes/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_generate_pdf\b/wiki_generate_pdf/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wikihelp\b/wiki_help/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_icache\b/wiki_icache/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_monosp\b/wiki_monosp/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_multiprint\b/wiki_multiprint/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_notepad\b/wiki_notepad/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_pictures\b/wiki_pictures/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_plurals\b/wiki_plurals/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_rankings\b/wiki_rankings/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_tables\b/wiki_tables/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_templates\b/wiki_templates/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_undo\b/wiki_undo/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_usrlock\b/wiki_usrlock/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wikiwords\b/wiki_words/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bwiki_feature_copyrights\b/wiki_copyrights/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_pretty_urls_extended\b/pretty_urls_extended/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\ballowMsgs\b/messages_allow_messages/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_user_theme\b/users_themes/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_categoryobjects\b/categories_objects/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_categorypath\b/categories_path/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_offline_thumbnailer\b/liberty_offline_thumbnailer/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_server_name\b/kernel_server_name/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_obzip\b/output_obzip/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_editcss\b/themes_edit_css/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_html_pages\b/html_pages/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_modulecontrols\b/themes_module_controls/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_collapsible_modules\b/themes_collapsible_modules/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_live_support\b/kernel_live_support/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_dropdown_navbar\b/themes_dropdown_navbar/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_user_layout\b/users_layouts/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_user_preferences\b/users_preferences/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_listSamples\b/sample_list_samples/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_search_stats\b/stats_search/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_last_changes\b/wiki_last_changes/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_like_pages\b/wiki_like_pages/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_list_pages\b/wiki_list_pages/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_userVersions\b/wiki_user_versions/g" {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_url_import\b/wiki_url_import/g" {} \;

	echo change preference names in tpl files
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bbitIndex\b/bit_index/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\ballowRegister\b/allow_register/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bforgotPass\b/forgot_pass/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\beponymousGroups\b/eponymous_groups/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bregisterPasscode\b/register_passcode/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\buseRegisterPasscode\b/use_register_passcode/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bvalidateUsers\b/validate_user/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bvalidateEmail\b/validate_email/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\btmpDir\b/temp_dir/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bmaxRecords\b/max_records/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\burlIndex\b/url_index/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\banonCanEdit\b/anon_can_edit/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bmaxVersions\b/max_versions/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bwikiHomePage\b/wiki_home_page/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bwikiLicensePage\b/wiki_license_page/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bwikiSubmitNotice\b/wiki_submit_notice/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bsiteTitle\b/site_title/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_lastChanges\b/feature_last_changes/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_likePages\b/feature_like_pages/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_listPages\b/feature_list_pages/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_userPreferences\b/feature_user_preferences/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_allow_dup_wiki_page_names\b/allow_dup_wiki_page_names/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_article_submissions\b/article_submissions/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_autolinks\b/autolinks/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_babelfish\b/babelfish/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_babelfish_logo\b/babelfish_logo/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_backlinks\b/backlinks/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_banning\b/banning/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_bidi\b/bidirectional_text/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_blogposts_comments\b/blogposts_comments/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_blog_rankings\b/blog_rankings/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_bot_bar\b/bot_bar/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_clear_passwords\b/clear_passwords/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_cms_rankings\b/cms_rankings/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_contact\b/site_contact/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_custom_home\b/custom_home/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_dump\b/wiki_dump/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_help\b/help/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_helpnotes\b/help_notes/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_helppopup\b/help_popup/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_history\b/content_history/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_hotwords\b/hotwords/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_hotwords_nw\b/hotwords_nw/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_jstabs\b/jstabs/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_lastChanges\b/last_changes/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_left_column\b/left_column/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_likePages\b/like_pages/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_listPages\b/list_pages/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_page_title\b/page_title/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_ranking\b/wiki_ranking/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_referer_stats\b/referer_stats/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_right_column\b/right_column/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_sandbox\b/sandbox/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_search_fulltext\b/search_fulltext/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_search_stats\b/search_stats/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_theme_control\b/theme_control/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_top_bar\b/themes_top_bar/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_top_bar_dropdown\b/top_bar_dropdown/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_user_bookmarks\b/user_bookmarks/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_userfiles\b/user_files/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_usermenu\b/usermenu/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_userPreferences\b/user_preferences/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_user_watches\b/user_watches/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_warn_on_edit\b/warn_on_edit/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_attachments\b/wiki_attachments/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_books\b/wiki_books/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_comments\b/wiki_comments/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_description\b/wiki_description/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_discuss\b/wiki_discuss/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_footnotes\b/wiki_footnotes/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_generate_pdf\b/wiki_generate_pdf/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wikihelp\b/wiki_help/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_icache\b/wiki_icache/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_monosp\b/wiki_monosp/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_multiprint\b/wiki_multiprint/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_notepad\b/wiki_notepad/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_pictures\b/wiki_pictures/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_plurals\b/wiki_plurals/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_rankings\b/wiki_rankings/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_tables\b/wiki_tables/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_templates\b/wiki_templates/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_undo\b/wiki_undo/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_usrlock\b/wiki_usrlock/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wikiwords\b/wiki_words/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bwiki_feature_copyrights\b/wiki_copyrights/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_pretty_urls_extended\b/pretty_urls_extended/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\ballowMsgs\b/messages_allow_messages/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_user_theme\b/users_themes/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_categoryobjects\b/categories_objects/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_categorypath\b/categories_path/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_offline_thumbnailer\b/liberty_offline_thumbnailer/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_server_name\b/kernel_server_name/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_obzip\b/output_obzip/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_editcss\b/themes_edit_css/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_html_pages\b/html_pages/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_modulecontrols\b/themes_module_controls/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_collapsible_modules\b/themes_collapsible_modules/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_live_support\b/kernel_live_support/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_dropdown_navbar\b/themes_dropdown_navbar/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_user_layout\b/users_layouts/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_user_preferences\b/users_preferences/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_listSamples\b/sample_list_samples/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_search_stats\b/stats_search/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_last_changes\b/wiki_last_changes/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_like_pages\b/wiki_like_pages/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_list_pages\b/wiki_list_pages/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_userVersions\b/wiki_user_versions/g" {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe "s/\bfeature_wiki_url_import\b/wiki_url_import/g" {} \;

	# Prefname changes 2006-04-14
	echo articles php
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bart_list_author\b/articles_list_author/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bart_list_date\b/articles_list_date/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bart_list_img\b/articles_list_img/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bart_list_reads\b/articles_list_reads/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bart_list_size\b/articles_list_size/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bart_list_title\b/articles_list_title/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bart_list_topic\b/articles_list_topic/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bart_list_type\b/articles_list_type/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bart_list_expire\b/articles_list_expire/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bmax_articles\b/articles_max_list/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bcms_rankings\b/articles_rankings/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\barticle_submissions\b/articles_submissions/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\barticle_description_length\b/articles_description_length/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\barticle_date_threshold\b/articles_date_threshold/g' {} \;

	echo articles tpl
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bart_list_author\b/articles_list_author/g' {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bart_list_date\b/articles_list_date/g' {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bart_list_img\b/articles_list_img/g' {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bart_list_reads\b/articles_list_reads/g' {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bart_list_size\b/articles_list_size/g' {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bart_list_title\b/articles_list_title/g' {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bart_list_topic\b/articles_list_topic/g' {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bart_list_type\b/articles_list_type/g' {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bart_list_expire\b/articles_list_expire/g' {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bmax_articles\b/articles_max_list/g' {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bcms_rankings\b/articles_rankings/g' {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\barticle_submissions\b/articles_submissions/g' {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\barticle_description_length\b/articles_description_length/g' {} \;
	find . -name "*.tpl" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\barticle_date_threshold\b/articles_date_threshold/g' {} \;

	echo wiki php
	#find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbacklinks\b/wiki_backlinks/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\ballow_dup_wiki_page_names\b/wiki_allow_dup_page_names/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bpage_title\b/wiki_page_title/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bsandbox\b/wiki_sandbox/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bw_use_db\b/wiki_attachments_use_db/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bw_use_dir\b/wiki_attachments_use_dir/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bwarn_on_edit_time\b/wiki_warn_on_edit_time/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bwikibook_show_path\b/wiki_book_show_path/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bwikibook_show_navigation\b/wiki_book_show_navigation/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bkeep_versions\b/wiki_min_versions/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bmax_versions\b/wiki_max_versions/g' {} \;

	echo wiki tpl
	#find . -name "*.tpl" -exec perl -i -wpe 's/\bbacklinks\b/wiki_backlinks/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\ballow_dup_wiki_page_names\b/wiki_allow_dup_page_names/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bpage_title\b/wiki_page_title/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bsandbox\b/wiki_sandbox/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bw_use_db\b/wiki_attachments_use_db/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bw_use_dir\b/wiki_attachments_use_dir/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bwarn_on_edit_time\b/wiki_warn_on_edit_time/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bwikibook_show_path\b/wiki_book_show_path/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bwikibook_show_navigation\b/wiki_book_show_navigation/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bkeep_versions\b/wiki_min_versions/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bmax_versions\b/wiki_max_versions/g' {} \;

	echo messages
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bsite_contact\b/messages_site_contact/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bcontact_user\b/messages_contact_user/g' {} \;

	echo chatterbox
	find chatterbox/ -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bprune_threshold\b/chatterbox_prune_threshold/g' {} \;

	echo languages
	find languages/ -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\brecord_untranslated\b/languages_record_untranslated/g' {} \;

	echo hotwords
	find hotwords/ -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bhotwords_nw\b/hotwords_new_window/g' {} \;

	echo blogs
	find blogs/ -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bblogposts_comments\b/blog_posts_comments/g' {} \;

	echo pigeonholes
	find pigeonholes/ -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bdisplay_pigeonhole_members\b/pigeonholes_display_members/g' {} \;
	find pigeonholes/ -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\blimit_member_number\b/pigeonholes_limit_member_number/g' {} \;

	echo phpgedview
	find phpgedview/ -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bpgv_session_time\b/pgv_session_time/g' {} \;
	find phpgedview/ -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bcalendar_format\b/pgv_calendar_format/g' {} \;
	find phpgedview/ -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bdefault_pedigree_generations\b/pgv_default_pedigree_generations/g' {} \;
	find phpgedview/ -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bmax_pedigree_generations\b/pgv_max_pedigree_generations/g' {} \;
	find phpgedview/ -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bmax_descendancy_generations\b/pgv_max_descendancy_generations/g' {} \;
	find phpgedview/ -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\buse_RIN\b/pgv_use_RIN/g' {} \;
	find phpgedview/ -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bpedigree_root_id\b/pgv_pedigree_root_id/g' {} \;
	find phpgedview/ -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bgedcom_prefix_id\b/pgv_gedcom_prefix_id/g' {} \;
	find phpgedview/ -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bsource_prefix_id\b/pgv_source_prefix_id/g' {} \;
	find phpgedview/ -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\brepo_prefix_id\b/pgv_repo_prefix_id/g' {} \;
	find phpgedview/ -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bfam_prefix_id\b/pgv_fam_prefix_id/g' {} \;
	find phpgedview/ -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bmedia_prefix_id\b/pgv_media_prefix_id/g' {} \;

	echo stats
	find stats/ -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\breferer_stats\b/stats_referers/g' {} \;

	echo liberty
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bcacheimages\b/liberty_cache_images/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bcachepages\b/liberty_cache_pages/g' {} \;

	echo tidbits
	find tidbits/ -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbanning\b/tidbits_banning/g' {} \;
	find tidbits/ -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\buser_files\b/tidbits_userfiles/g' {} \;
	find tidbits/ -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\buf_use_dir\b/tidbits_userfiles_use_dir/g' {} \;
	find tidbits/ -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bfeature_tasks\b/tidbits_tasks/g' {} \;
	find tidbits/ -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\busermenu\b/tidbits_usermenu/g' {} \;
	find tidbits/ -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\buser_bookmarks\b/tidbits_bookmarks/g' {} \;

	echo messages
	find . -name "*.tpl" -exec perl -i -wpe 's/\bsite_contact\b/messages_site_contact/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bcontact_user\b/messages_contact_user/g' {} \;

	echo chatterbox
	find chatterbox/ -name "*.tpl" -exec perl -i -wpe 's/\bprune_threshold\b/chatterbox_prune_threshold/g' {} \;

	echo languages
	find languages/ -name "*.tpl" -exec perl -i -wpe 's/\brecord_untranslated\b/languages_record_untranslated/g' {} \;

	echo hotwords
	find hotwords/ -name "*.tpl" -exec perl -i -wpe 's/\bhotwords_nw\b/hotwords_new_window/g' {} \;

	echo blogs
	find blogs/ -name "*.tpl" -exec perl -i -wpe 's/\bblogposts_comments\b/blog_posts_comments/g' {} \;

	echo pigeonholes
	find pigeonholes/ -name "*.tpl" -exec perl -i -wpe 's/\bdisplay_pigeonhole_members\b/pigeonholes_display_members/g' {} \;
	find pigeonholes/ -name "*.tpl" -exec perl -i -wpe 's/\blimit_member_number\b/pigeonholes_limit_member_number/g' {} \;

	echo phpgedview
	find phpgedview/ -name "*.tpl" -exec perl -i -wpe 's/\bpgv_session_time\b/pgv_session_time/g' {} \;
	find phpgedview/ -name "*.tpl" -exec perl -i -wpe 's/\bcalendar_format\b/pgv_calendar_format/g' {} \;
	find phpgedview/ -name "*.tpl" -exec perl -i -wpe 's/\bdefault_pedigree_generations\b/pgv_default_pedigree_generations/g' {} \;
	find phpgedview/ -name "*.tpl" -exec perl -i -wpe 's/\bmax_pedigree_generations\b/pgv_max_pedigree_generations/g' {} \;
	find phpgedview/ -name "*.tpl" -exec perl -i -wpe 's/\bmax_descendancy_generations\b/pgv_max_descendancy_generations/g' {} \;
	find phpgedview/ -name "*.tpl" -exec perl -i -wpe 's/\buse_RIN\b/pgv_use_RIN/g' {} \;
	find phpgedview/ -name "*.tpl" -exec perl -i -wpe 's/\bpedigree_root_id\b/pgv_pedigree_root_id/g' {} \;
	find phpgedview/ -name "*.tpl" -exec perl -i -wpe 's/\bgedcom_prefix_id\b/pgv_gedcom_prefix_id/g' {} \;
	find phpgedview/ -name "*.tpl" -exec perl -i -wpe 's/\bsource_prefix_id\b/pgv_source_prefix_id/g' {} \;
	find phpgedview/ -name "*.tpl" -exec perl -i -wpe 's/\brepo_prefix_id\b/pgv_repo_prefix_id/g' {} \;
	find phpgedview/ -name "*.tpl" -exec perl -i -wpe 's/\bfam_prefix_id\b/pgv_fam_prefix_id/g' {} \;
	find phpgedview/ -name "*.tpl" -exec perl -i -wpe 's/\bmedia_prefix_id\b/pgv_media_prefix_id/g' {} \;

	echo stats
	find stats/ -name "*.tpl" -exec perl -i -wpe 's/\breferer_stats\b/stats_referers/g' {} \;

	echo liberty
	find . -name "*.tpl" -exec perl -i -wpe 's/\bcacheimages\b/liberty_cache_images/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bcachepages\b/liberty_cache_pages/g' {} \;

	echo tidbits
	find tidbits/ -name "*.tpl" -exec perl -i -wpe 's/\bbanning\b/tidbits_banning/g' {} \;
	find tidbits/ -name "*.tpl" -exec perl -i -wpe 's/\buser_files\b/tidbits_userfiles/g' {} \;
	find tidbits/ -name "*.tpl" -exec perl -i -wpe 's/\buf_use_dir\b/tidbits_userfiles_use_dir/g' {} \;
	find tidbits/ -name "*.tpl" -exec perl -i -wpe 's/\bfeature_tasks\b/tidbits_tasks/g' {} \;
	find tidbits/ -name "*.tpl" -exec perl -i -wpe 's/\busermenu\b/tidbits_usermenu/g' {} \;
	find tidbits/ -name "*.tpl" -exec perl -i -wpe 's/\buser_bookmarks\b/tidbits_bookmarks/g' {} \;
fi

if [ $PERMS ]
then
	echo change permission names in php files
	echo .
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_view_shoutbox\b/p_shoutbox_view/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_admin_shoutbox\b/p_shoutbox_admin/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_post_shoutbox\b/p_shoutbox_post/g' {} \;

	echo .
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_send_pages\b/p_xmlrpc_send_content/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_sendme_pages\b/p_xmlrpc_sendme_content/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_admin_received_pages\b/p_xmlrpc_admin_content/g' {} \;

	echo .
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_admin\b/p_admin/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_access_closed_site\b/p_access_closed_site/g' {} \;

	echo .
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_create_gatekeeper\b/p_gatekeeper_create/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_gatekeeper_edit\b/p_gatekeeper_edit/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_gatekeeper_admin\b/p_gatekeeper_admin/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_read_gatekeeper\b/p_gatekeeper_read/g' {} \;

	echo .
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_view_calendar\b/p_calendar_view/g' {} \;

	echo .
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_admin_sample\b/p_sample_admin/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_create_sample\b/p_sample_create/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_edit_sample\b/p_sample_edit/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_read_sample\b/p_sample_read/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_remove_sample\b/p_sample_remove/g' {} \;

	echo .
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_admin_categories\b/p_categories_admin/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_view_categories\b/p_categories_view/g' {} \;

	echo .
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_admin_banning\b/p_tidbits_admin_banning/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_userfiles\b/p_tidbits_upload_userfiles/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_create_bookmarks\b/p_tidbits_create_bookmarks/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_cache_bookmarks\b/p_tidbits_cache_bookmarks/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_configure_modules\b/p_tidbits_configure_modules/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_usermenu\b/p_tidbits_use_usermenu/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_tasks\b/p_tidbits_use_tasks/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_custom_home_theme\b/p_tidbits_custom_home_theme/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_custom_home_layout\b/p_tidbits_custom_home_layout/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_custom_css\b/p_tidbits_use_custom_css/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_edit_cookies\b/p_tidbits_edit_fortune_cookies/g' {} \;

	echo .
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_create_quota\b/p_quota_create/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_quota_edit\b/p_quota_edit/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_quota_admin\b/p_quota_admin/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_read_quota\b/p_quota_read/g' {} \;

	echo .
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_use_smileys\b/p_smileys_use/g' {} \;

	echo .
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_use_chatterbox\b/p_chatterbox_use/g' {} \;

	echo .
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_view_fisheye\b/p_fisheye_view/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_create_fisheye\b/p_fisheye_create/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_edit_fisheye\b/p_fisheye_edit/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_upload_fisheye\b/p_fisheye_upload/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_admin_fisheye\b/p_fisheye_admin/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_fisheye_upload_nonimages\b/p_fisheye_upload_nonimages/g' {} \;

	echo .
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_create_languages\b/p_languages_create/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_edit_languages\b/p_languages_edit/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_delete_languages\b/p_languages_delete/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_edit_master_strings\b/p_languages_edit_master/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_import_languages\b/p_languages_import/g' {} \;

	echo .
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_user_group_perms\b/p_users_assign_group_perms/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_user_group_members\b/p_users_assign_group_members/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_user_group_subgroups\b/p_users_group_subgroups/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_admin_users\b/p_users_admin/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_view_tabs_and_tools\b/p_users_view_icons_and_tools/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_create_personal_groups\b/p_users_create_personal_groups/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_view_user_list\b/p_users_view_user_list/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_view_user_homepage\b/p_users_view_user_homepage/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_edit_user_homepage\b/p_users_edit_user_homepage/g' {} \;

	echo .
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_admin_workflow\b/p_galaxia_admin/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_abort_instance\b/p_galaxia_abort_instance/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_use_workflow\b/p_galaxia_use/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_exception_instance\b/p_galaxia_exception_instance/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_send_instance\b/p_galaxia_send_instance/g' {} \;

	echo .
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_admin_newsletters\b/p_newsletters_admin/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_create_newsletters\b/p_newsletters_create/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_create_editions\b/p_newsletters_create_editions/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_subscribe_newsletters\b/p_newsletters_subscribe/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_subscribe_email\b/p_newsletters_subscribe_email/g' {} \;

	echo .
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_create_blogs\b/p_blogs_create/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_create_public_blog\b/p_blogs_create_public_blog/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_blog_post\b/p_blogs_post/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_blog_admin\b/p_blogs_admin/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_read_blog\b/p_blogs_view/g' {} \;

	echo .
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_pdf_generation\b/p_pdf_generation/g' {} \;

	echo .
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_messages\b/p_messages_send/g' {} \;

	echo .
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_edit_dynvar\b/p_wiki_edit_dynvar/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_edit\b/p_wiki_edit_page/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_view\b/p_wiki_view_page/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_remove\b/p_wiki_remove_page/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_rollback\b/p_wiki_rollback/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_admin_wiki\b/p_wiki_admin/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_wiki_admin_attachments\b/p_wiki_admin_attachments/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_wiki_view_attachments\b/p_wiki_view_attachments/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_upload_picture\b/p_wiki_upload_picture/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_minor\b/p_wiki_save_minor/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_rename\b/p_wiki_rename_page/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_lock\b/p_wiki_lock_page/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_edit_books\b/p_wiki_edit_book/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_admin_books\b/p_wiki_admin_book/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_edit_copyrights\b/p_wiki_edit_copyright/g' {} \;

	echo .
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_view_pigeonholes\b/p_pigeonholes_view/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_insert_pigeonhole_member\b/p_pigeonholes_insert_member/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_edit_pigeonholes\b/p_pigeonholes_edit/g' {} \;

	echo .
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_stickies_edit\b/p_stickies_edit/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_stickies_admin\b/p_stickies_admin/g' {} \;

	echo .
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_view_referer_stats\b/p_stats_view_referer/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_view_stats\b/p_stats_view/g' {} \;

	echo .
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_edit_html_style\b/p_liberty_edit_html_style/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_post_comments\b/p_liberty_post_comments/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_read_comments\b/p_liberty_read_comments/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_remove_comments\b/p_liberty_remove_comments/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_vote_comments\b/p_liberty_vote_comments/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_edit_comments\b/p_liberty_edit_comments/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_content_attachments\b/p_liberty_attach_attachments/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_detach_attachment\b/p_liberty_detach_attachment/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_print\b/p_liberty_print/g' {} \;

	echo .
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_edit_article\b/p_articles_edit/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_remove_article\b/p_articles_remove/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_read_article\b/p_articles_read/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_submit_article\b/p_articles_submit/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_edit_submission\b/p_articles_edit_submission/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_remove_submission\b/p_articles_remove_submission/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_approve_submission\b/p_articles_approve_submission/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_send_articles\b/p_articles_send/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_sendme_articles\b/p_articles_sendme/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_autoapprove_submission\b/p_articles_auto_approve/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_admin_articles\b/p_articles_admin/g' {} \;

	echo .
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_insert_nexus_item\b/p_nexus_insert_item/g' {} \;
	find . -name "*.php" -not -name "upgrade_inc.php" -exec perl -i -wpe 's/\bbit_p_create_nexus_menus\b/p_nexus_create_menus/g' {} \;


	echo change permission names in tpl files
	echo .
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_view_shoutbox\b/p_shoutbox_view/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_admin_shoutbox\b/p_shoutbox_admin/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_post_shoutbox\b/p_shoutbox_post/g' {} \;

	echo .
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_send_pages\b/p_xmlrpc_send_content/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_sendme_pages\b/p_xmlrpc_sendme_content/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_admin_received_pages\b/p_xmlrpc_admin_content/g' {} \;

	echo .
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_admin\b/p_admin/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_access_closed_site\b/p_access_closed_site/g' {} \;

	echo .
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_create_gatekeeper\b/p_gatekeeper_create/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_gatekeeper_edit\b/p_gatekeeper_edit/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_gatekeeper_admin\b/p_gatekeeper_admin/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_read_gatekeeper\b/p_gatekeeper_read/g' {} \;

	echo .
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_view_calendar\b/p_calendar_view/g' {} \;

	echo .
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_admin_sample\b/p_sample_admin/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_create_sample\b/p_sample_create/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_edit_sample\b/p_sample_edit/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_read_sample\b/p_sample_read/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_remove_sample\b/p_sample_remove/g' {} \;

	echo .
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_admin_categories\b/p_categories_admin/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_view_categories\b/p_categories_view/g' {} \;

	echo .
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_admin_banning\b/p_tidbits_admin_banning/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_userfiles\b/p_tidbits_upload_userfiles/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_create_bookmarks\b/p_tidbits_create_bookmarks/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_cache_bookmarks\b/p_tidbits_cache_bookmarks/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_configure_modules\b/p_tidbits_configure_modules/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_usermenu\b/p_tidbits_use_usermenu/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_tasks\b/p_tidbits_use_tasks/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_custom_home_theme\b/p_tidbits_custom_home_theme/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_custom_home_layout\b/p_tidbits_custom_home_layout/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_custom_css\b/p_tidbits_use_custom_css/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_edit_cookies\b/p_tidbits_edit_fortune_cookies/g' {} \;

	echo .
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_create_quota\b/p_quota_create/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_quota_edit\b/p_quota_edit/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_quota_admin\b/p_quota_admin/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_read_quota\b/p_quota_read/g' {} \;

	echo .
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_use_smileys\b/p_smileys_use/g' {} \;

	echo .
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_use_chatterbox\b/p_chatterbox_use/g' {} \;

	echo .
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_view_fisheye\b/p_fisheye_view/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_create_fisheye\b/p_fisheye_create/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_edit_fisheye\b/p_fisheye_edit/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_upload_fisheye\b/p_fisheye_upload/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_admin_fisheye\b/p_fisheye_admin/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_fisheye_upload_nonimages\b/p_fisheye_upload_nonimages/g' {} \;

	echo .
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_create_languages\b/p_languages_create/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_edit_languages\b/p_languages_edit/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_delete_languages\b/p_languages_delete/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_edit_master_strings\b/p_languages_edit_master/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_import_languages\b/p_languages_import/g' {} \;

	echo .
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_user_group_perms\b/p_users_assign_group_perms/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_user_group_members\b/p_users_assign_group_members/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_user_group_subgroups\b/p_users_group_subgroups/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_admin_users\b/p_users_admin/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_view_tabs_and_tools\b/p_users_view_icons_and_tools/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_create_personal_groups\b/p_users_create_personal_groups/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_view_user_list\b/p_users_view_user_list/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_view_user_homepage\b/p_users_view_user_homepage/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_edit_user_homepage\b/p_users_edit_user_homepage/g' {} \;

	echo .
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_admin_workflow\b/p_galaxia_admin/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_abort_instance\b/p_galaxia_abort_instance/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_use_workflow\b/p_galaxia_use/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_exception_instance\b/p_galaxia_exception_instance/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_send_instance\b/p_galaxia_send_instance/g' {} \;

	echo .
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_admin_newsletters\b/p_newsletters_admin/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_create_newsletters\b/p_newsletters_create/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_create_editions\b/p_newsletters_create_editions/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_subscribe_newsletters\b/p_newsletters_subscribe/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_subscribe_email\b/p_newsletters_subscribe_email/g' {} \;

	echo .
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_create_blogs\b/p_blogs_create/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_create_public_blog\b/p_blogs_create_public_blog/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_blog_post\b/p_blogs_post/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_blog_admin\b/p_blogs_admin/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_read_blog\b/p_blogs_view/g' {} \;

	echo .
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_pdf_generation\b/p_pdf_generation/g' {} \;

	echo .
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_messages\b/p_messages_send/g' {} \;

	echo .
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_edit_dynvar\b/p_wiki_edit_dynvar/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_edit\b/p_wiki_edit_page/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_view\b/p_wiki_view_page/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_remove\b/p_wiki_remove_page/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_rollback\b/p_wiki_rollback/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_admin_wiki\b/p_wiki_admin/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_wiki_admin_attachments\b/p_wiki_admin_attachments/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_wiki_view_attachments\b/p_wiki_view_attachments/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_upload_picture\b/p_wiki_upload_picture/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_minor\b/p_wiki_save_minor/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_rename\b/p_wiki_rename_page/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_lock\b/p_wiki_lock_page/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_edit_books\b/p_wiki_edit_book/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_admin_books\b/p_wiki_admin_book/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_edit_copyrights\b/p_wiki_edit_copyright/g' {} \;

	echo .
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_view_pigeonholes\b/p_pigeonholes_view/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_insert_pigeonhole_member\b/p_pigeonholes_insert_member/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_edit_pigeonholes\b/p_pigeonholes_edit/g' {} \;

	echo .
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_stickies_edit\b/p_stickies_edit/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_stickies_admin\b/p_stickies_admin/g' {} \;

	echo .
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_view_referer_stats\b/p_stats_view_referer/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_view_stats\b/p_stats_view/g' {} \;

	echo .
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_edit_html_style\b/p_liberty_edit_html_style/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_post_comments\b/p_liberty_post_comments/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_read_comments\b/p_liberty_read_comments/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_remove_comments\b/p_liberty_remove_comments/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_vote_comments\b/p_liberty_vote_comments/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_edit_comments\b/p_liberty_edit_comments/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_content_attachments\b/p_liberty_attach_attachments/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_detach_attachment\b/p_liberty_detach_attachment/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_print\b/p_liberty_print/g' {} \;

	echo .
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_edit_article\b/p_articles_edit/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_remove_article\b/p_articles_remove/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_read_article\b/p_articles_read/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_submit_article\b/p_articles_submit/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_edit_submission\b/p_articles_edit_submission/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_remove_submission\b/p_articles_remove_submission/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_approve_submission\b/p_articles_approve_submission/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_send_articles\b/p_articles_send/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_sendme_articles\b/p_articles_sendme/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_autoapprove_submission\b/p_articles_auto_approve/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_admin_articles\b/p_articles_admin/g' {} \;

	echo .
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_insert_nexus_item\b/p_nexus_insert_item/g' {} \;
	find . -name "*.tpl" -exec perl -i -wpe 's/\bbit_p_create_nexus_menus\b/p_nexus_create_menus/g' {} \;
fi
