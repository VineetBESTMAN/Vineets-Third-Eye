# Local Windows handover

This is a complete Git clone of [bilawalsidhu/gods-eye-view](https://github.com/bilawalsidhu/gods-eye-view), with its source, bundled assets, original documentation, license, branches and tags fetched locally. The starting `main` commit is `202cb8c3dcf88d101398d74bc684385b74b9da30` (3,728 reachable commits). Upstream attribution and third-party notices are preserved.

## Start on this PC

1. Open `F:\OSINT project\gods-eye-view`.
2. Double-click `start-windows.cmd`.
3. Open <http://localhost:4173> in a WebGL-capable browser.
4. Choose **Explore Manually**, or one of the first-run missions.
5. Stop the foreground server with **Ctrl+C** in its terminal.

The launcher binds to localhost and uses strict port selection. If the app is already running, open the URL instead of starting a second instance. Port conflicts produce an error rather than silently changing the URL.

On Windows the launcher enables one-second polling for file watching, avoiding a native-watcher `EBUSY` crash observed when copying a documentation image. This may use more background CPU than native file events and adds up to roughly one second before detecting edits.

The installed runtime is `F:\OSINT project\.tools\node-v24.22.3-win-x64`. The system Node 18 installation is unchanged. The launchers select Node 24.22.3 automatically. Running plain `npm` in a new terminal may still select system Node 18: use the commands below instead.

## Reproduce on a fresh Windows x64 PC

Install Git, clone your GitHub copy, and double-click `setup-windows.cmd`. It downloads portable Node 24.22.3 from nodejs.org, verifies its SHA-256 against the official manifest, extracts it into `.tools`, installs the exact dependency lockfile with `npm ci`, downloads Puppeteer's test browser, and runs the setup doctor. It needs internet access and several GB of free disk space. The script changes no global PATH or system installation. A sibling `.tools` runtime is reused when available.

Then run `start-windows.cmd`. No API key is required for basic startup. Dependencies and generated binaries are intentionally reproducible downloads rather than Git objects.

## Maintenance and verification

Run these from the repository in PowerShell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\windows.ps1 -Action Install
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\windows.ps1 -Action Doctor
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\windows.ps1 -Action Build
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\windows.ps1 -Action Test
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\windows.ps1 -Action Check
```

`Check` runs doctor, formatting, package boundaries, unit tests, then production build. `Build` produces `dist/`. The development server includes provider middleware; opening `index.html` or `dist/index.html` directly is not a supported way to run the application. Use the local server for normal operation.

With the server already running, use `-Action Track` for the upstream tracking regression suite. It uses synthetic feeds and bundled imagery, so its passes do not establish live-provider availability. `scripts/smoke-local.mjs` separately checks real keyless startup and writes a screenshot and JSON report to `qa-artifacts/local-smoke/`. Set `PUPPETEER_CACHE_DIR` to the workspace `.tools\puppeteer` directory when invoking that script directly.

For the keyless browser smoke check, use `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\windows.ps1 -Action Smoke` while the server is running.

The unit runner now batches filenames on Windows to avoid `ENAMETOOLONG`; all discovered files remain included, and the original isolated allocation checks remain in place.

## Features and credentials

| Feature | Local keyless behavior / configuration |
| --- | --- |
| Globe | Esri satellite imagery and keyless terrain; internet and WebGL required |
| Aircraft | Anonymous OpenSky, subject to provider rate limits and availability |
| Satellites / earthquakes / launch missions | Public feeds; availability depends on providers |
| Traffic | Built-in simulation; distinguish this from live observations |
| Google photorealistic 3D / Places | Optional Google provider credentials |
| Cesium ion assets | Optional Cesium ion token |
| Voice | Optional OpenAI credentials or upstream's experimental supported sign-in path |
| Vessels | AISStream key required |
| Fires | NASA FIRMS key required |
| TomTom / Mapillary | Respective provider credentials required |

Use the app's **Provider Settings** and consult `.env.example` for all supported variables. Real credentials belong in ignored local environment files, never in commits. No personal API keys were supplied or configured during this setup. Local installation does not mean the live data is available offline, and it does not include paid subscriptions or service accounts.

## Deliverables and documentation map

- `LOCAL-WINDOWS.md`: installation, launch, credentials, maintenance and troubleshooting.
- `LOCAL-VALIDATION.md`: measured checks, failures and limitations for this PC.
- `setup-windows.cmd`, `start-windows.cmd`, `scripts/windows.ps1`: repeatable Windows setup and operation.
- `scripts/smoke-local.mjs`: browser startup evidence capture.
- `scripts/run-unit-tests.mjs` and `src/unitTestRunner.test.mjs`: Windows command-length fix and regression coverage.
- `README.md`: original feature guide and first five minutes.
- `DATA_SOURCES.md`, `.env.example`: provider inventory and configuration.
- `TESTING.md`, `docs/`, `CONTRIBUTING.md`: upstream manual tests, architecture and development guidance.
- `LICENSE`, `THIRD_PARTY_NOTICES.md`, `SECURITY.md`: original licensing, attribution and security guidance.
- `dist/`, `.gev-logs/`, `qa-artifacts/`, `node_modules/`: local generated output, deliberately ignored in Git.

## Troubleshooting

- **Unsupported Node:** use the supplied launchers. Do not use the system Node 18 for this repository.
- **Port 4173 occupied:** check whether the app already answers at localhost:4173. Stop the owning app before relaunching; the launcher does not kill arbitrary processes.
- **Blank globe:** enable browser hardware acceleration/WebGL, check network access to imagery providers, and examine the browser console. Headless software-rendering tests do not measure your GPU's performance.
- **Missing live data:** inspect the provider status and credentials; rate limits or upstream outages cannot be fixed by reinstalling the UI.
- **Dependency errors:** stop the server, run setup again, then doctor. This reinstalls from the committed lockfile.
- **Slow tests:** the upstream suite is large and browser tests can be expensive under software rendering. Run verification tasks sequentially on resource-constrained PCs.

## Updating the copy

`origin` is intended to point at your GitHub copy and `upstream` at the original project. Review updates before merging:

```powershell
git fetch upstream --tags
git log --oneline HEAD..upstream/main
git merge upstream/main
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\windows.ps1 -Action Install
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\windows.ps1 -Action Check
git push origin main
```

Resolve any merge conflicts before testing and pushing. Preserve the original license and all data/asset-specific notices when redistributing.
