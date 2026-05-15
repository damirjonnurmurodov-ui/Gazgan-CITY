grant update (views_count) on public.news to anon, authenticated;

drop policy if exists "Published news views can be updated"
  on public.news;

create policy "Published news views can be updated"
  on public.news for update
  to anon, authenticated
  using (status = 'published')
  with check (status = 'published');
