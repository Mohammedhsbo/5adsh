begin;

do $$
declare
  missing_tables text[];
begin
  select array_agg(required_table order by required_table)
  into missing_tables
  from unnest(array[
    'products', 'categories', 'product_variants', 'inventory',
    'collections', 'collection_products', 'homepage_content',
    'store_settings', 'app_roles'
  ]) as required(required_table)
  where to_regclass('public.' || required_table) is null;

  if missing_tables is not null then
    raise exception '006_restore_public_read_policies.sql requires migrations 001 through 005. Missing public tables: %', missing_tables;
  end if;
end;
$$;

drop policy if exists "Public read active products" on public.products;
create policy "Public read active products" on public.products
  for select to anon, authenticated using (active);

drop policy if exists "Public read active categories" on public.categories;
create policy "Public read active categories" on public.categories
  for select to anon, authenticated using (active);

drop policy if exists "Public read product variants" on public.product_variants;
create policy "Public read product variants" on public.product_variants
  for select to anon, authenticated using (
    exists (select 1 from public.products p where p.id = product_id and p.active)
  );

drop policy if exists "Public read inventory" on public.inventory;
create policy "Public read inventory" on public.inventory
  for select to anon, authenticated using (
    exists (
      select 1 from public.product_variants v
      join public.products p on p.id = v.product_id
      where v.id = variant_id and p.active
    )
  );

drop policy if exists "Public read active collections" on public.collections;
create policy "Public read active collections" on public.collections
  for select to anon, authenticated using (active);

drop policy if exists "Public read collection products" on public.collection_products;
create policy "Public read collection products" on public.collection_products
  for select to anon, authenticated using (
    exists (select 1 from public.collections c where c.id = collection_id and c.active)
  );

drop policy if exists "Public read homepage content" on public.homepage_content;
create policy "Public read homepage content" on public.homepage_content
  for select to anon, authenticated using (true);

drop policy if exists "Public read store settings" on public.store_settings;
create policy "Public read store settings" on public.store_settings
  for select to anon, authenticated using (true);

drop policy if exists users_read_own_roles on public.app_roles;
create policy users_read_own_roles on public.app_roles
  for select to authenticated using (user_id = auth.uid());

commit;
