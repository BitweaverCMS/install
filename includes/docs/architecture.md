# Install architecture

## Package role

Install performs environment checks, database configuration, package schema installation, upgrades, and cleanup.

## Initialization

The package bootstrap is none. Bitweaver discovers package bootstraps during
Kernel package scanning. Treat bootstrap files as registration and wiring code:
they can define constants, register the package, load shared classes, attach
Liberty services, and expose values to Smarty.

Do not call a package bootstrap as a web endpoint. All normal controllers must
load `kernel/includes/setup_inc.php` before using framework globals.

## Architectural responsibilities

Owns installation orchestration and the BitInstaller implementation used by package schema files.

## Dependency direction

This package depends on kernel, languages, util; package schema files discovered during installation. Calls into shared packages should
use their public classes, globals, services, and registered content types rather
than duplicating their persistence.

Does not participate in normal request handling after installation is secured or removed.

## Request and rendering pattern

Most package controllers follow Bitweaver's established flow:

1. Load Kernel setup.
2. Resolve and validate request identifiers.
3. Construct or load the domain object.
4. Enforce global and content-level permissions before mutation or disclosure.
5. Perform the domain operation.
6. Assign data to Smarty and render a package template.

Package-specific controllers and templates are enumerated in
[source-reference.md](source-reference.md). Read the controller and its included
files together; many older controllers delegate substantial behavior to
`*_inc.php` files.

## Persistence

When `admin/schema_inc.php` exists it is the canonical install-time declaration
of tables, sequences, indexes, constraints, permissions, and default
preferences. Runtime SQL must be checked against that file and relevant upgrade
scripts. Never infer a deployed database's exact migration state from the base
schema alone.

## Presentation

Templates belong to the package but are resolved through Themes/Smarty.
Controllers own request handling; templates should render assigned state rather
than perform domain mutations.
