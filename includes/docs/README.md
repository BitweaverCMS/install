# Install package documentation

> Engineering documentation derived from the source in this package. The
> package's `includes/` directory must be denied to direct HTTP requests.

## Purpose

Install performs environment checks, database configuration, package schema installation, upgrades, and cleanup.

## Responsibility

Owns installation orchestration and the BitInstaller implementation used by package schema files.

## Dependencies

kernel, languages, util; package schema files discovered during installation.

Dependency direction matters: this package may depend on the packages above;
the dependencies do not thereby depend on this package.

## Boundary

Does not participate in normal request handling after installation is secured or removed.

## Documentation map

- [Architecture](architecture.md) — initialization, components, and request flow.
- [Source reference](source-reference.md) — source-derived files, classes,
  controllers, schema artifacts, plugins, and templates.
- [Development guide](development.md) — safe change workflow, extension points,
  validation, and maintenance guidance.
- [Security](security.md) — trust boundaries and direct-HTTP access requirements.
- [Installer and schema lifecycle](installer-schema-lifecycle.md) — checks,
  configuration, package discovery, schema contracts, upgrades, and lockdown.
