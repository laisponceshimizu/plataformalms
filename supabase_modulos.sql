-- ============================================================
-- ARBUS ACADEMY — SQL Atualizado (com gestão de módulos)
-- Execute no SQL Editor do Supabase
-- ============================================================

-- ── 1. Tabela de MÓDULOS (nova — permite criar/editar/excluir)
CREATE TABLE IF NOT EXISTS public.modulos (
  id          serial PRIMARY KEY,
  titulo      text NOT NULL,
  descricao   text,
  emoji       text DEFAULT '📚',
  ordem       integer DEFAULT 1,
  ativo       boolean DEFAULT true,
  criado_em   timestamptz DEFAULT now()
);

-- Índice para ordenação rápida
CREATE INDEX IF NOT EXISTS idx_modulos_ordem ON public.modulos(ordem);

-- RLS: qualquer autenticado pode ler; apenas admin escreve
ALTER TABLE public.modulos ENABLE ROW LEVEL SECURITY;

CREATE POLICY "todos_leem_modulos"
  ON public.modulos FOR SELECT
  TO authenticated
  USING (ativo = true);

CREATE POLICY "admin_gerencia_modulos"
  ON public.modulos FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- ── 2. Inserir os 8 módulos padrão (pule se já existirem)
INSERT INTO public.modulos (titulo, descricao, emoji, ordem) VALUES
  ('Dashboard — Visão Inicial',           'Visão geral da plataforma',    '📡', 1),
  ('Cadastro e configuração de veículos', 'Como cadastrar sua frota',     '🚗', 2),
  ('Rastreamento em tempo real',          'Monitoramento ao vivo',        '🗺️', 3),
  ('Relatórios e telemetria',             'Análise de dados da frota',    '📊', 4),
  ('Alertas e eventos críticos',          'Configuração de alertas',      '🚨', 5),
  ('Jornada de trabalho e motoristas',    'Gestão de motoristas',         '👷', 6),
  ('Gestão de multas e infrações',        'Controle de infrações',        '📋', 7),
  ('Integração com Power BI',             'Dashboards avançados',         '📈', 8)
ON CONFLICT DO NOTHING;

-- ── 3. Tabela de PROGRESSO (sem o CHECK fixo de 1 a 8)
-- Se já existir com o constraint antigo, execute o ALTER abaixo:
ALTER TABLE public.progress DROP CONSTRAINT IF EXISTS progress_module_id_check;

-- Se a tabela não existir ainda, crie agora:
CREATE TABLE IF NOT EXISTS public.progress (
  id          uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id     uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  module_id   integer NOT NULL,
  percent     integer DEFAULT 0 CHECK (percent BETWEEN 0 AND 100),
  completed   boolean DEFAULT false,
  updated_at  timestamptz DEFAULT now(),
  UNIQUE(user_id, module_id)
);

ALTER TABLE public.progress ENABLE ROW LEVEL SECURITY;

CREATE POLICY IF NOT EXISTS "usuarios_veem_proprio_progresso"
  ON public.progress FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ── 4. Tabela de AULAS
CREATE TABLE IF NOT EXISTS public.aulas (
  id          uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  module_id   integer NOT NULL,
  tipo        text NOT NULL CHECK (tipo IN ('video','pdf')),
  titulo      text NOT NULL,
  url         text NOT NULL,
  ordem       integer DEFAULT 1,
  ativo       boolean DEFAULT true,
  criado_em   timestamptz DEFAULT now()
);

ALTER TABLE public.aulas ENABLE ROW LEVEL SECURITY;

CREATE POLICY IF NOT EXISTS "todos_leem_aulas"
  ON public.aulas FOR SELECT TO authenticated
  USING (ativo = true);

CREATE POLICY IF NOT EXISTS "admin_gerencia_aulas"
  ON public.aulas FOR ALL TO authenticated
  USING (true) WITH CHECK (true);

CREATE INDEX IF NOT EXISTS idx_aulas_module ON public.aulas(module_id);

-- ── 5. Views para o painel admin
CREATE OR REPLACE VIEW public.admin_user_progress AS
SELECT
  u.id                                          AS user_id,
  u.email,
  u.raw_user_meta_data->>'full_name'            AS full_name,
  u.created_at,
  COALESCE(ROUND(AVG(p.percent)), 0)::int       AS avg_progress,
  COUNT(p.id)::int                              AS modules_started,
  COUNT(CASE WHEN p.completed THEN 1 END)::int  AS modules_done,
  MAX(p.updated_at)                             AS last_activity
FROM auth.users u
LEFT JOIN public.progress p ON p.user_id = u.id
GROUP BY u.id, u.email, u.raw_user_meta_data, u.created_at;

CREATE OR REPLACE VIEW public.admin_module_progress AS
SELECT
  p.*,
  u.email,
  u.raw_user_meta_data->>'full_name' AS full_name
FROM public.progress p
JOIN auth.users u ON u.id = p.user_id;

-- ── 6. Permissões
GRANT SELECT ON public.admin_user_progress   TO authenticated;
GRANT SELECT ON public.admin_module_progress TO authenticated;
GRANT ALL    ON public.modulos               TO authenticated;
GRANT ALL    ON SEQUENCE public.modulos_id_seq TO authenticated;

-- ============================================================
-- PRONTO! Agora acesse o admin.html e crie seus módulos.
-- ============================================================
