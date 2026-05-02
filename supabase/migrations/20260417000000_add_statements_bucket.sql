-- Create the statements storage bucket (private)
INSERT INTO storage.buckets (id, name, public)
VALUES ('statements', 'statements', false)
ON CONFLICT (id) DO NOTHING;

-- RLS: users can upload their own files
CREATE POLICY "Users can upload their own statements"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'statements'
  AND (storage.foldername(name))[1] = 'statements'
  AND (storage.foldername(name))[2] = auth.uid()::text
);

-- RLS: users can read their own files
CREATE POLICY "Users can read their own statements"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'statements'
  AND (storage.foldername(name))[1] = 'statements'
  AND (storage.foldername(name))[2] = auth.uid()::text
);

-- RLS: users can delete their own files
CREATE POLICY "Users can delete their own statements"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'statements'
  AND (storage.foldername(name))[1] = 'statements'
  AND (storage.foldername(name))[2] = auth.uid()::text
);

