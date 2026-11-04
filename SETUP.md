# Sarthak Gupta Portfolio + Cloud Admin

## Included
- `index.html` — public portfolio (same dark luxury direction, now with profile-photo and logo slots)
- `admin.html` — secure sign-in and content editor
- `config.js` — Supabase project URL + anon key configuration
- `setup.sql` — database table, Row Level Security policies, and public image bucket

## Important security notes
- Do not put your password in HTML, JavaScript, GitHub, or this ZIP.
- Do not use the Supabase `service_role` key in a browser app. Use only the anon/public key.
- The admin password shared in chat should be changed; create a fresh password in Supabase Auth.
- This setup uses Supabase Auth and database/storage policies. Only the signed-in Auth user can edit the row and upload to their own UUID folder.
- The public portfolio content and uploaded images are public by design. Do not upload private documents or sensitive information.

## Setup
1. Create a Supabase project at https://supabase.com/.
2. In Supabase Dashboard > Authentication > Users, create the admin user with the intended admin email and a NEW password. Disable public sign-ups in Authentication settings if enabled. Do not reuse a password exposed in chat.
3. Copy the user's UUID from Authentication > Users.
4. Open SQL Editor, paste `setup.sql`, and run it. (The UUID is not required by this SQL; the row is created when you save in admin.)
5. Go to Project Settings > API. Copy the Project URL and the `anon` / publishable public key. Never copy the `service_role` secret key.
6. Paste those two values into `config.js`.
7. Upload all four files (`index.html`, `admin.html`, `config.js`, `setup.sql`) to the same website project/repository. Deploy to Vercel, Netlify, or another static host.
8. Visit `https://YOUR-DOMAIN/admin.html`, sign in with the Auth user, edit fields, upload profile photo/logo, and click **Save all changes**.
9. Open the public homepage. Content is loaded from Supabase and shared across devices and browsers.

## Editing list fields
- Facts: one per line, `Label | Value`
- Interests: one per line, `Category | Title | Description`
- Certificates: one per line, `Short icon | Title | Description`

## Limitations / next step
This is a static front end using Supabase directly. For production, also configure Supabase Auth allowed redirect URLs to your deployed domain and keep public sign-ups disabled. If the site uses a custom domain, add that exact domain to Supabase Auth URL configuration.
