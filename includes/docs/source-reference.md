# Install source reference

> Generated from the current checkout and then intended for human review.
> Paths are relative to the package root.

## Inventory summary

| Artifact | Count |
|---|---:|
| PHP files | 32 |
| Smarty templates | 37 |
| JavaScript files | 0 |
| CSS files | 1 |

## Bootstrap and schema artifacts


## First-party classes and interfaces

- `includes/classes/BitInstaller.php:10` — `class BitInstaller extends BitSystem {`

## Web-facing PHP controllers

- `create_firebird_database.php`
- `index.php`
- `install.php`
- `migrate.php`
- `migrate_database.php`
- `migrate_final.php`
- `migrate_welcome.php`
- `process_sql.php`
- `upgrade.php`
- `upgrade_database.php`
- `upgrade_final.php`
- `upgrade_packages.php`
- `upgrade_welcome.php`

## Declared schema tables

No table declaration was mechanically identified. Inspect schema files and runtime SQL before concluding that the package is stateless.

## Plugin and module directories


## Templates

- `templates/install.tpl`
- `templates/install_admin_inc.tpl`
- `templates/install_admin_inc_done.tpl`
- `templates/install_beta1_beta2.tpl`
- `templates/install_beta1_beta2_done.tpl`
- `templates/install_bit_settings.tpl`
- `templates/install_bit_settings_done.tpl`
- `templates/install_checks.tpl`
- `templates/install_cleanup.tpl`
- `templates/install_cleanup_done.tpl`
- `templates/install_database.tpl`
- `templates/install_database_done.tpl`
- `templates/install_database_reset.tpl`
- `templates/install_datapump.tpl`
- `templates/install_datapump_done.tpl`
- `templates/install_final_done.tpl`
- `templates/install_login.tpl`
- `templates/install_options.tpl`
- `templates/install_packages.tpl`
- `templates/install_packages_done.tpl`
- `templates/install_upgrade.tpl`
- `templates/install_upgrade_done.tpl`
- `templates/install_version.tpl`
- `templates/install_version_done.tpl`
- `templates/install_welcome.tpl`
- `templates/migrate_database.tpl`
- `templates/migrate_database_done.tpl`
- `templates/migrate_final_done.tpl`
- `templates/migrate_welcome.tpl`
- `templates/upgrade_database.tpl`
- `templates/upgrade_database_done.tpl`
- `templates/upgrade_final_done.tpl`
- `templates/upgrade_packages.tpl`
- `templates/upgrade_packages_done.tpl`
- `templates/upgrade_ready.tpl`
- `templates/upgrade_results.tpl`
- `templates/upgrade_welcome.tpl`

## Reading cautions

- Presence in this inventory does not make a file a supported public API.
- Bundled third-party libraries must be distinguished from package-owned code.
- Base schema files do not prove the migration state of a deployed database.
- Controllers may rely on include files, globals, services, and template callbacks not visible from their filename alone.
