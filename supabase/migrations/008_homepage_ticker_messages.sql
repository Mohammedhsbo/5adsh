begin;

do $$
begin
  if to_regclass('public.homepage_content') is null then
    raise exception '008_homepage_ticker_messages.sql requires migrations 001 and 002 first.';
  end if;
end;
$$;

alter table public.homepage_content
  add column if not exists ticker_messages text[] not null default array[
    'FREE SHIPPING ACROSS EGYPT OVER EGP 2,000',
    'DROP 07 — OUT NOW',
    'خدش مش عيب',
    'LEAVE A MARK'
  ]::text[];

commit;
