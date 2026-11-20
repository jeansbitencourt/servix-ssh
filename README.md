# Servix — SSH Operations Center

<img src="assets/branding/servix-logo.png" alt="Servix — SSH Operations Center" width="720">

Servix is a Flutter desktop app for **Linux, Windows, and macOS**. Manage SSH connections, run remote commands with one click, and work in built-in interactive terminals.

---

## ✨ Features

- 🔑 **SSH connection management**
  - Save servers with a port, username, and IP address or hostname. Organize them into groups such as Production, Staging, and Database.
  - Authenticate with a password or a private key (Ed25519, RSA, or PEM). Select key files in the native file picker and supply a passphrase when required.
  - Store passwords and key passphrases in the system credential store.
  - Test SSH connectivity directly from the app.

- ⚡ **One-click command shortcuts**
  - Save frequently used commands such as `uptime`, `free -m`, `df -h`, and `docker ps`.
  - Run commands non-interactively. Servix opens a connection, captures standard output, standard error, and the exit code, records the execution time, and disconnects.
  - Review and copy the output in a monospace dialog. The dialog shows a green status for exit code 0 and a red status for other exit codes.
  - Browse past executions stored in the local SQLite database.

- 💻 **Tabbed interactive terminal**
  - Use a built-in terminal compatible with `xterm-256color` and VT100 escape sequences.
  - Run full-screen tools such as `top`, `htop`, `vim`, and `nano` in a remote pseudo-terminal (PTY).
  - Resize the window and let the remote PTY adjust to the available space.
  - Switch tabs while open connections and their terminal buffers stay active in the background.
  - Change the font size, clear the screen, or reconnect from the toolbar.

- 🔀 **SSH tunnels**
  - Forward a local TCP port through a registered SSH server to a private service.
  - Manage each tunnel independently of terminal tabs, with optional startup and reconnect settings.
  - Check the local listener status and the number of active TCP connections.

- 🎨 **Responsive desktop interface**
  - Work in a dark Slate/Zinc theme with Indigo/Cyan accents.
  - Use the responsive sidebar to navigate, check the credential store status, and see how many terminals are active.
  - View metrics, frequently used shortcuts, and recent command executions on the dashboard.

---

## SSH host identity

Servix verifies the server’s signed host key before authentication for connection tests, commands, terminals, and tunnels. On first contact, compare the displayed algorithm and full OpenSSH `SHA256:` fingerprint with a value from a trusted source. Select **Trust this key** only after checking the fingerprint. Existing saved servers also require confirmation on their next connection.

Servix pins one negotiated algorithm and fingerprint per normalized hostname and SSH port. DNS names are compared without case or a final dot. IP literals are canonicalized, and DNS aliases and IP addresses have separate trust records. If a server offers multiple keys, Servix pins the one negotiated during verification. A different key or negotiated algorithm requires review, even when both keys are legitimate.

If a key changes, Servix blocks the connection and displays the previous and presented identities. For a planned rotation, verify the new fingerprint with the server administrator, choose **Review replacement**, and explicitly confirm **Replace trusted key**. Start a fresh connection afterward. A change during an established connection’s key exchange also terminates the connection. Start a fresh connection to review that key. Servix retains trust records when you delete a server registration, so recreating a registration uses the endpoint’s existing trust decision.

## Tunnel to a private RDS MySQL instance

1. In **Servers**, add the EC2 instance that can reach the private RDS endpoint. Use the EC2 SSH username and credentials.
2. In **Tunnels**, choose **New tunnel**, give it a name and select the EC2 server. Set **Remote host** to the RDS endpoint, **Remote port** to `3306`, and **Local port** to `3307`.
3. Save and start the tunnel. When prompted, compare the EC2 host key fingerprint with a trusted value and confirm it.
4. In DBeaver, create a MySQL connection to `127.0.0.1:3307` with the RDS database credentials. Use the copy button in Servix to copy the local endpoint. The EC2 instance must be able to resolve and reach the RDS endpoint, and its SSH server must allow local port forwarding.

The bind address is always IPv4 loopback. A tunnel listens locally after SSH authentication and creates a separate SSH channel for each incoming TCP connection. **Listening locally** reports the state of that listener. Servix reports destination or forwarding failures after a client attempts to connect. A tunnel accepts up to 128 active or pending TCP connections at a time.

Both automatic settings are off for a new tunnel. **Connect at startup** opens the tunnel after the app is ready to display trust prompts and use the system vault. **Reconnect automatically** retries connectivity failures with delays up to 30 seconds and stops on authentication, trust, or local bind failures. After reconnection, clients must open new TCP connections. Stop a tunnel before editing it. Delete or reassign its tunnels before deleting an SSH server.

Tunnels carry TCP traffic. The SSH tunnel encrypts transport to the SSH server. Configure the destination protocol’s TLS independently when needed.

---

## 🛠️ Technology Stack and Architecture

Servix follows Clean Architecture. Dependencies point toward the domain layer.

| Layer or role | Technology or package | Description |
|---|---|---|
| **Presentation and state** | `signals_flutter` | Reactive state management |
| **Embedded terminal** | `xterm` | ANSI/VT100 rendering and terminal scrollback |
| **SSH protocol** | `dartssh2` | Dart SSH-2 client with password and private-key authentication, PTY allocation, and streaming |
| **Local persistence** | `drift` + `sqlite3` | Typed storage for hosts, shortcuts, execution history, tunnel configurations, and trusted host keys |
| **Credential storage** | `flutter_secure_storage` | Secret Service on Linux, Keychain on macOS, and Credential Manager on Windows |
| **Dependency injection** | `get_it` | Service locator |
| **File picker** | `file_selector` | Native dialog for selecting SSH private keys |

### Directory Structure

```text
lib/
├── core/
│   ├── di/injection.dart                  # GetIt dependency registration
│   ├── errors/                            # Shared exceptions and failure types
│   ├── theme/
│   │   ├── app_brand.dart                 # Servix name, tagline, and icon
│   │   ├── app_theme.dart                 # Dark Slate/Indigo theme
│   │   └── terminal_theme.dart            # Terminal typography and colors
│   └── utils/date_formatter.dart          # Date and duration formatting
├── data/
│   ├── datasources/
│   │   ├── local_database.dart            # Drift tables and SQLite setup
│   │   ├── secure_storage_datasource.dart # System credential storage
│   │   ├── ssh_connection_factory.dart   # Authentication and host verification
│   │   ├── ssh_remote_datasource.dart     # Commands and PTY sessions
│   │   └── ssh_tunnel_datasource.dart     # TCP forwarding and tunnel lifecycle
│   ├── models/                            # Data transfer objects and entity mappings
│   └── repositories/                      # Repository implementations
├── domain/
│   ├── entities/                          # Hosts, commands, results, and terminal sessions
│   ├── repositories/                      # Repository interfaces
│   └── usecases/                          # Host management, command execution, and SSH sessions
└── presentation/
    ├── stores/                            # Reactive stores for hosts, shortcuts, and sessions
    ├── views/
    │   ├── main_layout.dart               # Desktop layout and sidebar
    │   ├── dashboard_view.dart            # Metrics, quick actions, and recent executions
    │   ├── hosts_view.dart                # Server list and details
    │   ├── shortcuts_view.dart            # Command shortcuts
    │   ├── terminal_view.dart             # Tabbed terminal emulator
    │   └── tunnels_view.dart              # Tunnel management
    └── widgets/                           # Reusable components and dialogs
```

---

## 🚀 Installation and Development

### Install on Linux

Install the Secret Service development library required by `flutter_secure_storage`.

**Fedora / RHEL**

```bash
sudo dnf install -y libsecret-devel
```

**Ubuntu / Debian**

```bash
sudo apt install -y libsecret-1-dev
```

**Arch Linux**

```bash
sudo pacman -S libsecret
```

Add Flutter to your `PATH` and install the Linux build dependencies (Clang, CMake, Ninja, pkg-config, and GTK 3 development files). The Linux scripts also use `flock` from util-linux. Run the installer from the repository root.

```bash
./scripts/install-linux.sh
```

The script builds the release bundle, installs it in `$XDG_DATA_HOME/com.servix.Servix/bundle`, and adds **Servix** to the application menu. The data directory defaults to `~/.local/share`. Run the same command after updating the source code to replace the installed version. If you previously installed ControlPanel, the script archives its old launcher.

### Install on Windows

Install Flutter and Visual Studio with the *Desktop development with C++* workload. From the repository root, run the installer in PowerShell. [Flutter setup for Windows](https://docs.flutter.dev/platform-integration/windows/setup)

```powershell
.\scripts\install-windows.ps1
```

The installer builds the release bundle, copies it to `%LOCALAPPDATA%\Programs\Servix`, and adds **Servix** to the Start menu. Close Servix before running the script again to update it.

### Install on macOS

On a Mac with Flutter, Xcode configured, and CocoaPods installed, run the installer from the repository root. [Flutter setup for macOS](https://docs.flutter.dev/platform-integration/macos/setup)

```bash
./scripts/install-macos.sh
```

The installer builds the release app and copies **Servix.app** to `~/Applications`. Open it from Finder. The local build can reopen saved SSH key paths across sessions using your account's file permissions. Distribution signing and notarization require separate setup.

### Uninstall Servix

Close Servix, then run the script for your platform from the repository root with the same user account you used to install it. On Linux, use the same `XDG_DATA_HOME` setting. Run the scripts with your regular user privileges. Uninstalling does not require Flutter.

**Linux**

```bash
./scripts/uninstall-linux.sh
```

**Windows (PowerShell)**

```powershell
.\scripts\uninstall-windows.ps1
```

**macOS**

```bash
./scripts/uninstall-macos.sh
```

The scripts remove the installed app and its application menu entry on Linux or Start menu shortcut on Windows. Saved hosts, command shortcuts, execution history, and credentials remain available when you reinstall Servix.

### Data from Previous Versions

Servix uses a new database, `servix.sqlite`, in the application's support directory and has its own credential store identifier. Add your ControlPanel servers and credentials again in Servix. Future Servix reinstalls reuse the new data.

### Install Flutter Dependencies

```bash
flutter pub get
```

### Edit App Translations

Servix follows the operating system’s preferred languages and falls back to English. Edit the English messages in `lib/l10n/app_en.arb` and the Brazilian Portuguese messages in `lib/l10n/app_pt.arb`. The `app_pt_BR.arb` bundle declares the regional locale and inherits the Portuguese messages.

Run `flutter gen-l10n` after editing the catalogs. `flutter pub get` also generates the localization classes.

### Regenerate Drift Code After Schema Changes

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Run Automated Tests

```bash
flutter test
```

### Run the Desktop App During Development

```bash
flutter run -d linux
```

### Build a Linux Release Bundle

```bash
flutter build linux --release
```

On x64, the executable is at `build/linux/x64/release/bundle/servix`. Keep it in the bundle alongside the shared libraries and assets.

---

## 🔒 Security

- **Local database** — SQLite stores connection details, shortcut definitions, and execution history.
- **Credential storage** — Servix stores SSH passwords and key passphrases in the system credential store through `flutter_secure_storage`.

---

## 📝 License

Distributed under the MIT License.

### SSH and tunnel integration tests

Run `flutter test` for the standard suite, including migration and tunnel lifecycle coverage. To exercise a temporary OpenSSH server on Linux, install `sshd` and `ssh-keygen` and run the following command.

```bash
flutter test --dart-define=SERVIX_OPENSSH_TESTS=true test/ssh_openssh_integration_test.dart
```

The test uses the current local account and disposable Ed25519 keys on loopback. Set `SERVIX_SSHD` to the absolute executable path if `/usr/bin/sshd` is unavailable. Native quit handling, vault access, and client connectivity can also be checked by starting a tunnel with a desktop client and quitting Servix on each target platform.
