-- Run only after migrations 001 through 005 on a verified-empty staging project.
-- Inserts the sample catalog without replacing existing products, inventory,
-- collections, or storefront settings.
begin;

do $$
begin
  if to_regclass('public.products') is null
    or to_regclass('public.categories') is null
    or to_regclass('public.product_variants') is null
    or to_regclass('public.inventory') is null
    or to_regclass('public.collections') is null
    or to_regclass('public.collection_products') is null
    or to_regclass('public.homepage_content') is null
    or to_regclass('public.store_settings') is null then
    raise exception 'Run migrations 001 through 005 before supabase/seed.sql.';
  end if;
end;
$$;

insert into public.categories (name, slug)
values
  ('T-Shirts', 't-shirts'),
  ('Jeans', 'jeans'),
  ('Jackets', 'jackets'),
  ('Dresses', 'dresses'),
  ('Pants', 'pants'),
  ('Shoes', 'shoes'),
  ('Accessories', 'accessories')
on conflict (slug) do nothing;

with seed_products (
  slug, name, category, subcategory, price, sale_price, sku, description, badge,
  featured, best_seller, new_arrival, colors, sizes, variants
) as (
  values
    (
      'fracture-tee-washed-black', 'Fracture Tee — Washed Black', 'T-Shirts', 'T-Shirts',
      1150, 990, '5AD-TS-001',
      'Heavy-weight washed cotton tee with a distressed print and a relaxed cut intended for daily wear.',
      'NEW', true, false, true,
      '["Black","Bone","Stone"]'::jsonb, '["S","M","L","XL"]'::jsonb,
      '[{"size":"S","color":"Black","stock":6},{"size":"M","color":"Black","stock":12},{"size":"L","color":"Black","stock":9},{"size":"XL","color":"Black","stock":4},{"size":"M","color":"Bone","stock":5},{"size":"L","color":"Stone","stock":3}]'::jsonb
    ),
    (
      'split-knee-wide-jeans', 'Split-Knee Wide Jeans', 'Jeans', 'Jeans',
      2450, 1990, '5AD-JN-021',
      'Structured wide-leg denim with split knees, a clean taper, and a durable finish designed for all-day movement.',
      'SALE', false, true, true,
      '["Indigo","Stone","Black"]'::jsonb, '["28","30","32","34"]'::jsonb,
      '[{"size":"30","color":"Indigo","stock":8},{"size":"32","color":"Indigo","stock":7},{"size":"30","color":"Stone","stock":4},{"size":"34","color":"Black","stock":3}]'::jsonb
    ),
    (
      'raw-edge-denim-jacket', 'Raw Edge Denim Jacket', 'Jackets', 'Jackets',
      3600, null, '5AD-JK-034',
      'Double-layered denim jacket with raw hems, a relaxed fit, and a heavyweight finish suited for the city in motion.',
      'LIMITED', true, false, true,
      '["Washed Indigo","Black"]'::jsonb, '["S","M","L","XL"]'::jsonb,
      '[{"size":"M","color":"Washed Indigo","stock":6},{"size":"L","color":"Washed Indigo","stock":3},{"size":"L","color":"Black","stock":2}]'::jsonb
    ),
    (
      'column-maxi-dress', 'Column Maxi Dress', 'Dresses', 'Dresses',
      2800, null, '5AD-DR-045',
      'Minimal column dress with clean tailoring and a soft drape built for movement and elevated layering.',
      null, true, false, false,
      '["Jet","Ivory","Stone"]'::jsonb, '["XS","S","M","L"]'::jsonb,
      '[{"size":"S","color":"Jet","stock":5},{"size":"M","color":"Ivory","stock":4},{"size":"L","color":"Stone","stock":2}]'::jsonb
    ),
    (
      'root-graphic-oversized-tee', 'Root Graphic Oversized Tee', 'T-Shirts', 'T-Shirts',
      990, 790, '5AD-TS-102',
      'Oversized cotton tee with a large graphic print, clean neckline, and a heavy wash for a consistent broken-in feel.',
      null, false, true, false,
      '["Cream","Black","Olive"]'::jsonb, '["S","M","L","XL"]'::jsonb,
      '[{"size":"M","color":"Cream","stock":9},{"size":"L","color":"Black","stock":7},{"size":"XL","color":"Olive","stock":4}]'::jsonb
    ),
    (
      'cargo-parachute-pant', 'Cargo Parachute Pant', 'Pants', 'Pants',
      2100, null, '5AD-PT-214',
      'Airy parachute pants with utility pockets, a boxy silhouette, and a lightweight construction for everyday layering.',
      null, false, true, false,
      '["Stone","Black","Khaki"]'::jsonb, '["S","M","L","XL"]'::jsonb,
      '[{"size":"M","color":"Stone","stock":5},{"size":"L","color":"Black","stock":7},{"size":"XL","color":"Khaki","stock":3}]'::jsonb
    ),
    (
      'tread-runner-triple-black', 'Tread Runner — Triple Black', 'Shoes', 'Shoes',
      4200, 3490, '5AD-SH-330',
      'Technical runner-inspired sneaker with a supportive sole, layered cushioning, and minimal monochrome styling.',
      null, false, true, false,
      '["Black"]'::jsonb, '["39","40","41","42","43"]'::jsonb,
      '[{"size":"39","color":"Black","stock":3},{"size":"41","color":"Black","stock":5},{"size":"42","color":"Black","stock":4},{"size":"43","color":"Black","stock":2}]'::jsonb
    ),
    (
      'curb-chain-6mm', 'Curb Chain 6mm', 'Accessories', 'Accessories',
      650, null, '5AD-AC-422',
      'Heavy curb chain with a substantial finish and minimal profile for layered styling or standalone wear.',
      null, false, true, false,
      '["Silver","Black"]'::jsonb, '["One Size"]'::jsonb,
      '[{"size":"One Size","color":"Silver","stock":11},{"size":"One Size","color":"Black","stock":8}]'::jsonb
    )
)
insert into public.products (
  slug, name, category, subcategory, price, sale_price, sku, description, badge,
  featured, best_seller, new_arrival, images, colors, sizes, variants, category_id, active
)
select
  seed.slug, seed.name, seed.category, seed.subcategory, seed.price, seed.sale_price,
  seed.sku, seed.description, seed.badge, seed.featured, seed.best_seller,
  seed.new_arrival, '[]'::jsonb, seed.colors, seed.sizes, seed.variants,
  category.id, true
from seed_products seed
join public.categories category on category.slug = lower(seed.category)
on conflict do nothing;

insert into public.product_variants (product_id, size, color)
select product.id, variant ->> 'size', variant ->> 'color'
from public.products product
cross join lateral jsonb_array_elements(product.variants) as variant
where product.slug in (
  'fracture-tee-washed-black',
  'split-knee-wide-jeans',
  'raw-edge-denim-jacket',
  'column-maxi-dress',
  'root-graphic-oversized-tee',
  'cargo-parachute-pant',
  'tread-runner-triple-black',
  'curb-chain-6mm'
)
on conflict (product_id, size, color) do nothing;

insert into public.inventory (variant_id, stock_quantity)
select product_variant.id, (variant ->> 'stock')::integer
from public.products product
cross join lateral jsonb_array_elements(product.variants) as variant
join public.product_variants product_variant
  on product_variant.product_id = product.id
  and product_variant.size = variant ->> 'size'
  and product_variant.color = variant ->> 'color'
where product.slug in (
  'fracture-tee-washed-black',
  'split-knee-wide-jeans',
  'raw-edge-denim-jacket',
  'column-maxi-dress',
  'root-graphic-oversized-tee',
  'cargo-parachute-pant',
  'tread-runner-triple-black',
  'curb-chain-6mm'
)
on conflict (variant_id) do nothing;

insert into public.collections (name, slug, description)
values
  ('After Hours', 'after-hours', 'Night layering'),
  ('Night Shift', 'night-shift', 'Monochrome essentials')
on conflict (slug) do nothing;

insert into public.collection_products (collection_id, product_id, position)
select collection.id, product.id, seed.position
from (
  values
    ('after-hours', 'raw-edge-denim-jacket', 0),
    ('after-hours', 'cargo-parachute-pant', 1),
    ('night-shift', 'fracture-tee-washed-black', 0),
    ('night-shift', 'column-maxi-dress', 1)
) as seed(collection_slug, product_slug, position)
join public.collections collection on collection.slug = seed.collection_slug
join public.products product on product.slug = seed.product_slug
on conflict (collection_id, product_id) do nothing;

insert into public.homepage_content (
  singleton, hero_title, hero_subtitle, primary_cta, secondary_cta, announcement
)
values (
  true,
  'Wear the mark. Not the rules.',
  'Raw-edge denim. Heavy cotton. Hand-distressed in small batches.',
  'Shop now',
  'View drops',
  'FREE SHIPPING ACROSS EGYPT OVER EGP 2,000'
)
on conflict (singleton) do update
set hero_title = excluded.hero_title,
    hero_subtitle = excluded.hero_subtitle,
    primary_cta = excluded.primary_cta,
    secondary_cta = excluded.secondary_cta,
    announcement = excluded.announcement
where homepage_content.hero_title = 'Wear the mark.'
  and homepage_content.hero_subtitle = 'Raw streetwear from Cairo.'
  and homepage_content.primary_cta = 'Shop now'
  and homepage_content.secondary_cta = 'Explore new drops'
  and homepage_content.announcement = '';

insert into public.store_settings (
  singleton, currency, shipping_free_threshold, standard_shipping,
  default_country, allow_cash_on_delivery, support_email, timezone
)
values (true, 'EGP', 2000, 120, 'Egypt', true, 'hello@5adsh.store', 'Africa/Cairo')
on conflict (singleton) do update
set support_email = excluded.support_email
where store_settings.support_email = '';

commit;
