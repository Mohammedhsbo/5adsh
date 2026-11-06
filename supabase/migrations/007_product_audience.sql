begin;

do $$
begin
  if to_regclass('public.products') is null then
    raise exception '007_product_audience.sql requires migrations 001 and 002 first.';
  end if;
end;
$$;

alter table public.products
  add column if not exists audience text not null default 'all';

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conrelid = 'public.products'::regclass
      and conname = 'products_audience_check'
  ) then
    alter table public.products
      add constraint products_audience_check
      check (audience in ('all', 'men', 'women', 'kids'));
  end if;
end;
$$;

commit;
