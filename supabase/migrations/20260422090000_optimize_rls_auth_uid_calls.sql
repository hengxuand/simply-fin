-- Optimize RLS policy expressions so auth.uid() is evaluated once per statement.
-- This addresses Supabase's "Auth RLS Initialization Plan" performance warning.

-- profiles
DROP POLICY IF EXISTS "profiles: select own" ON public.profiles;
CREATE POLICY "profiles: select own" ON public.profiles
  FOR SELECT USING ((SELECT auth.uid()) = id);

DROP POLICY IF EXISTS "profiles: insert own" ON public.profiles;
CREATE POLICY "profiles: insert own" ON public.profiles
  FOR INSERT WITH CHECK ((SELECT auth.uid()) = id);

DROP POLICY IF EXISTS "profiles: update own" ON public.profiles;
CREATE POLICY "profiles: update own" ON public.profiles
  FOR UPDATE USING ((SELECT auth.uid()) = id);

DROP POLICY IF EXISTS "profiles: delete own" ON public.profiles;
CREATE POLICY "profiles: delete own" ON public.profiles
  FOR DELETE USING ((SELECT auth.uid()) = id);

-- uploaded_files
DROP POLICY IF EXISTS "uploaded_files: select own" ON public.uploaded_files;
CREATE POLICY "uploaded_files: select own" ON public.uploaded_files
  FOR SELECT USING ((SELECT auth.uid()) = user_id);

DROP POLICY IF EXISTS "uploaded_files: insert own" ON public.uploaded_files;
CREATE POLICY "uploaded_files: insert own" ON public.uploaded_files
  FOR INSERT WITH CHECK ((SELECT auth.uid()) = user_id);

DROP POLICY IF EXISTS "uploaded_files: update own" ON public.uploaded_files;
CREATE POLICY "uploaded_files: update own" ON public.uploaded_files
  FOR UPDATE USING ((SELECT auth.uid()) = user_id);

DROP POLICY IF EXISTS "uploaded_files: delete own" ON public.uploaded_files;
CREATE POLICY "uploaded_files: delete own" ON public.uploaded_files
  FOR DELETE USING ((SELECT auth.uid()) = user_id);

-- transactions
DROP POLICY IF EXISTS "transactions: select own" ON public.transactions;
CREATE POLICY "transactions: select own" ON public.transactions
  FOR SELECT USING ((SELECT auth.uid()) = user_id);

DROP POLICY IF EXISTS "transactions: insert own" ON public.transactions;
CREATE POLICY "transactions: insert own" ON public.transactions
  FOR INSERT WITH CHECK ((SELECT auth.uid()) = user_id);

DROP POLICY IF EXISTS "transactions: update own" ON public.transactions;
CREATE POLICY "transactions: update own" ON public.transactions
  FOR UPDATE USING ((SELECT auth.uid()) = user_id)
  WITH CHECK ((SELECT auth.uid()) = user_id);

DROP POLICY IF EXISTS "transactions: delete own" ON public.transactions;
CREATE POLICY "transactions: delete own" ON public.transactions
  FOR DELETE USING ((SELECT auth.uid()) = user_id);

