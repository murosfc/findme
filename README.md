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

- Flutter SDK 3.0.0+
- Dart 3.0.0+
- Android Studio / VS Code
- Dispositivo Android com suporte a ARCore

## 🛠️ Instalação

1. Clone o repositório:

```bash
git clone https://github.com/seu-usuario/findme.git
cd findme
```

2. Instale as dependências:

```bash
flutter pub get
```

3. Configure o Firebase:

   - Adicione o arquivo `google-services.json` na pasta `android/app/`
   - Configure as credenciais do Firebase no projeto

4. Execute o aplicativo:

```bash
flutter run
```

5. Você vai precisar criar suas API's, uma para autenticação e outra para fazer a troca de dados de localização entro os usuários.

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

- ✅ Atualização para Flutter 3.0+
- ✅ Atualização de todas as dependências para versões mais recentes
- ✅ Migração de `wakelock` para `wakelock_plus`
- ✅ Melhoria na compatibilidade

### ⚡ Performance

- ✅ Otimização de chamadas de API
- ✅ Implementação de lazy loading
- ✅ Melhoria no gerenciamento de estado
- ✅ Redução de rebuilds desnecessários

## 🧪 Testes

Para executar os testes:

```bash
flutter test
```

## 📱 Plataformas Suportadas

- ✅ Android (requer ARCore)
- ⏳ iOS (em desenvolvimento)

## 🤝 Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

**Desenvolvido com ❤️ usando Flutter**
