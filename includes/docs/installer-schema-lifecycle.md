# Installer and schema lifecycle

## Installer boundary

Install is a privileged bootstrap application. It operates before a normal site
is fully configured and can create configuration, schema, permissions, and
package state. It must be disabled or denied after installation.

Verify behavior against current files before relying on a historical deployment
assumption.

## Entry and phases

`install.php` coordinates the browser workflow through include files and Smarty
templates. Supporting controllers handle database migration, SQL processing,
upgrade, and cleanup.

The conceptual phases are:

1. Welcome and environment requirements.
2. Filesystem/configuration readiness.
3. Database selection and connection.
4. Core schema installation.
5. Package discovery and selection.
6. Package schema, preferences, permissions, and data installation.
7. Upgrade/migration when an existing install is detected.
8. Configuration write and installation cleanup/lockdown.

Never assume an installer request has normal `$gBitUser` authorization.
Operational access controls and explicit installer state are primary defenses.

## `BitInstaller`

`includes/classes/BitInstaller.php` provides the registry/execution surface
used by package `admin/schema_inc.php` files. Packages register:

- Tables.
- Constraints.
- Indexes.
- Sequences.
- Preferences.
- Permissions.
- Package metadata and version information.
- Data rows or upgrade work where supported.

Registration describes intended schema; execution order resolves dependencies.
Cross-package constraints may need a later phase because required packages can
have circular schema references.

## Package schema contract

A package base schema must be usable for a fresh install. Upgrade scripts must
move prior supported versions forward. A change is incomplete if it updates only
one path.

For a schema change:

1. Update `admin/schema_inc.php`.
2. Add/update the correct upgrade script and version.
3. Register indexes, constraints, and sequences explicitly.
4. Define default preferences and permissions.
5. Consider uninstall/cleanup behavior.
6. Test fresh install and upgrade from a representative older version.

Use installer/ADOdb portable types unless the package explicitly limits its
database support.

## Package discovery

Kernel scans `admin/schema_inc.php` for installable packages. Schema files
should register declarations; they should not assume the package's normal
runtime setup has completed.

Required-package order matters. Optional-package absence must not make an
unrelated core install fail.

## Configuration files

Database credentials and installation configuration are secrets. The installer
must:

- Avoid echoing passwords in forms, errors, or logs.
- Write with restrictive ownership/permissions.
- Avoid following attacker-controlled symlinks.
- Use atomic/validated writes where supported.
- Never place backups beneath a directly served path.

## Migration and SQL utilities

Migration and raw SQL processing are especially privileged. Restrict access,
validate source/target configuration, use transactions where the database and
operation support them, and report failures without dumping credentials.

Large migrations need resumable/idempotent design or explicit recovery steps.

## Cleanup and lockdown

Successful installation is not complete until the installer can no longer be
invoked remotely. Deployments should remove, rename, or server-deny Install
according to their operating model. `includes/` denial alone does not block
top-level `install.php`.

Verify:

- Installer URL is unavailable.
- Configuration is not downloadable.
- `includes/` and documentation return 403/404.
- Temporary SQL/config files are absent.
- Database user privileges are no broader than required.

## Testing matrix

- Fresh install for each supported database.
- Upgrade from each supported baseline.
- Missing PHP extension and unwritable directory failures.
- Invalid/partial database credentials.
- Interrupted schema step and retry.
- Required/optional package dependency order.
- Existing table/sequence/index handling.
- Secret redaction in HTML and logs.
- Post-install remote denial.
