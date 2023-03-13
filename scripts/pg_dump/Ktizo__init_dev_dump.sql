--
-- PostgreSQL database dump
--

-- Dumped from database version 12.11
-- Dumped by pg_dump version 14.6 (Homebrew)

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

ALTER TABLE IF EXISTS ONLY public.withdrawal DROP CONSTRAINT IF EXISTS withdrawal_artist_id_fkey;
ALTER TABLE IF EXISTS ONLY public.upload_user_files DROP CONSTRAINT IF EXISTS upload_user_files_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.similar_track DROP CONSTRAINT IF EXISTS similar_track_supervisor_id_fkey;
ALTER TABLE IF EXISTS ONLY public.project DROP CONSTRAINT IF EXISTS project_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.payment DROP CONSTRAINT IF EXISTS payment_supervisor_id_fkey;
ALTER TABLE IF EXISTS ONLY public.payment DROP CONSTRAINT IF EXISTS payment_invoice_id_fkey;
ALTER TABLE IF EXISTS ONLY public.notification DROP CONSTRAINT IF EXISTS notification_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.notification DROP CONSTRAINT IF EXISTS notification_song_id_fkey;
ALTER TABLE IF EXISTS ONLY public.my_earnings DROP CONSTRAINT IF EXISTS my_earnings_artist_id_fkey;
ALTER TABLE IF EXISTS ONLY public.licence DROP CONSTRAINT IF EXISTS licence_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.licence DROP CONSTRAINT IF EXISTS licence_song_id_fkey;
ALTER TABLE IF EXISTS ONLY public.invoice DROP CONSTRAINT IF EXISTS invoice_supervisor_id_fkey;
ALTER TABLE IF EXISTS ONLY public.invoice DROP CONSTRAINT IF EXISTS invoice_song_id_fkey;
ALTER TABLE IF EXISTS ONLY public.invoice DROP CONSTRAINT IF EXISTS "invoice_Licence_id_fkey";
ALTER TABLE IF EXISTS ONLY public.feedback DROP CONSTRAINT IF EXISTS feedback_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.count_likes DROP CONSTRAINT IF EXISTS count_likes_song_id_fkey;
ALTER TABLE IF EXISTS ONLY public."Songs" DROP CONSTRAINT IF EXISTS "Songs_user_id_fkey";
ALTER TABLE IF EXISTS ONLY public."Songs" DROP CONSTRAINT IF EXISTS "Songs_project_id_fkey";
ALTER TABLE IF EXISTS ONLY public.withdrawal DROP CONSTRAINT IF EXISTS withdrawal_pkey;
ALTER TABLE IF EXISTS ONLY public.user_ratings DROP CONSTRAINT IF EXISTS user_ratings_pkey;
ALTER TABLE IF EXISTS ONLY public."user" DROP CONSTRAINT IF EXISTS user_pkey;
ALTER TABLE IF EXISTS ONLY public."user" DROP CONSTRAINT IF EXISTS user_email_key;
ALTER TABLE IF EXISTS ONLY public.upload_user_files DROP CONSTRAINT IF EXISTS upload_user_files_pkey;
ALTER TABLE IF EXISTS ONLY public.song_ratings DROP CONSTRAINT IF EXISTS song_ratings_pkey;
ALTER TABLE IF EXISTS ONLY public.similar_track DROP CONSTRAINT IF EXISTS similar_track_pkey;
ALTER TABLE IF EXISTS ONLY public.reset_password DROP CONSTRAINT IF EXISTS reset_password_reset_token_key;
ALTER TABLE IF EXISTS ONLY public.reset_password DROP CONSTRAINT IF EXISTS reset_password_pkey;
ALTER TABLE IF EXISTS ONLY public.reset_password DROP CONSTRAINT IF EXISTS reset_password_expired_in_key;
ALTER TABLE IF EXISTS ONLY public.reset_password DROP CONSTRAINT IF EXISTS reset_password_email_key;
ALTER TABLE IF EXISTS ONLY public.project DROP CONSTRAINT IF EXISTS project_pkey;
ALTER TABLE IF EXISTS ONLY public.payment DROP CONSTRAINT IF EXISTS payment_pkey;
ALTER TABLE IF EXISTS ONLY public.notification DROP CONSTRAINT IF EXISTS notification_pkey;
ALTER TABLE IF EXISTS ONLY public.my_earnings DROP CONSTRAINT IF EXISTS my_earnings_pkey;
ALTER TABLE IF EXISTS ONLY public.licence DROP CONSTRAINT IF EXISTS licence_pkey;
ALTER TABLE IF EXISTS ONLY public.invoice DROP CONSTRAINT IF EXISTS invoice_pkey;
ALTER TABLE IF EXISTS ONLY public.feedback DROP CONSTRAINT IF EXISTS feedback_pkey;
ALTER TABLE IF EXISTS ONLY public.email_details DROP CONSTRAINT IF EXISTS email_details_pkey;
ALTER TABLE IF EXISTS ONLY public.email_details DROP CONSTRAINT IF EXISTS email_details_email_key;
ALTER TABLE IF EXISTS ONLY public.count_likes DROP CONSTRAINT IF EXISTS count_likes_pkey;
ALTER TABLE IF EXISTS ONLY public.contact_details DROP CONSTRAINT IF EXISTS contact_details_pkey;
ALTER TABLE IF EXISTS ONLY public.alembic_version DROP CONSTRAINT IF EXISTS alembic_version_pkc;
ALTER TABLE IF EXISTS ONLY public."Songs" DROP CONSTRAINT IF EXISTS "Songs_pkey";
ALTER TABLE IF EXISTS public.payment ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.invoice ALTER COLUMN id DROP DEFAULT;
DROP TABLE IF EXISTS public.withdrawal;
DROP TABLE IF EXISTS public.user_ratings;
DROP TABLE IF EXISTS public."user";
DROP TABLE IF EXISTS public.upload_user_files;
DROP TABLE IF EXISTS public.song_ratings;
DROP TABLE IF EXISTS public.similar_track;
DROP TABLE IF EXISTS public.reset_password;
DROP TABLE IF EXISTS public.project;
DROP SEQUENCE IF EXISTS public.payment_id_seq;
DROP TABLE IF EXISTS public.payment;
DROP TABLE IF EXISTS public.notification;
DROP TABLE IF EXISTS public.my_earnings;
DROP TABLE IF EXISTS public.licence;
DROP SEQUENCE IF EXISTS public.invoice_id_seq;
DROP TABLE IF EXISTS public.invoice;
DROP TABLE IF EXISTS public.feedback;
DROP TABLE IF EXISTS public.email_details;
DROP TABLE IF EXISTS public.count_likes;
DROP TABLE IF EXISTS public.contact_details;
DROP TABLE IF EXISTS public.alembic_version;
DROP TABLE IF EXISTS public."Songs";
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Songs; Type: TABLE; Schema: public; Owner: ktizo
--

CREATE TABLE public."Songs" (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    music_title character varying(255),
    genre character varying(255),
    own_recording boolean,
    parties jsonb,
    writers jsonb,
    publishers jsonb,
    audio_url character varying(255),
    image_url character varying(255),
    upload_date date,
    spotify_id character varying(255),
    music_duration character varying(255),
    status integer,
    track_id character varying(255),
    spotify_artist_id character varying(255),
    bpm character varying(255),
    project_id uuid,
    origin_url character varying(255),
    clean_url character varying(255),
    instrumental_url character varying(255),
    cover_photo character varying(255),
    artist_title character varying(255)
);


ALTER TABLE public."Songs" OWNER TO ktizo;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: ktizo
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO ktizo;

--
-- Name: contact_details; Type: TABLE; Schema: public; Owner: ktizo
--

CREATE TABLE public.contact_details (
    id uuid NOT NULL,
    name character varying(255),
    email character varying(255),
    user_role character varying(255),
    message character varying(255),
    reply character varying(255),
    last_name character varying(255),
    company_name character varying(255),
    number_of_employees character varying(255)
);


ALTER TABLE public.contact_details OWNER TO ktizo;

--
-- Name: count_likes; Type: TABLE; Schema: public; Owner: ktizo
--

CREATE TABLE public.count_likes (
    id uuid NOT NULL,
    song_id uuid NOT NULL,
    action jsonb,
    sync jsonb
);


ALTER TABLE public.count_likes OWNER TO ktizo;

--
-- Name: email_details; Type: TABLE; Schema: public; Owner: ktizo
--

CREATE TABLE public.email_details (
    id uuid NOT NULL,
    full_name character varying(255),
    email character varying(255),
    user_role character varying(255)
);


ALTER TABLE public.email_details OWNER TO ktizo;

--
-- Name: feedback; Type: TABLE; Schema: public; Owner: ktizo
--

CREATE TABLE public.feedback (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    easyto_understand character varying(255),
    songs_satisfaction character varying(255),
    easyto_navigate character varying(255),
    licensing_effective character varying(255),
    improve_ideas character varying(255)
);


ALTER TABLE public.feedback OWNER TO ktizo;

--
-- Name: invoice; Type: TABLE; Schema: public; Owner: ktizo
--

CREATE TABLE public.invoice (
    id integer NOT NULL,
    supervisor_id uuid NOT NULL,
    song_id uuid NOT NULL,
    "Licence_id" uuid NOT NULL,
    date date
);


ALTER TABLE public.invoice OWNER TO ktizo;

--
-- Name: invoice_id_seq; Type: SEQUENCE; Schema: public; Owner: ktizo
--

CREATE SEQUENCE public.invoice_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.invoice_id_seq OWNER TO ktizo;

--
-- Name: invoice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ktizo
--

ALTER SEQUENCE public.invoice_id_seq OWNED BY public.invoice.id;


--
-- Name: licence; Type: TABLE; Schema: public; Owner: ktizo
--

CREATE TABLE public.licence (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    song_id uuid NOT NULL,
    date date,
    email character varying(255),
    "to" character varying(255),
    master_recording character varying(255),
    written_by jsonb,
    published_by jsonb,
    performed_by character varying(255),
    label character varying(255),
    tv_show character varying(255),
    show_description character varying(2000),
    use character varying(2000),
    onetime_fee character varying(255),
    direct_performancefee character varying(255),
    master_licencefee character varying(255),
    sync_licencefee character varying(255),
    performance_fee character varying(255),
    reached_at character varying(1000),
    reachedat_email character varying(255),
    status integer,
    approved_date date,
    search_artistid character varying(255),
    search_trackid character varying(255),
    licensor jsonb,
    producer jsonb
);


ALTER TABLE public.licence OWNER TO ktizo;

--
-- Name: my_earnings; Type: TABLE; Schema: public; Owner: ktizo
--

CREATE TABLE public.my_earnings (
    id uuid NOT NULL,
    artist_id uuid NOT NULL,
    invoice_id character varying(255),
    artist_name character varying(255),
    total_amount character varying(255),
    balance_amount character varying(255),
    withdraw_amount character varying(255),
    invoice_number jsonb,
    date date
);


ALTER TABLE public.my_earnings OWNER TO ktizo;

--
-- Name: notification; Type: TABLE; Schema: public; Owner: ktizo
--

CREATE TABLE public.notification (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    song_id uuid NOT NULL,
    artist_id uuid,
    music_title character varying(255),
    track_id character varying(255),
    date date,
    status integer,
    seen integer,
    datetime timestamp without time zone
);


ALTER TABLE public.notification OWNER TO ktizo;

--
-- Name: payment; Type: TABLE; Schema: public; Owner: ktizo
--

CREATE TABLE public.payment (
    id integer NOT NULL,
    supervisor_id uuid NOT NULL,
    invoice_id integer NOT NULL,
    stripe_id character varying(255),
    email character varying(255),
    amount character varying(255),
    date date,
    status character varying(255),
    amount_before_reduction character varying(255),
    receipt_url character varying(500),
    receipt_created_date timestamp without time zone,
    song_id character varying(255)
);


ALTER TABLE public.payment OWNER TO ktizo;

--
-- Name: payment_id_seq; Type: SEQUENCE; Schema: public; Owner: ktizo
--

CREATE SEQUENCE public.payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payment_id_seq OWNER TO ktizo;

--
-- Name: payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ktizo
--

ALTER SEQUENCE public.payment_id_seq OWNED BY public.payment.id;


--
-- Name: project; Type: TABLE; Schema: public; Owner: ktizo
--

CREATE TABLE public.project (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255) NOT NULL,
    created_date timestamp without time zone
);


ALTER TABLE public.project OWNER TO ktizo;

--
-- Name: reset_password; Type: TABLE; Schema: public; Owner: ktizo
--

CREATE TABLE public.reset_password (
    id uuid NOT NULL,
    email character varying(255) NOT NULL,
    status boolean NOT NULL,
    reset_token character varying(255) NOT NULL,
    expired_in timestamp without time zone NOT NULL
);


ALTER TABLE public.reset_password OWNER TO ktizo;

--
-- Name: similar_track; Type: TABLE; Schema: public; Owner: ktizo
--

CREATE TABLE public.similar_track (
    id uuid NOT NULL,
    supervisor_id uuid NOT NULL,
    search_artistid character varying(255) NOT NULL,
    search_trackid character varying(255) NOT NULL,
    similar_songs jsonb,
    date date NOT NULL,
    search_artistname character varying(255),
    search_trackname character varying(255)
);


ALTER TABLE public.similar_track OWNER TO ktizo;

--
-- Name: song_ratings; Type: TABLE; Schema: public; Owner: ktizo
--

CREATE TABLE public.song_ratings (
    id uuid NOT NULL,
    song_id character varying(255),
    reviewer_id character varying(255),
    rate integer
);


ALTER TABLE public.song_ratings OWNER TO ktizo;

--
-- Name: upload_user_files; Type: TABLE; Schema: public; Owner: ktizo
--

CREATE TABLE public.upload_user_files (
    id uuid NOT NULL,
    s3_file_url character varying(255),
    filename character varying(255),
    user_id uuid NOT NULL
);


ALTER TABLE public.upload_user_files OWNER TO ktizo;

--
-- Name: user; Type: TABLE; Schema: public; Owner: ktizo
--

CREATE TABLE public."user" (
    id uuid NOT NULL,
    full_name character varying(255),
    email character varying(255),
    password character varying(255),
    age integer,
    spotify_artist_profile character varying(255),
    favourite_music_style character varying(255),
    favourite_music_mood character varying(255),
    yourown_music character varying(255),
    favourite_music_topic character varying(255),
    master character varying(255),
    publish_control character varying(255),
    outside_income character varying(255),
    established_artist character varying(255),
    company character varying(255),
    linkedin_profile character varying(255),
    project_seek_music character varying(255),
    turn_around_time character varying(255),
    project_budject character varying(255),
    syncs_seek character varying(255),
    token character varying(255),
    user_role character varying(255),
    spotify_user_id character varying(255),
    legal_name character varying(255),
    profile_pic character varying(255),
    about_me character varying(500),
    music_rating character varying(255),
    song_writer jsonb,
    own_masters jsonb,
    music_publishing character varying(255),
    music_publishing_owners jsonb,
    master_recording character varying(255),
    master_recording_owners jsonb,
    spotify_user_name character varying(255),
    account_id character varying(255),
    active_status integer,
    coupon_code character varying(255),
    coupon_status integer,
    coupon_created_date timestamp without time zone
);


ALTER TABLE public."user" OWNER TO ktizo;

--
-- Name: user_ratings; Type: TABLE; Schema: public; Owner: ktizo
--

CREATE TABLE public.user_ratings (
    id uuid NOT NULL,
    reviewee_id character varying(255),
    reviewer_id character varying(255),
    rate integer
);


ALTER TABLE public.user_ratings OWNER TO ktizo;

--
-- Name: withdrawal; Type: TABLE; Schema: public; Owner: ktizo
--

CREATE TABLE public.withdrawal (
    id uuid NOT NULL,
    artist_id uuid NOT NULL,
    amount character varying(255),
    date date,
    status integer,
    remarks character varying(255)
);


ALTER TABLE public.withdrawal OWNER TO ktizo;

--
-- Name: invoice id; Type: DEFAULT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.invoice ALTER COLUMN id SET DEFAULT nextval('public.invoice_id_seq'::regclass);


--
-- Name: payment id; Type: DEFAULT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.payment ALTER COLUMN id SET DEFAULT nextval('public.payment_id_seq'::regclass);


--
-- Data for Name: Songs; Type: TABLE DATA; Schema: public; Owner: ktizo
--

COPY public."Songs" (id, user_id, music_title, genre, own_recording, parties, writers, publishers, audio_url, image_url, upload_date, spotify_id, music_duration, status, track_id, spotify_artist_id, bpm, project_id, origin_url, clean_url, instrumental_url, cover_photo, artist_title) FROM stdin;
821d34ee-9eb3-4274-be8b-b6695d82935d	2491764d-dd64-417d-9704-51a085fd6c83	A Very Strange Time	pop	t	[{"name": "", "email": "", "percentage": ""}]	[{"writerIPI": "1245", "writerPRO": "ASCAP", "writerName": "writer1", "writerPerc": "100%", "writerEmail": "user@gmail.com"}]	[{"publisherIPI": "2121", "publisherPRO": "ASCAP", "publisherName": "user2", "publisherPerc": "100%", "publisherEmail": "user@gmail.com"}]	https://ktizo-prod.s3.amazonaws.com/Anyone.mp3	https://ktizo-prod.s3.amazonaws.com/creatorDiv.png	2022-07-04	6EtjpH5ma85sXU9DyO812N	3:40	1	160003	\N	79.498	\N	\N	\N	\N	\N	\N
a5df2da4-2eb9-4631-acb9-8cbfa49bedf8	2491764d-dd64-417d-9704-51a085fd6c83	10 Toes	pop	t	[{"name": "", "email": "", "percentage": ""}]	[{"writerIPI": "12121", "writerPRO": "ASCAPBMI", "writerName": "test", "writerPerc": "100%", "writerEmail": "test@gmail.com"}]	[{"publisherIPI": "1242", "publisherPRO": "ASCAPBMI", "publisherName": "Rahman", "publisherPerc": "100%", "publisherEmail": "Rahman@gmail.com"}]	https://ktizo-prod.s3.amazonaws.com/Aparshakti Khurana_ Balle Ni Balle _ Dhanashree VC _ Siddharth AB _ Gurpreet S _ Official Video.mp3	https://ktizo-prod.s3.amazonaws.com/Record-Album-02 (1).jpg	2022-07-01	2BN5ZMErVAhbEroB99b3no	3:48	1	194100	\N	101.986	\N	\N	\N	\N	\N	\N
4cfa75c6-e1ed-4394-bd84-8f8ae049c207	0e16ac26-f71b-4188-b3fa-dd40afe5b3b1	Bay 101	Pop	t	[{"name": "", "email": "", "percentage": ""}]	[{"writerIPI": "1212", "writerPRO": "Test-1", "writerName": "Test-1", "writerPerc": "50%", "writerEmail": "test1@xminds.com"}, {"writerIPI": "1211", "writerPRO": "Test-2", "writerName": "Test-2", "writerPerc": "50%", "writerEmail": "test2@xminds.com"}]	[{"publisherIPI": "0011", "publisherPRO": "Renjith", "publisherName": "Renjith", "publisherPerc": "100%", "publisherEmail": "renjithaim05@gmail.com"}]	https://ktizo-prod.s3.amazonaws.com/Bay_101_(getmp3.pro).mp3	https://ktizo-prod.s3.amazonaws.com/bridesmaids-img3.jpg	2022-07-01	32i9Zz376Thwuft0UoWqM8	1:31	1	436966	\N	105.007	\N	\N	\N	\N	\N	\N
5d474098-f4f7-4d4e-ba37-3b9a97ffbc07	0e16ac26-f71b-4188-b3fa-dd40afe5b3b1	Paradise	Pop	t	[{"name": "", "email": "", "percentage": ""}]	[{"writerIPI": "11111", "writerPRO": "Test-1", "writerName": "Test-1", "writerPerc": "100%", "writerEmail": "test-1@xminds.com"}]	[{"publisherIPI": "2222", "publisherPRO": "Test-2", "publisherName": "Test-2", "publisherPerc": "100%", "publisherEmail": "renjithaim05@gmail.com"}]	https://ktizo-prod.s3.amazonaws.com/Paradise.mp3	https://ktizo-prod.s3.amazonaws.com/about_me.jpg	2022-07-01	412XVsG2DN1ws4OlDzoumc	2:52	1	436959	\N	120.002	\N	\N	\N	\N	\N	\N
b220f19e-3ea5-4e60-be6f-6575fce35189	2491764d-dd64-417d-9704-51a085fd6c83	Almost Famous	pop	t	[{"name": "", "email": "", "percentage": ""}]	[{"writerIPI": "1245", "writerPRO": "ASCAP", "writerName": "writer1", "writerPerc": "100%", "writerEmail": "user@gmail.com"}]	[{"publisherIPI": "2121", "publisherPRO": "ASCAP", "publisherName": "user2", "publisherPerc": "100%", "publisherEmail": "user@gmail.com"}]	https://ktizo-prod.s3.amazonaws.com/Anyone.mp3	https://ktizo-prod.s3.amazonaws.com/contactus_Image.png	2022-07-04	4qJVEovuJ0Oezit9lEzodQ	4:29	1	404280	\N	124.025	\N	\N	\N	\N	\N	\N
a6b17501-af77-4c1d-aa95-ba539565f760	2491764d-dd64-417d-9704-51a085fd6c83	A Little More (feat. Kiana Ledé)	pop	t	[{"name": "", "email": "", "percentage": ""}]	[{"writerIPI": "1245", "writerPRO": "ASCAP", "writerName": "writer1", "writerPerc": "100%", "writerEmail": "user@gmail.com"}]	[{"publisherIPI": "2121", "publisherPRO": "ASCAP", "publisherName": "user2", "publisherPerc": "100%", "publisherEmail": "user@gmail.com"}]	https://ktizo-prod.s3.amazonaws.com/Anyone.mp3	https://ktizo-prod.s3.amazonaws.com/Dubxx.jpg	2022-07-04	5exI67CSZNnIjY7RyInyy4	3:33	1	129931	\N	87.016	\N	\N	\N	\N	\N	\N
5361ce8c-be44-4fb0-a501-b7f86563c0bb	2491764d-dd64-417d-9704-51a085fd6c83	All Facts (feat. Ty Dolla $ign)	pop	t	[{"name": "", "email": "", "percentage": ""}]	[{"writerIPI": "211", "writerPRO": "122", "writerName": "Test", "writerPerc": "100%", "writerEmail": "test@xminds.com"}]	[{"publisherIPI": "4878", "publisherPRO": "454", "publisherName": "Test", "publisherPerc": "100%", "publisherEmail": "test@xminds.com"}]	https://ktizo-prod.s3.amazonaws.com/G_Eazy_-_All_Facts_Lyrics_Ft_Ty_(getmp3.pro).mp3	https://ktizo-prod.s3.amazonaws.com/bridesmaids-img1.jpg	2022-07-04	19TWdlPoMYhyWKEUDE6xRx	3:01	1	169530	\N	160.221	\N	\N	\N	\N	\N	\N
43ae3340-d36f-4b84-ae70-c9c117432d7f	2491764d-dd64-417d-9704-51a085fd6c83	Angel	pop	t	[{"name": "", "email": "", "percentage": ""}]	[{"writerIPI": "1245", "writerPRO": "ASCAP", "writerName": "writer1", "writerPerc": "100%", "writerEmail": "user@gmail.com"}]	[{"publisherIPI": "2121", "publisherPRO": "ASCAP", "publisherName": "user2", "publisherPerc": "100%", "publisherEmail": "user@gmail.com"}]	https://ktizo-prod.s3.amazonaws.com/Anyone.mp3	https://ktizo-prod.s3.amazonaws.com/UICU-1323.jpg	2022-07-04	6TX9hUdcCMvmFTonaGxdeX	3:10	1	210166	\N	155.849	\N	\N	\N	\N	\N	\N
d4f98ad2-a44a-4ad6-81ca-c59eac4cac15	2491764d-dd64-417d-9704-51a085fd6c83	10 Toes	pop	t	[{"name": "", "email": "", "percentage": ""}]	[{"writerIPI": "12121", "writerPRO": "ASCAPBMI", "writerName": "test", "writerPerc": "100%", "writerEmail": "test@gmail.com"}]	[{"publisherIPI": "1242", "publisherPRO": "ASCAPBMI", "publisherName": "test", "publisherPerc": "100%", "publisherEmail": "test@gmail.com"}]	https://ktizo-prod.s3.amazonaws.com/Arabic Kuthu - Video Song _ Beast _ Thalapathy Vijay _ Pooja Hegde _ Sun Pictures _ Nelson _ Anirudh (1).mp3	https://ktizo-prod.s3.amazonaws.com/Record-Album-02 (1).jpg	2022-07-05	53zTSN9Zgq9PJhS9xTcJv7	3:48	1	65414	\N	101.986	\N	\N	\N	\N	\N	\N
ada103db-5b4a-486c-af75-295a0bf0925b	2491764d-dd64-417d-9704-51a085fd6c83	A Little More (feat. Kiana Ledé)	pop	t	[{"name": "", "email": "", "percentage": ""}]	[{"writerIPI": "12121", "writerPRO": "ASCAPBMI", "writerName": "test", "writerPerc": "100%", "writerEmail": "test@gmail.com"}]	[{"publisherIPI": "1242", "publisherPRO": "ASCAPBMI", "publisherName": "test", "publisherPerc": "100%", "publisherEmail": "test@gmail.com"}]	https://ktizo-prod.s3.amazonaws.com/Aparshakti Khurana_ Balle Ni Balle _ Dhanashree VC _ Siddharth AB _ Gurpreet S _ Official Video.mp3	https://ktizo-prod.s3.amazonaws.com/wallpaperflare.com_wallpaper.jpg	2022-07-05	1waruKeJtERqtrboAlxijk	3:33	1	343542	\N	87.016	\N	\N	\N	\N	\N	\N
0c2f68b0-0d88-4bed-8e87-a714972f1596	2491764d-dd64-417d-9704-51a085fd6c83	A Little More (feat. Kiana Ledé)	pop	t	[{"name": "", "email": "", "percentage": ""}]	[{"writerIPI": "123", "writerPRO": "ASCAP", "writerName": "test", "writerPerc": "100%", "writerEmail": "test@gmail.com"}]	[{"publisherIPI": "2331", "publisherPRO": "ASCAP", "publisherName": "test", "publisherPerc": "100%", "publisherEmail": "test@gmail.com"}]	https://ktizo-prod.s3.amazonaws.com/Mersal - Aalaporan Thamizhan Tamil Video _ Vijay _ A.R. Rahman.mp3	https://ktizo-prod.s3.amazonaws.com/Record-Album-02 (1).jpg	2022-08-18	0OLKDxDEz1yW3YCOsW02ee	3:33	1	65415	\N	87.016	\N	\N	\N	\N	\N	\N
fa5786ba-f7e4-43b9-aea0-3cd5bfbc541b	f4fa08bb-6f0e-47c2-ab0e-052d5ead332f	Baby Blues	Electronic R&B	f	[{"name": "Alec B", "email": "alec@celabeats.com", "percentage": "50%"}]	[{"writerIPI": "869022224", "writerPRO": "Ascap", "writerName": "Duncan Davis", "writerPerc": "50%", "writerEmail": "dunc.h.davis@gmail.com"}, {"writerIPI": "00858617885", "writerPRO": "BMI", "writerName": "Alec B", "writerPerc": "50%", "writerEmail": "alec@celabeats.com"}]	[{"publisherIPI": "395529515", "publisherPRO": "Ascap", "publisherName": "Duncan Davis", "publisherPerc": "50%", "publisherEmail": "dunc.h.davis@gmail.com"}, {"publisherIPI": "00858617885", "publisherPRO": "BMI", "publisherName": "Alec B", "publisherPerc": "50%", "publisherEmail": "alec@celabeats.com"}]	https://ktizo-prod.s3.amazonaws.com/Baby Blues PANO Ab.wav	https://ktizo-prod.s3.amazonaws.com/baby blues copy.PNG	2022-10-22	0W7LpXiaVCk8QkcSAk6ioc	2:44	1	437810	\N	160.009	\N	\N	\N	\N	\N	\N
5c5c3a8c-4d8e-4493-bdb5-5b2914f5e651	214e1202-a9ed-439c-8dcb-1dc73fadec0c	Sin	Pop	t	[{"name": "", "email": "", "percentage": ""}]	[{"writerIPI": "638289310", "writerPRO": "BMI", "writerName": "Farah Achour", "writerPerc": "100%", "writerEmail": "farahuniverse@gmail.com"}]	[{"publisherIPI": "638289310", "publisherPRO": "BMI", "publisherName": "Farah Achour", "publisherPerc": "100%", "publisherEmail": "farahuniverse@gmail.com"}]	https://ktizo-prod.s3.amazonaws.com/FARAH - SIN - MASTER 1_0.mp3	https://ktizo-prod.s3.amazonaws.com/SinCoverFinal.png	2022-09-01	0Tyn4nSTsyaewGsH10FPh0	3:21	1	437720	\N	127.937	\N	\N	\N	\N	\N	\N
e7bf8ed0-f3b5-4b37-a5a8-f838e2997f45	228532c2-47e2-4c28-b459-65cefd516038	For Me	pop	t	[{"name": "", "email": "", "percentage": ""}]	[{"writerIPI": "00615625946", "writerPRO": "BMI", "writerName": "Willmore Stuart", "writerPerc": "50%", "writerEmail": "williewaters.dbd@gmail.com"}, {"writerIPI": "00658531423", "writerPRO": "BMI ", "writerName": "Bertram Cash", "writerPerc": "50%", "writerEmail": "ramontgreen@gmail.com"}]	[{"publisherIPI": "01039195846", "publisherPRO": "BMI", "publisherName": "DBD Entertainment Publishing", "publisherPerc": "50%", "publisherEmail": "ent.dbd@gmail.com"}, {"publisherIPI": "00889957337", "publisherPRO": "BMI", "publisherName": "MUSIC BY ROYALTY AND RESPECT PUBLISHING", "publisherPerc": "50%", "publisherEmail": "ramontgreen@gmail.com"}]	https://ktizo-prod.s3.amazonaws.com/Willie Waters _For Me_12022021.mp3	https://ktizo-prod.s3.amazonaws.com/Willie Waters - For_Me cover.jpg	2022-08-05	3bqA2IBPRZs9eiHgCD44OU	2:41	1	437171	\N	95.536	\N	\N	\N	\N	\N	\N
61af30e3-f177-4c9a-87c1-42122a723712	f4fa08bb-6f0e-47c2-ab0e-052d5ead332f	Angry	POP R&B	t	[{"name": "", "email": "", "percentage": ""}]	[{"writerIPI": "869022224", "writerPRO": "Ascap", "writerName": "Duncan Davis", "writerPerc": "100%", "writerEmail": "dunc.h.davis@gmail.com"}]	[{"publisherIPI": "395529515", "publisherPRO": "Ascap", "publisherName": "Duncan Davis", "publisherPerc": "100%", "publisherEmail": "dunc.h.davis@gmail.com"}]	https://ktizo-prod.s3.amazonaws.com/DDBABSY - ANGRY - CR 2BB_1.mp3	https://ktizo-prod.s3.amazonaws.com/angryy.PNG	2022-10-22	1ThvwdW2fotP1QktVMVLKR	2:58	1	437809	\N	149.96	\N	\N	\N	\N	\N	\N
70d497d4-c4c6-41a1-b0fa-f02bd1fed13e	0cd24b0d-2c87-44e7-b991-33317f83ace6	Addicted	pop	t	[{"name": "", "email": "", "percentage": ""}]	[{"writerIPI": "123", "writerPRO": "123", "writerName": "Y", "writerPerc": "100%", "writerEmail": "tka4yk1848@gmail.com"}]	[{"publisherIPI": "123", "publisherPRO": "123", "publisherName": "q", "publisherPerc": "100%", "publisherEmail": "tka4yk1848@gmail.com"}]	https://ktizo-prod.s3.amazonaws.com/Mr. Freeman - Mr. Freeman feat. Killagram, Вася Обломов, Ольга Арефьева, клип Колыбельная.mp3	https://ktizo-prod.s3.amazonaws.com/ieronim bosch dark fantasy battle (1).png	2022-12-03	6QVx8qNSScVNwR5O7nNaUZ	4:31	1	173269	\N	93.914	\N	\N	\N	\N	\N	\N
86c09172-eb34-45f6-8b4f-50bbf68f64f2	d573331f-b924-44bc-8799-e66bf7ff6ac7	Sin	Pop	t	[{"name": "", "email": "", "percentage": ""}]	[{"writerIPI": "638289310", "writerPRO": "BMI", "writerName": "Farah Achour", "writerPerc": "100%", "writerEmail": "farahuniverse@gmail.com"}]	[{"publisherIPI": "638289310", "publisherPRO": "BMI", "publisherName": "Farah Achour", "publisherPerc": "100%", "publisherEmail": "farahuniverse@gmail.com"}]	https://ktizo-prod.s3.amazonaws.com/FARAH - SIN - MASTER 1_0.mp3	https://ktizo-prod.s3.amazonaws.com/SinCoverFinal.png	2022-09-01	0Tyn4nSTsyaewGsH10FPh0	3:21	0	437720	\N	127.937	93c7f29d-6e74-46e2-badd-95d789403a43	\N	\N	\N	\N	\N
86c09172-eb34-45f6-8b4f-50bbf68f64f1	0cd24b0d-2c87-44e7-b991-33317f83ace6	Sin	Pop	t	[{"name": "", "email": "", "percentage": ""}]	[{"writerIPI": "638289310", "writerPRO": "BMI", "writerName": "Farah Achour", "writerPerc": "100%", "writerEmail": "farahuniverse@gmail.com"}]	[{"publisherIPI": "638289310", "publisherPRO": "BMI", "publisherName": "Farah Achour", "publisherPerc": "100%", "publisherEmail": "farahuniverse@gmail.com"}]	https://ktizo-prod.s3.amazonaws.com/FARAH - SIN - MASTER 1_0.mp3	https://ktizo-prod.s3.amazonaws.com/SinCoverFinal.png	2022-09-01	0Tyn4nSTsyaewGsH10FPh0	3:21	0	437720	\N	127.937	93c7f29d-6e74-46e2-badd-95d789403a43	\N	\N	\N	\N	\N
86c09172-eb34-45f6-8b4f-50bbf68f64f6	60d34088-3b0e-443a-b931-732951a50e3c	Alien - Edit	pop	t	[{"name": "", "email": "", "percentage": ""}]	[{"writerIPI": "123", "writerPRO": "123", "writerName": "y", "writerPerc": "100%", "writerEmail": "tka4yk1848@gmail.com"}]	[{"publisherIPI": "123", "publisherPRO": "123", "publisherName": "y", "publisherPerc": "100%", "publisherEmail": "tka4yk1848@gmail.com"}]	https://ktizo-prod.s3.amazonaws.com/Mr. Freeman - Mr. Freeman feat. Killagram, Вася Обломов, Ольга Арефьева, клип Колыбельная.mp3	https://ktizo-prod.s3.amazonaws.com/ieronim bosch dark fantasy battle .png	2022-12-03	693VDu8b5jfxQjK1SCrRDQ	2:44	1	173322	\N	82.476	93c7f29d-6e74-46e2-badd-95d789403a44	\N	\N	\N	\N	\N
86c09172-eb34-45f6-8b4f-50bbf68f64f7	60d34088-3b0e-443a-b931-732951a50e3c	Alien - Edit	pop	t	[{"name": "", "email": "", "percentage": ""}]	[{"writerIPI": "123", "writerPRO": "123", "writerName": "y", "writerPerc": "100%", "writerEmail": "tka4yk1848@gmail.com"}]	[{"publisherIPI": "123", "publisherPRO": "123", "publisherName": "y", "publisherPerc": "100%", "publisherEmail": "tka4yk1848@gmail.com"}]	https://ktizo-prod.s3.amazonaws.com/Mr. Freeman - Mr. Freeman feat. Killagram, Вася Обломов, Ольга Арефьева, клип Колыбельная.mp3	https://ktizo-prod.s3.amazonaws.com/ieronim bosch dark fantasy battle .png	2022-12-03	693VDu8b5jfxQjK1SCrRDQ	2:44	1	173322	\N	82.476	93c7f29d-6e74-46e2-badd-95d789403a44	\N	\N	\N	\N	\N
\.


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: ktizo
--

COPY public.alembic_version (version_num) FROM stdin;
e13739b151be
\.


--
-- Data for Name: contact_details; Type: TABLE DATA; Schema: public; Owner: ktizo
--

COPY public.contact_details (id, name, email, user_role, message, reply, last_name, company_name, number_of_employees) FROM stdin;
5d5129d5-0959-49f5-b0fd-48853f2e7b07	El viper 	umumethode222@gmail.com	Artist 	I just wanna join you 	\N	\N	\N	\N
80953f1b-4fd3-483e-9dc2-fc26ddf081e2	Treeh	treehhaus@gmail.com	Treeh	Looking to get a few songs from my most recent Ep 'Sumthin Different' synced. Please follow the link below to hear the vibes linktr.ee/tr33h	\N	\N	\N	\N
f17cd6aa-c463-4251-b5bd-f0d955581b73	Lorenzo	lorenzotyner@icloud.com	Artist	Singer/songwriter looking for licensing representation 	\N	Tyner
3fab9ca4-9ecc-4c73-85eb-d62a490dc94c	Hieu Vu	star.hieu.5500@gmail.com	Artist	Just do it	\N	Hoang
daf3d0a5-b702-4165-ac00-f47a90f4f801	Duncan	duncan8donut@gmail.com	Artist	I want to remove a song I submitted titled "ANGRY" I need to get everyones publishing ID and writing ID\n	Hi Duncan,\n\nThanks for notifying us. We've removed the song "Angry." Do you plan to re-upload it and submit it again?\n\nThanks,\nTeam at Ktizo	Davis
0703992c-0642-4578-aa62-7684a75e3919	asdsad	asdasas@asdas.com	Supervisor	adsa	\N	asdas	asdad	5
7ecb66ac-d077-4332-b714-cfb01392e23b	asdsad	asdasas@asdas.com	Supervisor	adsa	\N	asdas	asdad	5
5c8ff7ed-5493-4482-ae40-673157bb1f25	asdsad	asdasas@asdas.com	Supervisor	adsa	\N	asdas	asdad	5
9d996df4-766f-41c9-9632-0da707ddeb44	asdasd	asdasd@gasda.com	Artist	asdaa	\N	asdasd
081102c2-7a1c-40e9-bfc9-570f631a0fbc	13132	adasd@asda.com	Artist	adasda	\N	31231
d2c8bac6-fc61-44fd-931a-689de8e14bac	asda	zavada.nazar@gmail.com	Artist	asda	\N	adsad
78b14d31-32b9-4ddd-9297-c5f7dd7a4839	asdasd	zavada.nazar@gmail.com	Artist	adads	\N	asdasd
\.


--
-- Data for Name: count_likes; Type: TABLE DATA; Schema: public; Owner: ktizo
--

COPY public.count_likes (id, song_id, action, sync) FROM stdin;
f5a465d3-99e6-4443-ab18-0511884c4247	4cfa75c6-e1ed-4394-bd84-8f8ae049c207	[{"like": "True", "dislike": "False", "user_id": "6906c7df-8e12-46b1-bfec-9e473f1022f0"}]	\N
593e3f11-57b0-4502-9d70-09c940458407	5d474098-f4f7-4d4e-ba37-3b9a97ffbc07	[{"like": "True", "dislike": "False", "user_id": "6906c7df-8e12-46b1-bfec-9e473f1022f0"}]	\N
ca23cda1-2c35-4b7c-844b-8a3deec6df66	a6b17501-af77-4c1d-aa95-ba539565f760	[{"like": "True", "dislike": "False", "user_id": "6906c7df-8e12-46b1-bfec-9e473f1022f0"}]	\N
4ba423d4-cf4b-4d88-9d11-03cc0196f0b8	821d34ee-9eb3-4274-be8b-b6695d82935d	[{"like": "True", "dislike": "False", "user_id": "6906c7df-8e12-46b1-bfec-9e473f1022f0"}]	\N
af9c8c27-9a03-4bc0-990b-fbe43a0f3667	b220f19e-3ea5-4e60-be6f-6575fce35189	[{"like": "True", "dislike": "False", "user_id": "6906c7df-8e12-46b1-bfec-9e473f1022f0"}]	\N
52fa40d3-b281-4e52-baf9-9beeab3ae0ad	43ae3340-d36f-4b84-ae70-c9c117432d7f	[{"like": "True", "dislike": "False", "user_id": "6906c7df-8e12-46b1-bfec-9e473f1022f0"}]	\N
a48474d2-3365-405c-ae3e-622c135cff9d	ada103db-5b4a-486c-af75-295a0bf0925b	[{"like": "True", "dislike": "False", "user_id": "6906c7df-8e12-46b1-bfec-9e473f1022f0"}]	\N
6385b69d-056a-4aa4-bec4-47abc0889c27	a5df2da4-2eb9-4631-acb9-8cbfa49bedf8	[{"like": "True", "dislike": "False", "user_id": "d8f4e48a-8cc6-42a8-acf7-03006b2f57a6"}, {"like": "True", "dislike": "False", "user_id": "6906c7df-8e12-46b1-bfec-9e473f1022f0"}]	\N
f5be2447-7175-42d4-806f-3ef3eb25639f	5361ce8c-be44-4fb0-a501-b7f86563c0bb	[{"like": "True", "dislike": "False", "user_id": "6906c7df-8e12-46b1-bfec-9e473f1022f0"}, {"like": "True", "dislike": "False", "user_id": "ce8ee1fa-bd89-4d00-9d99-b3a9fe69fb2a"}]	\N
\.


--
-- Data for Name: email_details; Type: TABLE DATA; Schema: public; Owner: ktizo
--

COPY public.email_details (id, full_name, email, user_role) FROM stdin;
b5efb068-0599-4637-b13d-efe93b459e42	Colby Kline	colbykline@gmail.com	Artist
9f7521a0-f08b-42eb-bb05-6f1819dafb28	Christine Black-Reimel	christine.reimel@nfl.com	Supervisor
8ba1931b-126c-401d-8617-40a884f49006	Destini Stacy	DESTINI.STACY@GMAIL.COM	Artist
1b70aa32-4f2f-4866-ab35-8e1775ae31c1	Kal	mymusicandmyguitar@gmail.com	Artist
a0859535-806c-4639-b4da-865a0c5a743e	Lorine Chia	bookinglorinechia@gmail.com	Artist
9c1a79a0-ed36-4905-9531-fd33cc8e128b	Kendric D Davis	kd.1220.davis@gmail.com	Artist
fb11e924-ef76-4bab-988c-94f6502b2cd8	Nemiahya Crockett 	zaddiemac19@gmail.com	Artist
827fed1c-f82a-45b5-904d-9dd62ec27cb1	Juliano Hodges 	Julianohodges6@gmail.com	Artist
e995cd7c-e047-4644-9c23-c8fa20f27029	james carter	jayfunkrecordz@gmail.com	Supervisor
6b17ec34-0d62-4f5a-a0a1-83250af94deb	Melvin Smith	melvinsmithms1i@gmail.com	Artist
85f815d0-004e-4143-ac1e-177def48a5f9	Smartkidjonzing	olusojifunshy@gmail.com	Artist
cefcd3cd-e8a8-4e7c-a3d9-02b866536b46	Twizi Aka Bars	Tr3yn9ne39@gmail.com	Artist
4cec7af9-bdba-429b-8a45-e76a1e1f827f	Kalarav Patel	crasherkp@gmail.com	Supervisor
29195918-9d7e-45e6-8dea-2c998a8e64d9	Itz Syfour Cyclop	itzsyfourbookings@gmail.com	Artist
52b6741d-57ed-4f66-b5b4-7f86b00ff360	Boby Mic	onyaditsweboby@gmail.com	Artist
513a93cf-5e43-4d77-ac6d-ed77ad64ad8d	Mark fairgroundz	markfisher4500@gmail.com	Artist
41efb9d7-ba5f-4f53-833d-c0da4bd5633d	Yung keli	mtalabunakamula@gmail.com	Artist
4a9c2a1b-3b7d-4256-9999-1a75b25b1f2c	L's World	larry1drumwright@gmail.com	Artist
f23f4a6e-0e7c-463e-821d-8d34e828df0a	Man Dj (Convert)	mandjconvert@gmail.com	Artist
e2dd7ae7-608b-47a8-822c-c110b2d8ffd2	Pn Jetmud	princenjetmud@gmail.com	Artist
56e4d847-5ac9-4983-9f29-c1a82fc46b7b	JACOBI JOHNSON	youngk314booking@gmail.com	Artist
69084277-be2a-4cf6-8694-996d86d8511b	NIAL THE ARTIST	currenw@icloud.com	Artist
74fa50dd-7e84-4455-8682-4e82a971b7c8	Darryl Clark	producerdc@gmail.com	Artist
ecd4edf7-ab4c-443a-8235-b1a7096d686c	Miss Lyric	misslyric01@gmail.com	Artist
9d9ca881-8e37-48a8-9703-f5f4cdb4f31b	Jarrett Jordon-Thompson	tatortotmusicbusiness@gmail.com	Artist
d8660ba0-a321-46ad-95ef-62453d4c6217	Billy Yfantis	Byfantis@yahoo.com	Artist
633dbf06-66b7-4473-a708-ae7c4a478e4d	Joséphine Tehrani	josephinemusicofficial@gmail.com	Artist
ef35e9a3-e813-464a-9de8-ba3786a02c6e	Lawford Campbell	Mentalkryptonite@gmail.com	Artist
e094b49b-2c4b-406a-a702-7e9509159f66	A7 Recording Studio	a7recordingstudio@gmail.com	Artist
7c5597ec-ec3b-48b3-a891-c6541922336b	Mike Sb	itsmikesb@gmail.com	Artist
2ba2f9ac-c8e7-47a9-8b2a-c83a10303477	Deandre	dravenofficialrvm@gmail.com	Artist
a03a4407-7d40-428a-a493-2779864ce233	Adhurim svirca 	admmirkola@gmail.com	Artist
36f9cf9d-67fc-4dd8-b4fa-c18106e15ebd	Adhurim svirca 	sosa91c@icloud.com	Artist
6503afa5-0026-40db-83dc-79f5275341a8	Tyfas III	tyfasiii@gmail.com	Artist
2da63140-6d0e-4c98-ba7d-0206123e1430	Ches	janiraches@gmail.com	Artist
8834220a-cdce-4e90-9dac-87838859eae5	El viper 	umumethode222@gmail.com	Artist
ce8ed903-b546-40e5-a566-a384ba0182a8	Vincent Shidumo	mrthabanglebese@gmail.com	Artist
457d6de7-e89b-4ccc-8c8c-08a58171e46d	Willie Waters	williewaters.dbd@gmail.com	Artist
b7f6faf0-bc07-41ab-849e-f0bc7bb7e8fc	Van-Adam Pierre	kiddadamzmgmt@gmail.com	Artist
2983238a-6d2b-40dc-9404-82d1cf6dd7c3	Destin Flemming	tazent1804@gmail.com	Artist
3f339d6c-43d8-42d3-8ef9-297f630178ab	Khiy The Musician	khiythemusician@gmail.com	Artist
836d8fbb-878d-4f88-9a55-d19cfccf7238	LaWanda Lee	lawandalee@gmail.com	Artist
bf82101e-8bcf-4436-8f31-e9ca1b997852	Cillion	cilliondalion@gmail.com	Artist
74f30615-509f-4850-a827-0791eac18762	namestage6	namestage6@gmail.com	Artist
611a76b8-cbde-482d-bf30-94ed6428d7d6	Kid YM 	Kidym13@gmail.com	Artist
06e2a3fc-724a-4012-879f-baa1ca7822ab	Hamisi Abel	hemyparis97@gmail.com	Artist
ba789f44-7521-45d6-949b-311c6503b7de	PrinceO Worldwide	princeoye11@gmail.com	Artist
bb2ffda3-6312-48be-b9dd-b0731e758392	Treontae huntley	Treontaehuntley@gmail.com	Artist
8f023e8a-bec8-4b65-914d-391e6cf5fd37	Tonderai The Dogon 	tonderaithedogon@gmail.com	Artist
cd54a8f4-91c4-4861-94c1-c4bca2bb3f3f	De Great	degreatchukwuemeka9@gmail.com	Artist
6531a445-a737-4cce-9c41-6ac15f2bc8c5	Lyvonte Byrd	gtrsouth@gmail.com	Supervisor
7814d369-49b3-47df-a3b8-fc9d7957cf62	Patrick Sabdo 	patricksabdo@gmail.com	Artist
fab28259-3eb9-412c-ae84-cd25d7096d8f	Redd Bricks	realreddbricks@gmail.com	Artist
dc905cbe-c01a-4611-b3b0-1bee8174d7e0	Lorenzo 	lorenzotyner81@gmail.com	Artist
7929335d-39c9-46a9-b517-4a0614fcfeca	Naten Jones 	mpgtrillfam41@gmail.com	Artist
1c126d62-90f5-4030-88fa-8acb254cc3c0	Terrell Fure'	terrellfuremusic@gmail.com	Artist
43a6b281-750d-4240-a1b7-0e56c3490ba2	naten  jones	pgtrillfam41@gmail.com	Artist
c43f030b-fe52-42b5-9a38-6737c9d7b569	Omar Just	omarjustmusic@gmail.com	Artist
186f55aa-619a-4bae-9a2c-e0a50189a536	Jmello 	MelloWorldEntertainment@gmail.com	Supervisor
ab94bf65-fe34-4d7e-8048-708edd17cec3	Cory Rucker	segathephoenixmusic@gmail.com	Artist
90b60424-4c96-452d-b2a8-b2468cb4f1d0	RICO BEE	Rizzybell.rb@gmail.com	Artist
8fbebeb4-b17d-46e9-869a-60ef08ddd1e7	Raja	rickykhan377@gmail.com	Artist
c83957bf-d26b-44c9-aa15-7b1cad06d33a	Vincent Horsu	vincentkgameli@gmail.com	Artist
06900821-44bf-4ed1-83da-9594d749e18f	Tony A Phiri	phiritonya6@gmail.com	Artist
db7848b2-85a8-4271-806f-b73c266ff25b	Kappy	kappyofficial8@gmail.com	Supervisor
517f62a2-2ae9-4f50-b140-d7c945bc11c9	Black Ends	blackendsmusic@gmail.com	Artist
711f2b95-ba97-4562-b781-c7732d8eaa68	Lawrence Paul 	emceelp@gmail.com	Artist
cb46cf4f-e598-4bad-b6b1-d7e250831f2a	Odin Mevissen	odinmsmusic@gmail.com	Artist
e80b52fd-99f3-4f14-bd07-61911259737e	FamousKwa	kwaveoutlaw13@gmail.com	Artist
ba3ecd7b-077b-490a-87cd-21b9b1c959eb	leroy aka lbee 	ondalookout98@gmail.com	Artist
45c70ac9-e949-4aaf-b0ce-4441301de734	Tesfa Ferris	tesillasipher1@gmail.com	Artist
2c6ccdc8-0647-4ff4-8fd9-e95f0ffe8643	Jerrystarka	therealjerrystarka@gmail.com	Artist
6346c230-752e-495d-979a-a77d0088e1de	YoungNRich	youngnrichbookings@gmail.com	Artist
6fc38a5f-a7c9-4cba-bc3f-bce1db36552d	YoungNRich	youngnrichbooking@gmail.com	Artist
8bb2c792-3f7a-4762-8d19-b6a9a3754e91	Chiblizy 	chiblisy@gmail.com	Artist
2026199a-6d8b-4303-82c4-f320179d0776	Stobe	stobe17booking@gmail.com	Artist
d9b84a7e-eb6f-4825-b518-7c136fca4e0a	Instrumental Icons	instrumentalicons@gmail.com	Artist
b8f20e47-a054-45a8-a27b-cf6d726da8d2	Fabo PGE	fabopge@gmail.com	Artist
499f0ff3-0c86-4678-ae5b-2c080c91152e	Laren Robinson	ndl.numbersdontlie@gmail.com	Artist
554ed898-640b-46ee-bbec-b1d45710eec4	Treeh	treehhaus@gmail.com	Artist
7b9355e3-d570-405e-9ba2-2f9617de87a0	Arren nunn	arrennunn1@gmail.com	Artist
0301f40a-c722-4c34-973b-a9f04a1ffb38	Leonardo White	leorasoul94@gmail.com	Artist
3c85abd9-fbf6-460b-8af8-11f6bb049450	nahvi	nahvimusicpromo@gmail.com	Artist
53b97a20-ae1b-41d1-ab4b-5a2060ceb4fb	Regg	volumetv@gmail.com	Artist
56f945dd-3cd9-4eac-9bb8-8c1920733103	Lewis Peterson	illbdemtunes@gmail.com	Artist
902d98bb-837d-46fc-aa3a-bc3ab4774788	Terry Rankins	trriimusic@gmail.com	Artist
23367c9a-2e20-429f-ad84-82eba95c7ecb	BroTex Williams 	brotexworld@gmail.com	Artist
1c36eae4-06a4-4ecc-959e-268edfb5b897	Rahab Mcneish	RahabMC95@hotmail.com	Artist
770f036a-2229-44d4-9b05-b4bbb2b7247d	Mr. Colella Maurizio	mcolella@sirupmusic.com	Supervisor
987af8bb-11d3-47e5-9efe-da6047bc5050	Will Jones	souwerecordings@gmail.com	Supervisor
9b064fa4-3944-4d33-bbfe-18d7f8253e6d	Eugene-Andrew Sarmiento	geohworks@gmail.com	Artist
df74fa39-d536-4a8d-8fcf-12f4bb4b449b	Panama  Fargo	fargopanama@gmail.com	Artist
8bcffd11-ad05-4039-a3b8-6e201f974f2a	Zack Vaca	knucklez66music@gmail.com	Artist
0f18b1a5-3b9a-488c-92db-f88efd06bd64	Tory HARRELSON	flossy007@gmail.com	Artist
a16f9151-c47b-401a-b4af-d54222949263	Aron Levi	myth.wav@gmail.com	Artist
bbf2ebdb-594c-4440-b61b-d39ab8cfe93c	Lawrence chico taylor	chicotaylor8234@gmail.com	Artist
c57e5d78-5925-42ce-8fd0-dd5aa2c6d2e8	Temple	officialtemple1@gmail.com	Artist
5bf74a9b-04be-47f0-a2e7-35376cca83bf	kelly Nwachukwu	justtoosmooth@icloud.com	Artist
88b500e5-942e-4f26-9c59-845907b2486b	Weas Genius	weasgenius@gmail.com	Artist
4363fa42-8b50-4f98-a10e-647ff6d45aa5	Antoine Thompson	megaton6342@gmail.com	Artist
6b691ac2-682a-403b-b1d8-eb5a04a1a326	Sogo Ogunyemi 	Sogoonplugged@gmail.com	Artist
13e4e703-9f96-48d8-aa41-2994ccb9ca4e	Arlington Taylor	arlingtontaylormusic@gmail.com	Artist
59a3faf0-022d-44f9-9378-faa45324f58f	Crusbeatz 	crusbeatz@gmail.com	Artist
60104c8c-293e-42fd-8345-55f2d667ac1c	Jarrett Jordon-Thompson	tatortotakamrjjt@gmail.com	Artist
e0473fd0-bd8f-4da2-bc7e-14e94a8d1688	Dope Swope	swopeworks@gmail.com	Artist
5900e218-56c4-4b64-9dca-54819626dab9	Anthony Caceres	tonyfromdachi23@gmail.com	Artist
024ade03-2db6-4e4a-b84d-4102bf97cd25	dolltr!ck	dolltrickteam@gmail.com	Artist
bf0d95af-054a-4838-9d0f-1572ce17eb03	jacarr goodmand	carbanga@gmail.com	Artist
\.


--
-- Data for Name: feedback; Type: TABLE DATA; Schema: public; Owner: ktizo
--

COPY public.feedback (id, user_id, easyto_understand, songs_satisfaction, easyto_navigate, licensing_effective, improve_ideas) FROM stdin;
d4b41d1d-c3a4-49de-ba83-f375ef1b0a1f	60d34088-3b0e-443a-b931-732951a50e3c	2.5	3	3	2.5	Accuracy
\.


--
-- Data for Name: invoice; Type: TABLE DATA; Schema: public; Owner: ktizo
--

COPY public.invoice (id, supervisor_id, song_id, "Licence_id", date) FROM stdin;
2	d8f4e48a-8cc6-42a8-acf7-03006b2f57a6	a5df2da4-2eb9-4631-acb9-8cbfa49bedf8	6385b69d-056a-4aa4-bec4-47abc0889c27	2022-07-01
3	6906c7df-8e12-46b1-bfec-9e473f1022f0	4cfa75c6-e1ed-4394-bd84-8f8ae049c207	f5a465d3-99e6-4443-ab18-0511884c4247	2022-07-01
4	6906c7df-8e12-46b1-bfec-9e473f1022f0	5d474098-f4f7-4d4e-ba37-3b9a97ffbc07	593e3f11-57b0-4502-9d70-09c940458407	2022-07-01
5	6906c7df-8e12-46b1-bfec-9e473f1022f0	a6b17501-af77-4c1d-aa95-ba539565f760	ca23cda1-2c35-4b7c-844b-8a3deec6df66	2022-07-04
6	6906c7df-8e12-46b1-bfec-9e473f1022f0	821d34ee-9eb3-4274-be8b-b6695d82935d	4ba423d4-cf4b-4d88-9d11-03cc0196f0b8	2022-07-04
7	6906c7df-8e12-46b1-bfec-9e473f1022f0	b220f19e-3ea5-4e60-be6f-6575fce35189	af9c8c27-9a03-4bc0-990b-fbe43a0f3667	2022-07-04
8	6906c7df-8e12-46b1-bfec-9e473f1022f0	43ae3340-d36f-4b84-ae70-c9c117432d7f	52fa40d3-b281-4e52-baf9-9beeab3ae0ad	2022-07-04
9	6906c7df-8e12-46b1-bfec-9e473f1022f0	5361ce8c-be44-4fb0-a501-b7f86563c0bb	f5be2447-7175-42d4-806f-3ef3eb25639f	2022-07-04
10	6906c7df-8e12-46b1-bfec-9e473f1022f0	a5df2da4-2eb9-4631-acb9-8cbfa49bedf8	34fc7ca0-8b7d-47ad-a299-7c58f3445cbe	2022-07-05
11	6906c7df-8e12-46b1-bfec-9e473f1022f0	ada103db-5b4a-486c-af75-295a0bf0925b	a48474d2-3365-405c-ae3e-622c135cff9d	2022-07-05
12	ce8ee1fa-bd89-4d00-9d99-b3a9fe69fb2a	5361ce8c-be44-4fb0-a501-b7f86563c0bb	8441d886-4a01-4b19-a9ef-fb163b3249df	2022-07-25
13	ce8ee1fa-bd89-4d00-9d99-b3a9fe69fb2a	5361ce8c-be44-4fb0-a501-b7f86563c0bb	8441d886-4a01-4b19-a9ef-fb163b3249df	2022-07-25
\.


--
-- Data for Name: licence; Type: TABLE DATA; Schema: public; Owner: ktizo
--

COPY public.licence (id, user_id, song_id, date, email, "to", master_recording, written_by, published_by, performed_by, label, tv_show, show_description, use, onetime_fee, direct_performancefee, master_licencefee, sync_licencefee, performance_fee, reached_at, reachedat_email, status, approved_date, search_artistid, search_trackid, licensor, producer) FROM stdin;
a48474d2-3365-405c-ae3e-622c135cff9d	6906c7df-8e12-46b1-bfec-9e473f1022f0	ada103db-5b4a-486c-af75-295a0bf0925b	2022-07-05	testxminds@xminds.com	Test-Xminds	A Little More (feat. Kiana Ledé)	["test"]	["test"]	Test-Xminds	A Little More (feat. Kiana Ledé)	short film	test	test	100	100	0	0	0	1234567890	test@gmail.com	1	2022-07-05			[{"licensor_by": "Test artist", "licensor_its": "", "licensor_name": ""}]	[{"producer_by": "Test supervisor", "producer_its": "", "producer_name": ""}]
6385b69d-056a-4aa4-bec4-47abc0889c27	d8f4e48a-8cc6-42a8-acf7-03006b2f57a6	a5df2da4-2eb9-4631-acb9-8cbfa49bedf8	2022-07-01	testxminds@xminds.com	Test-Xminds	10 Toes	["test"]	["Rahman"]	Test-Xminds	10 Toes	short film	test	test	100	100	0	0	0	8848154598	anandhu.anil@xminds.com	1	2022-07-01			[{"licensor_by": "Anandu", "licensor_its": "", "licensor_name": ""}]	[{"producer_by": "Xminds", "producer_its": "", "producer_name": ""}]
f5a465d3-99e6-4443-ab18-0511884c4247	6906c7df-8e12-46b1-bfec-9e473f1022f0	4cfa75c6-e1ed-4394-bd84-8f8ae049c207	2022-07-01	renjithr@xminds.com	Test Xminds	Bay 101	["Test-1", "Test-2"]	["Renjith"]	Test Xminds	Bay 101	Test-Show	Test data from Xminds development team	For testing purposes	50	100	0	0	0	9074645393	renjithaim05@gmail.com	1	2022-07-01			[{"licensor_by": "QA-Xminds", "licensor_its": "", "licensor_name": ""}]	[{"producer_by": "QA-1-Xminds", "producer_its": "", "producer_name": ""}]
593e3f11-57b0-4502-9d70-09c940458407	6906c7df-8e12-46b1-bfec-9e473f1022f0	5d474098-f4f7-4d4e-ba37-3b9a97ffbc07	2022-07-01	renjithr@xminds.com	Test Xminds	Paradise	["Test-1"]	["Test-2"]	Test Xminds	Paradise	Test TV show	Xminds development test	Xminds development test	50	100	0	0	0	9074645393	renjithr@xminds.com	1	2022-07-01			[{"licensor_by": "QA-Xminds", "licensor_its": "", "licensor_name": ""}]	[{"producer_by": "QA-1-Xminds", "producer_its": "", "producer_name": ""}]
ca23cda1-2c35-4b7c-844b-8a3deec6df66	6906c7df-8e12-46b1-bfec-9e473f1022f0	a6b17501-af77-4c1d-aa95-ba539565f760	2022-07-04	testxminds@xminds.com	Test-Xminds	A Little More (feat. Kiana Ledé)	["writer1"]	["user2"]	Test-Xminds	A Little More (feat. Kiana Ledé)	test	test	test	100	100	0	0	0	1234567890	company@gmail.com	1	2022-07-04			[{"licensor_by": "Test-Xminds", "licensor_its": "", "licensor_name": ""}]	[{"producer_by": " Test-Supervisor-Xminds", "producer_its": "", "producer_name": ""}]
4ba423d4-cf4b-4d88-9d11-03cc0196f0b8	6906c7df-8e12-46b1-bfec-9e473f1022f0	821d34ee-9eb3-4274-be8b-b6695d82935d	2022-07-04	testxminds@xminds.com	Test-Xminds	A Very Strange Time	["writer1"]	["user2"]	Test-Xminds	A Very Strange Time	test	test	test	150	150	0	0	0	1234567890	company@gmail.com	1	2022-07-04			[{"licensor_by": "Test-Xminds", "licensor_its": "", "licensor_name": ""}]	[{"producer_by": " Test-Supervisor-Xminds", "producer_its": "", "producer_name": ""}]
af9c8c27-9a03-4bc0-990b-fbe43a0f3667	6906c7df-8e12-46b1-bfec-9e473f1022f0	b220f19e-3ea5-4e60-be6f-6575fce35189	2022-07-04	testxminds@xminds.com	Test-Xminds	Almost Famous	["writer1"]	["user2"]	Test-Xminds	Almost Famous	test	test	test	50	50	0	0	0	1234567890	company@gmail.com	1	2022-07-04			[{"licensor_by": "Test-Xminds", "licensor_its": "", "licensor_name": ""}]	[{"producer_by": " Test-Supervisor-Xminds", "producer_its": "", "producer_name": ""}]
52fa40d3-b281-4e52-baf9-9beeab3ae0ad	6906c7df-8e12-46b1-bfec-9e473f1022f0	43ae3340-d36f-4b84-ae70-c9c117432d7f	2022-07-04	testxminds@xminds.com	Test-Xminds	Angel	["writer1"]	["user2"]	Test-Xminds	Angel	test	test	test	100	100	0	0	0	1234567890	company@gmail.com	1	2022-07-04			[{"licensor_by": "Test-Xminds", "licensor_its": "", "licensor_name": ""}]	[{"producer_by": "", "producer_its": "", "producer_name": ""}]
f5be2447-7175-42d4-806f-3ef3eb25639f	6906c7df-8e12-46b1-bfec-9e473f1022f0	5361ce8c-be44-4fb0-a501-b7f86563c0bb	2022-07-04	testxminds@xminds.com	Test-Xminds	All Facts (feat. Ty Dolla $ign)	["Test"]	["Test"]	Test-Xminds	All Facts (feat. Ty Dolla $ign)	test	test	test	50	50	0	0	0	1234567890	company@gmail.com	1	2022-07-04			[{"licensor_by": "Test-Xminds", "licensor_its": "", "licensor_name": ""}]	[{"producer_by": " Test-Supervisor-Xminds", "producer_its": "", "producer_name": ""}]
34fc7ca0-8b7d-47ad-a299-7c58f3445cbe	6906c7df-8e12-46b1-bfec-9e473f1022f0	a5df2da4-2eb9-4631-acb9-8cbfa49bedf8	2022-07-05	testxminds@xminds.com	Test-Xminds	10 Toes	["test"]	["Rahman"]	Test-Xminds	10 Toes	short film	test	test	100	100	0	0	0	1234567890	user@gmail.com	1	2022-07-05			[{"licensor_by": "Anandu", "licensor_its": "", "licensor_name": ""}]	[{"producer_by": "Anandu", "producer_its": "", "producer_name": ""}]
8441d886-4a01-4b19-a9ef-fb163b3249df	ce8ee1fa-bd89-4d00-9d99-b3a9fe69fb2a	5361ce8c-be44-4fb0-a501-b7f86563c0bb	2022-07-25	testxminds@xminds.com	Test-Xminds	All Facts (feat. Ty Dolla $ign)	["Test"]	["Test"]	Test-Xminds	All Facts (feat. Ty Dolla $ign)	short film	test	test	50	50	0	0	0	1234567890	test@gmail.com	1	2022-07-25			[{"licensor_by": "Test Xminds", "licensor_its": "", "licensor_name": ""}]	[{"producer_by": "Test supervisor", "producer_its": "", "producer_name": ""}]
8441d886-4a01-4b19-a9ef-fb163b324941	0cd24b0d-2c87-44e7-b991-33317f83ace6	ada103db-5b4a-486c-af75-295a0bf0925b	2022-07-05	testxminds@xminds.com	Test-Xminds	A Little More (feat. Kiana Ledé)	["test"]	["test"]	Test-Xminds	A Little More (feat. Kiana Ledé)	short film	test	test	100	100	0	0	0	1234567890	test@gmail.com	1	2022-07-05			[{"licensor_by": "Test artist", "licensor_its": "", "licensor_name": ""}]	[{"producer_by": "Test supervisor", "producer_its": "", "producer_name": ""}]
8441d886-4a01-4b19-a9ef-fb163b324942	0cd24b0d-2c87-44e7-b991-33317f83ace6	a5df2da4-2eb9-4631-acb9-8cbfa49bedf8	2022-07-01	testxminds@xminds.com	Test-Xminds	10 Toes	["test"]	["Rahman"]	Test-Xminds	10 Toes	short film	test	test	100	100	0	0	0	8848154598	anandhu.anil@xminds.com	1	2022-07-01			[{"licensor_by": "Anandu", "licensor_its": "", "licensor_name": ""}]	[{"producer_by": "Xminds", "producer_its": "", "producer_name": ""}]
8441d886-4a01-4b19-a9ef-fb163b324943	0cd24b0d-2c87-44e7-b991-33317f83ace6	4cfa75c6-e1ed-4394-bd84-8f8ae049c207	2022-07-01	renjithr@xminds.com	Test Xminds	Bay 101	["Test-1", "Test-2"]	["Renjith"]	Test Xminds	Bay 101	Test-Show	Test data from Xminds development team	For testing purposes	50	100	0	0	0	9074645393	renjithaim05@gmail.com	1	2022-07-01			[{"licensor_by": "QA-Xminds", "licensor_its": "", "licensor_name": ""}]	[{"producer_by": "QA-1-Xminds", "producer_its": "", "producer_name": ""}]
8441d886-4a01-4b19-a9ef-fb163b324944	0cd24b0d-2c87-44e7-b991-33317f83ace6	5d474098-f4f7-4d4e-ba37-3b9a97ffbc07	2022-07-01	renjithr@xminds.com	Test Xminds	Paradise	["Test-1"]	["Test-2"]	Test Xminds	Paradise	Test TV show	Xminds development test	Xminds development test	50	100	0	0	0	9074645393	renjithr@xminds.com	1	2022-07-01			[{"licensor_by": "QA-Xminds", "licensor_its": "", "licensor_name": ""}]	[{"producer_by": "QA-1-Xminds", "producer_its": "", "producer_name": ""}]
8441d886-4a01-4b19-a9ef-fb163b324945	0cd24b0d-2c87-44e7-b991-33317f83ace6	a6b17501-af77-4c1d-aa95-ba539565f760	2022-07-04	testxminds@xminds.com	Test-Xminds	A Little More (feat. Kiana Ledé)	["writer1"]	["user2"]	Test-Xminds	A Little More (feat. Kiana Ledé)	test	test	test	100	100	0	0	0	1234567890	company@gmail.com	1	2022-07-04			[{"licensor_by": "Test-Xminds", "licensor_its": "", "licensor_name": ""}]	[{"producer_by": " Test-Supervisor-Xminds", "producer_its": "", "producer_name": ""}]
8441d886-4a01-4b19-a9ef-fb163b324946	0cd24b0d-2c87-44e7-b991-33317f83ace6	821d34ee-9eb3-4274-be8b-b6695d82935d	2022-07-04	testxminds@xminds.com	Test-Xminds	A Very Strange Time	["writer1"]	["user2"]	Test-Xminds	A Very Strange Time	test	test	test	150	150	0	0	0	1234567890	company@gmail.com	1	2022-07-04			[{"licensor_by": "Test-Xminds", "licensor_its": "", "licensor_name": ""}]	[{"producer_by": " Test-Supervisor-Xminds", "producer_its": "", "producer_name": ""}]
8441d886-4a01-4b19-a9ef-fb163b324947	0cd24b0d-2c87-44e7-b991-33317f83ace6	b220f19e-3ea5-4e60-be6f-6575fce35189	2022-07-04	testxminds@xminds.com	Test-Xminds	Almost Famous	["writer1"]	["user2"]	Test-Xminds	Almost Famous	test	test	test	50	50	0	0	0	1234567890	company@gmail.com	1	2022-07-04			[{"licensor_by": "Test-Xminds", "licensor_its": "", "licensor_name": ""}]	[{"producer_by": " Test-Supervisor-Xminds", "producer_its": "", "producer_name": ""}]
8441d886-4a01-4b19-a9ef-fb163b324948	0cd24b0d-2c87-44e7-b991-33317f83ace6	43ae3340-d36f-4b84-ae70-c9c117432d7f	2022-07-04	testxminds@xminds.com	Test-Xminds	Angel	["writer1"]	["user2"]	Test-Xminds	Angel	test	test	test	100	100	0	0	0	1234567890	company@gmail.com	1	2022-07-04			[{"licensor_by": "Test-Xminds", "licensor_its": "", "licensor_name": ""}]	[{"producer_by": "", "producer_its": "", "producer_name": ""}]
8441d886-4a01-4b19-a9ef-fb163b324949	0cd24b0d-2c87-44e7-b991-33317f83ace6	5361ce8c-be44-4fb0-a501-b7f86563c0bb	2022-07-04	testxminds@xminds.com	Test-Xminds	All Facts (feat. Ty Dolla $ign)	["Test"]	["Test"]	Test-Xminds	All Facts (feat. Ty Dolla $ign)	test	test	test	50	50	0	0	0	1234567890	company@gmail.com	1	2022-07-04			[{"licensor_by": "Test-Xminds", "licensor_its": "", "licensor_name": ""}]	[{"producer_by": " Test-Supervisor-Xminds", "producer_its": "", "producer_name": ""}]
8441d886-4a01-4b19-a9ef-fb163b324950	0cd24b0d-2c87-44e7-b991-33317f83ace6	a5df2da4-2eb9-4631-acb9-8cbfa49bedf8	2022-07-05	testxminds@xminds.com	Test-Xminds	10 Toes	["test"]	["Rahman"]	Test-Xminds	10 Toes	short film	test	test	100	100	0	0	0	1234567890	user@gmail.com	1	2022-07-05			[{"licensor_by": "Anandu", "licensor_its": "", "licensor_name": ""}]	[{"producer_by": "Anandu", "producer_its": "", "producer_name": ""}]
8441d886-4a01-4b19-a9ef-fb163b324951	0cd24b0d-2c87-44e7-b991-33317f83ace6	5361ce8c-be44-4fb0-a501-b7f86563c0bb	2022-07-25	testxminds@xminds.com	Test-Xminds	All Facts (feat. Ty Dolla $ign)	["Test"]	["Test"]	Test-Xminds	All Facts (feat. Ty Dolla $ign)	short film	test	test	50	50	0	0	0	1234567890	test@gmail.com	1	2022-07-25			[{"licensor_by": "Test Xminds", "licensor_its": "", "licensor_name": ""}]	[{"producer_by": "Test supervisor", "producer_its": "", "producer_name": ""}]
8441d886-4a01-4b19-a9ef-fb163b324952	0cd24b0d-2c87-44e7-b991-33317f83ace6	86c09172-eb34-45f6-8b4f-50bbf68f64f1	2022-07-25	testxminds@xminds.com	Test-Xminds	All Facts (feat. Ty Dolla $ign)	["Test"]	["Test"]	Test-Xminds	All Facts (feat. Ty Dolla $ign)	short film	test	test	50	50	0	0	0	1234567890	test@gmail.com	1	2022-07-25			[{"licensor_by": "Test Xminds", "licensor_its": "", "licensor_name": ""}]	[{"producer_by": "Test supervisor", "producer_its": "", "producer_name": ""}]
\.


--
-- Data for Name: my_earnings; Type: TABLE DATA; Schema: public; Owner: ktizo
--

COPY public.my_earnings (id, artist_id, invoice_id, artist_name, total_amount, balance_amount, withdraw_amount, invoice_number, date) FROM stdin;
93f92754-b413-49d3-829e-aee3ce483235	0e16ac26-f71b-4188-b3fa-dd40afe5b3b1	\N	Test Xminds	112	\N	\N	4	2022-07-04
cddf896e-0e17-4d7e-ad2f-e527a9f2de7b	2491764d-dd64-417d-9704-51a085fd6c83	\N	Test-Xminds	225	\N	\N	6	2022-07-04
4b2ed56a-dae5-4618-85cd-f09d55fa919a	2491764d-dd64-417d-9704-51a085fd6c83	\N	Test-Xminds	150	\N	\N	5	2022-07-04
7f56e0ad-b8e7-47b5-9d40-2a944b8cec82	2491764d-dd64-417d-9704-51a085fd6c83	\N	Test-Xminds	75	\N	\N	7	2022-07-04
4d657c68-bf11-4bd9-8986-26bee29a69c8	2491764d-dd64-417d-9704-51a085fd6c83	\N	Test-Xminds	150	\N	\N	5	2022-07-04
60d8fd25-239d-4561-8d50-8d2db749f5fd	2491764d-dd64-417d-9704-51a085fd6c83	\N	Test-Xminds	150	\N	\N	8	2022-07-04
59b4621e-e744-4c89-9cd5-6c9bf7ad9678	2491764d-dd64-417d-9704-51a085fd6c83	\N	Test-Xminds	150	\N	\N	8	2022-07-04
59b4621e-e744-4c89-9cd5-6c9bf7ad9652	0cd24b0d-2c87-44e7-b991-33317f83ace6	1234	Dev Ktizovych	112	123	41	21	2022-07-04
59b4621e-e744-4c89-9cd5-6c9bf7ad9658	0cd24b0d-2c87-44e7-b991-33317f83ace6	213213	Dev Ktizovych	150	129	47	27	2022-07-04
59b4621e-e744-4c89-9cd5-6c9bf7ad9655	0cd24b0d-2c87-44e7-b991-33317f83ace6	123	Dev Ktizovych	75	126	44	24	2022-07-04
59b4621e-e744-4c89-9cd5-6c9bf7ad9656	0cd24b0d-2c87-44e7-b991-33317f83ace6	2132132	Dev Ktizovych	150	127	45	25	2022-07-04
59b4621e-e744-4c89-9cd5-6c9bf7ad9654	0cd24b0d-2c87-44e7-b991-33317f83ace6	22222	Dev Ktizovych	150	125	43	23	2022-12-28
59b4621e-e744-4c89-9cd5-6c9bf7ad9657	0cd24b0d-2c87-44e7-b991-33317f83ace6	222231	Dev Ktizovych	150	128	46	26	2022-12-21
59b4621e-e744-4c89-9cd5-6c9bf7ad9653	0cd24b0d-2c87-44e7-b991-33317f83ace6	12321	Dev Ktizovych	225	124	42	22	2022-12-27
\.


--
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: ktizo
--

COPY public.notification (id, user_id, song_id, artist_id, music_title, track_id, date, status, seen, datetime) FROM stdin;
413f3a27-ce51-466e-b406-1003479a1f36	6906c7df-8e12-46b1-bfec-9e473f1022f0	5361ce8c-be44-4fb0-a501-b7f86563c0bb	2491764d-dd64-417d-9704-51a085fd6c83	All Facts (feat. Ty Dolla $ign)	169530	2022-07-04	1	0	2022-07-04 13:24:45
3cea3ead-1f88-4eb1-b646-2b07e3075607	d8f4e48a-8cc6-42a8-acf7-03006b2f57a6	a5df2da4-2eb9-4631-acb9-8cbfa49bedf8	2491764d-dd64-417d-9704-51a085fd6c83	10 Toes	194100	2022-07-01	1	0	2022-07-01 12:37:10
0880865c-fd61-4954-9542-6127e1487230	6906c7df-8e12-46b1-bfec-9e473f1022f0	4cfa75c6-e1ed-4394-bd84-8f8ae049c207	0e16ac26-f71b-4188-b3fa-dd40afe5b3b1	Bay 101	436966	2022-07-01	0	0	2022-07-01 13:25:36
f29cad70-0ff4-440e-8210-b18e8a22e79f	6906c7df-8e12-46b1-bfec-9e473f1022f0	4cfa75c6-e1ed-4394-bd84-8f8ae049c207	0e16ac26-f71b-4188-b3fa-dd40afe5b3b1	Bay 101	436966	2022-07-01	1	0	2022-07-01 13:26:14
41d5ad84-1188-41c2-8a45-ec65ec9687f6	6906c7df-8e12-46b1-bfec-9e473f1022f0	5d474098-f4f7-4d4e-ba37-3b9a97ffbc07	0e16ac26-f71b-4188-b3fa-dd40afe5b3b1	Paradise	436959	2022-07-01	0	0	2022-07-01 15:57:14
cbe3394a-5b89-46e4-819f-b09a7b7e1b09	6906c7df-8e12-46b1-bfec-9e473f1022f0	5d474098-f4f7-4d4e-ba37-3b9a97ffbc07	0e16ac26-f71b-4188-b3fa-dd40afe5b3b1	Paradise	436959	2022-07-01	1	0	2022-07-01 15:57:53
7702b87c-e7b4-4cae-aebf-232575237b79	6906c7df-8e12-46b1-bfec-9e473f1022f0	4cfa75c6-e1ed-4394-bd84-8f8ae049c207	0e16ac26-f71b-4188-b3fa-dd40afe5b3b1	Bay 101	436966	2022-07-03	4	0	2022-07-03 05:51:38
3ee9de2e-316d-42c1-9391-b6eae90ec9b1	6906c7df-8e12-46b1-bfec-9e473f1022f0	a6b17501-af77-4c1d-aa95-ba539565f760	2491764d-dd64-417d-9704-51a085fd6c83	A Little More (feat. Kiana Ledé)	129931	2022-07-04	1	0	2022-07-04 06:53:39
b31d254c-7f08-48ac-be95-f57089e1f04d	6906c7df-8e12-46b1-bfec-9e473f1022f0	821d34ee-9eb3-4274-be8b-b6695d82935d	2491764d-dd64-417d-9704-51a085fd6c83	A Very Strange Time	160003	2022-07-04	1	0	2022-07-04 06:53:51
cfc82173-1cfc-4d79-ad4d-b60476fd6e4b	6906c7df-8e12-46b1-bfec-9e473f1022f0	b220f19e-3ea5-4e60-be6f-6575fce35189	2491764d-dd64-417d-9704-51a085fd6c83	Almost Famous	404280	2022-07-04	1	0	2022-07-04 07:21:48
7a56371a-adfa-4884-aeb9-31ab41908af7	6906c7df-8e12-46b1-bfec-9e473f1022f0	a5df2da4-2eb9-4631-acb9-8cbfa49bedf8	2491764d-dd64-417d-9704-51a085fd6c83	10 Toes	194100	2022-07-04	4	0	2022-07-04 07:43:34
015ec5c9-7bb8-4ddb-b3d1-45d9418ae279	6906c7df-8e12-46b1-bfec-9e473f1022f0	821d34ee-9eb3-4274-be8b-b6695d82935d	2491764d-dd64-417d-9704-51a085fd6c83	A Very Strange Time	160003	2022-07-04	4	0	2022-07-04 08:02:32
89296a14-5f70-437e-886a-f568ffa8fa3f	6906c7df-8e12-46b1-bfec-9e473f1022f0	a6b17501-af77-4c1d-aa95-ba539565f760	2491764d-dd64-417d-9704-51a085fd6c83	A Little More (feat. Kiana Ledé)	129931	2022-07-04	4	0	2022-07-04 08:02:32
cc674601-b1a7-4bc4-b788-054a47cbd482	6906c7df-8e12-46b1-bfec-9e473f1022f0	b220f19e-3ea5-4e60-be6f-6575fce35189	2491764d-dd64-417d-9704-51a085fd6c83	Almost Famous	404280	2022-07-04	4	0	2022-07-04 08:02:32
5b246df3-a02a-48ea-8ee5-cc88ecf17d66	6906c7df-8e12-46b1-bfec-9e473f1022f0	821d34ee-9eb3-4274-be8b-b6695d82935d	2491764d-dd64-417d-9704-51a085fd6c83	A Very Strange Time	160003	2022-07-04	4	0	2022-07-04 10:58:25
5cc23609-6b70-48e7-a46d-e73d2db97983	6906c7df-8e12-46b1-bfec-9e473f1022f0	a6b17501-af77-4c1d-aa95-ba539565f760	2491764d-dd64-417d-9704-51a085fd6c83	A Little More (feat. Kiana Ledé)	129931	2022-07-04	4	0	2022-07-04 10:58:25
673c39b6-83bd-4e92-81d0-1cd99be7924d	6906c7df-8e12-46b1-bfec-9e473f1022f0	b220f19e-3ea5-4e60-be6f-6575fce35189	2491764d-dd64-417d-9704-51a085fd6c83	Almost Famous	404280	2022-07-04	4	0	2022-07-04 10:58:25
6bd9f043-08be-423d-a549-723f2c110538	6906c7df-8e12-46b1-bfec-9e473f1022f0	821d34ee-9eb3-4274-be8b-b6695d82935d	2491764d-dd64-417d-9704-51a085fd6c83	A Very Strange Time	160003	2022-07-04	4	0	2022-07-04 10:58:36
dfcc8028-63cd-4090-923f-242af2097ebb	6906c7df-8e12-46b1-bfec-9e473f1022f0	a6b17501-af77-4c1d-aa95-ba539565f760	2491764d-dd64-417d-9704-51a085fd6c83	A Little More (feat. Kiana Ledé)	129931	2022-07-04	4	0	2022-07-04 10:58:36
d35ccd69-c838-49e7-8ea2-9ec540be2949	6906c7df-8e12-46b1-bfec-9e473f1022f0	b220f19e-3ea5-4e60-be6f-6575fce35189	2491764d-dd64-417d-9704-51a085fd6c83	Almost Famous	404280	2022-07-04	4	0	2022-07-04 10:58:36
bdcc9fae-2bc9-478b-867b-467934f87d1b	6906c7df-8e12-46b1-bfec-9e473f1022f0	821d34ee-9eb3-4274-be8b-b6695d82935d	2491764d-dd64-417d-9704-51a085fd6c83	A Very Strange Time	160003	2022-07-04	4	0	2022-07-04 11:22:02
1152b3b7-f32e-4c25-a7b3-8df5fedb9eb1	6906c7df-8e12-46b1-bfec-9e473f1022f0	a6b17501-af77-4c1d-aa95-ba539565f760	2491764d-dd64-417d-9704-51a085fd6c83	A Little More (feat. Kiana Ledé)	129931	2022-07-04	4	0	2022-07-04 11:22:02
1c5c96ae-cc97-45d1-84a8-d331347f0ffd	6906c7df-8e12-46b1-bfec-9e473f1022f0	b220f19e-3ea5-4e60-be6f-6575fce35189	2491764d-dd64-417d-9704-51a085fd6c83	Almost Famous	404280	2022-07-04	4	0	2022-07-04 11:22:02
380db217-636b-4806-9b2c-cfc5bb1a2f70	6906c7df-8e12-46b1-bfec-9e473f1022f0	821d34ee-9eb3-4274-be8b-b6695d82935d	2491764d-dd64-417d-9704-51a085fd6c83	A Very Strange Time	160003	2022-07-04	4	0	2022-07-04 11:22:22
3ea59614-6554-40b0-8d5c-623b0b23aeb0	6906c7df-8e12-46b1-bfec-9e473f1022f0	a6b17501-af77-4c1d-aa95-ba539565f760	2491764d-dd64-417d-9704-51a085fd6c83	A Little More (feat. Kiana Ledé)	129931	2022-07-04	4	0	2022-07-04 11:22:22
dbc651db-5773-40d0-93f2-47a5c4abceac	6906c7df-8e12-46b1-bfec-9e473f1022f0	b220f19e-3ea5-4e60-be6f-6575fce35189	2491764d-dd64-417d-9704-51a085fd6c83	Almost Famous	404280	2022-07-04	4	0	2022-07-04 11:22:22
2babe283-ee0d-45e6-aba8-18bfb9f131a4	6906c7df-8e12-46b1-bfec-9e473f1022f0	43ae3340-d36f-4b84-ae70-c9c117432d7f	2491764d-dd64-417d-9704-51a085fd6c83	Angel	210166	2022-07-04	0	0	2022-07-04 11:26:23
4f1132f3-fc3e-4bd0-bd8c-dc556e90a1ef	6906c7df-8e12-46b1-bfec-9e473f1022f0	821d34ee-9eb3-4274-be8b-b6695d82935d	2491764d-dd64-417d-9704-51a085fd6c83	A Very Strange Time	160003	2022-07-04	4	0	2022-07-04 11:53:28
18c9c3fb-d9bf-4717-8163-71e52c74a631	6906c7df-8e12-46b1-bfec-9e473f1022f0	a6b17501-af77-4c1d-aa95-ba539565f760	2491764d-dd64-417d-9704-51a085fd6c83	A Little More (feat. Kiana Ledé)	129931	2022-07-04	4	0	2022-07-04 11:53:28
009b65d3-21fe-48b7-a64e-b4338f84d071	6906c7df-8e12-46b1-bfec-9e473f1022f0	43ae3340-d36f-4b84-ae70-c9c117432d7f	2491764d-dd64-417d-9704-51a085fd6c83	Angel	210166	2022-07-04	4	0	2022-07-04 11:53:28
0f6481cc-b833-4526-b84e-8d42cbed9a71	6906c7df-8e12-46b1-bfec-9e473f1022f0	b220f19e-3ea5-4e60-be6f-6575fce35189	2491764d-dd64-417d-9704-51a085fd6c83	Almost Famous	404280	2022-07-04	4	0	2022-07-04 11:53:28
7341567d-3d36-4a96-97c3-517813ba0cc8	6906c7df-8e12-46b1-bfec-9e473f1022f0	43ae3340-d36f-4b84-ae70-c9c117432d7f	2491764d-dd64-417d-9704-51a085fd6c83	Angel	210166	2022-07-04	1	0	2022-07-04 12:11:31
2b4afc66-4da1-40e4-8fae-4356e2ab9cb0	6906c7df-8e12-46b1-bfec-9e473f1022f0	5d474098-f4f7-4d4e-ba37-3b9a97ffbc07	0e16ac26-f71b-4188-b3fa-dd40afe5b3b1	Paradise	436959	2022-07-04	4	0	2022-07-04 12:33:38
5bd1f262-4916-41bc-87d7-e62255e3347e	6906c7df-8e12-46b1-bfec-9e473f1022f0	4cfa75c6-e1ed-4394-bd84-8f8ae049c207	0e16ac26-f71b-4188-b3fa-dd40afe5b3b1	Bay 101	436966	2022-07-04	4	0	2022-07-04 12:33:47
cdb9d641-3d8d-4f89-bb5a-80038ee5caa6	6906c7df-8e12-46b1-bfec-9e473f1022f0	821d34ee-9eb3-4274-be8b-b6695d82935d	2491764d-dd64-417d-9704-51a085fd6c83	A Very Strange Time	160003	2022-07-04	4	0	2022-07-04 12:47:16
067043ef-36d6-4fb1-b0b3-e2ad77dffee2	6906c7df-8e12-46b1-bfec-9e473f1022f0	a6b17501-af77-4c1d-aa95-ba539565f760	2491764d-dd64-417d-9704-51a085fd6c83	A Little More (feat. Kiana Ledé)	129931	2022-07-04	4	0	2022-07-04 12:47:16
cad981b6-fb2a-45eb-b271-77eb2dbddcc7	6906c7df-8e12-46b1-bfec-9e473f1022f0	43ae3340-d36f-4b84-ae70-c9c117432d7f	2491764d-dd64-417d-9704-51a085fd6c83	Angel	210166	2022-07-04	4	0	2022-07-04 12:47:16
7ff88380-68d1-4eb2-b9a5-e0003e550b51	6906c7df-8e12-46b1-bfec-9e473f1022f0	b220f19e-3ea5-4e60-be6f-6575fce35189	2491764d-dd64-417d-9704-51a085fd6c83	Almost Famous	404280	2022-07-04	4	0	2022-07-04 12:47:16
1f82003f-f707-452f-9681-3f66b74042c2	6906c7df-8e12-46b1-bfec-9e473f1022f0	821d34ee-9eb3-4274-be8b-b6695d82935d	2491764d-dd64-417d-9704-51a085fd6c83	A Very Strange Time	160003	2022-07-04	4	0	2022-07-04 12:54:51
9544f446-2108-42ef-a13c-e630cfeca4a1	6906c7df-8e12-46b1-bfec-9e473f1022f0	a6b17501-af77-4c1d-aa95-ba539565f760	2491764d-dd64-417d-9704-51a085fd6c83	A Little More (feat. Kiana Ledé)	129931	2022-07-04	4	0	2022-07-04 12:54:51
db9c11a9-d47c-4ddb-b32e-9bc1941433db	6906c7df-8e12-46b1-bfec-9e473f1022f0	43ae3340-d36f-4b84-ae70-c9c117432d7f	2491764d-dd64-417d-9704-51a085fd6c83	Angel	210166	2022-07-04	4	0	2022-07-04 12:54:51
b93bb4fc-7ef3-42bb-8d37-5dfbedf0649f	6906c7df-8e12-46b1-bfec-9e473f1022f0	b220f19e-3ea5-4e60-be6f-6575fce35189	2491764d-dd64-417d-9704-51a085fd6c83	Almost Famous	404280	2022-07-04	4	0	2022-07-04 12:54:51
37d4933f-8f71-4b93-8805-fee63367c5d7	6906c7df-8e12-46b1-bfec-9e473f1022f0	a5df2da4-2eb9-4631-acb9-8cbfa49bedf8	2491764d-dd64-417d-9704-51a085fd6c83	10 Toes	194100	2022-07-04	4	0	2022-07-04 13:21:21
ace4b428-35f4-404b-a8e5-7ea61d47f91d	6906c7df-8e12-46b1-bfec-9e473f1022f0	a5df2da4-2eb9-4631-acb9-8cbfa49bedf8	2491764d-dd64-417d-9704-51a085fd6c83	10 Toes	194100	2022-07-04	4	0	2022-07-04 13:21:29
f6e2e08c-a971-4070-949b-59aba57dad29	6906c7df-8e12-46b1-bfec-9e473f1022f0	a5df2da4-2eb9-4631-acb9-8cbfa49bedf8	2491764d-dd64-417d-9704-51a085fd6c83	10 Toes	194100	2022-07-04	4	0	2022-07-04 13:23:59
24c82d9c-3d7d-4890-b945-8218e4d0aa0c	6906c7df-8e12-46b1-bfec-9e473f1022f0	5361ce8c-be44-4fb0-a501-b7f86563c0bb	2491764d-dd64-417d-9704-51a085fd6c83	All Facts (feat. Ty Dolla $ign)	169530	2022-07-04	0	0	2022-07-04 13:24:27
7904d973-b1a6-4487-bfe0-5c7573c8a2a6	6906c7df-8e12-46b1-bfec-9e473f1022f0	5361ce8c-be44-4fb0-a501-b7f86563c0bb	2491764d-dd64-417d-9704-51a085fd6c83	All Facts (feat. Ty Dolla $ign)	169530	2022-07-05	4	0	2022-07-05 10:12:29
ac578519-68db-4805-a871-0f9c06e4f900	6906c7df-8e12-46b1-bfec-9e473f1022f0	a5df2da4-2eb9-4631-acb9-8cbfa49bedf8	2491764d-dd64-417d-9704-51a085fd6c83	10 Toes	194100	2022-07-05	4	0	2022-07-05 10:12:29
459be246-59a1-4c58-bf6b-9f715c4d65aa	6906c7df-8e12-46b1-bfec-9e473f1022f0	a5df2da4-2eb9-4631-acb9-8cbfa49bedf8	2491764d-dd64-417d-9704-51a085fd6c83	10 Toes	194100	2022-07-05	0	0	2022-07-05 10:14:03
b9d0d56d-a7f5-4123-8ce1-40c3962123d1	6906c7df-8e12-46b1-bfec-9e473f1022f0	a5df2da4-2eb9-4631-acb9-8cbfa49bedf8	2491764d-dd64-417d-9704-51a085fd6c83	10 Toes	194100	2022-07-05	1	0	2022-07-05 10:16:07
362a323c-f47c-479d-855d-7fcd82e16897	6906c7df-8e12-46b1-bfec-9e473f1022f0	5361ce8c-be44-4fb0-a501-b7f86563c0bb	2491764d-dd64-417d-9704-51a085fd6c83	All Facts (feat. Ty Dolla $ign)	169530	2022-07-05	4	0	2022-07-05 10:23:41
31b1c085-f482-4f98-ab12-f34aa272cae0	6906c7df-8e12-46b1-bfec-9e473f1022f0	a5df2da4-2eb9-4631-acb9-8cbfa49bedf8	2491764d-dd64-417d-9704-51a085fd6c83	10 Toes	194100	2022-07-05	4	0	2022-07-05 10:23:41
90f6ab0a-3661-4b3a-a17f-e7340a25d795	6906c7df-8e12-46b1-bfec-9e473f1022f0	5361ce8c-be44-4fb0-a501-b7f86563c0bb	2491764d-dd64-417d-9704-51a085fd6c83	All Facts (feat. Ty Dolla $ign)	169530	2022-07-05	4	0	2022-07-05 10:24:31
82bab95d-d13d-4f39-bb13-582ddc07ec94	6906c7df-8e12-46b1-bfec-9e473f1022f0	a5df2da4-2eb9-4631-acb9-8cbfa49bedf8	2491764d-dd64-417d-9704-51a085fd6c83	10 Toes	194100	2022-07-05	4	0	2022-07-05 10:24:31
ed45d28c-6566-47ee-9f57-80efddb54f49	6906c7df-8e12-46b1-bfec-9e473f1022f0	ada103db-5b4a-486c-af75-295a0bf0925b	2491764d-dd64-417d-9704-51a085fd6c83	A Little More (feat. Kiana Ledé)	343542	2022-07-05	0	0	2022-07-05 10:31:11
492df56b-85d7-451b-ab1a-8b44162f43c8	6906c7df-8e12-46b1-bfec-9e473f1022f0	ada103db-5b4a-486c-af75-295a0bf0925b	2491764d-dd64-417d-9704-51a085fd6c83	A Little More (feat. Kiana Ledé)	343542	2022-07-05	1	0	2022-07-05 10:31:25
bdd2f446-5269-43d0-9471-2251e22daa7c	6906c7df-8e12-46b1-bfec-9e473f1022f0	a5df2da4-2eb9-4631-acb9-8cbfa49bedf8	2491764d-dd64-417d-9704-51a085fd6c83	10 Toes	194100	2022-07-05	2	0	2022-07-05 10:32:14
27744292-051d-4fd2-a971-145d36b926de	6906c7df-8e12-46b1-bfec-9e473f1022f0	a5df2da4-2eb9-4631-acb9-8cbfa49bedf8	2491764d-dd64-417d-9704-51a085fd6c83	10 Toes	194100	2022-07-05	2	0	2022-07-05 10:32:40
343e58ad-90a6-4b06-9e10-d5279c85ea15	6906c7df-8e12-46b1-bfec-9e473f1022f0	a5df2da4-2eb9-4631-acb9-8cbfa49bedf8	2491764d-dd64-417d-9704-51a085fd6c83	10 Toes	194100	2022-07-05	2	0	2022-07-05 10:32:15
aa4596a4-eeb3-4205-ac6f-e6040f361e8f	6906c7df-8e12-46b1-bfec-9e473f1022f0	a5df2da4-2eb9-4631-acb9-8cbfa49bedf8	2491764d-dd64-417d-9704-51a085fd6c83	10 Toes	194100	2022-07-05	2	0	2022-07-05 10:32:42
b0b11bd5-a8b1-4637-8681-fe0aa7e6249d	6906c7df-8e12-46b1-bfec-9e473f1022f0	5361ce8c-be44-4fb0-a501-b7f86563c0bb	2491764d-dd64-417d-9704-51a085fd6c83	All Facts (feat. Ty Dolla $ign)	169530	2022-07-05	2	0	2022-07-05 10:32:19
7134eca1-b15f-4eed-a357-cd06a075d9fd	ce8ee1fa-bd89-4d00-9d99-b3a9fe69fb2a	a5df2da4-2eb9-4631-acb9-8cbfa49bedf8	2491764d-dd64-417d-9704-51a085fd6c83	10 Toes	194100	2022-07-06	4	0	2022-07-06 12:41:52
79181e10-a3ac-4686-83f6-825462c1d760	ce8ee1fa-bd89-4d00-9d99-b3a9fe69fb2a	a5df2da4-2eb9-4631-acb9-8cbfa49bedf8	2491764d-dd64-417d-9704-51a085fd6c83	10 Toes	194100	2022-07-25	4	0	2022-07-25 10:12:22
6241fa38-91f8-4cb6-94f4-983767d05812	ce8ee1fa-bd89-4d00-9d99-b3a9fe69fb2a	5361ce8c-be44-4fb0-a501-b7f86563c0bb	2491764d-dd64-417d-9704-51a085fd6c83	All Facts (feat. Ty Dolla $ign)	169530	2022-07-25	0	0	2022-07-25 10:13:14
2c70ff61-0838-49d0-95f2-374c6013c69e	ce8ee1fa-bd89-4d00-9d99-b3a9fe69fb2a	5361ce8c-be44-4fb0-a501-b7f86563c0bb	2491764d-dd64-417d-9704-51a085fd6c83	All Facts (feat. Ty Dolla $ign)	169530	2022-07-25	1	0	2022-07-25 10:13:34
6adedd31-0438-47d5-b3e9-48663a689316	ce8ee1fa-bd89-4d00-9d99-b3a9fe69fb2a	5361ce8c-be44-4fb0-a501-b7f86563c0bb	2491764d-dd64-417d-9704-51a085fd6c83	All Facts (feat. Ty Dolla $ign)	169530	2022-07-25	1	0	2022-07-25 10:13:34
\.


--
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: ktizo
--

COPY public.payment (id, supervisor_id, invoice_id, stripe_id, email, amount, date, status, amount_before_reduction, receipt_url, receipt_created_date, song_id) FROM stdin;
22	ce8ee1fa-bd89-4d00-9d99-b3a9fe69fb2a	12	pi_3LPOIEDcjKsmIMDS2BC7MmZk	\N	75	2022-07-25	\N	100	\N	\N	5361ce8c-be44-4fb0-a501-b7f86563c0bb
3	6906c7df-8e12-46b1-bfec-9e473f1022f0	3	pi_3LGq9RDcjKsmIMDS06Yo4hSH	\N	112	2022-07-01	pending	150	\N	\N	4cfa75c6-e1ed-4394-bd84-8f8ae049c207
4	6906c7df-8e12-46b1-bfec-9e473f1022f0	3	pi_3LGqBODcjKsmIMDS2YgWGbbu	\N	112	2022-07-01	pending	150	\N	\N	4cfa75c6-e1ed-4394-bd84-8f8ae049c207
5	6906c7df-8e12-46b1-bfec-9e473f1022f0	4	pi_3LGqC8DcjKsmIMDS15e3QJiV	\N	112	2022-07-01	pending	150	\N	\N	5d474098-f4f7-4d4e-ba37-3b9a97ffbc07
7	6906c7df-8e12-46b1-bfec-9e473f1022f0	4	pi_3LHhncDcjKsmIMDS0iT6CyxC	\N	112	2022-07-04	pending	150	\N	\N	5d474098-f4f7-4d4e-ba37-3b9a97ffbc07
8	6906c7df-8e12-46b1-bfec-9e473f1022f0	6	pi_3LHjBBDcjKsmIMDS0YCIpoLv	anandhu.anil@xminds.com	225	2022-07-04	succeeded	300	https://pay.stripe.com/receipts/acct_1L5aAKDcjKsmIMDS/ch_3LHjBBDcjKsmIMDS0HQmLCZq/rcpt_LzidB26QSrzM0OzOeO6c6Foxaa6vTAO	2022-07-04 06:55:46	821d34ee-9eb3-4274-be8b-b6695d82935d
9	6906c7df-8e12-46b1-bfec-9e473f1022f0	5	pi_3LHjDXDcjKsmIMDS0XfEzWuu	anandhu.anil@xminds.com	150	2022-07-04	succeeded	200	https://pay.stripe.com/receipts/acct_1L5aAKDcjKsmIMDS/py_3LHjDXDcjKsmIMDS0Hzx4JpB/rcpt_LzikftouCtXk35VEDhlpGAWG3TSr4Km	2022-07-04 07:03:03	a6b17501-af77-4c1d-aa95-ba539565f760
11	6906c7df-8e12-46b1-bfec-9e473f1022f0	7	pi_3LHjbYDcjKsmIMDS3x8o70dR	anandhu.anil@xminds.com	75	2022-07-04	succeeded	100	https://pay.stripe.com/receipts/acct_1L5aAKDcjKsmIMDS/py_3LHjbYDcjKsmIMDS3QM7s9ay/rcpt_Lzj4vHIUgNwUUjOn4pwljEdeCVgC0kr	2022-07-04 07:23:10	b220f19e-3ea5-4e60-be6f-6575fce35189
12	6906c7df-8e12-46b1-bfec-9e473f1022f0	5	pi_3LHlt9DcjKsmIMDS0z4HbNBN	\N	150	2022-07-04	pending	200	\N	\N	a6b17501-af77-4c1d-aa95-ba539565f760
10	6906c7df-8e12-46b1-bfec-9e473f1022f0	5	pi_3LHjI9DcjKsmIMDS2mOeDHoY	anandhu.anil@xminds.com	150	2022-07-04	succeeded	200	https://pay.stripe.com/receipts/acct_1L5aAKDcjKsmIMDS/py_3LHjI9DcjKsmIMDS2R2Rv6fz/rcpt_LzlSpRATCLxfQFruBWbNoObvcObmE42	2022-07-04 09:50:39	a6b17501-af77-4c1d-aa95-ba539565f760
13	6906c7df-8e12-46b1-bfec-9e473f1022f0	8	pi_3LHo7vDcjKsmIMDS02hsf8rW	anandhu.anil@xminds.com	150	2022-07-04	succeeded	200	https://pay.stripe.com/receipts/acct_1L5aAKDcjKsmIMDS/py_3LHo7vDcjKsmIMDS0uai9UIt/rcpt_Lznk63P8ISB28BKiHwLp4XBN0w90Wrn	2022-07-04 12:13:14	43ae3340-d36f-4b84-ae70-c9c117432d7f
15	6906c7df-8e12-46b1-bfec-9e473f1022f0	8	pi_3LHoUaDcjKsmIMDS27eL51H8	\N	150	2022-07-04	pending	200	\N	\N	43ae3340-d36f-4b84-ae70-c9c117432d7f
16	6906c7df-8e12-46b1-bfec-9e473f1022f0	8	pi_3LHoWxDcjKsmIMDS0PXI3t14	\N	150	2022-07-04	pending	200	\N	\N	43ae3340-d36f-4b84-ae70-c9c117432d7f
17	6906c7df-8e12-46b1-bfec-9e473f1022f0	8	pi_3LHoxDDcjKsmIMDS0eZn3emx	\N	150	2022-07-04	pending	200	\N	\N	43ae3340-d36f-4b84-ae70-c9c117432d7f
6	6906c7df-8e12-46b1-bfec-9e473f1022f0	4	pi_3LHhlZDcjKsmIMDS3AGNfvO78	mpmcoronel@gmail.com	112	2022-07-04	suceeded	150	https://pay.stripe.com/receipts/acct_1L5aAKDcjKsmIMDS/py_3LHhlZDcjKsmIMDS3qk7wJTV/rcpt_LzhAkpLt73nlVyyfpJSPSlFtWNUQFdn	2022-07-04 05:24:54	5d474098-f4f7-4d4e-ba37-3b9a97ffbc07
18	6906c7df-8e12-46b1-bfec-9e473f1022f0	9	pi_3LHphRDcjKsmIMDS3YJ1Jx2D	\N	75	2022-07-04	pending	100	\N	\N	5361ce8c-be44-4fb0-a501-b7f86563c0bb
19	6906c7df-8e12-46b1-bfec-9e473f1022f0	9	pi_3LHpnpDcjKsmIMDS0Sb5JB2v	\N	75	2022-07-04	pending	100	\N	\N	5361ce8c-be44-4fb0-a501-b7f86563c0bb
14	6906c7df-8e12-46b1-bfec-9e473f1022f0	8	pi_3LHo8pDcjKsmIMDS0pp6Wwfk	anandhu.anil@xminds.com	150	2022-07-04	succeeded	200	https://pay.stripe.com/receipts/acct_1L5aAKDcjKsmIMDS/py_3LHo8pDcjKsmIMDS0xfA3ymk/rcpt_LzpYM4xM5qGzqr77bwb47BsQPuC14yF	2022-07-04 14:04:23	43ae3340-d36f-4b84-ae70-c9c117432d7f
20	6906c7df-8e12-46b1-bfec-9e473f1022f0	11	pi_3LI92dDcjKsmIMDS3U3AnZPy	\N	150	2022-07-05	\N	200	\N	\N	ada103db-5b4a-486c-af75-295a0bf0925b
21	6906c7df-8e12-46b1-bfec-9e473f1022f0	11	pi_3LIqsjDcjKsmIMDS2heTAO3l	\N	150	2022-07-07	\N	200	\N	\N	ada103db-5b4a-486c-af75-295a0bf0925b
\.


--
-- Data for Name: project; Type: TABLE DATA; Schema: public; Owner: ktizo
--

COPY public.project (id, user_id, name, description, created_date) FROM stdin;
93c7f29d-6e74-46e2-badd-95d789403a43	0cd24b0d-2c87-44e7-b991-33317f83ace6	Project1	TEST	2023-01-05 00:00:00
d9ec7ba0-0aad-4d8f-a6d7-6316f5be9486	0cd24b0d-2c87-44e7-b991-33317f83ace6	Project2	string2	2023-01-05 00:00:00
93c7f29d-6e74-46e2-badd-95d789403a44	60d34088-3b0e-443a-b931-732951a50e3c	strin1g	string	2023-01-05 00:00:00
275ef9b0-e8ae-4c96-928b-ae30c2ac7a2d	60d34088-3b0e-443a-b931-732951a50e3c	123	123	2023-01-10 00:00:00
bf000913-1dac-4982-acdd-191a7921e4e8	60d34088-3b0e-443a-b931-732951a50e3c	Project 13	13	2023-01-11 00:00:00
3fc5516f-87dd-4b0d-ba8f-2ce5da4045de	d3ec0af9-e8c9-4ec3-adea-62aa4ad5b602	asdasd	asdaddas	2023-01-12 00:00:00
31f339a2-5804-46be-8edb-2a1f503b97c7	d3ec0af9-e8c9-4ec3-adea-62aa4ad5b602	фівфввфв	фвфівфі	2023-01-12 00:00:00
\.


--
-- Data for Name: reset_password; Type: TABLE DATA; Schema: public; Owner: ktizo
--

COPY public.reset_password (id, email, status, reset_token, expired_in) FROM stdin;
355fd20c-fe70-4d6f-b67d-07092f1a1a01	anandhu.anil@xminds.com	t	ee2d0f38-3973-42b0-92e7-d4c0957773b5	2022-07-15 12:12:01.029281
fe403594-fb30-4155-9de7-c5aaa7fdb8d9	glong661@gmail.com	t	99656229-4433-41c0-b6cd-55fdf44777e5	2022-12-13 03:32:24.826156
\.


--
-- Data for Name: similar_track; Type: TABLE DATA; Schema: public; Owner: ktizo
--

COPY public.similar_track (id, supervisor_id, search_artistid, search_trackid, similar_songs, date, search_artistname, search_trackname) FROM stdin;
cc849aa1-2b99-4320-ac8b-f81449bc4225	6906c7df-8e12-46b1-bfec-9e473f1022f0	1805	436966	[{"id": "4cfa75c6-e1ed-4394-bd84-8f8ae049c207", "bpm": "105.007", "genre": "Pop", "status": 1, "user_id": "0e16ac26-f71b-4188-b3fa-dd40afe5b3b1", "track_id": "436966", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Bay_101_(getmp3.pro).mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/bridesmaids-img3.jpg", "user_like": "False", "like_count": 0, "spotify_id": "32i9Zz376Thwuft0UoWqM8", "music_title": "Bay 101", "user_dislike": "False", "dislike_count": 0, "music_duration": "1:31", "licenced_status": 0}]	2022-07-01	Paul Water	Bay 101
d42a8b20-6d45-4d5a-ae72-d027d9f9c055	6906c7df-8e12-46b1-bfec-9e473f1022f0	1805	436959	[{"id": "5d474098-f4f7-4d4e-ba37-3b9a97ffbc07", "bpm": "120.002", "genre": "Pop", "status": 1, "user_id": "0e16ac26-f71b-4188-b3fa-dd40afe5b3b1", "track_id": "436959", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Paradise.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/about_me.jpg", "user_like": "False", "like_count": 0, "spotify_id": "412XVsG2DN1ws4OlDzoumc", "music_title": "Paradise", "user_dislike": "False", "dislike_count": 0, "music_duration": "2:52", "licenced_status": 0}]	2022-07-01	Paul Water	Paradise
da52def7-270b-4ab9-a590-7c25fe19a411	6906c7df-8e12-46b1-bfec-9e473f1022f0	1805	436966	[{"id": "4cfa75c6-e1ed-4394-bd84-8f8ae049c207", "bpm": "105.007", "genre": "Pop", "status": 1, "user_id": "0e16ac26-f71b-4188-b3fa-dd40afe5b3b1", "track_id": "436966", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Bay_101_(getmp3.pro).mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/bridesmaids-img3.jpg", "user_like": "True", "like_count": 1, "spotify_id": "32i9Zz376Thwuft0UoWqM8", "music_title": "Bay 101", "user_dislike": "False", "dislike_count": 0, "music_duration": "1:31", "licenced_status": 1}]	2022-07-03	Paul Water	Bay 101
626776e5-f1c3-4955-865e-00436b6b27b9	6906c7df-8e12-46b1-bfec-9e473f1022f0	5	925	[{"id": "a5df2da4-2eb9-4631-acb9-8cbfa49bedf8", "bpm": "101.986", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "194100", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Aparshakti Khurana Balle Ni Balle  Dhanashree VC  Siddharth AB  Gurpreet S _ Official Video.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/Record-Album-02 (1).jpg", "user_like": "False", "like_count": 1, "spotify_id": "2BN5ZMErVAhbEroB99b3no", "music_title": "10 Toes", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:48", "licenced_status": 0}]	2022-07-04	Justin Bieber	2 Much
9b958042-dbca-4ee5-8f58-99e5fb4648b6	6906c7df-8e12-46b1-bfec-9e473f1022f0	5	925	[{"id": "a5df2da4-2eb9-4631-acb9-8cbfa49bedf8", "bpm": "101.986", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "194100", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Aparshakti Khurana Balle Ni Balle  Dhanashree VC  Siddharth AB  Gurpreet S _ Official Video.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/Record-Album-02 (1).jpg", "user_like": "False", "like_count": 1, "spotify_id": "2BN5ZMErVAhbEroB99b3no", "music_title": "10 Toes", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:48", "licenced_status": 0}]	2022-07-04	Justin Bieber	2 Much
fa57086b-5c65-4d6d-ba3a-4fefd8dfed6d	6906c7df-8e12-46b1-bfec-9e473f1022f0	179	44416	[{"id": "821d34ee-9eb3-4274-be8b-b6695d82935d", "bpm": "79.498", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "160003", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Anyone.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/creatorDiv.png", "user_like": "True", "like_count": 1, "spotify_id": "6EtjpH5ma85sXU9DyO812N", "music_title": "A Very Strange Time", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:40", "licenced_status": 1}, {"id": "a6b17501-af77-4c1d-aa95-ba539565f760", "bpm": "87.016", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "129931", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Anyone.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/Dubxx.jpg", "user_like": "True", "like_count": 1, "spotify_id": "5exI67CSZNnIjY7RyInyy4", "music_title": "A Little More (feat. Kiana Ledé)", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:33", "licenced_status": 1}, {"id": "b220f19e-3ea5-4e60-be6f-6575fce35189", "bpm": "124.025", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "404280", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Anyone.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/contactus_Image.png", "user_like": "True", "like_count": 1, "spotify_id": "4qJVEovuJ0Oezit9lEzodQ", "music_title": "Almost Famous", "user_dislike": "False", "dislike_count": 0, "music_duration": "4:29", "licenced_status": 1}]	2022-07-04	2 Chainz	2 Dollar Bill (feat. Lil Wayne, E-40)
13e75298-7ad7-4829-a001-87a105c411d8	6906c7df-8e12-46b1-bfec-9e473f1022f0	179	44416	[{"id": "821d34ee-9eb3-4274-be8b-b6695d82935d", "bpm": "79.498", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "160003", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Anyone.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/creatorDiv.png", "user_like": "True", "like_count": 1, "spotify_id": "6EtjpH5ma85sXU9DyO812N", "music_title": "A Very Strange Time", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:40", "licenced_status": 1}, {"id": "a6b17501-af77-4c1d-aa95-ba539565f760", "bpm": "87.016", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "129931", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Anyone.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/Dubxx.jpg", "user_like": "True", "like_count": 1, "spotify_id": "5exI67CSZNnIjY7RyInyy4", "music_title": "A Little More (feat. Kiana Ledé)", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:33", "licenced_status": 1}, {"id": "b220f19e-3ea5-4e60-be6f-6575fce35189", "bpm": "124.025", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "404280", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Anyone.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/contactus_Image.png", "user_like": "True", "like_count": 1, "spotify_id": "4qJVEovuJ0Oezit9lEzodQ", "music_title": "Almost Famous", "user_dislike": "False", "dislike_count": 0, "music_duration": "4:29", "licenced_status": 1}]	2022-07-04	2 Chainz	2 Dollar Bill (feat. Lil Wayne, E-40)
80bddf10-b5cb-486f-b148-9f637521edf2	6906c7df-8e12-46b1-bfec-9e473f1022f0	179	44416	[{"id": "821d34ee-9eb3-4274-be8b-b6695d82935d", "bpm": "79.498", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "160003", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Anyone.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/creatorDiv.png", "user_like": "True", "like_count": 1, "spotify_id": "6EtjpH5ma85sXU9DyO812N", "music_title": "A Very Strange Time", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:40", "licenced_status": 1}, {"id": "a6b17501-af77-4c1d-aa95-ba539565f760", "bpm": "87.016", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "129931", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Anyone.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/Dubxx.jpg", "user_like": "True", "like_count": 1, "spotify_id": "5exI67CSZNnIjY7RyInyy4", "music_title": "A Little More (feat. Kiana Ledé)", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:33", "licenced_status": 1}, {"id": "b220f19e-3ea5-4e60-be6f-6575fce35189", "bpm": "124.025", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "404280", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Anyone.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/contactus_Image.png", "user_like": "True", "like_count": 1, "spotify_id": "4qJVEovuJ0Oezit9lEzodQ", "music_title": "Almost Famous", "user_dislike": "False", "dislike_count": 0, "music_duration": "4:29", "licenced_status": 1}]	2022-07-04	2 Chainz	2 Dollar Bill (feat. Lil Wayne, E-40)
9244402c-8e2d-4edc-a7fa-b2ed8964d75b	6906c7df-8e12-46b1-bfec-9e473f1022f0	179	44416	[{"id": "821d34ee-9eb3-4274-be8b-b6695d82935d", "bpm": "79.498", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "160003", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Anyone.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/creatorDiv.png", "user_like": "True", "like_count": 1, "spotify_id": "6EtjpH5ma85sXU9DyO812N", "music_title": "A Very Strange Time", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:40", "licenced_status": 1}, {"id": "a6b17501-af77-4c1d-aa95-ba539565f760", "bpm": "87.016", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "129931", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Anyone.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/Dubxx.jpg", "user_like": "True", "like_count": 1, "spotify_id": "5exI67CSZNnIjY7RyInyy4", "music_title": "A Little More (feat. Kiana Ledé)", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:33", "licenced_status": 1}, {"id": "b220f19e-3ea5-4e60-be6f-6575fce35189", "bpm": "124.025", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "404280", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Anyone.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/contactus_Image.png", "user_like": "True", "like_count": 1, "spotify_id": "4qJVEovuJ0Oezit9lEzodQ", "music_title": "Almost Famous", "user_dislike": "False", "dislike_count": 0, "music_duration": "4:29", "licenced_status": 1}]	2022-07-04	2 Chainz	2 Dollar Bill (feat. Lil Wayne, E-40)
7f5db873-6418-4774-9279-258a5bb899b1	6906c7df-8e12-46b1-bfec-9e473f1022f0	179	44416	[{"id": "43ae3340-d36f-4b84-ae70-c9c117432d7f", "bpm": "155.849", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "210166", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Anyone.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/UICU-1323.jpg", "user_like": "False", "like_count": 0, "spotify_id": "6TX9hUdcCMvmFTonaGxdeX", "music_title": "Angel", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:10", "licenced_status": 0}, {"id": "821d34ee-9eb3-4274-be8b-b6695d82935d", "bpm": "79.498", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "160003", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Anyone.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/creatorDiv.png", "user_like": "True", "like_count": 1, "spotify_id": "6EtjpH5ma85sXU9DyO812N", "music_title": "A Very Strange Time", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:40", "licenced_status": 1}, {"id": "a6b17501-af77-4c1d-aa95-ba539565f760", "bpm": "87.016", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "129931", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Anyone.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/Dubxx.jpg", "user_like": "True", "like_count": 1, "spotify_id": "5exI67CSZNnIjY7RyInyy4", "music_title": "A Little More (feat. Kiana Ledé)", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:33", "licenced_status": 1}, {"id": "b220f19e-3ea5-4e60-be6f-6575fce35189", "bpm": "124.025", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "404280", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Anyone.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/contactus_Image.png", "user_like": "True", "like_count": 1, "spotify_id": "4qJVEovuJ0Oezit9lEzodQ", "music_title": "Almost Famous", "user_dislike": "False", "dislike_count": 0, "music_duration": "4:29", "licenced_status": 1}]	2022-07-04	2 Chainz	2 Dollar Bill (feat. Lil Wayne, E-40)
84c80202-314b-4450-8e0e-b34c33fc1da0	6906c7df-8e12-46b1-bfec-9e473f1022f0	1805	436966	[{"id": "4cfa75c6-e1ed-4394-bd84-8f8ae049c207", "bpm": "105.007", "genre": "Pop", "status": 1, "user_id": "0e16ac26-f71b-4188-b3fa-dd40afe5b3b1", "track_id": "436966", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Bay_101_(getmp3.pro).mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/bridesmaids-img3.jpg", "user_like": "True", "like_count": 1, "spotify_id": "32i9Zz376Thwuft0UoWqM8", "music_title": "Bay 101", "user_dislike": "False", "dislike_count": 0, "music_duration": "1:31", "licenced_status": 1}]	2022-07-04	Paul Water	Bay 101
659a9dfa-03cc-47c6-b6e9-e118277fa445	6906c7df-8e12-46b1-bfec-9e473f1022f0	179	44416	[{"id": "821d34ee-9eb3-4274-be8b-b6695d82935d", "bpm": "79.498", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "160003", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Anyone.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/creatorDiv.png", "user_like": "True", "like_count": 1, "spotify_id": "6EtjpH5ma85sXU9DyO812N", "music_title": "A Very Strange Time", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:40", "licenced_status": 1}, {"id": "a6b17501-af77-4c1d-aa95-ba539565f760", "bpm": "87.016", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "129931", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Anyone.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/Dubxx.jpg", "user_like": "True", "like_count": 1, "spotify_id": "5exI67CSZNnIjY7RyInyy4", "music_title": "A Little More (feat. Kiana Ledé)", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:33", "licenced_status": 1}, {"id": "43ae3340-d36f-4b84-ae70-c9c117432d7f", "bpm": "155.849", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "210166", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Anyone.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/UICU-1323.jpg", "user_like": "True", "like_count": 1, "spotify_id": "6TX9hUdcCMvmFTonaGxdeX", "music_title": "Angel", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:10", "licenced_status": 1}, {"id": "b220f19e-3ea5-4e60-be6f-6575fce35189", "bpm": "124.025", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "404280", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Anyone.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/contactus_Image.png", "user_like": "True", "like_count": 1, "spotify_id": "4qJVEovuJ0Oezit9lEzodQ", "music_title": "Almost Famous", "user_dislike": "False", "dislike_count": 0, "music_duration": "4:29", "licenced_status": 1}]	2022-07-04	2 Chainz	2 Dollar Bill (feat. Lil Wayne, E-40)
b1f23cca-8989-4500-98a9-210c8ac73898	6906c7df-8e12-46b1-bfec-9e473f1022f0	179	44416	[{"id": "821d34ee-9eb3-4274-be8b-b6695d82935d", "bpm": "79.498", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "160003", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Anyone.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/creatorDiv.png", "user_like": "True", "like_count": 1, "spotify_id": "6EtjpH5ma85sXU9DyO812N", "music_title": "A Very Strange Time", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:40", "licenced_status": 1}, {"id": "a6b17501-af77-4c1d-aa95-ba539565f760", "bpm": "87.016", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "129931", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Anyone.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/Dubxx.jpg", "user_like": "True", "like_count": 1, "spotify_id": "5exI67CSZNnIjY7RyInyy4", "music_title": "A Little More (feat. Kiana Ledé)", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:33", "licenced_status": 1}, {"id": "43ae3340-d36f-4b84-ae70-c9c117432d7f", "bpm": "155.849", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "210166", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Anyone.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/UICU-1323.jpg", "user_like": "True", "like_count": 1, "spotify_id": "6TX9hUdcCMvmFTonaGxdeX", "music_title": "Angel", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:10", "licenced_status": 1}, {"id": "b220f19e-3ea5-4e60-be6f-6575fce35189", "bpm": "124.025", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "404280", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Anyone.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/contactus_Image.png", "user_like": "True", "like_count": 1, "spotify_id": "4qJVEovuJ0Oezit9lEzodQ", "music_title": "Almost Famous", "user_dislike": "False", "dislike_count": 0, "music_duration": "4:29", "licenced_status": 1}]	2022-07-04	2 Chainz	2 Dollar Bill (feat. Lil Wayne, E-40)
daf15e65-3b99-4151-9e53-ac55f142bab0	6906c7df-8e12-46b1-bfec-9e473f1022f0	1805	436959	[{"id": "5d474098-f4f7-4d4e-ba37-3b9a97ffbc07", "bpm": "120.002", "genre": "Pop", "status": 1, "user_id": "0e16ac26-f71b-4188-b3fa-dd40afe5b3b1", "track_id": "436959", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Paradise.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/about_me.jpg", "user_like": "True", "like_count": 1, "spotify_id": "412XVsG2DN1ws4OlDzoumc", "music_title": "Paradise", "user_dislike": "False", "dislike_count": 0, "music_duration": "2:52", "licenced_status": 1}]	2022-07-04	Paul Water	Paradise
12b43782-67f2-40bc-b829-4792ce92c439	6906c7df-8e12-46b1-bfec-9e473f1022f0	179	44416	[{"id": "821d34ee-9eb3-4274-be8b-b6695d82935d", "bpm": "79.498", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "160003", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Anyone.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/creatorDiv.png", "user_like": "True", "like_count": 1, "spotify_id": "6EtjpH5ma85sXU9DyO812N", "music_title": "A Very Strange Time", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:40", "licenced_status": 1}, {"id": "a6b17501-af77-4c1d-aa95-ba539565f760", "bpm": "87.016", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "129931", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Anyone.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/Dubxx.jpg", "user_like": "True", "like_count": 1, "spotify_id": "5exI67CSZNnIjY7RyInyy4", "music_title": "A Little More (feat. Kiana Ledé)", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:33", "licenced_status": 1}, {"id": "43ae3340-d36f-4b84-ae70-c9c117432d7f", "bpm": "155.849", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "210166", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Anyone.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/UICU-1323.jpg", "user_like": "True", "like_count": 1, "spotify_id": "6TX9hUdcCMvmFTonaGxdeX", "music_title": "Angel", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:10", "licenced_status": 1}, {"id": "b220f19e-3ea5-4e60-be6f-6575fce35189", "bpm": "124.025", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "404280", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Anyone.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/contactus_Image.png", "user_like": "True", "like_count": 1, "spotify_id": "4qJVEovuJ0Oezit9lEzodQ", "music_title": "Almost Famous", "user_dislike": "False", "dislike_count": 0, "music_duration": "4:29", "licenced_status": 1}]	2022-07-04	2 Chainz	2 Dollar Bill (feat. Lil Wayne, E-40)
867d70d4-99ab-4b00-8981-2550593fdc77	6906c7df-8e12-46b1-bfec-9e473f1022f0	5	925	[{"id": "a5df2da4-2eb9-4631-acb9-8cbfa49bedf8", "bpm": "101.986", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "194100", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Aparshakti Khurana_ Balle Ni Balle _ Dhanashree VC _ Siddharth AB _ Gurpreet S _ Official Video.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/Record-Album-02 (1).jpg", "user_like": "False", "like_count": 1, "spotify_id": "2BN5ZMErVAhbEroB99b3no", "music_title": "10 Toes", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:48", "licenced_status": 0}]	2022-07-04	Justin Bieber	2 Much
fdcbdd43-d810-4418-b84e-95f0062967c9	6906c7df-8e12-46b1-bfec-9e473f1022f0	5	925	[{"id": "a5df2da4-2eb9-4631-acb9-8cbfa49bedf8", "bpm": "101.986", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "194100", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Aparshakti Khurana_ Balle Ni Balle _ Dhanashree VC _ Siddharth AB _ Gurpreet S _ Official Video.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/Record-Album-02 (1).jpg", "user_like": "False", "like_count": 1, "spotify_id": "2BN5ZMErVAhbEroB99b3no", "music_title": "10 Toes", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:48", "licenced_status": 0}]	2022-07-04	Justin Bieber	2 Much
c5467111-7562-4f4d-8e11-0a63bb9807b1	6906c7df-8e12-46b1-bfec-9e473f1022f0	5	925	[{"id": "5361ce8c-be44-4fb0-a501-b7f86563c0bb", "bpm": "160.221", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "169530", "audio_url": "https://ktizo-prod.s3.amazonaws.com/G_Eazy_-_All_Facts_Lyrics_Ft_Ty_(getmp3.pro).mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/bridesmaids-img1.jpg", "user_like": "False", "like_count": 0, "spotify_id": "19TWdlPoMYhyWKEUDE6xRx", "music_title": "All Facts (feat. Ty Dolla $ign)", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:01", "licenced_status": 0}, {"id": "a5df2da4-2eb9-4631-acb9-8cbfa49bedf8", "bpm": "101.986", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "194100", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Aparshakti Khurana_ Balle Ni Balle _ Dhanashree VC _ Siddharth AB _ Gurpreet S _ Official Video.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/Record-Album-02 (1).jpg", "user_like": "False", "like_count": 1, "spotify_id": "2BN5ZMErVAhbEroB99b3no", "music_title": "10 Toes", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:48", "licenced_status": 0}]	2022-07-04	Justin Bieber	2 Much
9cd9a8fe-6c53-4d7a-a75d-ae244d2c169b	6906c7df-8e12-46b1-bfec-9e473f1022f0	5	925	[{"id": "5361ce8c-be44-4fb0-a501-b7f86563c0bb", "bpm": "160.221", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "169530", "audio_url": "https://ktizo-prod.s3.amazonaws.com/G_Eazy_-_All_Facts_Lyrics_Ft_Ty_(getmp3.pro).mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/bridesmaids-img1.jpg", "user_like": "True", "like_count": 1, "spotify_id": "19TWdlPoMYhyWKEUDE6xRx", "music_title": "All Facts (feat. Ty Dolla $ign)", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:01", "licenced_status": 1}, {"id": "a5df2da4-2eb9-4631-acb9-8cbfa49bedf8", "bpm": "101.986", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "194100", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Aparshakti Khurana_ Balle Ni Balle _ Dhanashree VC _ Siddharth AB _ Gurpreet S _ Official Video.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/Record-Album-02 (1).jpg", "user_like": "False", "like_count": 1, "spotify_id": "2BN5ZMErVAhbEroB99b3no", "music_title": "10 Toes", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:48", "licenced_status": 0}]	2022-07-05	Justin Bieber	2 Much
9e33bad6-43f6-42fa-a450-3c30261bed46	6906c7df-8e12-46b1-bfec-9e473f1022f0	5	925	[{"id": "5361ce8c-be44-4fb0-a501-b7f86563c0bb", "bpm": "160.221", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "169530", "audio_url": "https://ktizo-prod.s3.amazonaws.com/G_Eazy_-_All_Facts_Lyrics_Ft_Ty_(getmp3.pro).mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/bridesmaids-img1.jpg", "user_like": "True", "like_count": 1, "spotify_id": "19TWdlPoMYhyWKEUDE6xRx", "music_title": "All Facts (feat. Ty Dolla $ign)", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:01", "licenced_status": 1}, {"id": "a5df2da4-2eb9-4631-acb9-8cbfa49bedf8", "bpm": "101.986", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "194100", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Aparshakti Khurana_ Balle Ni Balle _ Dhanashree VC _ Siddharth AB _ Gurpreet S _ Official Video.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/Record-Album-02 (1).jpg", "user_like": "True", "like_count": 2, "spotify_id": "2BN5ZMErVAhbEroB99b3no", "music_title": "10 Toes", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:48", "licenced_status": 1}]	2022-07-05	Justin Bieber	2 Much
246ca6d6-6872-4c81-8ac0-fb7b0f03b553	6906c7df-8e12-46b1-bfec-9e473f1022f0	5	925	[{"id": "5361ce8c-be44-4fb0-a501-b7f86563c0bb", "bpm": "160.221", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "169530", "audio_url": "https://ktizo-prod.s3.amazonaws.com/G_Eazy_-_All_Facts_Lyrics_Ft_Ty_(getmp3.pro).mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/bridesmaids-img1.jpg", "user_like": "True", "like_count": 1, "spotify_id": "19TWdlPoMYhyWKEUDE6xRx", "music_title": "All Facts (feat. Ty Dolla $ign)", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:01", "licenced_status": 1}, {"id": "a5df2da4-2eb9-4631-acb9-8cbfa49bedf8", "bpm": "101.986", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "194100", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Aparshakti Khurana_ Balle Ni Balle _ Dhanashree VC _ Siddharth AB _ Gurpreet S _ Official Video.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/Record-Album-02 (1).jpg", "user_like": "True", "like_count": 2, "spotify_id": "2BN5ZMErVAhbEroB99b3no", "music_title": "10 Toes", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:48", "licenced_status": 1}]	2022-07-05	Justin Bieber	2 Much
079fd6d9-406c-4990-8e47-09d789d01bab	6906c7df-8e12-46b1-bfec-9e473f1022f0	272	65414	[{"id": "ada103db-5b4a-486c-af75-295a0bf0925b", "bpm": "87.016", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "343542", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Aparshakti Khurana_ Balle Ni Balle _ Dhanashree VC _ Siddharth AB _ Gurpreet S _ Official Video.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/wallpaperflare.com_wallpaper.jpg", "user_like": "False", "like_count": 0, "spotify_id": "1waruKeJtERqtrboAlxijk", "music_title": "A Little More (feat. Kiana Ledé)", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:33", "licenced_status": 0}]	2022-07-05	G-Eazy	10 Toes
e22c5b33-42ee-4236-b834-9cba7ff76240	ce8ee1fa-bd89-4d00-9d99-b3a9fe69fb2a	5	925	[{"id": "5361ce8c-be44-4fb0-a501-b7f86563c0bb", "bpm": "160.221", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "169530", "audio_url": "https://ktizo-prod.s3.amazonaws.com/G_Eazy_-_All_Facts_Lyrics_Ft_Ty_(getmp3.pro).mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/bridesmaids-img1.jpg", "user_like": "False", "like_count": 1, "spotify_id": "19TWdlPoMYhyWKEUDE6xRx", "music_title": "All Facts (feat. Ty Dolla $ign)", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:01", "licenced_status": 0}, {"id": "a5df2da4-2eb9-4631-acb9-8cbfa49bedf8", "bpm": "101.986", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "194100", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Aparshakti Khurana_ Balle Ni Balle _ Dhanashree VC _ Siddharth AB _ Gurpreet S _ Official Video.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/Record-Album-02 (1).jpg", "user_like": "False", "like_count": 2, "spotify_id": "2BN5ZMErVAhbEroB99b3no", "music_title": "10 Toes", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:48", "licenced_status": 0}]	2022-07-06	Justin Bieber	2 Much
5bf5ee7c-0ec2-4d5b-8bfd-1d485cff1342	ce8ee1fa-bd89-4d00-9d99-b3a9fe69fb2a	5	925	[{"id": "5361ce8c-be44-4fb0-a501-b7f86563c0bb", "bpm": "160.221", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "169530", "audio_url": "https://ktizo-prod.s3.amazonaws.com/G_Eazy_-_All_Facts_Lyrics_Ft_Ty_(getmp3.pro).mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/bridesmaids-img1.jpg", "user_like": "False", "like_count": 1, "spotify_id": "19TWdlPoMYhyWKEUDE6xRx", "music_title": "All Facts (feat. Ty Dolla $ign)", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:01", "licenced_status": 0}, {"id": "a5df2da4-2eb9-4631-acb9-8cbfa49bedf8", "bpm": "101.986", "genre": "pop", "status": 1, "user_id": "2491764d-dd64-417d-9704-51a085fd6c83", "track_id": "194100", "audio_url": "https://ktizo-prod.s3.amazonaws.com/Aparshakti Khurana_ Balle Ni Balle _ Dhanashree VC _ Siddharth AB _ Gurpreet S _ Official Video.mp3", "image_url": "https://ktizo-prod.s3.amazonaws.com/Record-Album-02 (1).jpg", "user_like": "False", "like_count": 2, "spotify_id": "2BN5ZMErVAhbEroB99b3no", "music_title": "10 Toes", "user_dislike": "False", "dislike_count": 0, "music_duration": "3:48", "licenced_status": 0}]	2022-07-25	Justin Bieber	2 Much
\.


--
-- Data for Name: song_ratings; Type: TABLE DATA; Schema: public; Owner: ktizo
--

COPY public.song_ratings (id, song_id, reviewer_id, rate) FROM stdin;
\.


--
-- Data for Name: upload_user_files; Type: TABLE DATA; Schema: public; Owner: ktizo
--

COPY public.upload_user_files (id, s3_file_url, filename, user_id) FROM stdin;
82ca90ff-8886-4df0-913c-89e0ec26328e	https://ktizo-dev.s3.amazonaws.com/0cd24b0d-2c87-44e7-b991-33317f83ace6/audio/origin_Akella - Serezhadelal - EMPTYROOM.mp3	origin_Akella - Serezhadelal - EMPTYROOM.mp3	0cd24b0d-2c87-44e7-b991-33317f83ace6
4ba63eb7-48c2-4e0d-ab9b-372471521610	https://ktizo-dev.s3.amazonaws.com/0cd24b0d-2c87-44e7-b991-33317f83ace6/audio/instrumental_Akella - Serezhadelal - EMPTYROOM.mp3	instrumental_Akella - Serezhadelal - EMPTYROOM.mp3	0cd24b0d-2c87-44e7-b991-33317f83ace6
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: ktizo
--

COPY public."user" (id, full_name, email, password, age, spotify_artist_profile, favourite_music_style, favourite_music_mood, yourown_music, favourite_music_topic, master, publish_control, outside_income, established_artist, company, linkedin_profile, project_seek_music, turn_around_time, project_budject, syncs_seek, token, user_role, spotify_user_id, legal_name, profile_pic, about_me, music_rating, song_writer, own_masters, music_publishing, music_publishing_owners, master_recording, master_recording_owners, spotify_user_name, account_id, active_status, coupon_code, coupon_status, coupon_created_date) FROM stdin;
2491764d-dd64-417d-9704-51a085fd6c83	Test-Xminds	testxminds@xminds.com	$2b$12$SpCGIQr/Jsy66DRlvYcyW.sBPoeNPRqlPJOCpPoSlf7kyIJO7lJaW	\N	https://open.spotify.com/artist/02kJSzxNuaWGqwubyUba0Z	Country	Billboards Radio Hits	\N	\N	\N	\N	no	Justin	\N	\N	\N	\N	\N	\N	\N	Artist	272	Test-Xminds	https://ktizo-prod.s3.amazonaws.com/profile_pic/Record-Album-02.jpg	\N	4.5	[{"writer_Pro": "SESAC", "IPI/CAE Number": "1213"}]	[{"pro": "ASCAP", "publisher": "1213", "publisher_name": "test"}]	yes	null	yes	null	02kJSzxNuaWGqwubyUba0Z	acct_1LFa1MRjdiGiGNnX	0	\N	\N	\N
60d34088-3b0e-443a-b931-732951a50e3c	Malcolm	malcolm.coronel@gmail.com	$2b$12$okDmf2YreV1EP9SrONpY7e3uSxYxZ7xz6QABsttlnh3AFbwtmP33O	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Uncut Gems	https://www.linkedin.com/in/malcolm-paul-coronel/	TV	1-3 days	$2.5k - $5k per sync	1 - 5 Syncs for this project	\N	Music Supervisor	\N	\N	https://ktizo-prod.s3.amazonaws.com/profile_pic/Headshot.jpg	Music Supervisor	\N	null	null	\N	null	\N	null	\N	\N	0	\N	\N	\N
e42309c1-d1a8-4f84-9891-aa63c4f37ab0	Malcolm Paul Coronel	malcyyymalc@gmail.com	$2b$12$riOI8BN3QNvLwJAle.h/9uxfxbU/BaqQYCPCmXRkELgjpCMIA2PAm	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Infinite Paradise Inc.	https://www.linkedin.com/in/malcolm-paul-coronel/	Test	1-3 days	$2.5k - $5k per sync	1 - 5 Syncs for this project	\N	Music Supervisor	\N	\N	\N	\N	\N	null	null	\N	null	\N	null	\N	\N	0	\N	\N	\N
603ce6a5-2075-4e19-98a6-155457828ef7	Paul Water	paulwatermusic@gmail.com	$2b$12$MTRgjm5Ea00xFe7uB.1XAOy7Gk.SzinRxiLnEm2CglSquROJlZTGW	\N	https://open.spotify.com/artist/3ZffOsXVWPXYnHbttabyuA?si=RemJ9p7cRK61A9_PKXvQfw	Dance/Electronic	Chill	\N	\N	\N	\N	no	Calvin Harris	\N	\N	\N	\N	\N	\N	\N	Artist	1805	Malcolm Coronel	\N	\N	5	[{"writer_Pro": "ASCAP", "IPI/CAE Number": "574077628"}]	[{"pro": "ASCAP", "publisher": "851254349", "publisher_name": "Infinite Paradise Ent."}]	yes	null	yes	null	3ZffOsXVWPXYnHbttabyuA	\N	0	\N	\N	\N
3bd20b10-0613-499d-9190-a8d30c8c11c8	Arjith Singh	alfin+arjith@xmind.com	$2b$12$pzPcsCp3v2RshpKEGGrpY.9sOQUmETSF1tBKQ9iJ5/LABy8jfMlVm	\N	https://open.spotify.com/artist/4YRxDV8wJFPHPTeXepOstw	Country	Billboards Radio Hits	\N	\N	\N	\N	yes	ioohlkjl	\N	\N	\N	\N	\N	\N	\N	Artist	69	Arjith Singh	\N	testing	4	[{"writer_Pro": "SESAC", "IPI/CAE Number": "1234"}]	[{"pro": "SESAC", "publisher": "1234", "publisher_name": "Arjith"}]	yes	null	yes	null	4YRxDV8wJFPHPTeXepOstw	\N	1	\N	\N	\N
13f41942-0d6c-4739-865d-c7da18191ca9	Testing-Supervisor	testing@xminds.com	$2b$12$3DwV3ilKYyBmFY5fArOGCe3ZE6tF1z7EXqoLk1Kl2R3JDhaR7Nt1K	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	test	test	test	Less than 24 hours	$2.5k or below per sync	1 Sync for this project	\N	Music Supervisor	\N	\N	\N	\N	\N	null	null	\N	null	\N	null	\N	\N	0	\N	\N	\N
8ea1f144-81e1-4d3e-9ee5-61715b5f29e2	User	anandhu.anil@xminds.com	$2b$12$g.z5QFC.nKs5xv1Ups25yu99gumxh7bKBaQ4.P0h34G1y6GgWzs.a	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	test-user	test	test	Less than 24 hours	$2.5k or below per sync	1 Sync for this project	\N	Music Supervisor	\N	\N	\N	\N	\N	null	null	\N	null	\N	null	\N	\N	0	\N	\N	\N
6906c7df-8e12-46b1-bfec-9e473f1022f0	Test-Supervisor-Xminds	testsupervisorxminds@xminds.com	$2b$12$4YvkX/6nl2P2dQWlIDHZSOxsfGmNrWdKzA3HHG2OMdq1q5Jhnqt/a	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Xminds	Test-Supervisor-Xminds	Ktizo	Less than 24 hours	$2.5k or below per sync	1 Sync for this project	\N	Music Supervisor	\N	\N	\N	\N	\N	null	null	\N	null	\N	null	\N	\N	0	\N	\N	\N
0e16ac26-f71b-4188-b3fa-dd40afe5b3b1	Test Xminds	renjithr@xminds.com	$2b$12$a78lWxRtWiNl/.ORMNvNn.gJotS9ZMN3Nb3AMgYbUW4sIQd7UY6BK	\N	https://open.spotify.com/artist/3ZffOsXVWPXYnHbttabyuA	Country	Billboards Radio Hits	\N	\N	\N	\N	yes	Test Xminds	\N	\N	\N	\N	\N	\N	\N	Artist	1805	Test Xminds	\N	\N	4.5	[{"writer_Pro": "SESAC", "IPI/CAE Number": "1212121212"}]	[{"pro": "Test", "publisher": "12121212", "publisher_name": "Test"}]	yes	null	yes	null	3ZffOsXVWPXYnHbttabyuA	\N	1	\N	\N	\N
d8f4e48a-8cc6-42a8-acf7-03006b2f57a6	test-Xminds	test@xminds.com	$2b$12$yAjT2NSKVzbDG4e6OSS0lua6c.JMWPibJxPSgGEm/3K0kOnh.HH4.	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	test	test	adore you	1-3 days	$2.5k - $5k per sync	1 - 5 Syncs for this project	\N	Music Supervisor	\N	\N	\N	\N	\N	null	null	\N	null	\N	null	\N	\N	0	\N	\N	\N
9a142be4-6dca-4c9f-a6d8-88667d3a1282	Test xminds	xminds123@gmail.com	$2b$12$a3oXMcU9OKkTgkT0K3dwBOvq56XgKhfpuPmf9i955vE3fNi5lVaTa	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Xminds	Xminds	Test	Less than 24 hours	$2.5k or below per sync	1 Sync for this project	\N	Music Supervisor	\N	\N	\N	\N	\N	null	null	\N	null	\N	null	\N	\N	0	\N	\N	\N
ce8ee1fa-bd89-4d00-9d99-b3a9fe69fb2a	Test-Supervisor	testsupervisor@xminds.com	$2b$12$ie1v7iBQUup5..O0gt1u9.73KgCCNv6gQFetWoDtAxAdw8te53MCC	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	test	test	test	Less than 24 hours	$2.5k or below per sync	1 Sync for this project	\N	Music Supervisor	\N	\N	\N	\N	\N	null	null	\N	null	\N	null	\N	\N	0	\N	\N	\N
021b5e4a-53fc-44af-bc5a-13dd4a35613b	Test-Xminds	testxminds123@gmail.com	$2b$12$mBraHr5HtkJNhhi00q.sUOUBV6psanKyTzbk087SIJtr8AcDTGoAW	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Xminds-India	Test-Xminds	Test	Less than 24 hours	$2.5k or below per sync	1 Sync for this project	\N	Music Supervisor	\N	\N	\N	\N	\N	null	null	\N	null	\N	null	\N	\N	0	\N	\N	\N
a3a1bd14-c408-45ce-b0cc-2fa36d24c9ce	Deep Veronika	house.labs@gmail.com	$2b$12$kbZNqb/hjeQE1v7FWC5PO.1EGAGi8tr.B0/HXO6MgEpCQG70vsj4m	\N	https://open.spotify.com/artist/6FXMGgJwohJLUSr5nVlf9X	Dance/Electronic	Sad	\N	\N	\N	\N	yes	Portishead	\N	\N	\N	\N	\N	\N	\N	Artist	1810	Deep Veronika	\N	\N	5	[{"writer_Pro": "BMI", "IPI/CAE Number": "123"}]	[{"pro": "123123", "publisher": "123123", "publisher_name": "Deep Veronika"}]	yes	null	yes	null	6FXMGgJwohJLUSr5nVlf9X	\N	0	\N	0	2022-08-22 07:03:55
228532c2-47e2-4c28-b459-65cefd516038	Willie Waters	williewaters.dbd@gmail.com	$2b$12$IIrapy.DfR4DdcY8NLKQoeKQorFR2J686p/AFzypWhgXxMzqHwROm	\N	https://open.spotify.com/artist/3fYkYpeCG07mFndaeBzNYh	Hip-Hop	Billboards Radio Hits	\N	\N	\N	\N	yes	Drake	\N	\N	\N	\N	\N	\N	\N	Artist	1809	Willmore Stuart	\N	\N	0	[{"writer_Pro": "BMI", "IPI/CAE Number": "01025749561"}]	[{"pro": "BMI", "publisher": "01039195846", "publisher_name": "DBD Entertainment Publishing"}]	yes	null	yes	null	3fYkYpeCG07mFndaeBzNYh	\N	0	BUILD50	0	2022-08-05 21:09:11
4286ae97-ad8c-4c66-af6b-a2deac0dd614	Alastar Corr	house.labs@yandex.ru	$2b$12$Z9BPWqcyLgSuelVstMBeUuwjfbZi3qqVwUiF5tu1w4RTVoAu3evee	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	MadBear	https://linkedin.con/carboninc	Carbon Inc	1-2 weeks	$2.5k - $5k per sync	1 - 5 Syncs for this project	\N	Music Supervisor	\N	\N	\N	\N	\N	null	null	\N	null	\N	null	\N	\N	0	\N	0	2022-08-22 07:17:01
214e1202-a9ed-439c-8dcb-1dc73fadec0c	Farah Ash	farahuniverse@gmail.com	$2b$12$uDg0LPmQmreztaVPR2jXme1lFGcdZPhBASONifNJ9wLlUJWWUwyXe	\N	https://open.spotify.com/artist/7ITra5TrWubSoTrjGdLcNH?si=yZO8ocsxRtGvwt31KZkdzQ	Pop	Billboards Radio Hits	\N	\N	\N	\N	no	Rihanna	\N	\N	\N	\N	\N	\N	\N	Artist	1811	Farah Achour	\N	\N	5	[{"writer_Pro": "BMI", "IPI/CAE Number": "638289310"}]	[{"pro": "BMI", "publisher": "754148826", "publisher_name": "Farahuniverse Music Publishing"}]	yes	null	yes	null	7ITra5TrWubSoTrjGdLcNH	\N	0	BUILD50	0	2022-09-01 16:35:05
d573331f-b924-44bc-8799-e66bf7ff6ac7	admin	malcolm@ktizo.io	$2b$12$M/H7laTir7nEHzQIykU15OsCSFeYkIeyCOWwIitv2kPt3384AxVvK	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	\N
ea9f5354-7e3f-44d2-bb29-6d9f4f26c09d	Highrise.	chane.eckhardt@gmail.com	$2b$12$Q30MxVfEGO.mlBd15gnjZuniGo6nnHRdfF5nhABfJKQw84L7WYut2	\N	https://open.spotify.com/artist/0mEysEsEHho2zxpPE0HbgZ?si=6cSE41TDRbuXrOf8riaPUw	Dance/Electronic	Chill	\N	\N	\N	\N	yes	Idealism	\N	\N	\N	\N	\N	\N	\N	Artist	1812	Chane Eckhardt	\N	\N	0.5	[{"writer_Pro": "BMI", "IPI/CAE Number": "01132909374"}]	[{"pro": "551031007", "publisher": "01132909374", "publisher_name": "Highrise."}]	yes	null	yes	null	0mEysEsEHho2zxpPE0HbgZ	\N	0	\N	0	2022-09-10 19:13:50
57a0c49d-704f-4314-9d98-e74bdcdfbbea	Tai Nguyen	nguyentritai96@gmail.com	$2b$12$v7pGRXFi8yGUCYNsjohZl.PnMT6tf/mNPuBpZHI53j5eHwrPe4Hvu	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TaiNguyen	https://www.ktizo.io/registration/supervisor	xxx	Less than 24 hours	$2.5k or below per sync	1 Sync for this project	\N	Music Supervisor	\N	\N	\N	\N	\N	null	null	\N	null	\N	null	\N	\N	0	\N	0	2022-09-20 02:02:48
4733eb87-18f5-4a9b-9973-a8f6d954f235	Nguyễn Văn Tường	tuongnguyen@beeknights.com	$2b$12$QNZVNr.yUhP0/yWo41fzDOHONC2bhrYQEKh3ImZ0oGyxA0rfKJ/P.	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Ftech	linkedin.com/in/nguyễn-tường-214038143/	pop right now	Less than 24 hours	$2.5k or below per sync	1 Sync for this project	\N	Music Supervisor	\N	\N	\N	\N	\N	null	null	\N	null	\N	null	\N	\N	0	\N	0	2022-09-21 16:42:59
376e4a78-8880-4d58-8015-d6714227e24f	Ally Ahern	allyahernmusic@gmail.com	$2b$12$a4qdyVnlWbmwLLW2q6Mi2uztjqbp2OPV16zkFfJs1PpauWwaTt16u	\N	https://open.spotify.com/artist/4RSgbf1zgR2X2APEbTqxbM?si=Y-NG2356SQ6MDfv_5ja-QQ	Pop	Billboards Radio Hits	\N	\N	\N	\N	no	Ashnikko, Melanie Martinez, Mia Rodriguez	\N	\N	\N	\N	\N	\N	\N	Artist	1813	Alexandra Logan Ahern	\N	\N	5	[{"writer_Pro": "BMI", "IPI/CAE Number": "845245137"}]	[{"pro": "Unsure", "publisher": "653581923", "publisher_name": "Honua Songs"}]	no	[{"name": "Honua Songs", "percentage": "50%"}]	yes	null	4RSgbf1zgR2X2APEbTqxbM	\N	0	\N	0	2022-10-09 00:09:18
f4fa08bb-6f0e-47c2-ab0e-052d5ead332f	Davis	dunc.h.davis@gmail.com	$2b$12$eAgKHShik8HxAm2tzmzQEOrZbBrC20V1QHNdkc7a5QcJKg2m6XBDS	\N	https://open.spotify.com/artist/1UMFvfUUhddeehpyd7D8dw?si=N7-StuYUR0GdhweK1FXVxA	R&B-Hop	Billboards Radio Hits	\N	\N	\N	\N	yes	Drake, Justin Bieber, Post Malone, Bryson Tiller	\N	\N	\N	\N	\N	\N	\N	Artist	1815	Duncan Davis	\N	\N	0	[{"writer_Pro": "ASCAP", "IPI/CAE Number": "869022224"}]	[{"pro": "Distrokid", "publisher": "395529515", "publisher_name": "DuncanDavisLLC"}]	yes	null	yes	null	1UMFvfUUhddeehpyd7D8dw	\N	0	\N	0	2022-10-22 04:23:23
fb13fc89-958e-4a57-835c-f19de2dbc185	Camryn Levert	info@serenityprojectsmgmt.com	$2b$12$F.af6rQyAxYnu.qo6wGEIOOdc0w2tgzhKxLgWKzSDxDDv/NpRkS16	\N	https://open.spotify.com/artist/2HtNeBOFredlrp4D0LLyLB?si=BE9PHGHzQ_a0oTImXl5wPw	R&B-Hop	Feel Good	\N	\N	\N	\N	no	Victoria Monet, SZA, Ariana Grande, H.E.R, RAYE	\N	\N	\N	\N	\N	\N	\N	Artist	1865	Camryn Levert	\N	\N	4	[{"writer_Pro": "BMI", "IPI/CAE Number": "550568305"}]	[{"pro": "n/a", "publisher": "n/a", "publisher_name": "Unpublished"}]	yes	null	no	[{"name": "Serenity Projects", "percentage": "66%"}]	2HtNeBOFredlrp4D0LLyLB	\N	0	\N	0	2022-12-12 15:48:15
603cf6ab-d2d8-463a-a698-ebd7a5f57445	Gavin Long	glong661@gmail.com	$2b$12$LHhP9OzQ48cVuvPB9QUJS.VXBooH0sBO/rP706kqUrml.qvXsDE2m	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Bunim-Murray Productions	Gavin Long	Test 1	1 week	$5k - $10k per sync	5 Syncs or more for this project	\N	Music Supervisor	\N	\N	\N	\N	\N	null	null	\N	null	\N	null	\N	\N	0	\N	0	2022-12-13 02:59:27
0cd24b0d-2c87-44e7-b991-33317f83ace6	Dev Ktizovych	info@ktizo.io	$2b$12$Y005KYV7Dm1HpD8VR0w4h.oGOaE4r8faLUsygiMtsAc.ZlkkfBj.C	23	12312312123123	Pop	Billboards Radio Hits	\N	\N	\N	\N	no	Chris Brown	My Comany	https://www.linkedin.com/in/mjcarps/	test field	1 week	$5k - $10k per sync	5 Syncs or more for this project	\N	Artist	1802	1111	https://ktizo-prod.s3.amazonaws.com/profile_pic/Экран для захвата проходящих людей на квадролайте на лыжах_Страница_1.jpg	Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque imperdiet orci sed maximus efficitur. Suspendisse accumsan hendrerit lorem id facilisis. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Aenean luctus, orci nec malesuada consequat, mauris d	3	[{"writer_Pro": "ASCAP", "IPI/CAE Number": "873987662"}]	[{"pro": "ASCAP", "publisher": "853844213", "publisher_name": "Patrick Group"}]	yes	null	yes	null	1N9NZiOruq1d1fMdpYuwwg	\N	0	BUILD51	1	2022-12-28 09:45:25
f585d291-a2b0-46f9-a736-1b7e3ff2a6e4	Dope Swope	swopeworks@gmail.com	$2b$12$jeaDtv/9CWGcL9teUr.rueSvwEkrfPNqOHFj2rhOLMw.Sn3zoQVSm	\N	https://open.spotify.com/artist/3MlTcfd81zET98jRujQOjO?si=OXojiYNZQHyXomfDzFn32Q	Hip-Hop	Party	\N	\N	\N	\N	yes	Jack Harlow	\N	\N	\N	\N	\N	\N	\N	Artist	1806	Michael Swope Jr	\N	\N	5	[{"writer_Pro": "BMI", "IPI/CAE Number": "\\t00865192117"}]	[{"pro": "BMI", "publisher": "\\t00865192117", "publisher_name": "Michael Swope JR"}]	yes	null	yes	null	3MlTcfd81zET98jRujQOjO	\N	0	\N	\N	\N
10729eb6-e6d4-4e95-8306-070dfbd2a851	Emalia	emaliamusic@outlook.com	$2b$12$pkcjCr0Hl7nNtv67WRc08.mCLH0OaWqLG6BZTsEA251y/3gSqkovO	\N	https://open.spotify.com/artist/1viII7jjCuXSzJdO59FJYv?si=p-eXxvTYRFS1caeoYuSPeg	R&B-Hop	Billboards Radio Hits	\N	\N	\N	\N	yes	TAYLOR SWIFT	\N	\N	\N	\N	\N	\N	\N	Artist	1814	Emilia Burford	https://ktizo-prod.s3.amazonaws.com/profile_pic/Untitled design (1).png	Creative power house Emalia is an empowered female RNB/Pop artist from Australia. Hailed as the nation’s “new RNB princess on the rise”, Emalia is defined by her unique musical identity, ultra-confident persona and a voice with the prowess of SZA, Ella Mai and Summer Walker.	5	[{"writer_Pro": "ASCAP", "IPI/CAE Number": "00650805848"}]	[{"pro": "APRA AMCOS", "publisher": "00650805848", "publisher_name": "EMALIA"}]	yes	null	no	[{"name": "SONY MUSIC AUSTRALIA", "percentage": "100"}]	1viII7jjCuXSzJdO59FJYv	\N	0	BUILD50	0	2022-10-13 00:11:02
3342a03a-1e40-406d-bbf9-a39c06495b6c	Mike Carpenter	mike@passionflix.com	$2b$12$JkPiCy.c.C943E6JxP0ACeQHNERetJOJDr9usyn0fNHtO9jN/xazu	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Passionflix	https://www.linkedin.com/in/mjcarps/	SL of AB	1-3 days	$2.5k or below per sync	1 - 5 Syncs for this project	\N	Music Supervisor	\N	\N	\N	\N	\N	null	null	\N	null	\N	null	\N	\N	0	\N	0	2022-10-20 21:51:10
d3ec0af9-e8c9-4ec3-adea-62aa4ad5b602	ivan	tkachukione@gmail.com	$2b$12$/w9hKw6.pbinST6ENDew4OMn/U2Rsug58jOztHI4UkKcAp95doHye	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	ivan	https://www.linkedin.com/in/ivan-tkachuk-54903420a/	ivan	Less than 24 hours	$2.5k or below per sync	1 Sync for this project	\N	Music Supervisor	\N	\N	\N	\N	\N	null	null	\N	null	\N	null	\N	\N	0	\N	0	2022-11-26 12:15:20
d01194dd-49ff-401a-9d1e-e7a7f471e3a3	ivan	ivan.tkachuk@smartteksas.com	$2b$12$84LNRCnUx3qgJsLYwBiWAeqenWVjOCA7.zF3OKEiPWqykCu0GCSpC	\N	https://open.spotify.com/artist/6wWVKhxIU2cEi0K81v7HvP	Rock	Feel Good	\N	\N	\N	\N	yes	asdad	\N	\N	\N	\N	\N	\N	\N	Artist	1750	Tkachuk	https://ktizo-prod.s3.amazonaws.com/profile_pic/4116455578-1f8d781f66-b_article_column@2x.jpg	\N	4.5	[{"writer_Pro": "ASCAP", "IPI/CAE Number": "1231231"}]	[{"pro": "12312", "publisher": "12321", "publisher_name": "adasdasd"}]	yes	null	yes	null	6wWVKhxIU2cEi0K81v7HvP	\N	0	\N	0	2022-12-05 00:35:06
475b81c9-b7c2-4dfc-bad3-f575bc71006b		godzila7606@gmail.com	$2b$12$mfldJ8lo5920kG6YIojaSeFNkUWWXRMGclM9V9bAQc08S1iE.Jrwy	\N	\N	Country	Billboards Radio Hits	\N	\N	\N	\N	no	asdasd	\N	\N	\N	\N	\N	\N	\N	Artist	\N	godzila7606@gmail.com	\N	\N	4	[{"writer_Pro": "SESAC", "IPI/CAE Number": "adad"}]	[{"pro": "ads", "publisher": "asdasda", "publisher_name": "adasd"}]	yes	null	yes	null	\N	\N	0	\N	0	2022-12-24 09:16:06
a0a0a069-7a3e-4975-850c-e637549fcf32		ivan.tkachuk1@smartteksas.com	$2b$12$B4bmcTy6s9vyVvejLK9kQeJj/0A3/NvmRPAtgUbKx/wfb/p8fFEMW	\N	\N			\N	\N	\N	\N			\N	\N	\N	\N	\N	\N	\N	Artist	\N	ivan.tkachuk1@smartteksas.com	\N	\N	0	[{"writer_Pro": "writer_pro", "IPI/CAE Number": "ivan.tkachuk1@smartteksas.com"}]	[{"pro": "ivan.tkachuk1@smartteksas.com", "publisher": "ivan.tkachuk1@smartteksas.com", "publisher_name": "ivan.tkachuk1@smartteksas.com"}]	yes	null	yes	null	\N	\N	0	\N	0	2022-12-24 09:41:56
1353416a-7460-4da6-923f-faf81f3df486	formLabelRadio@gmail.com	formLabelRadio@gmail.com	$2b$12$V9RPcXWdYVj7QtgoXBjKeuUOHejwuc.pGa6ySLnLgJLRrw3uyYfuW	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	formLabelRadio@gmail.com	formLabelRadio@gmail.com	formLabelRadio@gmail.com	1 week	$2.5k - $5k per sync	1 - 5 Syncs for this project	\N	Music Supervisor	\N	\N	\N	\N	\N	null	null	\N	null	\N	null	\N	\N	0	\N	0	2022-12-26 04:38:24
f95a04b1-6aef-41ac-9556-d714e9814d67	asdsadasdsda@gmail.com	asdsadasdsda@gmail.com	$2b$12$tKvXQRwr8vYEWRP6VjhHjudpN/yzCCqw34Fu4iBZCsiy.j87.RDyi	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	asdsadasdsda@gmail.com	asdsadasdsda@gmail.com	asdsadasdsda@gmail.com	1-2 weeks	$2.5k - $5k per sync	1 Sync for this project	\N	Music Supervisor	\N	\N	\N	\N	\N	null	null	\N	null	\N	null	\N	\N	0	\N	0	2022-12-26 06:52:18
8c2fc378-e87f-4ea5-a1e5-bb63cda89f77	ddasdasd	godzila76adasdada06@gmail.com	$2b$12$C3lTHBQ4xq/ylwU/a2Qd1uvNbp22j6MibbPZjYR.Sj7sEfgv8Dfly	\N				\N	\N	\N	\N			\N	\N	\N	\N	\N	\N	\N	Artist	\N	godzila76adasdada06@gmail.com	\N		0	[{"pro": "", "publisher": "", "publisher_name": ""}]	[{"pro": "", "publisher": "", "publisher_name": ""}]	yes	null	yes	null	\N	\N	0	\N	0	2022-12-28 12:48:53
ec5ca61f-726f-4f07-8d91-9ef9e5421fe6	godzila76adasdadasdaa06@gmail.com	godzila76adasdadasdaa06@gmail.com	$2b$12$4mQDD1ESzUUgiokDLNYVG.fVcyXWxSt9wy8hINuhmAZY8S9wqpAEG	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	godzila76adasdadasdaa06@gmail.com	godzila76adasdadasdaa06@gmail.com	qeqw	1 week	$5k - $10k per sync	1 - 5 Syncs for this project	\N	Music Supervisor	\N	\N	\N	\N	\N	null	null	\N	null	\N	null	\N	\N	0	\N	0	2022-12-28 12:51:09
aec8d003-e05f-408d-a88f-8bac6325b8fa	Test Testovych	mail@mail.com	$2b$12$JQ.62hORtyq0wZ7GN7KMIerjfamAchFrK2z.usnYBIAAE2Z45VzFG	21	www.string.com	pop	string	string	string	string	string	string	string	COMPANY	string	3231	222	123	string	string	string	string	string	\N	\N	string	["string"]	["string"]	string	["string"]	string	["string"]	Sting	\N	0	string	0	2023-01-04 11:18:51
8e4cd538-1b5a-4a17-a341-d8738e7ce83e	Andrii zaiko	Andrii.Zaiko@smartteksas.com	$2b$12$SXs2AomT6YBl2DM3f05wDuW4dHO3/prVjEdJnJ0kvecuUcGBH0s3C	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Andrii.Zaiko@smartteksas.com	Andrii.Zaiko@smartteksas.com	Andrii.Zaiko@smartteksas.com	1 month	$2.5k - $5k per sync	1 - 5 Syncs for this project	\N	Music Supervisor	\N	\N	\N	\N	\N	null	null	\N	null	\N	null	\N	\N	0	\N	0	2023-01-06 11:15:52
4c60157b-f540-4e97-a06c-0745d4c3772e		bclark288@gmail.com	$2b$12$aNXEE.p1xqqpma24589yge1EiZ1KUEtj.5467hqADYP3TeuoCL9y.	\N	\N			\N	\N	\N	\N			\N	\N	\N	\N	\N	\N	\N	Artist	\N	Beach Clark	\N	\N	0	[{"pro": "", "publisher": "", "publisher_name": ""}]	[{"pro": "", "publisher": "", "publisher_name": ""}]	no	[{"name": "", "percentage": ""}]	no	[{"name": "", "percentage": ""}]	\N	\N	0	\N	0	2023-01-10 13:30:39
\.


--
-- Data for Name: user_ratings; Type: TABLE DATA; Schema: public; Owner: ktizo
--

COPY public.user_ratings (id, reviewee_id, reviewer_id, rate) FROM stdin;
1873632c-c0fa-42ad-9904-d5a2bd1f5c0a	string	string	0
\.


--
-- Data for Name: withdrawal; Type: TABLE DATA; Schema: public; Owner: ktizo
--

COPY public.withdrawal (id, artist_id, amount, date, status, remarks) FROM stdin;
0cd24b0d-2c87-44e7-b991-33317f83ac21	0cd24b0d-2c87-44e7-b991-33317f83ace6	123	2022-12-01	1	test
0cd24b0d-2c87-44e7-b991-33317f83ac22	0cd24b0d-2c87-44e7-b991-33317f83ace6	124	2022-12-02	0	123
0cd24b0d-2c87-44e7-b991-33317f83ac23	0cd24b0d-2c87-44e7-b991-33317f83ace6	125	2022-12-03	1	remark
0cd24b0d-2c87-44e7-b991-33317f83ac24	0cd24b0d-2c87-44e7-b991-33317f83ace6	1223	2022-12-04	1	remark
0cd24b0d-2c87-44e7-b991-33317f83ac25	0cd24b0d-2c87-44e7-b991-33317f83ace6	223	2022-12-05	1	remark
0cd24b0d-2c87-44e7-b991-33317f83ac26	0cd24b0d-2c87-44e7-b991-33317f83ace6	221	2022-12-06	1	remark
0cd24b0d-2c87-44e7-b991-33317f83ac27	0cd24b0d-2c87-44e7-b991-33317f83ace6	2332	2022-12-07	0	remark
\.


--
-- Name: invoice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ktizo
--

SELECT pg_catalog.setval('public.invoice_id_seq', 13, true);


--
-- Name: payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ktizo
--

SELECT pg_catalog.setval('public.payment_id_seq', 22, true);


--
-- Name: Songs Songs_pkey; Type: CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public."Songs"
    ADD CONSTRAINT "Songs_pkey" PRIMARY KEY (id);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: contact_details contact_details_pkey; Type: CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.contact_details
    ADD CONSTRAINT contact_details_pkey PRIMARY KEY (id);


--
-- Name: count_likes count_likes_pkey; Type: CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.count_likes
    ADD CONSTRAINT count_likes_pkey PRIMARY KEY (id);


--
-- Name: email_details email_details_email_key; Type: CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.email_details
    ADD CONSTRAINT email_details_email_key UNIQUE (email);


--
-- Name: email_details email_details_pkey; Type: CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.email_details
    ADD CONSTRAINT email_details_pkey PRIMARY KEY (id);


--
-- Name: feedback feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.feedback
    ADD CONSTRAINT feedback_pkey PRIMARY KEY (id);


--
-- Name: invoice invoice_pkey; Type: CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.invoice
    ADD CONSTRAINT invoice_pkey PRIMARY KEY (id);


--
-- Name: licence licence_pkey; Type: CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.licence
    ADD CONSTRAINT licence_pkey PRIMARY KEY (id);


--
-- Name: my_earnings my_earnings_pkey; Type: CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.my_earnings
    ADD CONSTRAINT my_earnings_pkey PRIMARY KEY (id);


--
-- Name: notification notification_pkey; Type: CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (id);


--
-- Name: project project_pkey; Type: CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.project
    ADD CONSTRAINT project_pkey PRIMARY KEY (id);


--
-- Name: reset_password reset_password_email_key; Type: CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.reset_password
    ADD CONSTRAINT reset_password_email_key UNIQUE (email);


--
-- Name: reset_password reset_password_expired_in_key; Type: CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.reset_password
    ADD CONSTRAINT reset_password_expired_in_key UNIQUE (expired_in);


--
-- Name: reset_password reset_password_pkey; Type: CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.reset_password
    ADD CONSTRAINT reset_password_pkey PRIMARY KEY (id);


--
-- Name: reset_password reset_password_reset_token_key; Type: CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.reset_password
    ADD CONSTRAINT reset_password_reset_token_key UNIQUE (reset_token);


--
-- Name: similar_track similar_track_pkey; Type: CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.similar_track
    ADD CONSTRAINT similar_track_pkey PRIMARY KEY (id);


--
-- Name: song_ratings song_ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.song_ratings
    ADD CONSTRAINT song_ratings_pkey PRIMARY KEY (id);


--
-- Name: upload_user_files upload_user_files_pkey; Type: CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.upload_user_files
    ADD CONSTRAINT upload_user_files_pkey PRIMARY KEY (id);


--
-- Name: user user_email_key; Type: CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_email_key UNIQUE (email);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: user_ratings user_ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.user_ratings
    ADD CONSTRAINT user_ratings_pkey PRIMARY KEY (id);


--
-- Name: withdrawal withdrawal_pkey; Type: CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.withdrawal
    ADD CONSTRAINT withdrawal_pkey PRIMARY KEY (id);


--
-- Name: Songs Songs_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public."Songs"
    ADD CONSTRAINT "Songs_project_id_fkey" FOREIGN KEY (project_id) REFERENCES public.project(id) ON DELETE CASCADE;


--
-- Name: Songs Songs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public."Songs"
    ADD CONSTRAINT "Songs_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: count_likes count_likes_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.count_likes
    ADD CONSTRAINT count_likes_song_id_fkey FOREIGN KEY (song_id) REFERENCES public."Songs"(id) ON DELETE CASCADE;


--
-- Name: feedback feedback_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.feedback
    ADD CONSTRAINT feedback_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: invoice invoice_Licence_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.invoice
    ADD CONSTRAINT "invoice_Licence_id_fkey" FOREIGN KEY ("Licence_id") REFERENCES public.licence(id) ON DELETE CASCADE;


--
-- Name: invoice invoice_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.invoice
    ADD CONSTRAINT invoice_song_id_fkey FOREIGN KEY (song_id) REFERENCES public."Songs"(id) ON DELETE CASCADE;


--
-- Name: invoice invoice_supervisor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.invoice
    ADD CONSTRAINT invoice_supervisor_id_fkey FOREIGN KEY (supervisor_id) REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: licence licence_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.licence
    ADD CONSTRAINT licence_song_id_fkey FOREIGN KEY (song_id) REFERENCES public."Songs"(id) ON DELETE CASCADE;


--
-- Name: licence licence_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.licence
    ADD CONSTRAINT licence_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: my_earnings my_earnings_artist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.my_earnings
    ADD CONSTRAINT my_earnings_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: notification notification_song_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_song_id_fkey FOREIGN KEY (song_id) REFERENCES public."Songs"(id) ON DELETE CASCADE;


--
-- Name: notification notification_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: payment payment_invoice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES public.invoice(id) ON DELETE CASCADE;


--
-- Name: payment payment_supervisor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_supervisor_id_fkey FOREIGN KEY (supervisor_id) REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: project project_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.project
    ADD CONSTRAINT project_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: similar_track similar_track_supervisor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.similar_track
    ADD CONSTRAINT similar_track_supervisor_id_fkey FOREIGN KEY (supervisor_id) REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: upload_user_files upload_user_files_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.upload_user_files
    ADD CONSTRAINT upload_user_files_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE SET NULL;


--
-- Name: withdrawal withdrawal_artist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ktizo
--

ALTER TABLE ONLY public.withdrawal
    ADD CONSTRAINT withdrawal_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: ktizo
--

-- REVOKE ALL ON SCHEMA public FROM rdsadmin;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO ktizo;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

