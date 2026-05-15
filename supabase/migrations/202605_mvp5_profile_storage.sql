alter table public.profiles
  add column if not exists address text;

insert into storage.buckets (id, name, public)
values
  ('profile-avatars', 'profile-avatars', true),
  ('listing-images', 'listing-images', true)
on conflict (id) do update set public = excluded.public;

do $$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'Public profile avatars are readable'
  ) then
    create policy "Public profile avatars are readable"
      on storage.objects for select
      to anon, authenticated
      using (bucket_id = 'profile-avatars');
  end if;
end $$;

do $$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'Users upload own profile avatars'
  ) then
    create policy "Users upload own profile avatars"
      on storage.objects for insert
      to authenticated
      with check (
        bucket_id = 'profile-avatars'
        and (storage.foldername(name))[1] = auth.uid()::text
      );
  end if;
end $$;

do $$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'Users update own profile avatars'
  ) then
    create policy "Users update own profile avatars"
      on storage.objects for update
      to authenticated
      using (
        bucket_id = 'profile-avatars'
        and (storage.foldername(name))[1] = auth.uid()::text
      )
      with check (
        bucket_id = 'profile-avatars'
        and (storage.foldername(name))[1] = auth.uid()::text
      );
  end if;
end $$;

do $$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'Users delete own profile avatars'
  ) then
    create policy "Users delete own profile avatars"
      on storage.objects for delete
      to authenticated
      using (
        bucket_id = 'profile-avatars'
        and (storage.foldername(name))[1] = auth.uid()::text
      );
  end if;
end $$;

-- MVP 5 storage strategy:
-- bucket: profile-avatars
-- authenticated users upload/update/delete only files under auth.uid() folder
-- public read is enabled for simple avatar rendering in the user app
-- service_role is not used by the mobile client

-- bucket: listing-images
-- existing public read and upload behavior stays compatible with MVP 4 schema
-- app uploads to user_id/listing_timestamp.jpg before storing listings.image_url
-- target policy model: authenticated users upload own listing image;
-- users read approved listing images through public URLs;
-- users update/delete own pending listing images under their user_id folder

do $$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'Users update own listing images'
  ) then
    create policy "Users update own listing images"
      on storage.objects for update
      to authenticated
      using (
        bucket_id = 'listing-images'
        and (storage.foldername(name))[1] = auth.uid()::text
      )
      with check (
        bucket_id = 'listing-images'
        and (storage.foldername(name))[1] = auth.uid()::text
      );
  end if;
end $$;

do $$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'Users delete own listing images'
  ) then
    create policy "Users delete own listing images"
      on storage.objects for delete
      to authenticated
      using (
        bucket_id = 'listing-images'
        and (storage.foldername(name))[1] = auth.uid()::text
      );
  end if;
end $$;
