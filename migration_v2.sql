-- MyMeo v2 migration: multi-employee assignments + in-app notifications
-- Run once in Supabase Dashboard > SQL Editor. Safe to run again.

alter table public.shifts
  add column if not exists priority text not null default 'Bình thường',
  add column if not exists description text;

create table if not exists public.shift_assignments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  shift_id uuid not null references public.shifts(id) on delete cascade,
  employee_id uuid not null references public.employees(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique (shift_id, employee_id)
);

create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  employee_id uuid references public.employees(id) on delete cascade,
  shift_id uuid references public.shifts(id) on delete cascade,
  title text not null,
  body text,
  read_at timestamptz,
  created_at timestamptz not null default now()
);

alter table public.shift_assignments enable row level security;
alter table public.notifications enable row level security;

drop policy if exists "Users manage own shift_assignments" on public.shift_assignments;
create policy "Users manage own shift_assignments"
  on public.shift_assignments for all
  using (auth.uid() = user_id)
  with check (
    auth.uid() = user_id
    and exists (select 1 from public.shifts s where s.id = shift_id and s.user_id = auth.uid())
    and exists (select 1 from public.employees e where e.id = employee_id and e.user_id = auth.uid())
  );

drop policy if exists "Users manage own notifications" on public.notifications;
create policy "Users manage own notifications"
  on public.notifications for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create index if not exists shift_assignments_user_shift_idx on public.shift_assignments(user_id, shift_id);
create index if not exists shift_assignments_employee_idx on public.shift_assignments(employee_id);
create index if not exists notifications_user_created_idx on public.notifications(user_id, created_at desc);
create index if not exists shifts_user_work_date_time_idx on public.shifts(user_id, work_date, start_time);

-- Migrate the old single employee_id into the new multi-assignment relation.
insert into public.shift_assignments (user_id, shift_id, employee_id)
select s.user_id, s.id, s.employee_id
from public.shifts s
where s.employee_id is not null
on conflict (shift_id, employee_id) do nothing;
