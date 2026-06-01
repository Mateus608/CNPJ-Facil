# CNPJ Fácil

<p align="center">
  <img src="https://github.com/user-attachments/assets/a6ec019b-b701-482d-a0d5-54c7ac2d6995" alt="CNPJ Fácil" width="200"/>
</p>

<p align="center">
  <strong>Consulte informações de empresas de forma rápida, prática e intuitiva.</strong>
</p>

---

## 📋 Sobre o Projeto

O **CNPJ Fácil** é um aplicativo desenvolvido em Flutter que permite consultar informações cadastrais de empresas através do CNPJ utilizando a API da ReceitaWS.

O aplicativo foi desenvolvido com foco em simplicidade, acessibilidade e produtividade, permitindo que o usuário consulte empresas, visualize informações detalhadas, mantenha um histórico local de consultas e compartilhe os dados em PDF.

---
<p align="center">
<img src="https://github.com/user-attachments/assets/405cd4e2-d5b0-472b-81cf-7f424d4264ea" alt="Tema Claro" width="300"/>
&nbsp;&nbsp;&nbsp;
<img src="https://github.com/user-attachments/assets/3fa195f6-db0a-4cfb-9c9c-66ec5aabc573" alt="Tema Escuro" width="300"/>
</p>

---

## 🚀 Funcionalidades

### 🔐 Autenticação

- Primeiro acesso com cadastro obrigatório
- Login com usuário e senha
- Alteração de usuário e senha
- Persistência local das credenciais
- Confirmação de logout

### 🏢 Consulta de CNPJ

- Máscara automática de CNPJ
- Consulta através da API ReceitaWS
- Exibição dos principais dados da empresa

### 📜 Histórico

- Histórico local utilizando SQLite
- Armazenamento das consultas realizadas
- Visualização rápida das consultas anteriores

### 📄 Compartilhamento

- Geração de PDF com os dados da consulta
- Compartilhamento através dos aplicativos instalados no dispositivo

### 🎨 Interface

- Tema Claro
- Tema Escuro
- Alternância dinâmica entre temas
- Logo adaptada para ambos os temas
- Compatível com dispositivos Android

### 👋 Experiência do Usuário

- Tutorial exibido no primeiro acesso
- Mensagem de boas-vindas personalizada
- Card de boas-vindas com opção de fechamento
- Exibição automática da mensagem por até 3 logins caso não seja fechada

---

## 📱 Telas do Aplicativo

### Cadastro

Permite que o usuário realize seu primeiro cadastro.

Campos:

- Usuário
- Senha
- Confirmar Senha

Após o cadastro é exibida a mensagem:

> Cadastro realizado com sucesso! Faça login e inicie suas consultas.

---

### Login

Permite autenticação no aplicativo utilizando o usuário cadastrado.

---

### Consulta de CNPJ

Funcionalidades:

- Digitação do CNPJ
- Máscara automática
- Consulta na ReceitaWS
- Compartilhamento em PDF

---

### Histórico

Lista todas as consultas realizadas localmente.

---

### Configurações

Permite alterar:

- Usuário
- Senha

Ao salvar é exibida confirmação ao usuário.

---

## 🌐 API Utilizada

### ReceitaWS

Site:

https://receitaws.com.br

Endpoint:

```http
GET https://www.receitaws.com.br/v1/cnpj/{CNPJ}
```

### Exemplo

```http
GET https://www.receitaws.com.br/v1/cnpj/00000000000191
```

---

## 📂 Estrutura do Projeto

```txt
lib/
├── main.dart
└── src/
    ├── app_cnpj_facil.dart
    │
    ├── config/
    │   └── api_config.dart
    │
    ├── models/
    │   └── cnpj_model.dart
    │
    ├── repositories/
    │   └── cnpj_repository.dart
    │
    ├── services/
    │   ├── auth_service.dart
    │   ├── cnpj_service.dart
    │   ├── database_service.dart
    │   ├── pdf_service.dart
    │   └── theme_service.dart
    │
    ├── pages/
    │   ├── login_page.dart
    │   ├── cadastro_usuario_page.dart
    │   ├── consulta_cnpj_page.dart
    │   ├── historico_page.dart
    │   └── configuracoes_usuario_page.dart
    │
    └── widgets/
        ├── cnpj_card.dart
        ├── custom_text_field.dart
        └── theme_toggle_button.dart
```

---

## ⚙️ Instalação

### Clonar o projeto

```bash
git clone https://github.com/seu-usuario/cnpj-facil.git
```

### Entrar na pasta

```bash
cd cnpj-facil
```

### Instalar dependências

```bash
flutter pub get
```

### Executar

```bash
flutter run
```

---

## 📱 Gerar APK

### APK Release

```bash
flutter build apk
```

Arquivo gerado:

```txt
build/app/outputs/flutter-apk/app-release.apk
```

### APK por Arquitetura

```bash
flutter build apk --split-per-abi
```

---

## 🎨 Tema Escuro

O aplicativo possui suporte completo para:

- Tema Claro
- Tema Escuro

A preferência é salva localmente.

---

## 📄 Compartilhamento em PDF

Após uma consulta, o usuário pode gerar um PDF contendo:

- CNPJ
- Razão Social
- Nome Fantasia
- Situação
- Data de Abertura
- Natureza Jurídica
- Endereço
- Município
- UF
- CEP
- Telefone
- E-mail

O PDF pode ser compartilhado diretamente pelo dispositivo.

---

## 🔒 Segurança

- Credenciais armazenadas localmente
- Persistência segura utilizando SharedPreferences
- Nenhum dado é enviado para servidores próprios
- Consultas realizadas diretamente na API ReceitaWS

---

## 👨‍💻 Autor

**Mateus Milane**

Projeto desenvolvido em Flutter para consulta rápida de informações empresariais através do CNPJ.

---

## 📜 Licença

Projeto desenvolvido para fins acadêmicos e educacionais.

© CNPJ Fácil
