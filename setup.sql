-- Run once in Supabase: SQL Editor > New query
create table if not exists submissions(
 id uuid primary key,
 student_name text check (char_length(student_name)<=80),
 courses text[] default '{}',
 bouquet jsonb not null check (pg_column_size(bouquet)<20000),
 letter jsonb not null check (pg_column_size(letter)<40000),
 rating int not null check (rating between 1 and 5),
 created_at timestamptz default now());
create table if not exists config(name text primary key, value text not null);
alter table submissions enable row level security;
alter table config enable row level security;
-- Visitors may ONLY add rows. No select/update/delete policies = nobody can read directly.
create policy "anyone can add" on submissions for insert to anon with check (true);
grant insert on submissions to anon;
revoke select,update,delete on submissions from anon;
revoke all on config from anon;
-- Professor reads through this function, which needs the secret key.
create or replace function get_submissions(k text) returns setof submissions
language plpgsql security definer set search_path=public as $$
begin
 if k is null or k <> (select value from config where name='prof_key') then raise exception 'denied'; end if;
 return query select * from submissions order by created_at desc;
end $$;
revoke all on function get_submissions(text) from public; grant execute on function get_submissions(text) to anon;
-- CHANGE THIS to a long secret, then give it only to Professor Mikhail:
insert into config values('prof_key','CHANGE-ME-to-a-long-secret') on conflict (name) do update set value=excluded.value;
