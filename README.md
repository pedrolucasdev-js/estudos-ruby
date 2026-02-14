# 💇 Salon API

Uma API RESTful desenvolvida com **Ruby on Rails** para gerenciar salões de beleza, serviços, agendamentos e disponibilidade de horários.

## 📋 Índice

- [Visão Geral](#visão-geral)
- [Funcionalidades](#funcionalidades)
- [Pré-requisitos](#pré-requisitos)
- [Instalação](#instalação)
- [Configuração](#configuração)
- [Uso](#uso)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Endpoints da API](#endpoints-da-api)
- [Testes](#testes)
- [Deployment](#deployment)
- [Tecnologias](#tecnologias)

## 🎯 Visão Geral

A **Salon API** é um backend robusto e escalável para aplicações de agendamento de serviços em salões de beleza. Permite gerenciar múltiplos salões, seus serviços, profissionais, agendamentos e controlar a disponibilidade de horários de forma eficiente.

## ✨ Funcionalidades

- ✅ **Gerenciamento de Salões**: Criar, listar, atualizar e deletar salões
- ✅ **Gerenciamento de Serviços**: Definir serviços oferecidos por cada salão
- ✅ **Agendamentos**: Sistema completo de agendamento com confirmação
- ✅ **Disponibilidade**: Consulta de horários disponíveis
- ✅ **Status de Agendamentos**: Rastreamento com status (pendente, confirmado, finalizado, cancelado)
- ✅ **CORS Habilitado**: Suporte para requisições de múltiplas origens
- ✅ **API RESTful**: Endpoints bem estruturados e convencionais

## 📦 Pré-requisitos

Certifique-se de ter instalado em sua máquina:

- **Ruby**: 3.4.8 ou superior
- **Rails**: 7.1.3
- **PostgreSQL**: 12 ou superior
- **Node.js**: 14+ (para gerenciador de pacotes)
- **Git**: Para controle de versão
- **Bundler**: Para gerenciar dependências do Ruby

## 🚀 Instalação

### 1. Clonar o Repositório

```bash
git clone <seu-repositorio-url>
cd salon_api
```

### 2. Instalar Dependências

```bash
bundle install
```

### 3. Configurar o Banco de Dados

```bash
rails db:create
rails db:migrate
rails db:seed
```

### 4. Iniciar o Servidor

```bash
rails server
```

O servidor iniciará em `http://localhost:3000`

## ⚙️ Configuração

### Variáveis de Ambiente

Crie um arquivo `.env` na raiz do projeto (não será versionado):

```env
DATABASE_URL=postgresql://usuario:senha@localhost:5432/salon_api_development
RAILS_ENV=development
RAILS_LOG_TO_STDOUT=true
```

### CORS

O projeto está configurado com CORS habilitado. Veja [config/initializers/cors.rb](config/initializers/cors.rb) para customizar origens permitidas.

### Banco de Dados

O arquivo `config/database.yml` está configurado para PostgreSQL. Ajuste as credenciais conforme necessário.

## 📖 Uso

### Exemplos de Requisições

#### Listar Salões
```bash
curl -X GET http://localhost:3000/api/salons
```

#### Criar um Salão
```bash
curl -X POST http://localhost:3000/api/salons \
  -H "Content-Type: application/json" \
  -d '{
    "salon": {
      "name": "Salão XYZ",
      "phone": "11999999999",
      "slug": "salao-xyz"
    }
  }'
```

#### Listar Serviços de um Salão
```bash
curl -X GET http://localhost:3000/api/services?salon_id=1
```

#### Consultar Disponibilidade
```bash
curl -X GET "http://localhost:3000/api/appointments/availability?salon_id=1&date=2026-02-15"
```

#### Criar Agendamento
```bash
curl -X POST http://localhost:3000/api/appointments \
  -H "Content-Type: application/json" \
  -d '{
    "appointment": {
      "salon_id": 1,
      "service_id": 1,
      "date": "2026-02-15",
      "hour": "10:00"
    }
  }'
```

## 📁 Estrutura do Projeto

```
salon_api/
├── app/
│   ├── controllers/
│   │   └── api/                    # Controladores da API
│   │       ├── salons_controller.rb
│   │       ├── services_controller.rb
│   │       └── appointments_controller.rb
│   ├── models/
│   │   ├── salon.rb                # Modelo de Salão
│   │   ├── service.rb              # Modelo de Serviço
│   │   ├── appointment.rb          # Modelo de Agendamento
│   │   └── time_slot.rb            # Modelo de Slot de Tempo
│   └── jobs/
├── config/
│   ├── initializers/
│   │   └── cors.rb                 # Configuração CORS
│   ├── routes.rb                   # Rotas da API
│   ├── database.yml                # Configuração do Banco
│   └── environments/               # Configurações por ambiente
├── db/
│   ├── migrate/                    # Migrações
│   ├── schema.rb                   # Schema do banco
│   └── seeds.rb                    # Dados iniciais
├── test/
│   ├── controllers/
│   ├── models/
│   └── fixtures/
├── Gemfile                         # Dependências Ruby
├── Dockerfile                      # Configuração Docker
├── docker-compose.yml              # Orquestração Docker
└── README.md                       # Este arquivo
```

## 🔗 Endpoints da API

### Salões

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/salons` | Listar todos os salões |
| GET | `/api/salons/:id` | Obter detalhes de um salão |
| POST | `/api/salons` | Criar novo salão |
| PUT | `/api/salons/:id` | Atualizar salão |
| DELETE | `/api/salons/:id` | Deletar salão |

### Serviços

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/services` | Listar serviços |
| GET | `/api/services/:id` | Obter detalhes do serviço |
| POST | `/api/services` | Criar novo serviço |
| PUT | `/api/services/:id` | Atualizar serviço |
| DELETE | `/api/services/:id` | Deletar serviço |

### Agendamentos

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/api/appointments` | Listar agendamentos |
| GET | `/api/appointments/:id` | Obter detalhes do agendamento |
| GET | `/api/appointments/availability` | Consultar horários disponíveis |
| POST | `/api/appointments` | Criar novo agendamento |
| PATCH | `/api/appointments/:id/confirm` | Confirmar agendamento |
| PATCH | `/api/appointments/:id/finish` | Finalizar agendamento |
| PATCH | `/api/appointments/:id/cancel` | Cancelar agendamento |

## 🧪 Testes

Execute os testes com:

```bash
# Executar todos os testes
rails test

# Executar testes específicos
rails test:models
rails test:controllers

# Com verbosidade
rails test -v
```

Os testes utilizam fixtures localizadas em `test/fixtures/`.

## 🐳 Docker

### Build da Imagem

```bash
docker build -t salon-api .
```

### Executar com Docker Compose

```bash
docker-compose up
```

Isso inicializará:
- API Rails na porta 3000
- PostgreSQL na porta 5432

## 🚀 Deployment

### Render

O projeto está configurado para deploy automático no [Render](https://render.com).

**Pré-requisitos:**
- Conta no Render
- Repositório Git (GitHub, GitLab ou Bitbucket)
- `RAILS_MASTER_KEY` configurado nos secrets

**Processo:**
1. Conectar repositório no Render
2. Configurar variáveis de ambiente
3. Deploy automático em cada push para `main`

Veja [DEPLOY_RENDER.md](DEPLOY_RENDER.md) para instruções detalhadas.

## 🛠️ Tecnologias

| Tecnologia | Versão | Descrição |
|------------|--------|-----------|
| **Ruby** | 3.4.8 | Linguagem de programação |
| **Rails** | 7.1.3 | Framework web |
| **PostgreSQL** | 12+ | Banco de dados |
| **Puma** | 5.0+ | Servidor web |
| **rack-cors** | latest | Middleware CORS |
| **dotenv-rails** | latest | Variáveis de ambiente |
| **Docker** | latest | Containerização |

## 📝 Notas Importantes

- **Segurança**: Nunca commite arquivos `.env` ou chaves secretas
- **Migrações**: Sempre crie migrações para mudanças no banco
- **Tests**: Mantenha alta cobertura de testes
- **Logs**: Ative logs estruturados em produção

## 🤝 Contribuindo

1. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
2. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
3. Push para a branch (`git push origin feature/AmazingFeature`)
4. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.

## 📞 Suporte

Para dúvidas ou problemas, abra uma issue no repositório.
