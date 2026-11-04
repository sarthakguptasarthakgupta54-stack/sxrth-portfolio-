-- Run this in Supabase Dashboard > SQL Editor after creating the admin Auth user.
-- Replace ADMIN_USER_UUID with the user's UUID from Authentication > Users.

create table if not exists public.site_content (
  owner_id uuid primary key references auth.users(id) on delete cascade,
  content jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.site_content enable row level security;

drop policy if exists "Public can read portfolio content" on public.site_content;
create policy "Public can read portfolio content"
on public.site_content for select
to anon, authenticated
using (true);

drop policy if exists "Admin can insert own portfolio content" on public.site_content;
create policy "Admin can insert own portfolio content"
on public.site_content for insert
to authenticated
with check (auth.uid() = owner_id);

drop policy if exists "Admin can update own portfolio content" on public.site_content;
create policy "Admin can update own portfolio content"
on public.site_content for update
to authenticated
using (auth.uid() = owner_id)
with check (auth.uid() = owner_id);

-- Create public Storage bucket for public portfolio images.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('portfolio-assets', 'portfolio-assets', true, 5242880, array['image/jpeg','image/png','image/webp'])
on conflict (id) do update set public = true, file_size_limit = 5242880,
allowed_mime_types = array['image/jpeg','image/png','image/webp'];

-- Anyone can view portfolio images; only signed-in admin can upload/update/delete
-- files inside a folder named with their own Auth user UUID.
drop policy if exists "Public can view portfolio assets" on storage.objects;
create policy "Public can view portfolio assets"
on storage.objects for select
to anon, authenticated
using (bucket_id = 'portfolio-assets');

drop policy if exists "Admin uploads own portfolio assets" on storage.objects;
create policy "Admin uploads own portfolio assets"
on storage.objects for insert
to authenticated
with check (bucket_id = 'portfolio-assets' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "Admin updates own portfolio assets" on storage.objects;
create policy "Admin updates own portfolio assets"
on storage.objects for update
to authenticated
using (bucket_id = 'portfolio-assets' and (storage.foldername(name))[1] = auth.uid()::text)
with check (bucket_id = 'portfolio-assets' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "Admin deletes own portfolio assets" on storage.objects;
create policy "Admin deletes own portfolio assets"
on storage.objects for delete
to authenticated
using (bucket_id = 'portfolio-assets' and (storage.foldername(name))[1] = auth.uid()::text);

-- Optional initial row will be created automatically when you save from /admin.
