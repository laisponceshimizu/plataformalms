-- Adicionar coluna descricao na tabela aulas
-- Execute no SQL Editor do Supabase

ALTER TABLE public.aulas
ADD COLUMN IF NOT EXISTS descricao TEXT DEFAULT NULL;
