-- شغّله مرة واحدة في Supabase: SQL Editor > New query > Run

create table if not exists site_data (
  id int primary key,
  data jsonb not null
);

alter table site_data enable row level security;

-- الكل يكدر يقرأ
create policy "public read" on site_data
  for select using (true);

-- بس الأدمن (المسجل دخول) يكدر يعدل
create policy "admin write" on site_data
  for all to authenticated using (true) with check (true);

-- مخزن الصور
insert into storage.buckets (id, name, public)
values ('images', 'images', true)
on conflict (id) do nothing;

create policy "images public read" on storage.objects
  for select using (bucket_id = 'images');

create policy "images admin upload" on storage.objects
  for insert to authenticated with check (bucket_id = 'images');

create policy "images admin delete" on storage.objects
  for delete to authenticated using (bucket_id = 'images');
