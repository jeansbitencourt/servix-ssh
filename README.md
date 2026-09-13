# 🖥️ ControlPanel — SSH Linux Desktop Suite

Um painel administrativo desktop moderno para **Linux** construído com **Flutter**, focado em gerenciamento de conexões SSH, execução remota de atalhos de comandos em 1 clique e emulação de terminais interativos embutidos.

---

## ✨ Funcionalidades Principais

- 🔑 **Gerenciamento Seguro de Conexões SSH**:
  - Cadastro de servidores com porta, usuário, IP/domínio e organização por grupos/tags (`Produção`, `Staging`, `Database`, etc.).
  - Suporte completo a **autenticação por Senha** e **Chave Privada** (Ed25519, RSA, PEM) com seleção de arquivo nativa do sistema e suporte a passphrase.
  - **Cofre Seguro de Credenciais**: Senhas e passphrases são armazenadas criptografadas na Secret Service API do Linux (**GNOME Keyring / KWallet**).
  - Teste de conectividade SSH em tempo real direto da interface.

- ⚡ **Atalhos Rápidos de Comandos (1-Clique)**:
  - Disparo de comandos frequentes (ex: `uptime`, `free -m`, `df -h`, `docker ps`).
  - Execução não-interativa e rápida: conecta, executa, captura `stdout`, `stderr`, `exitCode`, mede a duração em milissegundos e desconecta.
  - Modal de saída com formatação monospace, visualização ANSI, status badge (`Exit 0` verde ou `Exit != 0` vermelho) e botão de cópia com 1 clique.
  - Histórico persistente de execuções no banco SQLite local.

- 💻 **Terminal Interativo Embutido (Multi-abas)**:
  - Emulador de terminal completo compatível com **xterm-256color** e sequências VT100.
  - Alocação real de **PTY** permitindo executar utilitários de tela cheia como `top`, `htop`, `vim` e `nano`.
  - **Redimensionamento dinâmico**: ao redimensionar a janela, a sessão PTY adapta automaticamente o layout do terminal remoto.
  - Sistema de abas múltiplas com `IndexedStack` (mantém o buffer e a conexão ativos em segundo plano ao trocar de aba).
  - Controles de zoom de fonte (`-` / `+`), limpeza de tela (`clear`) e reconexão rápida.

- 🎨 **Interface Desktop Moderna (Dark Dashboard)**:
  - Paleta escura Slate/Zinc com destaque Indigo/Cyan.
  - Sidebar responsiva com navegação rápida, status do cofre e contadores de terminais ativos.
  - Visão de Dashboard com cartões de métricas, atalhos populares e histórico das últimas execuções.

---

## 🛠️ Stack Tecnológica e Arquitetura

O projeto adota os princípios de **Clean Architecture**, mantendo a regra de dependência voltada para o domínio:

| Camada / Papel | Tecnologia / Pacote | Descrição |
|---|---|---|
| **Apresentação & Estado** | `signals_flutter` | Gerenciamento de estado reativo fino, performático e sem boilerplate |
| **Terminal Embutido** | `xterm` | Renderizador ANSI/VT100 com buffers de histórico e PTY |
| **Protocolo SSH** | `dartssh2` | Cliente SSH-2 puro em Dart (senha, Ed25519/RSA, PTY e streaming) |
| **Persistência Estruturada** | `drift` + `sqlite3` | Banco de dados relacional tipado para hosts, atalhos e histórico |
| **Cofre de Credenciais** | `flutter_secure_storage` | Armazenamento de senhas no GNOME Keyring / KWallet via Secret Service API |
| **Injeção de Dependências** | `get_it` | Service Locator desacoplado |
| **Seletor de Arquivos** | `file_picker` | Diálogo nativo do sistema para chaves privadas SSH |

### Estrutura de Diretórios

```text
lib/
├── core/
│   ├── di/injection.dart                   # Service Locator GetIt
│   ├── errors/                             # Exceptions e Failures padronizados
│   ├── theme/
│   │   ├── app_theme.dart                 # Design System Dark Slate/Indigo
│   │   └── terminal_theme.dart            # Paleta de cores para o xterm
│   └── utils/date_formatter.dart          # Formatação de datas e duração
├── data/
│   ├── datasources/
│   │   ├── local_database.dart            # Tabelas e DAOs Drift (SQLite)
│   │   ├── secure_storage_datasource.dart # Wrapper para o Keyring do Linux
│   │   └── ssh_remote_datasource.dart     # Conexões SSH, runCommand e PTY shell
│   ├── models/                            # DTOs e mapeamento entre tabelas e entidades
│   └── repositories/                      # Implementação concreta dos repositórios
├── domain/
│   ├── entities/                          # SSHHost, ShortcutCommand, CommandResult, TerminalSession
│   ├── repositories/                      # Contratos abstratos (interfaces)
│   └── usecases/                          # ManageHosts, ExecuteShortcut, OpenSSHSession
└── presentation/
    ├── stores/                            # Stores reativas (HostStore, ShortcutStore, TerminalSessionStore)
    ├── views/
    │   ├── main_layout.dart               # Shell da aplicação desktop com sidebar
    │   ├── dashboard_view.dart            # Painel com métricas e atalhos rápidos
    │   ├── hosts_view.dart                # Gerenciador mestre-detalhe de servidores
    │   ├── shortcuts_view.dart            # Grade de atalhos categorizados
    │   └── terminal_view.dart             # Emulador multipágina com abas
    └── widgets/                           # Componentes reutilizáveis e modais
```

---

## 🚀 Como Executar o Projeto

### 1. Pré-requisitos do Sistema Operacional

Como o aplicativo utiliza o cofre nativo de senhas (`flutter_secure_storage`), é necessário instalar a biblioteca de desenvolvimento da **Secret Service API**:

- **Fedora / RHEL**:
  ```bash
  sudo dnf install -y libsecret-devel
  ```

- **Ubuntu / Debian**:
  ```bash
  sudo apt install -y libsecret-1-dev
  ```

- **Arch Linux**:
  ```bash
  sudo pacman -S libsecret
  ```

### 2. Instalar Dependências do Flutter

```bash
flutter pub get
```

### 3. Gerar Código do Banco Drift (se modificado)

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Executar os Testes Automatizados

```bash
flutter test
```

### 5. Iniciar o Aplicativo Desktop

```bash
flutter run -d linux
```

### 6. Compilar para Produção (Release Bundle)

```bash
flutter build linux --release
```

O binário final relocável estará disponível no diretório:
```text
build/linux/x64/release/bundle/control_panel
```

---

## 🔒 Segurança

- **Nenhuma senha em texto puro**: O arquivo local SQLite armazena apenas metadados públicos (nome, host, porta, usuário, caminho do arquivo de chave).
- **Isolamento de Credenciais**: As senhas SSH e passphrases de chaves criptografadas são enviadas diretamente ao daemon de segurança do sistema operacional via D-Bus (`libsecret`), garantindo que apenas usuários autenticados na sessão atual tenham acesso às credenciais.

---

## 📝 Licença

Distribuído sob licença MIT. Sinta-se livre para usar e estender!
