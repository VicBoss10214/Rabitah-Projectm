# Clickable Rabitah desktop apps

The desktop package contains a Java runtime and connects directly to the Railway API. It does not start Maven, a local backend, or server discovery, so it opens much faster than the development scripts.

## Build locally

Use a JDK 21 (not a JRE) on the operating system you are packaging for.

Linux or macOS:

```bash
cd "/path/to/Rabitah-Projectm"
chmod +x scripts/package-desktop.sh
./scripts/package-desktop.sh
```

Windows PowerShell:

```powershell
cd "C:\path\to\Rabitah-Projectm"
powershell -ExecutionPolicy Bypass -File scripts\package-desktop.ps1
```

The output is a self-contained app image in `dist/`. Click the generated Rabitah launcher: `Rabitah.exe` on Windows, `Rabitah.app` on macOS, or `Rabitah/bin/Rabitah` on Linux.

To package a different hosted API, set `RABITAH_API_BASE_URL` before running the script.

## Build all operating systems from GitHub

Push the repository, then open **GitHub → Actions → Build desktop apps → Run workflow**. Download the three generated artifacts after the workflow completes. Each operating system’s app image must be built on that operating system.

macOS may show an unsigned-app warning because signing/notarization requires an Apple Developer account. On first open, use **Control-click → Open**.
