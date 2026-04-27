# 🚌 Arbus Academy — Guia de Deploy

Portal de treinamento para clientes Arbus Frotas.

---

## 📁 Estrutura dos arquivos

```
arbus-academy/
├── index.html              ← Plataforma do cliente (página principal)
├── admin.html              ← Painel administrativo (só você acessa)
├── supabase_setup.sql      ← SQL para configurar o banco de dados
└── README.md               ← Este guia
```

---

## 🗄️ PASSO 1 — Configurar o Supabase

### 1.1 Criar conta e projeto
1. Acesse [supabase.com](https://supabase.com) e clique em **Start for free**
2. Entre com GitHub ou Google
3. Clique em **New Project**
4. Preencha:
   - **Name:** `arbus-academy`
   - **Database Password:** escolha uma senha forte (guarde em lugar seguro)
   - **Region:** `South America (São Paulo)` ← mais próximo do Brasil
5. Clique em **Create new project** e aguarde ~2 minutos

### 1.2 Executar o SQL
1. No painel do Supabase, clique em **SQL Editor** no menu lateral
2. Clique em **New query**
3. Abra o arquivo `supabase_setup.sql` e copie todo o conteúdo
4. Cole no editor e clique em **Run** (ou Ctrl+Enter)
5. Deve aparecer "Success" em verde

### 1.3 Ativar autenticação por e-mail
1. Vá em **Authentication** → **Providers**
2. Clique em **Email**
3. Certifique-se que está **Enabled**
4. Desative "Confirm email" se quiser que clientes entrem sem confirmar e-mail (mais simples para começar)

### 1.4 Pegar as credenciais
1. Vá em **Project Settings** → **API**
2. Copie e guarde:
   - **Project URL** → ex: `https://xyzabc123.supabase.co`
   - **anon public** key → ex: `eyJhbGciOiJIUzI1NiIs...`

---

## 💻 PASSO 2 — Subir para o GitHub

### 2.1 Criar conta no GitHub (se não tiver)
1. Acesse [github.com](https://github.com) → Sign up

### 2.2 Criar repositório
1. Clique no **+** no canto superior direito → **New repository**
2. Preencha:
   - **Repository name:** `arbus-academy`
   - Deixe como **Public** (necessário para hospedagem gratuita)
3. Clique em **Create repository**

### 2.3 Fazer upload dos arquivos
1. Na página do repositório criado, clique em **uploading an existing file**
2. Arraste os 3 arquivos:
   - `index.html`
   - `admin.html`
   - `supabase_setup.sql`
3. Clique em **Commit changes**

---

## 🌐 PASSO 3 — Hospedar no Vercel (gratuito)

### 3.1 Criar conta no Vercel
1. Acesse [vercel.com](https://vercel.com) → Sign up
2. **Entre com sua conta do GitHub** (mais fácil — conecta direto)

### 3.2 Importar o projeto
1. No painel do Vercel, clique em **Add New** → **Project**
2. Selecione o repositório `arbus-academy`
3. Clique em **Deploy**
4. Aguarde ~30 segundos

### 3.3 Resultado
Você terá dois links:
- `https://arbus-academy.vercel.app` → plataforma do cliente (`index.html`)
- `https://arbus-academy.vercel.app/admin` → painel admin (`admin.html`)

---

## ⚙️ PASSO 4 — Inserir as credenciais do Supabase

### Na plataforma do cliente (index.html)
1. Abra `https://arbus-academy.vercel.app`
2. Clique no banner amarelo **"Configurar agora"**
3. Cole a **Project URL** e a **anon public key**
4. Clique em **Salvar e ativar**

### No painel admin (admin.html)
1. Abra `https://arbus-academy.vercel.app/admin`
2. Clique no banner amarelo
3. Cole as mesmas credenciais
4. Clique em **Salvar e conectar**
5. Use **"▶ Entrar em modo demonstração"** ou crie sua conta admin no Supabase

---

## 🔗 Domínio personalizado (opcional)

Para usar `academy.arbusfrotas.com.br`:

1. No Vercel, vá em **Settings** → **Domains**
2. Digite `academy.arbusfrotas.com.br` e clique em **Add**
3. O Vercel mostrará um registro DNS para adicionar
4. Acesse o painel do **Registro.br** (onde o domínio arbusfrotas.com.br está registrado)
5. Adicione um registro **CNAME**:
   - Nome: `academy`
   - Valor: `cname.vercel-dns.com`
6. Aguarde até 24h para propagar (geralmente menos de 1h)

---

## 👥 Como cadastrar clientes

### Opção A — Cliente se cadastra sozinho
Compartilhe o link da plataforma. O cliente clica em **"Criar conta"** e se registra.

### Opção B — Você cadastra pelo Supabase
1. Acesse o painel do Supabase
2. Vá em **Authentication** → **Users**
3. Clique em **Invite user**
4. Digite o e-mail do cliente → ele recebe um link para criar a senha

---

## 🆘 Problemas comuns

| Problema | Solução |
|---|---|
| "Invalid API key" | Verifique se colou a chave `anon public` (não a `service_role`) |
| Clientes não conseguem criar conta | Verifique se Email provider está habilitado no Supabase |
| Progresso não salva | Execute o SQL novamente e verifique se a tabela `progress` foi criada |
| Domínio não funciona | Aguarde a propagação DNS (até 24h) |

---

## 📞 Suporte

Dúvidas sobre a plataforma: desenvolvido com assistência do Claude (Anthropic).

Documentação Supabase: [supabase.com/docs](https://supabase.com/docs)

Documentação Vercel: [vercel.com/docs](https://vercel.com/docs)
