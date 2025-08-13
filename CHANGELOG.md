# Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

## [2.0.0] - 2024-12-19

### 🚀 Adicionado

- Nova estrutura de pastas organizada com `constants/`, `services/`, `themes/`, `utils/`
- Classe `AppConstants` centralizada para constantes da aplicação
- Classe `AppUtils` com métodos utilitários reutilizáveis
- Serviço `PermissionService` para gerenciamento centralizado de permissões
- Sistema de temas unificado com `AppTheme`
- Suporte completo a null safety
- Documentação abrangente no README.md

### 🔄 Modificado

- **Refatoração completa do ARScreen**:

  - Implementação de null safety
  - Uso de constantes centralizadas
  - Métodos utilitários para cálculos
  - Melhor organização do código
  - Otimização de performance

- **Melhoria do LoadingScreen**:

  - Uso do `PermissionService`
  - Melhor tratamento de estados
  - Verificação de `mounted` antes de operações de UI
  - Código mais limpo e legível

- **Refatoração do modelo User**:

  - Implementação de padrões modernos do Dart
  - Uso de `switch` statements
  - Melhor tratamento de erros
  - Métodos mais eficientes

- **Aprimoramento do MainDrawer**:
  - Separação em métodos menores
  - Melhor organização de widgets
  - Implementação de const constructors

### 📦 Atualizado

- **Flutter SDK**: Atualizado para 3.0.0+
- **Dependências principais**:
  - `cupertino_icons`: ^1.0.2 → ^1.0.8
  - `google_sign_in`: ^6.1.3 → ^6.2.1
  - `http`: ^0.13.5 → ^1.2.2
  - `flutter_secure_storage`: ^8.0.0 → ^9.2.2
  - `shared_preferences`: ^2.0.18 → ^2.3.2
  - `firebase_core`: ^2.11.0 → ^3.6.0
  - `firebase_messaging`: ^14.5.0 → ^15.1.3
  - `permission_handler`: ^10.2.0 → ^11.3.1
  - `geolocator`: ^9.0.2 → ^13.0.1
  - `socket_io_client`: ^1.0.2 → ^2.1.2
  - `flutter_local_notifications`: ^14.1.0 → ^18.0.1
  - `sensors_plus`: ^3.0.2 → ^6.0.1
  - `flutter_compass`: ^0.7.0 → ^0.8.0
  - `flutter_lints`: ^2.0.0 → ^5.0.0

### 🔧 Migrado

- **wakelock → wakelock_plus**: Migração para a nova versão mantida
  - Atualização de imports
  - Mudança de `Wakelock` para `WakelockPlus`

### ⚡ Otimizado

- **Performance do ARScreen**:

  - Cálculos mais eficientes para ângulos da seta
  - Melhor gerenciamento de recursos
  - Otimização de rebuilds

- **Gerenciamento de estado**:

  - Redução de operações desnecessárias
  - Melhor ciclo de vida dos widgets
  - Otimização de chamadas de API

- **Estrutura de código**:
  - Eliminação de código duplicado
  - Métodos mais focados e reutilizáveis
  - Melhor separação de responsabilidades

### 🐛 Corrigido

- Problemas de null safety em todo o projeto
- Vazamentos de memória potenciais
- Problemas de performance em widgets
- Inconsistências no tratamento de erros
- Warnings do linter

### 🔒 Segurança

- Melhor validação de tokens
- Tratamento seguro de dados sensíveis
- Implementação de timeouts em requests HTTP

### 📝 Documentação

- README.md completamente reescrito
- Documentação de instalação e configuração
- Guia de estrutura do projeto
- Changelog detalhado

---

## Como ler este changelog

- **🚀 Adicionado** para novas funcionalidades
- **🔄 Modificado** para mudanças em funcionalidades existentes
- **📦 Atualizado** para atualizações de dependências
- **🔧 Migrado** para migrações de bibliotecas
- **⚡ Otimizado** para melhorias de performance
- **🐛 Corrigido** para correções de bugs
- **🔒 Segurança** para melhorias de segurança
- **📝 Documentação** para mudanças na documentação
