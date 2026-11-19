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

- 🎨 **Responsive desktop interface**
  - Work in a dark Slate/Zinc theme with Indigo/Cyan accents.
  - Use the responsive sidebar to navigate, check the credential store status, and see how many terminals are active.
  - View metrics, frequently used shortcuts, and recent command executions on the dashboard.

---

## 🛠️ Technology Stack and Architecture

Servix follows Clean Architecture. Dependencies point toward the domain layer.

| Layer or role | Technology or package | Description |
|---|---|---|
| **Presentation and state** | `signals_flutter` | Reactive state management |
| **Embedded terminal** | `xterm` | ANSI/VT100 rendering and terminal scrollback |
| **SSH protocol** | `dartssh2` | Dart SSH-2 client with password and private-key authentication, PTY allocation, and streaming |
| **Local persistence** | `drift` + `sqlite3` | Typed relational storage for hosts, shortcuts, and execution history |
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
│   │   └── ssh_remote_datasource.dart     # SSH connections, commands, and PTY sessions
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
    │   └── terminal_view.dart             # Tabbed terminal emulator
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

Add Flutter to your `PATH` and install the Linux build dependencies (Clang, CMake, Ninja, pkg-config, and GTK 3 development files). Run the installer from the repository root.

```bash
./install.sh
```

The script builds the release bundle, installs it for your user, and adds **Servix** to the application menu. It uses `$XDG_DATA_HOME` or defaults to `~/.local/share`, with no `sudo` required. Run the same command after updating the source code to replace the installed version. If you previously installed ControlPanel, the script archives its old launcher.

### Install on Windows

Install Flutter and Visual Studio with the *Desktop development with C++* workload. From the repository root, run the installer in PowerShell. [Flutter setup for Windows](https://docs.flutter.dev/platform-integration/windows/setup)

```powershell
.\install-windows.ps1
```

The installer builds the release bundle, copies it to `%LOCALAPPDATA%\Programs\Servix`, and adds **Servix** to the Start menu. Close Servix before running the script again to update it.

### Install on macOS

On a Mac with Flutter, Xcode configured, and CocoaPods installed, run the installer from the repository root. [Flutter setup for macOS](https://docs.flutter.dev/platform-integration/macos/setup)

```bash
./install-macos.sh
```

The installer builds the release app and copies **Servix.app** to `~/Applications`. Open it from Finder. The local build can reopen saved SSH key paths across sessions using your account's file permissions. Distribution signing and notarization require separate setup.

### Data from Previous Versions

Servix uses a new database, `servix.sqlite`, in the application's support directory and has its own credential store identifier. Add your ControlPanel servers and credentials again in Servix. Future Servix reinstalls reuse the new data.

### Install Flutter Dependencies

```bash
flutter pub get
```

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
