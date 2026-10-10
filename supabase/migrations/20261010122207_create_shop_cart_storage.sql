/*
# Create persistent anonymous shopping cart storage

1. New Tables
- `shop_carts`
- `id` (uuid, primary key) identifies a cart record.
- `session_key` (text, unique, not null) identifies the browser's anonymous shopping session.
- `items` (jsonb, not null) stores product ids and quantities for that session.
- `updated_at` (timestamptz, not null) records the most recent cart change.

2. Security
- Row level security is enabled on `shop_carts`.
- Anonymous and signed-in visitors can use the cart storage because this storefront does not require an account to browse or build a cart.
- Separate read, create, update, and delete policies are provided for the anon and authenticated roles.
*/

CREATE TABLE IF NOT EXISTS public.shop_carts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  session_key text UNIQUE NOT NULL,
  items jsonb NOT NULL DEFAULT '[]'::jsonb,
  updated_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.shop_carts ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public can read shop carts" ON public.shop_carts;
CREATE POLICY "Public can read shop carts" ON public.shop_carts FOR SELECT TO anon, authenticated USING (true);
DROP POLICY IF EXISTS "Public can create shop carts" ON public.shop_carts;
CREATE POLICY "Public can create shop carts" ON public.shop_carts FOR INSERT TO anon, authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "Public can update shop carts" ON public.shop_carts;
CREATE POLICY "Public can update shop carts" ON public.shop_carts FOR UPDATE TO anon, authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "Public can delete shop carts" ON public.shop_carts;
CREATE POLICY "Public can delete shop carts" ON public.shop_carts FOR DELETE TO anon, authenticated USING (true);
