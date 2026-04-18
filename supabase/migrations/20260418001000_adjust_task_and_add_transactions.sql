-- Reuse bill_processing_tasks as the extraction lifecycle table,
-- scope file hash uniqueness to per user,
-- and add a simple/generic transactions table.

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1) Add extraction payload directly on bill_processing_tasks.
ALTER TABLE public.bill_processing_tasks
  ADD COLUMN IF NOT EXISTS result_payload JSONB NOT NULL DEFAULT '{}'::jsonb;

-- 2) Change uploaded_files dedup from global hash to per-user hash.
ALTER TABLE public.uploaded_files
  DROP CONSTRAINT IF EXISTS uploaded_files_file_hash_key;

CREATE UNIQUE INDEX IF NOT EXISTS uq_uploaded_files_user_hash
  ON public.uploaded_files(user_id, file_hash);

-- 3) Generic/simple transactions table.
CREATE TABLE IF NOT EXISTS public.transactions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,

  file_id UUID REFERENCES public.uploaded_files(id) ON DELETE SET NULL,

  transaction_at DATE NOT NULL,
  description TEXT DEFAULT NULL,
  amount NUMERIC(14,2) NOT NULL,
  merchant TEXT,

  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_transactions_user_date
  ON public.transactions(user_id, transaction_at DESC);

CREATE INDEX IF NOT EXISTS idx_transactions_file
  ON public.transactions(file_id);

-- 4) Keep updated_at in sync.
DROP TRIGGER IF EXISTS set_updated_at_transactions ON public.transactions;
CREATE TRIGGER set_updated_at_transactions
BEFORE UPDATE ON public.transactions
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- 5) RLS for new table.
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "transactions: select own" ON public.transactions;
CREATE POLICY "transactions: select own" ON public.transactions
  FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "transactions: insert own" ON public.transactions;
CREATE POLICY "transactions: insert own" ON public.transactions
  FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "transactions: update own" ON public.transactions;
CREATE POLICY "transactions: update own" ON public.transactions
  FOR UPDATE USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "transactions: delete own" ON public.transactions;
CREATE POLICY "transactions: delete own" ON public.transactions
  FOR DELETE USING (auth.uid() = user_id);


