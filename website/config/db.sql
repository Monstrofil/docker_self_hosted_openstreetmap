--
-- PostgreSQL database dump
--

-- Dumped from database version 12.3 (Debian 12.3-1.pgdg100+1)
-- Dumped by pg_dump version 12.3 (Ubuntu 12.3-1.pgdg18.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: dev
--

INSERT INTO public.users
  (email, id, pass_crypt, creation_time, display_name, data_public, description, home_lat, home_lon, home_zoom, pass_salt, email_valid, new_email, creation_ip, languages, status, terms_agreed, consider_pd, auth_uid, preferred_editor, terms_seen, description_format, changesets_count, traces_count, diary_entries_count, image_use_gravatar, auth_provider, home_tile, tou_agreed)
VALUES
  ('admin@localhost.nowhere', 1, 'zUsK8b2plsPhGHAHsM/ahxf7MqaFwGI2DVYC+pcIa98=', '2020-07-14 19:11:46.049136', 'admin', true, '', NULL, NULL, 3, 'sha512!10000!mrYs5TmfO+nAOzGF/gb9MRMn23Hj6lXWVc+NZQ1yLTs=', true, NULL, '194.31.169.87', 'ru,en-US,en,uk,de', 'active', '2020-07-14 19:11:51.577137', false, NULL, NULL, true, 'markdown', 0, 0, 0, false, NULL, NULL, '2020-07-14 19:11:51.577158');


--
-- Data for Name: client_applications; Type: TABLE DATA; Schema: public; Owner: dev
--

INSERT INTO public.client_applications (id, name, url, support_url, callback_url, key, secret, user_id, created_at, updated_at, allow_read_prefs, allow_write_prefs, allow_write_diary, allow_write_api, allow_read_gpx, allow_write_gpx, allow_write_notes) VALUES (1, 'ID Editor', 'https://tileserver.monstrofil.xyz/id/', '', 'https://tileserver.monstrofil.xyz/id/land.html', '7puZ4X2jAueYxlb6SgD2LPKaip1gpFLcpNW09WZl', 'U9Tg3szRrpH7iGrpvZxloQX7q6PgYkJZOeMue2Kf', 1, '2020-07-14 19:14:24.422447', '2020-07-14 19:14:24.422447', true, true, true, true, true, true, true);


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: dev
--

INSERT INTO public.user_roles (id, user_id, role, created_at, updated_at, granter_id) VALUES (1, 1, 'administrator', '2020-07-14 19:13:25.637732', '2020-07-14 19:13:25.637732', 2);
INSERT INTO public.user_roles (id, user_id, role, created_at, updated_at, granter_id) VALUES (2, 1, 'moderator', '2020-07-14 19:13:31.392647', '2020-07-14 19:13:31.392647', 2);
