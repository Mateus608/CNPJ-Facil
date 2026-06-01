# CNPJ Fácil

Aplicativo Flutter para consulta de CNPJ usando ReceitaWS, histórico SQLite, alteração local de usuário/senha e compartilhamento da consulta em PDF.

## Login padrão

- Usuário: `admin`
- Senha: `123456`

O usuário e a senha podem ser alterados dentro do app pelo ícone de conta no topo da tela de consulta.

## Rodar

```bash
flutter create .
flutter pub get
flutter run
```

## Recursos

- Login local
- Alteração de usuário e senha com `shared_preferences`
- Consulta de CNPJ com máscara
- Histórico SQLite
- Compartilhamento do card de consulta em PDF


## Últimas alterações

- Primeiro acesso: o usuário cria o próprio usuário e senha ao abrir o app pela primeira vez.
- Ajuste global de área segura para evitar que o conteúdo fique atrás dos botões de navegação do Android.
