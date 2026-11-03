-- WorkSpace schema for Supabase
-- Run this entire script in Supabase Dashboard > SQL Editor.
create extension if not exists pgcrypto;
create table if not exists public.employees (
 id uuid primary key default gen_random_uuid(), user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 code text not null, name text not null, phone text, email text, position text, department text,
 status text default 'Đang làm việc', note text, created_at timestamptz default now(), updated_at timestamptz default now(),
 unique(user_id,code)
);
create table if not exists public.shifts (
 id uuid primary key default gen_random_uuid(), user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 title text not null, employee_id uuid references public.employees(id) on delete set null,
 work_date date not null, start_time time not null, end_time time not null, location text,
 status text default 'Đã lên lịch', note text, created_at timestamptz default now(), updated_at timestamptz default now()
);
create table if not exists public.materials (
 id uuid primary key default gen_random_uuid(), user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 code text not null, name text not null, unit text not null, category text, quantity numeric(14,2) default 0,
 min_quantity numeric(14,2) default 0, location text, note text, created_at timestamptz default now(), updated_at timestamptz default now(),
 unique(user_id,code)
);
create table if not exists public.stock_movements (
 id uuid primary key default gen_random_uuid(), user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 material_id uuid references public.materials(id) on delete set null, movement_type text not null check (movement_type in ('Nhập','Xuất')),
 quantity numeric(14,2) not null check(quantity>0), movement_date date not null, reference text, person text, note text,
 created_at timestamptz default now()
);
alter table public.employees enable row level security;
alter table public.shifts enable row level security;
alter table public.materials enable row level security;
alter table public.stock_movements enable row level security;
do $$ declare t text; begin
 foreach t in array array['employees','shifts','materials','stock_movements'] loop
  execute format('drop policy if exists %I on public.%I', 'Users manage own ' || t, t);
  execute format('create policy %I on public.%I for all using (auth.uid() = user_id) with check (auth.uid() = user_id)', 'Users manage own ' || t, t);
 end loop;
end $$;
create index if not exists shifts_user_date_idx on public.shifts(user_id,work_date);
create index if not exists movements_user_date_idx on public.stock_movements(user_id,movement_date);
