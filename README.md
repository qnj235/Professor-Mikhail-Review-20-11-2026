# Professor Mikhail Spektor — The Review Page
Static site (GitHub Pages) + Supabase database.

## Setup
1. Put his photo at `assets/professor.jpg`.
2. Create a free project at supabase.com. SQL Editor: paste `setup.sql`, change `CHANGE-ME-to-a-long-secret`, run.
3. Settings > API: copy the Project URL and the **anon public** key into `CFG` at the top of the script in `index.html`. (The anon key is meant to be public; the policies make it insert-only. Never use the service_role key.)
4. Push to GitHub; Settings > Pages > deploy from `main` / root.
5. Share `https://<you>.github.io/<repo>/` with students. Professor: same site, "Wait, are you Professor Mikhail?", then enter the secret key.

## Notes
- Without Supabase values the site runs in demo mode (data stays in that browser only).
- Visitors can add submissions but cannot read any. Reading needs the key (a shared secret, not full authentication).
- Duplicate protection: each submission has a client-generated UUID primary key, and the save button locks while saving.
