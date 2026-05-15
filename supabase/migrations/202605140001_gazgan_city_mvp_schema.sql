create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  phone text,
  avatar_url text,
  role text not null default 'user' check (role in ('user', 'moderator', 'admin')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.news (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text,
  content text,
  category text not null default 'Yangiliklar',
  image_url text,
  is_featured boolean not null default false,
  is_official boolean not null default true,
  views_count integer not null default 0,
  status text not null default 'published' check (status in ('draft', 'published', 'archived')),
  published_at timestamptz default now(),
  created_at timestamptz not null default now()
);

create table if not exists public.announcements (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text,
  category text not null default 'Rasmiy e''lon',
  is_active boolean not null default true,
  starts_at timestamptz,
  ends_at timestamptz,
  created_at timestamptz not null default now()
);

create table if not exists public.mobile_receptions (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  location text,
  address text,
  starts_at timestamptz,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.listing_categories (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  sort_order integer not null default 0,
  is_active boolean not null default true
);

create table if not exists public.place_categories (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  sort_order integer not null default 0,
  is_active boolean not null default true
);

create table if not exists public.listings (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete set null,
  category_id uuid references public.listing_categories(id) on delete set null,
  title text not null,
  description text,
  price text,
  location text,
  phone text,
  image_url text,
  status text not null default 'pending' check (status in ('pending', 'active', 'rejected')),
  views_count integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.map_places (
  id uuid primary key default gen_random_uuid(),
  category_id uuid references public.place_categories(id) on delete set null,
  name text not null,
  category text not null default 'Davlat',
  address text,
  phone text,
  description text,
  image_url text,
  x numeric not null default 0.5,
  y numeric not null default 0.5,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.taxi_services (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  phone text not null,
  description text,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.masters (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  profession text not null,
  phone text not null,
  description text,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.jobs (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  organization text,
  salary text,
  phone text,
  description text,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.useful_contacts (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  phone text not null,
  category text not null default 'Foydali kontakt',
  description text,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.admin_messages (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  title text not null,
  message text not null,
  is_read boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.saved_items (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  item_type text not null check (item_type in ('listing', 'news', 'map_place')),
  item_id uuid not null,
  created_at timestamptz not null default now(),
  unique (user_id, item_type, item_id)
);

alter table public.profiles enable row level security;
alter table public.news enable row level security;
alter table public.announcements enable row level security;
alter table public.mobile_receptions enable row level security;
alter table public.listing_categories enable row level security;
alter table public.place_categories enable row level security;
alter table public.listings enable row level security;
alter table public.map_places enable row level security;
alter table public.taxi_services enable row level security;
alter table public.masters enable row level security;
alter table public.jobs enable row level security;
alter table public.useful_contacts enable row level security;
alter table public.admin_messages enable row level security;
alter table public.saved_items enable row level security;

grant select on public.news to anon, authenticated;
grant select on public.announcements to anon, authenticated;
grant select on public.mobile_receptions to anon, authenticated;
grant select on public.listing_categories to anon, authenticated;
grant select on public.place_categories to anon, authenticated;
grant select on public.listings to anon, authenticated;
grant select on public.map_places to anon, authenticated;
grant select on public.taxi_services to anon, authenticated;
grant select on public.masters to anon, authenticated;
grant select on public.jobs to anon, authenticated;
grant select on public.useful_contacts to anon, authenticated;
grant select, insert, update on public.profiles to authenticated;
grant insert, update, delete on public.listings to authenticated;
grant select, update on public.admin_messages to authenticated;
grant select, insert, delete on public.saved_items to authenticated;

create policy "Users read own profile"
  on public.profiles for select
  to authenticated
  using (id = auth.uid());

create policy "Users insert own profile"
  on public.profiles for insert
  to authenticated
  with check (id = auth.uid());

create policy "Users update own profile"
  on public.profiles for update
  to authenticated
  using (id = auth.uid())
  with check (id = auth.uid());

create policy "Published news is public"
  on public.news for select
  to anon, authenticated
  using (status = 'published');

create policy "Active announcements are public"
  on public.announcements for select
  to anon, authenticated
  using (is_active = true and (ends_at is null or ends_at >= now()));

create policy "Active receptions are public"
  on public.mobile_receptions for select
  to anon, authenticated
  using (is_active = true);

create policy "Active listing categories are public"
  on public.listing_categories for select
  to anon, authenticated
  using (is_active = true);

create policy "Active place categories are public"
  on public.place_categories for select
  to anon, authenticated
  using (is_active = true);

create policy "Active listings are public"
  on public.listings for select
  to anon, authenticated
  using (status = 'active');

create policy "Users read own listings"
  on public.listings for select
  to authenticated
  using (user_id = auth.uid());

create policy "Users create pending listings"
  on public.listings for insert
  to authenticated
  with check (user_id = auth.uid() and status = 'pending');

create policy "Users update own pending listings"
  on public.listings for update
  to authenticated
  using (user_id = auth.uid() and status in ('pending', 'rejected'))
  with check (user_id = auth.uid() and status = 'pending');

create policy "Users delete own listings"
  on public.listings for delete
  to authenticated
  using (user_id = auth.uid());

create policy "Active map places are public"
  on public.map_places for select
  to anon, authenticated
  using (is_active = true);

create policy "Active taxi services are public"
  on public.taxi_services for select
  to anon, authenticated
  using (is_active = true);

create policy "Active masters are public"
  on public.masters for select
  to anon, authenticated
  using (is_active = true);

create policy "Active jobs are public"
  on public.jobs for select
  to anon, authenticated
  using (is_active = true);

create policy "Active contacts are public"
  on public.useful_contacts for select
  to anon, authenticated
  using (is_active = true);

create policy "Users read own admin messages"
  on public.admin_messages for select
  to authenticated
  using (user_id = auth.uid());

create policy "Users mark own admin messages read"
  on public.admin_messages for update
  to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

create policy "Users manage own saved items"
  on public.saved_items for all
  to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

insert into storage.buckets (id, name, public)
values
  ('listing-images', 'listing-images', true),
  ('news-images', 'news-images', true),
  ('place-images', 'place-images', true)
on conflict (id) do nothing;

create policy "Public image buckets are readable"
  on storage.objects for select
  to anon, authenticated
  using (bucket_id in ('listing-images', 'news-images', 'place-images'));

create policy "Authenticated users upload listing images"
  on storage.objects for insert
  to authenticated
  with check (bucket_id = 'listing-images');

insert into public.listing_categories (name, sort_order, is_active)
values
  ('Xizmatlar', 10, true),
  ('Savdo', 20, true),
  ('Ish o''rinlari', 30, true),
  ('Ko''chmas mulk', 40, true),
  ('Transport', 50, true),
  ('Elektronika', 60, true),
  ('Boshqa', 70, true)
on conflict (name) do update
set
  sort_order = excluded.sort_order,
  is_active = excluded.is_active;
