# Deploy do Salon API no Render

## Pré-requisitos
- [ ] Conta no Render (https://render.com)
- [ ] Repositório Git (GitHub, GitLab ou Bitbucket)
- [ ] RAILS_MASTER_KEY configurado

## Passo 1: Preparar o Repositório

### 1.1 Adicionar Gemfile.lock ao repositório (se ainda não estiver)
```bash
git add Gemfile.lock
git commit -m "Add Gemfile.lock"
git push
```

### 1.2 Garantir que `.env` não está no repositório
Seu `.gitignore` deve conter:
```
.env
.env.local
.env.*.local
```

### 1.3 Preparar o arquivo render.yaml
O arquivo já foi criado na raiz do projeto. Ele define:
- **Serviço Web**: Rails API rodando no Puma
- **Banco de Dados**: PostgreSQL 15
- **Variáveis de ambiente necessárias**

## Passo 2: Configurar RAILS_MASTER_KEY

### 2.1 Obter a chave master
```bash
cat config/master.key
```

Copie este valor - você vai precisar dele no Render.

## Passo 3: Criar Instância no Render

### 3.1 Acessar Render Dashboard
1. Faça login em https://dashboard.render.com
2. Clique em "New +"
3. Selecione "Web Service"

### 3.2 Conectar Repositório
1. Selecione o seu repositório Git
2. Autorize o Render a acessar seu GitHub/GitLab/Bitbucket
3. Selecione a branch (geralmente `main` ou `master`)

### 3.3 Configurar Serviço Web
- **Name**: `salon-api`
- **Runtime**: `Ruby`
- **Build Command**: `./bin/rails db:prepare`
- **Start Command**: `bundle exec puma -t 5:5 -p 3000`
- **Plan**: Free (ou Premium)

### 3.4 Adicionar Variáveis de Ambiente
Clique em "Advanced" e adicione:

| Chave | Valor | Tipo |
|-------|-------|------|
| `RAILS_ENV` | `production` | - |
| `RAILS_MASTER_KEY` | [Cole o valor do config/master.key] | Secret |
| `RAILS_LOG_LEVEL` | `info` | - |

## Passo 4: Criar Banco de Dados PostgreSQL

### 4.1 Alternativa A: Criar via Render Dashboard
1. Clique em "New +"
2. Selecione "PostgreSQL"
3. Configure:
   - **Name**: `salon-api-db`
   - **Database**: `salon_api_production`
   - **User**: `postgres`
   - **Plan**: Free ou Starter

### 4.2 Alternativa B: Usar YAML (automático com render.yaml)
Se usar o render.yaml fornecido, a database é criada automaticamente.

### 4.3 Conectar Database ao Web Service
Após criar a database, copie a **Connection String** (Internal Database URL).

Adicione como variável de ambiente no seu Web Service:
- **Key**: `DATABASE_URL`
- **Value**: [Cole a Internal Database URL do PostgreSQL]
- **Type**: Secret

## Passo 5: Deploy

### 5.1 Fazer Push para o Repositório
```bash
git add .
git commit -m "Add render.yaml for deployment"
git push
```

### 5.2 Iniciar Deploy no Render
O Render detectará a mudança e iniciará o deploy automaticamente. Você pode:
- Acompanhar pelo dashboard
- Ver os logs em tempo real
- Verificar se o build e start commands executaram com sucesso

## Passo 6: Testes e Verificação

### 6.1 Verificar Health Check
```bash
curl https://seu-app-name.onrender.com/up
```

Resposta esperada: `200 OK`

### 6.2 Testar Endpoints
```bash
# Listar Salons
curl https://seu-app-name.onrender.com/api/salons

# Listar Services
curl https://seu-app-name.onrender.com/api/services

# Listar Appointments
curl https://seu-app-name.onrender.com/api/appointments
```

## Configurações Importantes Já Presentes

✅ **Dockerfile**: Otimizado para produção
✅ **production.rb**: 
  - `force_ssl = true` (HTTPS obrigatório)
  - Logging para STDOUT (necessário no Render)
  - Eager loading ativado
✅ **database.yml**: Usa `DATABASE_URL` env var
✅ **rack-cors**: Configurado para CORS
✅ **health check**: Endpoint `/up` disponível

## Possíveis Problemas e Soluções

### Erro: "ActiveRecord::DatabaseConnectionNotEstablished"
- Verificar se `DATABASE_URL` está configurada corretamente
- Confirmar que a database PostgreSQL foi criada
- Verificar Internal Database URL vs External

### Erro: "Rails master key is missing"
- Adicionar `RAILS_MASTER_KEY` como Secret var
- Não colar arquivo `config/master.key` no repositório

### Erro: "Precompiling assets"
- Seu app é API-only (config.api_only = true)
- Assets não são necessários
- Este erro não deve aparecer

### Timeout no Deploy
- Aumentar o timeout para primeira build (pode demorar)
- Checar logs para dependências faltando
- Verificar se `bundle install` está funcionando

## Variáveis de Ambiente Recomendadas

```
RAILS_ENV=production
RAILS_LOG_LEVEL=info
RAILS_MASTER_KEY=[seu_valor]
DATABASE_URL=[postgres://...]
BUNDLE_WITHOUT=development:test
```

## Próximos Passos

1. [ ] Fazer push do render.yaml para o repositório
2. [ ] Criar conta no Render
3. [ ] Conectar repositório ao Render
4. [ ] Criar PostgreSQL database
5. [ ] Configurar variáveis de ambiente
6. [ ] Iniciar deploy
7. [ ] Testar health check
8. [ ] Testar endpoints da API

## Referências Úteis

- [Render Rails Guide](https://render.com/docs/deploy-rails)
- [Render PostgreSQL](https://render.com/docs/databases)
- [Rails Production Checklist](https://guides.rubyonrails.org/configuring.html)
