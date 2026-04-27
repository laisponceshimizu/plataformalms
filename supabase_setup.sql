-- ============================================================
-- ARBUS ACADEMY — Supabase Setup SQL
-- Execute este arquivo no SQL Editor do Supabase
-- Passo a passo: https://supabase.com → SQL Editor → New Query
-- ============================================================

-- 1. Tabela de progresso por usuário
CREATE TABLE IF NOT EXISTS public.progress (
  id          uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id     uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  module_id   integer NOT NULL CHECK (module_id BETWEEN 1 AND 8),
  percent     integer DEFAULT 0 CHECK (percent BETWEEN 0 AND 100),
  completed   boolean DEFAULT false,
  updated_at  timestamptz DEFAULT now(),
  UNIQUE(user_id, module_id)
);

-- 2. Row Level Security — cada usuário vê só o próprio progresso
ALTER TABLE public.progress ENABLE ROW LEVEL SECURITY;

CREATE POLICY "usuarios_veem_proprio_progresso"
  ON public.progress
  FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- 3. View para o painel admin — visão consolidada por usuário
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

-- 4. View detalhada por módulo — usada no painel admin
CREATE OR REPLACE VIEW public.admin_module_progress AS
SELECT
  p.*,
  u.email,
  u.raw_user_meta_data->>'full_name' AS full_name
FROM public.progress p
JOIN auth.users u ON u.id = p.user_id;

-- 5. Permissões para usuários autenticados lerem as views
GRANT SELECT ON public.admin_user_progress   TO authenticated;
GRANT SELECT ON public.admin_module_progress TO authenticated;

-- ============================================================
-- PRONTO! Agora configure o Authentication no Supabase:
-- → Authentication → Providers → Email → Enable
-- → Authentication → Email Templates (opcional: personalizar)
-- → Project Settings → API → copiar URL e anon key
-- ============================================================
