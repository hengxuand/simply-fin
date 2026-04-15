-- Enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE uploaded_files ENABLE ROW LEVEL SECURITY;
ALTER TABLE bill_processing_tasks ENABLE ROW LEVEL SECURITY;

-- profiles (user is identified by id, not user_id)
CREATE POLICY "profiles: select own" ON profiles
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "profiles: insert own" ON profiles
    FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "profiles: update own" ON profiles
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "profiles: delete own" ON profiles
    FOR DELETE USING (auth.uid() = id);

-- uploaded_files
CREATE POLICY "uploaded_files: select own" ON uploaded_files
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "uploaded_files: insert own" ON uploaded_files
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "uploaded_files: update own" ON uploaded_files
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "uploaded_files: delete own" ON uploaded_files
    FOR DELETE USING (auth.uid() = user_id);

-- bill_processing_tasks
CREATE POLICY "bill_processing_tasks: select own" ON bill_processing_tasks
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "bill_processing_tasks: insert own" ON bill_processing_tasks
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "bill_processing_tasks: update own" ON bill_processing_tasks
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "bill_processing_tasks: delete own" ON bill_processing_tasks
    FOR DELETE USING (auth.uid() = user_id);
