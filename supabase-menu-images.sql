-- Run in this project's Supabase Dashboard > SQL Editor.
-- This page has no sign-in: uploads are allowed for anon and authenticated users.
-- Public image URLs are readable by anyone. No update/delete access is granted.
BEGIN;

INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'menu-images',
    'menu-images',
    true,
    5242880,
    ARRAY['image/*']::text[]
)
ON CONFLICT (id) DO UPDATE
SET public = EXCLUDED.public,
    file_size_limit = EXCLUDED.file_size_limit,
    allowed_mime_types = EXCLUDED.allowed_mime_types;

DROP POLICY IF EXISTS "cook_dashboard_insert_menu_images" ON storage.objects;

CREATE POLICY "cook_dashboard_insert_menu_images"
ON storage.objects
FOR INSERT
TO anon, authenticated
WITH CHECK (bucket_id = 'menu-images');

COMMIT;
