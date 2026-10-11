# Security Checklist

**Last reviewed: October 11, 2026.**

**Status: local demo / prototype stage.** NUMS is a Flutter cookie ordering
prototype published as a browser demo on GitHub Pages. The repository has Git
history and a GitHub Actions deployment workflow, but the app has no backend.
Accounts, orders, cart contents, notifications, inventory, and batch progress
are held in memory and reset when the app restarts. Sign-in and payment are
local demonstrations; they do not provide production authentication, access
control, or payment processing.

This checklist reflects the current repository and app behavior. Recheck it if
the app later uses real customer accounts, a backend, or payment processing.

## Secrets and credentials

| # | Check | Yes / No / N/A | Evidence |
| --- | --- | --- | --- |
| 1 | No API key, token, or password is hardcoded in `lib/`, including comments and commented-out code | No | `lib/providers/auth_provider.dart` contains fixed demo account passwords; they are public sample values, not private credentials. |
| 2 | Private configuration is gitignored or passed with `--dart-define`, with an example file committed | N/A | The app has no private configuration, API keys, or backend URL. |
| 3 | No keystore, `key.properties`, or signing credential is in the repository | N/A | The repository has no Android or iOS platform folder or signing configuration. |
| 4 | Git history is clean: I searched `git log -p` for password, secret, API key, and token | No | History contains the same intentional demo account passwords from `auth_provider.dart`; no production credential was found. |
| 5 | Any credential that was ever committed has been rotated | N/A | No real account credential was committed; the only passwords are fixed demo values with no external authentication service. |

## GitHub Actions

| # | Check | Yes / No / N/A | Evidence |
| --- | --- | --- | --- |
| 6 | No secret value is written literally in any workflow YAML file | Yes | `.github/workflows/deploy-pages.yml` contains no API key, password, or token value. |
| 7 | Secrets are stored in repository Actions secrets and read with `${{ secrets.NAME }}` | N/A | The deployment uses no repository secrets or private configuration. |
| 8 | No workflow step echoes, dumps, or debug-prints a secret, and I opened a recent run's log to confirm | No | The workflow has no secret-printing step, but GitHub requires sign-in to inspect the run logs, so I could not verify the log output. |
| 9 | If I build a signed APK: the keystore is a base64 secret decoded to a file at build time, never printed | N/A | There is no Android project or signed APK build. |
| 10 | Uploaded build artifacts contain no key file, keystore, or generated private config | Yes | The Pages artifact contains the compiled web app and public assets; no signing files or private config are part of the build. |
| 11 | Third-party actions are pinned to a commit SHA, not a moveable tag | No | The Pages workflow references actions by version tags such as `@v4` and `@v5`, not commit SHAs. |
| 12 | Secret scanning and push protection are enabled on the repository | No | I could not verify these controls in repository settings; treat them as unconfirmed until checked by the owner. |

## Backend and security rules

| # | Check | Yes / No / N/A | Evidence |
| --- | --- | --- | --- |
| 13 | Firestore and Storage rules are not left open to anyone; they require an authenticated user | N/A | NUMS does not use Firebase, Firestore, Storage, or another backend. |
| 14 | Rules restrict a user to their own documents where that makes sense | N/A | There are no remote user documents or backend rules. |
| 15 | If Supabase: Row Level Security is on for every table | N/A | Supabase is not used and there are no database tables. |
| 16 | Firebase and Google API keys are restricted in the Google Cloud console to the APIs and app they are for | N/A | The app has no Firebase project or Google API key. |
| 17 | I opened the app signed out and confirmed I could not read or write data I should not | N/A | There is no server-side data to read or write; the local demo login and staff screens are not security controls. |
| 18 | Seed and sample data is invented, not real people's data | Yes | The app's sample accounts, products, orders, and inventory are demo data; no real customer records are used. |

## Input and app surface

| # | Check | Yes / No / N/A | Evidence |
| --- | --- | --- | --- |
| 19 | Input is validated before it is written, not only styled as valid in the UI | No | Login and sign-up perform basic checks, and custom requests reject blank text, but free-text inputs are not consistently validated in the state layer; all app data remains local. |
| 20 | Nothing secret is recoverable from the built app, since a shipped binary can be unpacked | Yes | No private key or production credential is bundled; the fixed demo passwords are public sample values and must not be reused elsewhere. |

## Repository and privacy

| # | Check | Yes / No / N/A | Evidence |
| --- | --- | --- | --- |
| 21 | No student number, personal email, phone number, or home address is in the repository or commit messages | No | Public Git commit metadata includes the account's personal email address. |
| 22 | No classmate's personal data is in the repository | Yes | The checked app content uses demo accounts and sample order data; no classmate's personal details were found. |
| 23 | Dependencies come from pub.dev, and `build/` and `.dart_tool/` are gitignored | Yes | Flutter packages are declared through the Flutter SDK or pub.dev, and `.gitignore` excludes generated build and tool directories. |
| 24 | Images, fonts, and other assets are mine, licensed, or credited | No | The repository does not document the source or license for every bundled image and font asset. |
| 25 | Repository visibility is deliberate, and I checked it after my last push | Yes | The public `JethroMarkBejec/nums` repository and its GitHub Pages app are accessible without signing in. |

## Anything I found and fixed

The app contains public demo passwords in its local authentication provider.
They are not private credentials, but anyone can inspect a published client app,
so they must not be reused for real accounts. The app has no backend and its
local demo login does not protect staff data. GitHub Actions successfully built
and deployed the web app; the workflow actions use version tags, and I could not
verify repository secret-scanning settings or inspect run logs without signing
in. Asset licenses and sources also need to be recorded. These are prototype
limitations, not production security guarantees.
