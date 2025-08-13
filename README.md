# FindMe - Aplicativo de Localização AR

Um aplicativo Flutter que utiliza Realidade Aumentada (AR) para encontrar pessoas em tempo real.

## 📱 Sobre o Projeto

O FindMe é um aplicativo móvel que permite aos usuários se localizarem mutuamente usando tecnologia de Realidade Aumentada. O app utiliza geolocalização, bússola e ARCore para criar uma experiência imersiva de navegação.

É o resultado do TCC de @Felipe Muros @murosfc e Rafael Panisset @RafaelPanisset no curso de Sistemas de Informação no IFF de Campos dos Goytacazes. Defendido em 2023. Aprovado com nota 10.

## ✨ Funcionalidades

- 🔐 **Autenticação de usuário** com Firebase
- 👥 **Gerenciamento de contatos** e solicitações de amizade
- 📍 **Localização em tempo real** usando WebSocket
- 🧭 **Interface de Realidade Aumentada** com indicadores direcionais
- 🌍 **Suporte a internacionalização** (Português e Inglês)
- 🔔 **Notificações push** via Firebase Messaging
- 🎨 **Interface moderna** com design consistente

## 🚀 Tecnologias Utilizadas

- **Flutter** - Framework de desenvolvimento multiplataforma
- **Firebase** - Backend, autenticação e notificações
- **ARCore** - Realidade Aumentada (Android)
- **WebSocket** - Comunicação em tempo real
- **Geolocator** - Serviços de localização
- **Flutter Compass** - Acesso à bússola do dispositivo

## 📋 Pré-requisitos

- **Flutter SDK 3.32.8+** (stable)
- **Dart 3.8.1+** (incluído no Flutter)
- **Git** (para clonagem do repositório)
- **VS Code** ou **Android Studio** (recomendado)
- **Chrome** (para desenvolvimento web)
- **Dispositivo Android com suporte a ARCore** (para funcionalidades AR)

## 🛠️ Instalação

1. Clone o repositório:

```bash
git clone https://github.com/seu-usuario/findme.git
cd findme
```

2. Verifique a instalação do Flutter:

```bash
flutter doctor
```

3. Instale as dependências:

```bash
flutter pub get
```

4. Configure o Firebase:

   - Adicione o arquivo `google-services.json` na pasta `android/app/`
   - Configure as credenciais do Firebase no projeto

5. Execute o aplicativo:

```bash
# Para web (recomendado para teste inicial)
flutter run -d chrome

# Para Android (requer dispositivo/emulador)
flutter run

# Para compilar para web
flutter build web --release
```

6. Configure as APIs backend:

   - Crie API para autenticação de usuários
   - Configure API para troca de dados de localização em tempo real
   - Atualize as URLs no arquivo `lib/api/UserDataApi.dart`

## 📁 Estrutura do Projeto

```
lib/
├── api/                    # APIs e serviços externos
├── colors/                 # Definições de cores
├── components/             # Widgets reutilizáveis
├── constants/              # Constantes da aplicação
├── i18n/                   # Arquivos de internacionalização
├── model/                  # Modelos de dados
├── pages/                  # Telas da aplicação
├── services/               # Serviços (permissões, etc.)
├── themes/                 # Temas da aplicação
├── utils/                  # Utilidades e funções auxiliares
└── main.dart              # Ponto de entrada
```

## 🔧 Configuração

### Permissões Necessárias

- Câmera (para AR)
- Localização (para GPS)
- Internet (para comunicação)

### Variáveis de Ambiente

Configure as seguintes variáveis no seu arquivo de configuração:

- URL do servidor backend
- Chaves do Firebase
- Configurações de API

## 📈 Melhorias Implementadas

### 🏗️ Estrutura e Organização

- ✅ Reorganização da estrutura de pastas
- ✅ Criação de constantes centralizadas
- ✅ Separação de responsabilidades em serviços
- ✅ Implementação de temas unificados

### 🔄 Refatoração de Código

- ✅ Melhoria na legibilidade do código
- ✅ Implementação de null safety
- ✅ Otimização de widgets e métodos
- ✅ Remoção de código duplicado

### 📦 Dependências

- ✅ **Flutter 3.32.8** (stable)
- ✅ **Dart 3.8.1** (stable)
- ✅ Todas as dependências atualizadas para versões 2024/2025
- ✅ **Migração de `wakelock` para `wakelock_plus`**
- ✅ **Remoção da dependência `configuration`** (incompatível)
- ✅ **Socket.IO Client 2.0.3** (compatível com null safety)
- ✅ Melhoria completa na compatibilidade

### ⚡ Performance

- ✅ Otimização de chamadas de API
- ✅ Implementação de lazy loading
- ✅ Melhoria no gerenciamento de estado
- ✅ Redução de rebuilds desnecessários

## 🧪 Testes e Verificações

Para executar os testes:

```bash
flutter test
```

Para analisar o código:

```bash
flutter analyze
```

Para verificar dependências desatualizadas:

```bash
flutter pub outdated
```

## 🔧 Troubleshooting

### Problemas Comuns

1. **Erro "flutter command not found"**:

   - Verifique se o Flutter está no PATH
   - Execute `echo $PATH` (Linux/Mac) ou `echo $env:PATH` (Windows)

2. **Problemas com dependências**:

   ```bash
   flutter clean
   flutter pub get
   ```

3. **Erro de compilação para web**:

   - Verifique se o Chrome está instalado
   - Execute `flutter config --enable-web`

4. **Problemas com ARCore**:
   - Verifique se o dispositivo suporta ARCore
   - Consulte: https://developers.google.com/ar/devices

## 📱 Plataformas Suportadas

- ✅ **Web** (Chrome, Firefox, Safari)
- ✅ **Android** (requer ARCore para funcionalidades AR)
- ⏳ **iOS** (em desenvolvimento)
- ⏳ **Windows** (em desenvolvimento)

## 🤝 Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 📊 Status do Projeto

- **Versão**: 2.1.0
- **Flutter**: 3.32.8 (stable)
- **Dart**: 3.8.1 (stable)
- **Última atualização**: Dezembro 2024
- **Status**: ✅ Totalmente funcional

---

**Desenvolvido com ❤️ usando Flutter**
