# 🛠️ Guia de Instalação - FindMe

Este guia fornece instruções detalhadas para configurar o ambiente de desenvolvimento para o projeto FindMe.

## 📋 Pré-requisitos do Sistema

### Windows

- **Windows 10/11** (64-bit)
- **PowerShell** ou **Command Prompt**
- **Git** instalado
- **Chrome** (para desenvolvimento web)

### Hardware Mínimo

- **4GB RAM** (8GB recomendado)
- **5GB espaço em disco** livre
- **Conexão com internet** estável

## 🚀 Instalação Passo a Passo

### 1. Instalar Git (se não estiver instalado)

```bash
# Baixe do site oficial
https://git-scm.com/downloads

# Ou use Chocolatey (se disponível)
choco install git
```

### 2. Instalar Flutter

```bash
# Clone o repositório do Flutter
cd C:\
git clone https://github.com/flutter/flutter.git -b stable flutter

# Adicione ao PATH
setx PATH "%PATH%;C:\flutter\bin"
```

### 3. Verificar Instalação

```bash
# Reinicie o terminal e execute
flutter doctor

# Deve mostrar algo como:
# [✓] Flutter (Channel stable, 3.32.8, on Microsoft Windows)
# [✓] Chrome - develop for the web
# [✓] VS Code
```

### 4. Configurar Projeto FindMe

```bash
# Clone o projeto
git clone https://github.com/seu-usuario/findme.git
cd findme

# Instale dependências
flutter pub get

# Teste a compilação
flutter build web --release
```

## 🔧 Configurações Adicionais

### Para Desenvolvimento Android

```bash
# Instale Android Studio
https://developer.android.com/studio

# Configure Android SDK
flutter doctor --android-licenses
```

### Para Desenvolvimento iOS (macOS apenas)

```bash
# Instale Xcode
# Configure iOS SDK
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

## 🧪 Teste da Instalação

### Teste Rápido

```bash
cd findme
flutter run -d chrome
```

### Verificação Completa

```bash
# Análise de código
flutter analyze

# Dependências
flutter pub outdated

# Dispositivos disponíveis
flutter devices
```

## 🚨 Problemas Comuns

### Flutter não reconhecido

```bash
# Windows
echo $env:PATH
# Linux/Mac
echo $PATH

# Deve conter: C:\flutter\bin
```

### Dependências com conflito

```bash
flutter clean
flutter pub get
```

### Erro de compilação web

```bash
flutter config --enable-web
flutter doctor
```

### Performance lenta

```bash
# Limpe cache
flutter clean

# Rebuild completo
flutter pub get
flutter build web --release
```

## 📞 Suporte

Se encontrar problemas:

1. **Consulte o troubleshooting** no README.md
2. **Execute `flutter doctor -v`** para diagnóstico detalhado
3. **Verifique as issues** no repositório GitHub
4. **Abra uma nova issue** com logs completos

## 🎯 Próximos Passos

Após a instalação bem-sucedida:

1. **Configure Firebase** (para notificações)
2. **Configure backend APIs** (para autenticação)
3. **Teste em dispositivos** Android/iOS
4. **Deploy para produção**

---

**✅ Instalação Completa! Seu ambiente está pronto para desenvolvimento.** 🚀
