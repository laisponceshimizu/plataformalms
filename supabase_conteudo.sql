-- ============================================================
-- ARBUS ACADEMY — Tabela de conteúdo dos módulos
-- Execute no SQL Editor do Supabase
-- ============================================================

-- Tabela de aulas (vídeos e materiais por módulo)
CREATE TABLE IF NOT EXISTS public.aulas (
  id          uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  module_id   integer NOT NULL CHECK (module_id BETWEEN 1 AND 8),
  tipo        text NOT NULL CHECK (tipo IN ('video','pdf')),
  titulo      text NOT NULL,
  url         text NOT NULL,
  ordem       integer DEFAULT 1,
  ativo       boolean DEFAULT true,
  criado_em   timestamptz DEFAULT now()
);

-- Qualquer usuário autenticado pode LER as aulas
ALTER TABLE public.aulas ENABLE ROW LEVEL SECURITY;

CREATE POLICY "todos_leem_aulas"
  ON public.aulas FOR SELECT
  TO authenticated
  USING (ativo = true);

CREATE POLICY "admin_gerencia_aulas"
  ON public.aulas FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Índice para buscar por módulo rapidamente
CREATE INDEX IF NOT EXISTS idx_aulas_module ON public.aulas(module_id);

-- ============================================================
-- PRONTO! Volte para o HTML e adicione os vídeos pelo admin.
-- ============================================================
