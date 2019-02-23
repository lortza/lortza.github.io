--
-- PostgreSQL database dump
--

-- Dumped from database version 10.5
-- Dumped by pg_dump version 10.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ingredients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ingredients (
    id bigint NOT NULL,
    recipe_id bigint,
    quantity double precision DEFAULT 0.0 NOT NULL,
    measurement_unit character varying DEFAULT ''::character varying NOT NULL,
    name character varying DEFAULT ''::character varying NOT NULL,
    preparation_style character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ingredients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ingredients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ingredients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ingredients_id_seq OWNED BY public.ingredients.id;


--
-- Name: meal_plan_recipes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.meal_plan_recipes (
    id bigint NOT NULL,
    meal_plan_id bigint,
    recipe_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: meal_plan_recipes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.meal_plan_recipes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: meal_plan_recipes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.meal_plan_recipes_id_seq OWNED BY public.meal_plan_recipes.id;


--
-- Name: meal_plans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.meal_plans (
    id bigint NOT NULL,
    start_date date NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    people_served integer DEFAULT 0 NOT NULL
);


--
-- Name: meal_plans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.meal_plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: meal_plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.meal_plans_id_seq OWNED BY public.meal_plans.id;


--
-- Name: recipes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.recipes (
    id bigint NOT NULL,
    title character varying DEFAULT ''::character varying NOT NULL,
    source_name character varying DEFAULT ''::character varying NOT NULL,
    source_url character varying DEFAULT ''::character varying NOT NULL,
    servings integer DEFAULT 0 NOT NULL,
    instructions text DEFAULT ''::text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    prep_time integer DEFAULT 0 NOT NULL,
    cook_time integer DEFAULT 0 NOT NULL,
    image_url character varying DEFAULT ''::character varying NOT NULL,
    reheat_time integer,
    pepperplate_url character varying,
    notes text,
    archived boolean DEFAULT false,
    user_id bigint
);


--
-- Name: recipes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.recipes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recipes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.recipes_id_seq OWNED BY public.recipes.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: ingredients id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ingredients ALTER COLUMN id SET DEFAULT nextval('public.ingredients_id_seq'::regclass);


--
-- Name: meal_plan_recipes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meal_plan_recipes ALTER COLUMN id SET DEFAULT nextval('public.meal_plan_recipes_id_seq'::regclass);


--
-- Name: meal_plans id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meal_plans ALTER COLUMN id SET DEFAULT nextval('public.meal_plans_id_seq'::regclass);


--
-- Name: recipes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recipes ALTER COLUMN id SET DEFAULT nextval('public.recipes_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment	development	2018-08-27 14:31:42.706743	2018-08-27 14:31:42.706743
\.


--
-- Data for Name: ingredients; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ingredients (id, recipe_id, quantity, measurement_unit, name, preparation_style, created_at, updated_at) FROM stdin;
310	49	8	slice	muenster cheese		2018-08-30 02:42:20.942168	2018-08-30 02:42:20.942168
311	49	1	cup	cucumber	sliced	2018-08-30 02:42:20.944916	2018-08-30 02:42:20.944916
312	49	2	whole	tomato	sliced	2018-08-30 02:42:20.947395	2018-08-30 02:42:20.947395
313	49	0.5	whole	red bell pepper	matchsticked	2018-08-30 02:42:20.949757	2018-08-30 02:42:20.949757
314	49	0.5	whole	green bell pepper	matchsticked	2018-08-30 02:42:20.952053	2018-08-30 02:42:20.952053
315	49	0.25	cup	pitted black olives	sliced	2018-08-30 02:42:20.954199	2018-08-30 02:42:20.954199
316	49	3	cup	salad greens	chopped	2018-08-30 02:42:20.95644	2018-08-30 02:42:20.95644
317	49	4	whole	po'boy rolls		2018-08-30 02:42:20.958635	2018-08-30 02:42:20.958635
318	49	2	tsp	dried oregano		2018-08-30 02:42:20.960823	2018-08-30 02:42:20.960823
319	49	12	leaf	fresh basil	chopped	2018-08-30 02:42:20.962936	2018-08-30 02:42:20.962936
320	50	1	whole	plaintain maduro	sliced	2018-08-30 02:42:20.967766	2018-08-30 02:42:20.967766
321	50	3	sprig	fresh cilantro	chopped	2018-08-30 02:42:20.970129	2018-08-30 02:42:20.970129
322	50	1	T	adobo seasoning		2018-08-30 02:42:20.972263	2018-08-30 02:42:20.972263
323	50	2	ounce	queso blanco	crumbled	2018-08-30 02:42:20.974468	2018-08-30 02:42:20.974468
324	50	2	can	canned black beans	finely chopped	2018-08-30 02:42:20.976574	2018-08-30 02:42:20.976574
325	50	1	T	brown cane sugar	grated	2018-08-30 02:42:20.978457	2018-08-30 02:42:20.978457
326	50	1	T	garlic	minced	2018-08-30 02:42:20.980529	2018-08-30 02:42:20.980529
327	50	0.75	cup	onion	finely chopped	2018-08-30 02:42:20.982699	2018-08-30 02:42:20.982699
328	50	0.25	whole	red bell pepper	finely chopped	2018-08-30 02:42:20.985158	2018-08-30 02:42:20.985158
329	50	0.25	whole	green bell pepper	finely chopped	2018-08-30 02:42:20.987387	2018-08-30 02:42:20.987387
330	51	0.25	cup	peanut butter		2018-08-30 02:42:20.991839	2018-08-30 02:42:20.991839
331	51	0.5	cup	red bell pepper	finely chopped	2018-08-30 02:42:20.994004	2018-08-30 02:42:20.994004
332	51	1	T	soy sauce		2018-08-30 02:42:20.996152	2018-08-30 02:42:20.996152
333	51	1	tsp	brown sugar		2018-08-30 02:42:20.998275	2018-08-30 02:42:20.998275
334	51	0.5	T	rice vinegar		2018-08-30 02:42:21.000384	2018-08-30 02:42:21.000384
335	51	8	ounce	spaghetti	cooked	2018-08-30 02:42:21.002488	2018-08-30 02:42:21.002488
336	51	1	tsp	crushed red pepper		2018-08-30 02:42:21.004443	2018-08-30 02:42:21.004443
337	51	4	sprig	fresh cilantro	chopped	2018-08-30 02:42:21.0066	2018-08-30 02:42:21.0066
338	52	1	can	coconut milk		2018-08-30 02:42:21.010903	2018-08-30 02:42:21.010903
339	52	3	cup	water		2018-08-30 02:42:21.012913	2018-08-30 02:42:21.012913
340	52	0.333000000000000018	cup	dry red lentils	sorted	2018-08-30 02:42:21.01494	2018-08-30 02:42:21.01494
341	52	0.333000000000000018	cup	dry brown lentils	sorted	2018-08-30 02:42:21.016977	2018-08-30 02:42:21.016977
343	52	0.125	cup	couscous	uncooked	2018-08-30 02:42:21.021204	2018-08-30 02:42:21.021204
344	52	2	leaf	bay leaf		2018-08-30 02:42:21.023137	2018-08-30 02:42:21.023137
345	52	0.5	tsp	sea salt		2018-08-30 02:42:21.025167	2018-08-30 02:42:21.025167
346	52	2	stalk	celery	finely chopped	2018-08-30 02:42:21.0273	2018-08-30 02:42:21.0273
347	52	2	whole	carrot	finely chopped	2018-08-30 02:42:21.029242	2018-08-30 02:42:21.029242
349	53	1	T	olive oil		2018-08-30 02:42:21.035556	2018-08-30 02:42:21.035556
350	53	1	tsp	cumin	ground	2018-08-30 02:42:21.037701	2018-08-30 02:42:21.037701
351	53	2	whole	carrot	chopped	2018-08-30 02:42:21.039719	2018-08-30 02:42:21.039719
352	53	1	cup	dry red lentils	sorted	2018-08-30 02:42:21.041744	2018-08-30 02:42:21.041744
353	53	4	cup	vegetable stock		2018-08-30 02:42:21.043856	2018-08-30 02:42:21.043856
354	53	1	loaf	crusty bread	sliced	2018-08-30 02:42:21.045811	2018-08-30 02:42:21.045811
355	54	1	whole	pie crust		2018-08-30 02:42:21.050108	2018-08-30 02:42:21.050108
356	54	1	whole	tomato	diced	2018-08-30 02:42:21.052198	2018-08-30 02:42:21.052198
357	54	6	ounce	frozen chopped spinach	thawed	2018-08-30 02:42:21.054351	2018-08-30 02:42:21.054351
358	54	0.5	dozen	egg		2018-08-30 02:42:21.056469	2018-08-30 02:42:21.056469
359	54	0.25	cup	feta	crumbled	2018-08-30 02:42:21.05862	2018-08-30 02:42:21.05862
360	54	0.125	tsp	garlic powder		2018-08-30 02:42:21.060608	2018-08-30 02:42:21.060608
361	54	0.125	tsp	onion powder		2018-08-30 02:42:21.062627	2018-08-30 02:42:21.062627
362	54	0.5	tsp	basil	dried	2018-08-30 02:42:21.064533	2018-08-30 02:42:21.064533
363	54	0.5	tsp	oregano	dried	2018-08-30 02:42:21.066586	2018-08-30 02:42:21.066586
364	54	0.125	tsp	sea salt		2018-08-30 02:42:21.068733	2018-08-30 02:42:21.068733
365	55	2	cup	onion	chopped	2018-08-30 02:42:21.073033	2018-08-30 02:42:21.073033
366	55	2	cup	tomato	diced	2018-08-30 02:42:21.075216	2018-08-30 02:42:21.075216
367	55	0.25	tsp	garlic powder		2018-08-30 02:42:21.077293	2018-08-30 02:42:21.077293
368	55	1	T	fresh ginger root	minced	2018-08-30 02:42:21.079606	2018-08-30 02:42:21.079606
369	55	0.5	tsp	garam masala		2018-08-30 02:42:21.081589	2018-08-30 02:42:21.081589
370	55	0.75	tsp	curry powder		2018-08-30 02:42:21.083577	2018-08-30 02:42:21.083577
371	55	0.25	tsp	cumin	ground	2018-08-30 02:42:21.085764	2018-08-30 02:42:21.085764
372	55	1	T	red curry paste		2018-08-30 02:42:21.087794	2018-08-30 02:42:21.087794
373	55	1	cup	dry red lentils	sorted	2018-08-30 02:42:21.089733	2018-08-30 02:42:21.089733
374	55	2	cup	water		2018-08-30 02:42:21.091668	2018-08-30 02:42:21.091668
375	55	1	can	coconut milk		2018-08-30 02:42:21.093554	2018-08-30 02:42:21.093554
376	55	0.5	cup	rice	uncooked	2018-08-30 02:42:21.095572	2018-08-30 02:42:21.095572
377	56	16	ounce	gnocchi	uncooked	2018-08-30 02:42:21.099878	2018-08-30 02:42:21.099878
378	56	1	pint	cherry tomato	sliced in half	2018-08-30 02:42:21.101978	2018-08-30 02:42:21.101978
379	56	2	whole	yellow squash	sliced	2018-08-30 02:42:21.103945	2018-08-30 02:42:21.103945
380	56	1	whole	zucchini	sliced	2018-08-30 02:42:21.105891	2018-08-30 02:42:21.105891
381	56	2	T	olive oil		2018-08-30 02:42:21.107771	2018-08-30 02:42:21.107771
382	56	2	T	lemon juice		2018-08-30 02:42:21.109644	2018-08-30 02:42:21.109644
383	56	1	ounce	goat cheese	crumbled	2018-08-30 02:42:21.111539	2018-08-30 02:42:21.111539
384	56	0.125	tsp	garlic powder		2018-08-30 02:42:21.113446	2018-08-30 02:42:21.113446
385	56	0.5	tsp	crushed red pepper flakes		2018-08-30 02:42:21.115309	2018-08-30 02:42:21.115309
386	56	8	leaf	fresh basil	chopped	2018-08-30 02:42:21.117253	2018-08-30 02:42:21.117253
387	56	1	tsp	oregano	dried	2018-08-30 02:42:21.119241	2018-08-30 02:42:21.119241
483	69	0.5	bunch	green onion	for serving	2019-02-16 22:37:55.621237	2019-02-16 22:37:55.621237
484	69	1	cup	salsa	for serving	2019-02-16 22:37:55.622597	2019-02-16 22:37:55.622597
488	70	8	ounce	colby jack cheese	shredded	2019-02-16 22:42:00.277843	2019-02-16 22:42:00.277843
486	70	8	ounce	yogurt		2019-02-16 22:42:00.273069	2019-02-17 22:32:19.297922
487	70	0.125	tsp	garlic powder		2019-02-16 22:42:00.275138	2019-02-17 22:32:19.307451
342	52	0.25	cup	dry yellow lentils	sorted	2018-08-30 02:42:21.01912	2019-02-19 00:31:23.617162
348	53	1	cup	onion		2018-08-30 02:42:21.033498	2019-02-19 03:23:35.820236
398	59	1	cup	raw cashews	soaked in hot water for 1 hour	2019-02-16 20:59:12.728929	2019-02-16 20:59:12.728929
400	59	0.5	cup	nutritional yeast		2019-02-16 21:00:31.324054	2019-02-16 21:00:31.324054
401	59	0.5	cup	water		2019-02-16 21:00:31.327457	2019-02-16 21:00:31.327457
399	59	1	whole	jalapeño pepper	deseeded and chopped	2019-02-16 21:00:31.314081	2019-02-16 21:01:57.151977
402	59	0.5	tsp	chili powder		2019-02-16 21:01:57.156989	2019-02-16 21:01:57.156989
403	59	0.5	tsp	cumin		2019-02-16 21:01:57.159506	2019-02-16 21:01:57.159506
404	59	0.5	tsp	garlic powder		2019-02-16 21:01:57.161805	2019-02-16 21:01:57.161805
405	59	0.5	tsp	sea salt		2019-02-16 21:01:57.164424	2019-02-16 21:01:57.164424
406	59	1	T	honey		2019-02-16 21:01:57.172189	2019-02-16 21:01:57.172189
407	61	2	can	black beans	rinsed and drained	2019-02-16 21:07:00.296267	2019-02-16 21:07:00.296267
408	61	7	ounce	chipotle peppers in adobo sauce		2019-02-16 21:07:00.298522	2019-02-16 21:07:00.298522
409	61	0.5	tsp	onion powder		2019-02-16 21:07:00.300445	2019-02-16 21:07:00.300445
410	61	0.5	tsp	cumin		2019-02-16 21:07:00.304037	2019-02-16 21:07:00.304037
411	61	2	cup	water		2019-02-16 21:07:00.305857	2019-02-16 21:07:00.305857
412	61	12	whole	corn tortillas (small)		2019-02-16 21:07:00.307461	2019-02-16 21:07:00.307461
413	61	1	bunch	cilantro		2019-02-16 21:07:00.309086	2019-02-16 21:07:00.309086
414	61	4	ounce	queso fresco		2019-02-16 21:07:00.310855	2019-02-16 21:07:00.310855
415	60	24	ounce	frozen cauliflower	thawed to about room temp	2019-02-16 21:18:58.951072	2019-02-16 21:18:58.951072
416	60	0.5	T	smoked paprika		2019-02-16 21:18:58.958454	2019-02-16 21:18:58.958454
417	60	0.25	tsp	garlic powder		2019-02-16 21:18:58.960626	2019-02-16 21:18:58.960626
419	60	0.25	tsp	sea salt		2019-02-16 21:18:58.96347	2019-02-16 21:18:58.96347
420	60	1	T	olive oil		2019-02-16 21:18:58.966329	2019-02-16 21:18:58.966329
421	63	1	whole	onion	diced	2019-02-16 21:25:08.438991	2019-02-16 21:25:08.438991
422	63	2	clove	garlic	minced	2019-02-16 21:25:08.441042	2019-02-16 21:25:08.441042
423	63	2	whole	carrot	peeled and diced	2019-02-16 21:25:08.443845	2019-02-16 21:25:08.443845
424	63	0.5	cup	dried apricots	finely diced	2019-02-16 21:25:08.446233	2019-02-16 21:25:08.446233
425	63	1	tsp	cumin		2019-02-16 21:25:08.448729	2019-02-16 21:25:08.448729
426	63	1.5	cup	dried red lentils	rinsed and drained	2019-02-16 21:25:08.450822	2019-02-16 21:25:08.450822
427	63	1	can	canned diced tomatoes		2019-02-16 21:25:08.452685	2019-02-16 21:25:08.452685
428	63	4	cup	vegetable stock		2019-02-16 21:25:08.454785	2019-02-16 21:25:08.454785
431	64	0.5	cup	yellow onion	diced	2019-02-16 21:36:41.702154	2019-02-16 21:36:41.702154
432	64	0.5	whole	green bell pepper	diced	2019-02-16 21:36:41.70479	2019-02-16 21:36:41.70479
433	64	2	clove	garlic		2019-02-16 21:36:41.707271	2019-02-16 21:36:41.707271
434	64	1	can	pigeon peas	rinsed and drained	2019-02-16 21:36:41.719085	2019-02-16 21:36:41.719085
435	64	4	ounce	tomato sauce		2019-02-16 21:36:41.72128	2019-02-16 21:36:41.72128
436	64	3	cup	water		2019-02-16 21:36:41.722818	2019-02-16 21:36:41.722818
438	64	1	tsp	cumin		2019-02-16 21:36:41.72882	2019-02-16 21:36:41.72882
439	64	1	tsp	coriander		2019-02-16 21:36:41.730839	2019-02-16 21:36:41.730839
440	64	1	tsp	paprika		2019-02-16 21:36:41.732068	2019-02-16 21:36:41.732068
470	68	2	T	fresh parsley	chopped	2019-02-16 22:13:16.147857	2019-02-16 22:13:16.147857
430	64	0.333000000000000018	cup	coconut flakes	toasted	2019-02-16 21:27:53.612309	2019-02-16 21:37:21.465029
418	60	0.125	tsp	cayenne pepper		2019-02-16 21:18:58.961942	2019-02-16 21:46:53.396069
441	67	1	bunch	curly kale	washed, deboned, chopped, and squeezed	2019-02-16 21:57:20.438667	2019-02-16 21:57:20.438667
442	67	0.5	whole	avocado	cubed	2019-02-16 21:57:20.441882	2019-02-16 21:57:20.441882
443	67	1	whole	red bell pepper	chopped	2019-02-16 21:57:20.444045	2019-02-16 21:57:20.444045
444	67	1	whole	carrot	peeled and julienned	2019-02-16 21:57:20.446425	2019-02-16 21:57:20.446425
445	67	0.125	bunch	cilantro	chopped	2019-02-16 21:57:20.450135	2019-02-16 21:57:20.450135
446	67	1	T	red onion	minced	2019-02-16 21:57:20.452802	2019-02-16 21:57:20.452802
447	67	1	tsp	sesame seeds		2019-02-16 21:57:20.455489	2019-02-16 21:57:20.455489
448	67	1	bunch	brocolini		2019-02-16 21:57:20.458763	2019-02-16 21:57:20.458763
449	67	0.25	cup	red cabbage	chopped	2019-02-16 21:57:20.460572	2019-02-16 21:57:20.460572
450	67	2	T	apple cider vinegar		2019-02-16 21:59:47.239915	2019-02-16 21:59:47.239915
451	67	1	whole	lime	juiced	2019-02-16 21:59:47.242266	2019-02-16 21:59:47.242266
452	67	2	T	honey		2019-02-16 21:59:47.245203	2019-02-16 21:59:47.245203
453	67	3	T	olive oil		2019-02-16 21:59:47.2512	2019-02-16 21:59:47.2512
454	67	1	inch	ginger	peeled and minced	2019-02-16 22:00:36.472915	2019-02-16 22:00:36.472915
455	68	1	whole	baguette	cut into big cubes and dried	2019-02-16 22:12:56.101825	2019-02-16 22:12:56.101825
456	68	1	T	olive oil		2019-02-16 22:12:56.105378	2019-02-16 22:12:56.105378
457	68	1	whole	onion	diced	2019-02-16 22:12:56.108126	2019-02-16 22:12:56.108126
458	68	2	stalk	celery	roughly chopped	2019-02-16 22:12:56.110841	2019-02-16 22:12:56.110841
459	68	1	whole	red bell pepper	roughly chopped	2019-02-16 22:12:56.11228	2019-02-16 22:12:56.11228
460	68	8	ounce	mushrooms	washed and roughly sliced	2019-02-16 22:12:56.11374	2019-02-16 22:12:56.11374
461	68	2	whole	zucchini	sliced into thick half moons	2019-02-16 22:12:56.115156	2019-02-16 22:12:56.115156
462	68	1	whole	tomato	roughly chopped	2019-02-16 22:12:56.116481	2019-02-16 22:12:56.116481
463	68	2	clove	garlic	sliced	2019-02-16 22:12:56.118303	2019-02-16 22:12:56.118303
464	68	0.5	tsp	dried thyme	crumbled	2019-02-16 22:12:56.121111	2019-02-16 22:12:56.121111
466	68	5	whole	egg		2019-02-16 22:12:56.125124	2019-02-16 22:12:56.125124
467	68	0.5	T	sea salt		2019-02-16 22:12:56.126925	2019-02-16 22:12:56.126925
468	68	0.25	tsp	ground nutmeg		2019-02-16 22:12:56.128398	2019-02-16 22:12:56.128398
469	68	2	cup	gruyere	or swiss, grated	2019-02-16 22:12:56.129803	2019-02-16 22:12:56.129803
471	69	16	ounce	extra firm tofu	drained and crumbled	2019-02-16 22:37:55.594257	2019-02-16 22:37:55.594257
472	69	6	whole	flour tortilla (burrito size)		2019-02-16 22:37:55.600267	2019-02-16 22:37:55.600267
473	69	1	whole	potato	cubed and steamed	2019-02-16 22:37:55.602555	2019-02-16 22:37:55.602555
474	69	0.5	cup	white onion	diced	2019-02-16 22:37:55.604695	2019-02-16 22:37:55.604695
475	69	0.75	cup	red bell pepper	diced	2019-02-16 22:37:55.606272	2019-02-16 22:37:55.606272
476	69	1	whole	anaheim pepper	finely chopped	2019-02-16 22:37:55.607674	2019-02-16 22:37:55.607674
477	69	0.25	tsp	ground coriander		2019-02-16 22:37:55.608851	2019-02-16 22:37:55.608851
478	69	0.5	tsp	cumin		2019-02-16 22:37:55.610192	2019-02-16 22:37:55.610192
479	69	0.25	tsp	garlic powder		2019-02-16 22:37:55.612784	2019-02-16 22:37:55.612784
480	69	0.5	tsp	sea salt		2019-02-16 22:37:55.615283	2019-02-16 22:37:55.615283
481	69	1.25	tsp	turmeric		2019-02-16 22:37:55.616911	2019-02-16 22:37:55.616911
482	69	0.25	cup	yogurt	for serving	2019-02-16 22:37:55.619861	2019-02-16 22:37:55.619861
465	68	0.5	cup	milk		2019-02-16 22:12:56.123108	2019-02-18 00:27:41.482987
437	64	2	cup	uncooked white rice		2019-02-16 21:36:41.724692	2019-02-19 04:20:34.584042
490	70	1	tsp	vegetable bouillon		2019-02-16 22:43:08.932366	2019-02-16 22:43:08.932366
491	71	16	ounce	sweet potato gnocchi		2019-02-16 22:47:09.282346	2019-02-16 22:47:09.282346
492	71	1	bunch	broccolini	chopped into bit-size pieces	2019-02-16 22:47:09.285236	2019-02-16 22:47:09.285236
493	71	4	T	butter		2019-02-16 22:47:09.288057	2019-02-16 22:47:09.288057
494	71	0.125	tsp	ground nutmeg		2019-02-16 22:51:03.172286	2019-02-16 22:51:03.172286
495	71	0.125	tsp	cinnamon		2019-02-16 22:51:03.174715	2019-02-16 22:51:03.174715
496	71	0.5	ounce	goat cheese		2019-02-16 22:51:03.176608	2019-02-16 22:51:03.176608
497	72	16	ounce	frozen sweet corn		2019-02-16 22:59:10.211901	2019-02-16 22:59:10.211901
498	72	1	whole	onion	chopped	2019-02-16 22:59:10.215073	2019-02-16 22:59:10.215073
499	72	0.5	T	garlic powder		2019-02-16 22:59:10.216704	2019-02-16 22:59:10.216704
500	72	2	stalk	celery	chopped	2019-02-16 22:59:10.218062	2019-02-16 22:59:10.218062
501	72	2	whole	carrot	chopped	2019-02-16 22:59:10.219054	2019-02-16 22:59:10.219054
502	72	1	whole	red bell pepper	diced	2019-02-16 22:59:10.22004	2019-02-16 22:59:10.22004
504	72	0.125	bunch	fresh parsley	roughly chopped	2019-02-16 23:03:38.431221	2019-02-16 23:03:38.431221
505	72	1	can	coconut milk	well shaken	2019-02-16 23:03:38.433013	2019-02-16 23:03:38.433013
506	72	2	T	flour		2019-02-16 23:03:38.434922	2019-02-16 23:03:38.434922
507	72	0.5	tsp	cayenne pepper		2019-02-16 23:03:38.436666	2019-02-16 23:03:38.436666
508	72	0.75	tsp	sea salt		2019-02-16 23:03:38.438518	2019-02-16 23:03:38.438518
509	72	0.5	tsp	ground nutmeg		2019-02-16 23:03:38.440806	2019-02-16 23:03:38.440806
429	63	0.25	tsp	sea salt		2019-02-16 21:25:08.457171	2019-02-17 18:11:19.922668
511	73	2	whole	leek	chopped, soaked, washed, drained	2019-02-17 18:40:21.824944	2019-02-17 18:40:21.824944
512	73	3	stalk	celery	diced	2019-02-17 18:40:21.82872	2019-02-17 18:40:21.82872
513	73	1	whole	russet potato	diced	2019-02-17 18:40:21.830301	2019-02-17 18:40:21.830301
514	73	6	cup	vegetable stock		2019-02-17 18:40:21.832262	2019-02-17 18:40:21.832262
515	73	1	can	coconut milk	shaken	2019-02-17 18:40:21.833979	2019-02-17 18:40:21.833979
516	73	0.5	tsp	dried thyme		2019-02-17 18:40:21.836194	2019-02-17 18:40:21.836194
517	73	0.25	tsp	dried rosemary		2019-02-17 18:40:21.837883	2019-02-17 18:40:21.837883
518	73	2	whole	bay leaf		2019-02-17 18:40:21.839263	2019-02-17 18:40:21.839263
519	73	0.5	whole	butter		2019-02-17 18:40:21.84075	2019-02-17 18:40:21.84075
520	73	0.25	tsp	sea salt		2019-02-17 18:40:21.842126	2019-02-17 18:40:21.842126
521	73	0.25	cup	almonds	sliced or chopped	2019-02-17 18:40:21.843796	2019-02-17 18:40:21.843796
522	73	2	T	sunflower seeds		2019-02-17 18:40:21.845231	2019-02-17 18:40:21.845231
523	74	1	cup	uncooked couscous		2019-02-17 18:46:57.574739	2019-02-17 18:46:57.574739
524	74	2	cup	vegetable stock		2019-02-17 18:46:57.580136	2019-02-17 18:46:57.580136
525	74	0.25	cup	sundried tomatoes		2019-02-17 18:46:57.594418	2019-02-17 18:46:57.594418
526	74	2	whole	red bell pepper	cut in half like boats and deseeded	2019-02-17 18:46:57.605988	2019-02-17 18:46:57.605988
527	74	0.25	whole	green bell pepper	diced	2019-02-17 18:46:57.608351	2019-02-17 18:46:57.608351
528	74	0.25	tsp	garlic powder		2019-02-17 18:46:57.612027	2019-02-17 18:46:57.612027
529	74	0.25	tsp	onion powder		2019-02-17 18:46:57.622268	2019-02-17 18:46:57.622268
530	74	1	T	dried oregano		2019-02-17 18:46:57.624803	2019-02-17 18:46:57.624803
531	74	1	can	black eyed peas	drained and rinsed	2019-02-17 18:46:57.627044	2019-02-17 18:46:57.627044
532	74	0.25	cup	kalamata olived	pitted and diced	2019-02-17 18:46:57.647266	2019-02-17 18:46:57.647266
533	74	6	handful	baby spinach	chopped	2019-02-17 18:46:57.649503	2019-02-17 18:46:57.649503
534	74	4	ounce	feta cheese	crumbled	2019-02-17 18:46:57.654876	2019-02-17 18:46:57.654876
535	74	2	T	pine nuts	toasted	2019-02-17 18:46:57.660997	2019-02-17 18:46:57.660997
536	75	10	ounce	plain jackfruit	rinsed, drained, chopped	2019-02-17 19:25:06.277427	2019-02-17 19:25:06.277427
537	75	0.25	tsp	onion powder		2019-02-17 19:28:28.40918	2019-02-17 19:28:28.40918
538	75	1	stalk	celery	minced	2019-02-17 19:28:28.411207	2019-02-17 19:28:28.411207
539	75	0.5	tsp	dried tarragon		2019-02-17 19:28:28.412966	2019-02-17 19:28:28.412966
540	75	0.125	tsp	garlic powder		2019-02-17 19:28:28.415114	2019-02-17 19:28:28.415114
541	75	1	whole	tomato	half-mooned and sliced	2019-02-17 19:28:28.418969	2019-02-17 19:28:28.418969
542	75	1	can	great northern beans	rinsed and drained	2019-02-17 19:28:28.422382	2019-02-17 19:28:28.422382
543	75	0.25	cup	mayonnaise		2019-02-17 19:28:28.43149	2019-02-17 19:28:28.43149
544	75	1.5	T	dijon mustard		2019-02-17 19:28:28.43465	2019-02-17 19:28:28.43465
545	75	2	T	pickled relish		2019-02-17 19:28:28.436455	2019-02-17 19:28:28.436455
546	75	1	loaf	marble rye	sliced	2019-02-17 19:28:28.43797	2019-02-17 19:28:28.43797
547	75	12	slice	sliced swiss cheese		2019-02-17 19:28:28.442433	2019-02-17 19:28:28.442433
548	76	5	whole	carrot	finely chopped	2019-02-17 19:32:46.000548	2019-02-17 19:32:46.000548
549	76	5	stalk	celery	finely chopped	2019-02-17 19:32:46.003131	2019-02-17 19:32:46.003131
550	76	0.5	whole	onion	diced	2019-02-17 19:32:46.00576	2019-02-17 19:32:46.00576
551	76	1	cup	uncooked wild rice		2019-02-17 19:32:46.008035	2019-02-17 19:32:46.008035
552	76	8	ounce	fresh mushrooms	sliced	2019-02-17 19:32:46.016825	2019-02-17 19:32:46.016825
553	76	4	cup	vegetable stock	to start. Add more as needed.	2019-02-17 19:32:46.018882	2019-02-17 19:32:46.018882
554	76	1	tsp	sea salt		2019-02-17 19:32:46.021529	2019-02-17 19:32:46.021529
555	76	0.5	tsp	dried thyme		2019-02-17 19:32:46.023838	2019-02-17 19:32:46.023838
556	76	1.5	cup	milk		2019-02-17 19:32:46.025658	2019-02-17 19:32:46.025658
557	51	0.5	box	extra firm tofu	drained, crumbled	2019-02-17 19:35:25.562557	2019-02-17 19:35:25.562557
558	51	1	whole	carrot	julienned	2019-02-17 19:35:25.565378	2019-02-17 19:35:25.565378
510	72	4	cup	vegetable stock		2019-02-16 23:03:38.442917	2019-02-17 21:14:07.30453
485	70	2.5	whole	potato	thinly sliced	2019-02-16 22:42:00.270905	2019-02-17 21:49:03.082089
503	72	2	whole	potato	cubed	2019-02-16 22:59:10.221111	2019-02-17 21:50:01.468537
489	70	0.5	bunch	green onion	chopped	2019-02-16 22:42:00.280515	2019-02-17 22:32:19.309518
559	70	1	whole	pizza crust	premade	2019-02-17 22:32:19.311728	2019-02-17 22:32:19.311728
560	77	8	ounce	dried spaghetti	cooked	2019-02-18 23:46:30.923788	2019-02-18 23:46:30.923788
561	77	1	can	great northern beans	rinsed and drained	2019-02-18 23:46:30.927055	2019-02-18 23:46:30.927055
562	77	1	T	peanut butter		2019-02-18 23:46:30.929746	2019-02-18 23:46:30.929746
563	77	1	T	red curry paste		2019-02-18 23:46:30.931607	2019-02-18 23:46:30.931607
564	77	1	tsp	mustard		2019-02-18 23:46:30.933958	2019-02-18 23:46:30.933958
565	77	0.25	tsp	ground ginger		2019-02-18 23:46:30.936095	2019-02-18 23:46:30.936095
566	77	0.25	tsp	garlic powder		2019-02-18 23:46:30.940317	2019-02-18 23:46:30.940317
567	77	1	tsp	rice vinegar		2019-02-18 23:46:30.942714	2019-02-18 23:46:30.942714
568	77	1	T	soy sauce		2019-02-18 23:46:30.945233	2019-02-18 23:46:30.945233
569	77	2	whole	zucchini (medium)	julienned	2019-02-18 23:46:30.947564	2019-02-18 23:46:30.947564
570	78	1	whole	poblano pepper	diced	2019-02-18 23:51:46.454535	2019-02-18 23:51:46.454535
571	78	1	whole	white onion	diced	2019-02-18 23:51:46.456709	2019-02-18 23:51:46.456709
572	78	2	clove	garlic	minced	2019-02-18 23:51:46.458726	2019-02-18 23:51:46.458726
573	78	1	whole	jalapeño pepper	minced	2019-02-18 23:51:46.462805	2019-02-18 23:51:46.462805
574	78	1	tsp	ground cumin		2019-02-18 23:51:46.465232	2019-02-18 23:51:46.465232
575	78	1	can	crushed tomatoes		2019-02-18 23:51:46.467649	2019-02-18 23:51:46.467649
576	78	4	cup	vegetable stock		2019-02-18 23:51:46.470845	2019-02-18 23:51:46.470845
577	78	1	can	hominy	rinsed and drained	2019-02-18 23:51:46.473655	2019-02-18 23:51:46.473655
578	78	4	whole	radishes	sliced into thin rounds	2019-02-18 23:51:46.478054	2019-02-18 23:51:46.478054
579	78	1	can	black beans	rinsed and drained	2019-02-18 23:51:46.484566	2019-02-18 23:51:46.484566
580	78	1	handful	cilantro	chopped	2019-02-18 23:51:46.488474	2019-02-18 23:51:46.488474
582	79	4	cup	vegetable stock		2019-02-18 23:57:55.662861	2019-02-18 23:57:55.662861
583	79	2	T	fresh ginger	minced	2019-02-18 23:57:55.664434	2019-02-18 23:57:55.664434
584	79	0.5	tsp	ground turmeric		2019-02-18 23:57:55.665981	2019-02-18 23:57:55.665981
585	79	1	whole	zucchini	cut into 1" pieces	2019-02-18 23:57:55.669719	2019-02-18 23:57:55.669719
586	79	1.5	tsp	black mustard seeds		2019-02-18 23:57:55.672216	2019-02-18 23:57:55.672216
587	79	1	whole	yellow onion	halved and thinly sliced	2019-02-18 23:57:55.674811	2019-02-18 23:57:55.674811
588	79	2	clove	garlic	minced	2019-02-18 23:57:55.678527	2019-02-18 23:57:55.678527
590	79	2	whole	bay leaf		2019-02-18 23:57:55.687028	2019-02-18 23:57:55.687028
591	79	2	tsp	ground cumin		2019-02-18 23:57:55.689103	2019-02-18 23:57:55.689103
592	79	1	whole	tomato	cubed	2019-02-18 23:57:55.691225	2019-02-18 23:57:55.691225
589	79	1	whole	anaheim	thinly sliced and deseeded	2019-02-18 23:57:55.682479	2019-02-19 00:29:07.160275
581	79	1	cup	dry yellow lentils		2019-02-18 23:57:55.660724	2019-02-19 00:31:36.456426
594	80	1	whole	yellow onion	diced	2019-02-19 03:27:35.349095	2019-02-19 03:27:35.349095
595	80	3	stalk	celery	chopped	2019-02-19 03:27:35.351342	2019-02-19 03:27:35.351342
596	80	1	whole	carrot	peeled and chopped	2019-02-19 03:27:35.353445	2019-02-19 03:27:35.353445
597	80	0.125	tsp	garlic powder		2019-02-19 03:27:35.356794	2019-02-19 03:27:35.356794
598	80	0.5	tsp	powdered jalapeño pepper		2019-02-19 03:27:35.362722	2019-02-19 03:27:35.362722
599	80	3	can	black beans	rinsed and drained	2019-02-19 03:27:35.366685	2019-02-19 03:27:35.366685
600	80	1	cup	vegetable stock		2019-02-19 03:27:35.371624	2019-02-19 03:27:35.371624
601	80	0.25	cup	fresh cilantro	chopped	2019-02-19 03:27:35.374019	2019-02-19 03:27:35.374019
602	80	1	tsp	vinegar		2019-02-19 03:27:35.375904	2019-02-19 03:27:35.375904
603	81	1	bunch	broccolini	cut into large bite sizes	2019-02-19 03:32:43.986256	2019-02-19 03:32:43.986256
604	81	2	inch	fresh ginger root	peeled and minced	2019-02-19 03:32:43.988216	2019-02-19 03:32:43.988216
605	81	2	whole	carrot	julienned	2019-02-19 03:32:43.991538	2019-02-19 03:32:43.991538
606	81	2	stalk	celery	chopped at an angle	2019-02-19 03:32:43.995036	2019-02-19 03:32:43.995036
607	81	0.25	whole	onion	sliced into thin half moons	2019-02-19 03:32:44.002834	2019-02-19 03:32:44.002834
608	81	0.125	tsp	garlic powder		2019-02-19 03:32:44.005757	2019-02-19 03:32:44.005757
609	81	3	whole	baby bok choi	chopped	2019-02-19 03:32:44.017362	2019-02-19 03:32:44.017362
611	81	2	tsp	vinegar		2019-02-19 03:32:44.022338	2019-02-19 03:32:44.022338
612	81	1	T	honey		2019-02-19 03:32:44.02677	2019-02-19 03:32:44.02677
613	81	1	T	soy sauce		2019-02-19 03:32:44.033495	2019-02-19 03:32:44.033495
614	81	0.25	tsp	crushed red pepper		2019-02-19 03:32:44.035031	2019-02-19 03:32:44.035031
615	82	1	whole	sweet potato	cut into small dice	2019-02-19 03:38:40.493387	2019-02-19 03:38:40.493387
616	82	0.5	lb	mexican chorizo		2019-02-19 03:38:40.499659	2019-02-19 03:38:40.499659
617	82	1	can	black beans	rinsed and drained	2019-02-19 03:38:40.502976	2019-02-19 03:38:40.502976
618	82	1	cup	uncooked white rice		2019-02-19 03:38:40.50795	2019-02-19 03:38:40.50795
619	82	1	cup	salsa		2019-02-19 03:38:40.510228	2019-02-19 03:38:40.510228
620	82	1.75	cup	vegetable stock		2019-02-19 03:38:40.512162	2019-02-19 03:38:40.512162
621	82	1	cup	shredded cheddar cheese	for garnish	2019-02-19 03:38:40.516053	2019-02-19 03:38:40.516053
622	82	2	stalk	green onion	chopped, for garnish	2019-02-19 03:38:40.517932	2019-02-19 03:38:40.517932
623	83	1	cup	white onion	diced	2019-02-19 03:43:20.39855	2019-02-19 03:43:20.39855
624	83	0.25	tsp	garlic powder		2019-02-19 03:43:20.40152	2019-02-19 03:43:20.40152
625	83	0.5	tsp	ground cumin		2019-02-19 03:43:20.404421	2019-02-19 03:43:20.404421
626	83	0.125	cup	nutritional yeast		2019-02-19 03:43:20.406892	2019-02-19 03:43:20.406892
627	83	1	can	lentils	rinsed and drained	2019-02-19 03:43:20.409265	2019-02-19 03:43:20.409265
628	83	1	cup	vegetable stock		2019-02-19 03:43:20.415367	2019-02-19 03:43:20.415367
629	83	8	ounce	wide egg noodles		2019-02-19 03:43:20.422765	2019-02-19 03:43:20.422765
630	83	4	cup	kale	thinly sliced	2019-02-19 03:43:20.429484	2019-02-19 03:43:20.429484
631	83	0.330000000000000016	cup	parmesan	grated	2019-02-19 03:43:20.431794	2019-02-19 03:43:20.431794
632	84	1	whole	yellow onion	thinly sliced	2019-02-19 03:47:58.926772	2019-02-19 03:47:58.926772
633	84	1	whole	red bell pepper	diced	2019-02-19 03:47:58.930859	2019-02-19 03:47:58.930859
634	84	1	whole	jalapeño pepper	deseeded and sliced	2019-02-19 03:47:58.933422	2019-02-19 03:47:58.933422
635	84	3	clove	garlic	minced	2019-02-19 03:47:58.935289	2019-02-19 03:47:58.935289
636	84	1.5	T	smoked paprika		2019-02-19 03:47:58.938447	2019-02-19 03:47:58.938447
637	84	2	tsp	ground cumin		2019-02-19 03:47:58.946225	2019-02-19 03:47:58.946225
638	84	28	ounce	canned diced tomatoes		2019-02-19 03:47:58.948628	2019-02-19 03:47:58.948628
639	84	6	whole	egg		2019-02-19 03:47:58.957874	2019-02-19 03:47:58.957874
640	84	10	whole	kalamata olive	pitted and sliced in half	2019-02-19 04:02:46.015678	2019-02-19 04:02:46.015678
641	84	1	handful	cilantro	chopped	2019-02-19 04:02:46.02115	2019-02-19 04:02:46.02115
642	84	4	ounce	feta cheese	for serving	2019-02-19 04:02:46.024354	2019-02-19 04:02:46.024354
593	79	1	cup	uncooked jasmine rice	cooked	2019-02-18 23:57:55.693518	2019-02-19 04:20:34.590206
610	81	1	cup	uncooked white rice	cooked	2019-02-19 03:32:44.019561	2019-02-19 04:20:34.592111
643	85	2	whole	sweet potato		2019-02-19 14:00:41.231381	2019-02-19 14:00:41.231381
644	85	0.5	cup	brown sugar		2019-02-19 14:00:41.238714	2019-02-19 14:00:41.238714
645	85	0.25	cup	cane juice sugar		2019-02-19 14:00:41.246671	2019-02-19 14:00:41.246671
646	85	1	T	cinnamon		2019-02-19 14:00:41.249994	2019-02-19 14:00:41.249994
647	85	0.5	tsp	ground nutmeg		2019-02-19 14:00:41.257197	2019-02-19 14:00:41.257197
648	85	0.25	tsp	ground ginger		2019-02-19 14:00:41.261521	2019-02-19 14:00:41.261521
649	85	0.25	tsp	sea salt		2019-02-19 14:00:41.263537	2019-02-19 14:00:41.263537
650	85	2	T	melted butter		2019-02-19 14:00:41.26712	2019-02-19 14:00:41.26712
651	85	3	whole	egg		2019-02-19 14:00:41.269088	2019-02-19 14:00:41.269088
652	85	1	cup	vanilla nut milk		2019-02-19 14:00:41.272919	2019-02-19 14:00:41.272919
653	85	1	whole	9" pie crust		2019-02-19 14:00:41.276608	2019-02-19 14:00:41.276608
654	86	4	cup	water	boiled and cooled	2019-02-20 03:11:26.662511	2019-02-20 03:11:26.662511
655	87	4	whole	sweet potato	scrubbed	2019-02-20 03:26:11.180829	2019-02-20 03:26:11.180829
656	87	1	lb	chorizo	casing removed and sliced into 1/2 moons	2019-02-20 03:26:11.183195	2019-02-20 03:26:11.183195
657	87	0.5	cup	vegetable stock		2019-02-20 03:26:11.184966	2019-02-20 03:26:11.184966
658	87	1	cup	pumpkin puree		2019-02-20 03:26:11.188096	2019-02-20 03:26:11.188096
659	87	1	clove	garlic	minced	2019-02-20 03:26:11.190017	2019-02-20 03:26:11.190017
660	87	1	whole	chipotle in adobo sauce	finely chopped, + 1 T sauce	2019-02-20 03:26:11.191959	2019-02-20 03:26:11.191959
661	87	1	tsp	orange zest		2019-02-20 03:26:11.193912	2019-02-20 03:26:11.193912
662	87	1	T	honey		2019-02-20 03:26:11.195685	2019-02-20 03:26:11.195685
663	87	0.125	tsp	ground nutmeg		2019-02-20 03:26:11.19735	2019-02-20 03:26:11.19735
664	87	1	cup	shredded smoked cheddar cheese		2019-02-20 03:26:11.200126	2019-02-20 03:26:11.200126
665	87	4	whole	green onion	chopped	2019-02-20 03:26:11.206561	2019-02-20 03:26:11.206561
666	88	1	can	beans		2019-02-20 03:45:03.874498	2019-02-20 03:45:03.874498
667	88	2	stalk	celery		2019-02-20 03:45:03.884034	2019-02-20 03:45:03.884034
\.


--
-- Data for Name: meal_plan_recipes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.meal_plan_recipes (id, meal_plan_id, recipe_id, created_at, updated_at) FROM stdin;
1	\N	\N	2018-08-28 02:33:34.386129	2018-08-28 02:33:34.386129
2	\N	\N	2018-08-28 02:33:38.418265	2018-08-28 02:33:38.418265
3	\N	\N	2018-08-28 03:17:19.670532	2018-08-28 03:17:19.670532
4	\N	\N	2018-08-28 12:17:04.101926	2018-08-28 12:17:04.101926
5	\N	\N	2018-08-28 14:38:41.369342	2018-08-28 14:38:41.369342
7	\N	\N	2018-08-28 14:38:54.173703	2018-08-28 14:38:54.173703
9	\N	\N	2018-08-28 14:38:54.17591	2018-08-28 14:38:54.17591
8	\N	\N	2018-08-28 14:38:54.174811	2018-08-28 14:38:54.174811
10	\N	\N	2018-08-28 14:38:54.176969	2018-08-28 14:38:54.176969
6	\N	\N	2018-08-28 14:38:54.171903	2018-08-28 14:38:54.171903
11	\N	\N	2018-08-28 14:38:54.183955	2018-08-28 14:38:54.183955
13	\N	\N	2018-08-28 14:38:54.186332	2018-08-28 14:38:54.186332
12	\N	\N	2018-08-28 14:38:54.185243	2018-08-28 14:38:54.185243
14	\N	\N	2018-08-28 14:38:54.187363	2018-08-28 14:38:54.187363
17	\N	\N	2018-08-28 14:38:54.196908	2018-08-28 14:38:54.196908
19	\N	\N	2018-08-28 14:38:54.198769	2018-08-28 14:38:54.198769
15	\N	\N	2018-08-28 14:38:54.194772	2018-08-28 14:38:54.194772
18	\N	\N	2018-08-28 14:38:54.197834	2018-08-28 14:38:54.197834
16	\N	\N	2018-08-28 14:38:54.195899	2018-08-28 14:38:54.195899
20	\N	\N	2018-08-28 14:38:54.204511	2018-08-28 14:38:54.204511
40	\N	\N	2018-08-28 15:32:20.754473	2018-08-28 15:32:20.754473
47	\N	\N	2018-08-28 15:32:20.768778	2018-08-28 15:32:20.768778
50	\N	\N	2018-08-28 15:32:20.776542	2018-08-28 15:32:20.776542
75	\N	\N	2018-08-30 02:40:04.280183	2018-08-30 02:40:04.280183
73	\N	\N	2018-08-30 02:40:04.275808	2018-08-30 02:40:04.275808
74	\N	\N	2018-08-30 02:40:04.278753	2018-08-30 02:40:04.278753
23	\N	\N	2018-08-28 15:00:28.154016	2018-08-28 15:00:28.154016
33	\N	\N	2018-08-28 15:00:28.177077	2018-08-28 15:00:28.177077
78	\N	\N	2018-08-30 02:40:04.289959	2018-08-30 02:40:04.289959
79	\N	\N	2018-08-30 02:40:04.29114	2018-08-30 02:40:04.29114
76	\N	\N	2018-08-30 02:40:04.287651	2018-08-30 02:40:04.287651
77	\N	\N	2018-08-30 02:40:04.288837	2018-08-30 02:40:04.288837
82	\N	\N	2018-08-30 02:40:04.301131	2018-08-30 02:40:04.301131
84	\N	\N	2018-08-30 02:40:04.303255	2018-08-30 02:40:04.303255
81	\N	\N	2018-08-30 02:40:04.300046	2018-08-30 02:40:04.300046
83	\N	\N	2018-08-30 02:40:04.302175	2018-08-30 02:40:04.302175
80	\N	\N	2018-08-30 02:40:04.298786	2018-08-30 02:40:04.298786
89	\N	\N	2018-08-30 02:40:04.315406	2018-08-30 02:40:04.315406
87	\N	\N	2018-08-30 02:40:04.313222	2018-08-30 02:40:04.313222
85	\N	\N	2018-08-30 02:40:04.310963	2018-08-30 02:40:04.310963
88	\N	\N	2018-08-30 02:40:04.314272	2018-08-30 02:40:04.314272
86	\N	\N	2018-08-30 02:40:04.312151	2018-08-30 02:40:04.312151
93	\N	\N	2018-08-30 02:40:04.326228	2018-08-30 02:40:04.326228
90	\N	\N	2018-08-30 02:40:04.323008	2018-08-30 02:40:04.323008
92	\N	\N	2018-08-30 02:40:04.325121	2018-08-30 02:40:04.325121
91	\N	\N	2018-08-30 02:40:04.324119	2018-08-30 02:40:04.324119
34	\N	\N	2018-08-28 15:00:28.184234	2018-08-28 15:00:28.184234
38	\N	\N	2018-08-28 15:00:28.1974	2018-08-28 15:00:28.1974
39	\N	\N	2018-08-28 15:32:20.74515	2018-08-28 15:32:20.74515
43	\N	\N	2018-08-28 15:32:20.757961	2018-08-28 15:32:20.757961
48	\N	\N	2018-08-28 15:32:20.769711	2018-08-28 15:32:20.769711
51	\N	\N	2018-08-28 15:32:20.782271	2018-08-28 15:32:20.782271
94	\N	\N	2018-08-30 02:40:04.33688	2018-08-30 02:40:04.33688
95	\N	\N	2018-08-30 02:40:04.338219	2018-08-30 02:40:04.338219
21	\N	\N	2018-08-28 15:00:28.151281	2018-08-28 15:00:28.151281
27	\N	\N	2018-08-28 15:00:28.165079	2018-08-28 15:00:28.165079
30	\N	\N	2018-08-28 15:00:28.173913	2018-08-28 15:00:28.173913
35	\N	\N	2018-08-28 15:00:28.193176	2018-08-28 15:00:28.193176
41	\N	\N	2018-08-28 15:32:20.755622	2018-08-28 15:32:20.755622
46	\N	\N	2018-08-28 15:32:20.76779	2018-08-28 15:32:20.76779
52	\N	\N	2018-08-28 15:32:20.783376	2018-08-28 15:32:20.783376
96	\N	\N	2018-08-30 02:40:04.339477	2018-08-30 02:40:04.339477
97	\N	\N	2018-08-30 02:40:04.34062	2018-08-30 02:40:04.34062
25	\N	\N	2018-08-28 15:00:28.156564	2018-08-28 15:00:28.156564
29	\N	\N	2018-08-28 15:00:28.167093	2018-08-28 15:00:28.167093
32	\N	\N	2018-08-28 15:00:28.176046	2018-08-28 15:00:28.176046
36	\N	\N	2018-08-28 15:00:28.194829	2018-08-28 15:00:28.194829
44	\N	\N	2018-08-28 15:32:20.759284	2018-08-28 15:32:20.759284
49	\N	\N	2018-08-28 15:32:20.770711	2018-08-28 15:32:20.770711
53	\N	\N	2018-08-28 15:32:20.784313	2018-08-28 15:32:20.784313
24	\N	\N	2018-08-28 15:00:28.155364	2018-08-28 15:00:28.155364
26	\N	\N	2018-08-28 15:00:28.163872	2018-08-28 15:00:28.163872
42	\N	\N	2018-08-28 15:32:20.756723	2018-08-28 15:32:20.756723
45	\N	\N	2018-08-28 15:32:20.766694	2018-08-28 15:32:20.766694
22	\N	\N	2018-08-28 15:00:28.152795	2018-08-28 15:00:28.152795
28	\N	\N	2018-08-28 15:00:28.166106	2018-08-28 15:00:28.166106
31	\N	\N	2018-08-28 15:00:28.175013	2018-08-28 15:00:28.175013
37	\N	\N	2018-08-28 15:00:28.196196	2018-08-28 15:00:28.196196
58	\N	\N	2018-08-28 15:33:53.20904	2018-08-28 15:33:53.20904
56	\N	\N	2018-08-28 15:33:53.206607	2018-08-28 15:33:53.206607
55	\N	\N	2018-08-28 15:33:53.205323	2018-08-28 15:33:53.205323
57	\N	\N	2018-08-28 15:33:53.207785	2018-08-28 15:33:53.207785
54	\N	\N	2018-08-28 15:33:53.203646	2018-08-28 15:33:53.203646
60	\N	\N	2018-08-28 15:33:53.216913	2018-08-28 15:33:53.216913
61	\N	\N	2018-08-28 15:33:53.217939	2018-08-28 15:33:53.217939
59	\N	\N	2018-08-28 15:33:53.215685	2018-08-28 15:33:53.215685
65	\N	\N	2018-08-28 15:33:53.227659	2018-08-28 15:33:53.227659
62	\N	\N	2018-08-28 15:33:53.224565	2018-08-28 15:33:53.224565
63	\N	\N	2018-08-28 15:33:53.225585	2018-08-28 15:33:53.225585
64	\N	\N	2018-08-28 15:33:53.226622	2018-08-28 15:33:53.226622
70	\N	\N	2018-08-28 15:33:53.242694	2018-08-28 15:33:53.242694
69	\N	\N	2018-08-28 15:33:53.241445	2018-08-28 15:33:53.241445
68	\N	\N	2018-08-28 15:33:53.240053	2018-08-28 15:33:53.240053
67	\N	\N	2018-08-28 15:33:53.238753	2018-08-28 15:33:53.238753
66	\N	\N	2018-08-28 15:33:53.237209	2018-08-28 15:33:53.237209
72	\N	\N	2018-08-28 15:33:53.250131	2018-08-28 15:33:53.250131
71	\N	\N	2018-08-28 15:33:53.249008	2018-08-28 15:33:53.249008
121	37	68	2019-02-17 00:22:34.857729	2019-02-17 00:22:34.857729
122	37	69	2019-02-17 00:22:34.860332	2019-02-17 00:22:34.860332
123	37	72	2019-02-17 00:22:34.861649	2019-02-17 00:22:34.861649
124	37	70	2019-02-17 00:22:34.863275	2019-02-17 00:22:34.863275
125	37	71	2019-02-17 00:22:34.864563	2019-02-17 00:22:34.864563
128	39	74	2019-02-17 18:49:58.276806	2019-02-17 18:49:58.276806
129	39	73	2019-02-17 18:49:58.283207	2019-02-17 18:49:58.283207
130	39	75	2019-02-17 19:36:28.73481	2019-02-17 19:36:28.73481
131	39	51	2019-02-17 19:36:28.742546	2019-02-17 19:36:28.742546
132	39	76	2019-02-17 19:36:28.758222	2019-02-17 19:36:28.758222
133	40	64	2019-02-18 23:37:59.27807	2019-02-18 23:37:59.27807
134	40	52	2019-02-18 23:37:59.285692	2019-02-18 23:37:59.285692
135	40	77	2019-02-18 23:46:44.736594	2019-02-18 23:46:44.736594
136	40	78	2019-02-18 23:51:55.311013	2019-02-18 23:51:55.311013
137	40	79	2019-02-18 23:58:04.90251	2019-02-18 23:58:04.90251
138	41	82	2019-02-19 03:49:53.631791	2019-02-19 03:49:53.631791
139	41	81	2019-02-19 03:49:53.635303	2019-02-19 03:49:53.635303
140	41	83	2019-02-19 03:49:53.648283	2019-02-19 03:49:53.648283
141	41	84	2019-02-19 03:49:53.650346	2019-02-19 03:49:53.650346
142	41	80	2019-02-19 03:49:53.65509	2019-02-19 03:49:53.65509
143	42	86	2019-02-20 03:11:48.796795	2019-02-20 03:11:48.796795
144	43	87	2019-02-20 03:33:23.260628	2019-02-20 03:33:23.260628
145	44	68	2019-02-20 03:34:04.941361	2019-02-20 03:34:04.941361
146	44	72	2019-02-20 03:34:04.945944	2019-02-20 03:34:04.945944
\.


--
-- Data for Name: meal_plans; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.meal_plans (id, start_date, created_at, updated_at, people_served) FROM stdin;
37	2019-02-17	2019-02-17 00:22:34.853172	2019-02-17 00:22:34.853172	2
39	2019-02-10	2019-02-17 18:49:58.255976	2019-02-17 18:49:58.255976	2
40	2019-02-24	2019-02-18 23:37:59.270886	2019-02-18 23:37:59.270886	2
41	2019-03-03	2019-02-19 03:49:53.626752	2019-02-19 03:49:53.626752	2
42	2018-10-24	2019-02-20 03:11:48.791501	2019-02-20 03:11:48.791501	2
43	2007-11-22	2019-02-20 03:33:23.256372	2019-02-20 03:33:23.256372	4
44	2018-11-22	2019-02-20 03:34:04.927773	2019-02-20 03:34:04.927773	2
\.


--
-- Data for Name: recipes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.recipes (id, title, source_name, source_url, servings, instructions, created_at, updated_at, prep_time, cook_time, image_url, reheat_time, pepperplate_url, notes, archived, user_id) FROM stdin;
49	Veggie Po'boy	Warm Kitchen	https://warmkitchen.wordpress.com/2014/11/12/its-a-veggie-po-boy-yall/	4	Turn your oven onto broil\r\n\r\nCut your bread into 6″ lengths, then cut it open\r\n\r\nPlace both side face up on a baking tray and top both pieces of bread with cheese and banana peppers\r\n\r\nBroil for just a few minutes while you prep the other vegetables\r\n\r\nThinly slice your cucumbers and bell pepper\r\n\r\nCheck your poboy bread\r\n\r\nThinly slice your tomatoes and onion\r\n\r\nPrep your greens\r\n\r\nCheck your bread\r\n\r\nWhen the bread and cheese are getting all goldeny and delicious, pull them out\r\n\r\nTop with all of your vegetables, then close the lid\r\n\r\nEnjoy with a side of chips	2018-08-30 02:42:20.939534	2019-02-23 22:11:36.56123	10	20	http://cdn2.pepperplate.com/recipes/bcb751ba9ab749dbb0f48ffb083a72c5.jpg	20	http://www.pepperplate.com/recipes/view.aspx?id=15454393		f	1
51	Quick Pad Thai	Women's Health Magazine	https://subscribe.hearstmags.com/circulation/shared/index.html	4	Cook pasta according to package directions. Toss with 1 teaspoon olive oil.\r\n\r\nIn a small bowl, whisk soy sauce, peanut butter, sugar, chili flakes, and 1 tablespoon water until smooth. Set aside.\r\n\r\nCook onion and bell peppers\r\n\r\nAdd in tofu and cook for another 2 minutes.\r\n\r\nAdd cooked pasta and peanut butter mixture to pan\r\n\r\nAdd chopped cilantro.\r\n\r\nGarnish with crushed peanuts, bean sprouts, or lime wedge if desired.	2018-08-30 02:42:20.989449	2019-02-23 22:11:36.572981	10	20	http://cdn2.pepperplate.com/recipes/dad9e72fa23f4e839c6057b8684da88e.jpg	10	http://www.pepperplate.com/recipes/view.aspx?id=15772038		f	1
54	Quiche	Original Creation	/	4	Preheat oven 350F (or just use a toaster oven so you don't have to preheat)\r\n\r\nPrebake the crust for about 10 mi. Keep an eye on it because you don't want it to get too deformed in the process.\r\n\r\nYou don't have to prebake, but it keeps the bottom of the crust from getting mushy from the eggs.\r\n\r\nWhile the crust is prebaking, prepare your tomato and spinach\r\n\r\nWhen the crust is done, whisk the eggs and herbs/spices thoroughly\r\n\r\nMix in the feta, tomato, and spinach\r\n\r\nPour into shell\r\n\r\nBake about 45 min	2018-08-30 02:42:21.047749	2019-02-23 22:11:36.577613	10	30	http://cdn2.pepperplate.com/recipes/07aae73855464443b20e789a31df8caf.jpg	20	http://www.pepperplate.com/recipes/view.aspx?id=19998600		f	1
52	Creamy Lentil Soup	Bob's Red Mill	https://www.bobsredmill.com/recipes/how-to-make/creamed-vegi-soup/	4	Simmer soup mix and water for 30 minutes.\r\n\r\nAdd cut-up carrots, celery and onion.\r\n\r\nContinue cooking for 30 minutes or until ingredients are soft.\r\n\r\nCool soup enough to blend.\r\n\r\nPlace soup in blender, and blend until smooth. <-- skip this\r\n\r\nAdd 1 cup Milk (rice, soy, etc.) to blended soup.\r\n\r\nSeason to taste and warm soup to serving temperature- but do not boil.\r\n\r\nNote, broth can be substituted for water.	2018-08-30 02:42:21.008616	2019-02-23 22:11:36.580529	20	30	http://cdn2.pepperplate.com/recipes/66a034972ccf478c98983f876d11de6b.jpg	10	http://www.pepperplate.com/recipes/view.aspx?id=18529284		f	1
55	Red Lentil Curry	Jessica in the Kitchen	https://jessicainthekitchen.com/red-lentil-curry-vegan/	4	Cook down the onions and tomatoes\r\n\r\nAdd in the spices, simmer for about 30 seconds\r\n\r\nAdd in the lentils & water and bring to a boil.\r\n\r\nBe careful to stir enough to keep the lentils from sticking to the bottom.\r\n\r\nBring the temp down and a simmer for 30 min.\r\n\r\nMake rice.\r\n\r\nWhen the lentils are soft, turn off the heat and add in the coconut milk.	2018-08-30 02:42:21.07061	2019-02-23 22:11:36.585242	20	30	http://cdn2.pepperplate.com/recipes/5b8972b2e1344a83965f7a248ec4f978.jpg	15	http://www.pepperplate.com/recipes/view.aspx?id=22761475		f	1
53	Blended Red Lentil Soup	Loving it Vegan	https://lovingitvegan.com/vegan-lentil-soup/	4	Peel and chop the onion and add to a pot with the olive oil and cumin and sauté until slightly softened.\r\n\r\nAdd the carrots and toss together. Then the lentils and toss together with the other vegetables.\r\n\r\nFinally, add in the vegetable stock and mix together.\r\n\r\nBring to the boil and then reduce heat, cover the pot and simmer until the lentils are cooked (they should be soft).\r\n\r\nTake the pot off the heat and blend directly in the pot using an immersion blender.\r\n\r\nIf you don’t have an immersion blender, then transfer to your blender jug and blend up in stages until it’s all smooth.\r\n\r\nServe into bowls and garnish with black pepper.	2018-08-30 02:42:21.031094	2019-02-23 22:11:36.592233	10	30	http://cdn2.pepperplate.com/recipes/7830f70754dd4f75ba89595ee1568cf2.jpg	10	http://www.pepperplate.com/recipes/view.aspx?id=22709198		f	1
50	Caraotas Negras	GOYA	https://www.goya.com/en/recipes/dishes-desserts/caraotas-negras	4	Add bacon to medium saucepan over medium-high heat.\r\n\r\nCook until fat is rendered and bacon begins to crisp, about 7 minutes.\r\n\r\nAdd onions, peppers and garlic.\r\n\r\nCook, stirring occasionally, until onions soften and begin to brown, about 12 minutes.\r\n\r\nStir in brown sugar cane (if desired), stirring until well combined.\r\n\r\nStir in black beans, 3/4 cup water and Adobo.\r\n\r\nBring mixture to boil.	2018-08-30 02:42:20.96505	2019-02-23 22:11:36.595967	10	20	http://cdn2.pepperplate.com/recipes/edca0cc48bfe4d45bf3d27bb66b76c3b.jpg	10	http://www.pepperplate.com/recipes/view.aspx?id=20213928		f	1
64	Arroz Con Gandules Pigeon Peas	GOYA	https://www.goya.com/en/recipes/arroz-con-gandules	8	Toast coconut flakes in a dry skillet until they start to get a little brown\r\n\r\nIn large skillet, cook onions and peppers, cook for 3 minutes\r\n\r\nStir in garlic\r\n\r\nAdd gandules, tomato sauce, water, and bring to a boil\r\n\r\nAdd coconut flakes and rice\r\n\r\nStir, cover, reduce to simmer for 25 min	2019-01-27 21:59:07.980688	2019-02-23 22:11:36.607389	10	25	http://cdn2.pepperplate.com/recipes/597c21cde8f243d8963affe31aa588b6.jpg	15	http://www.pepperplate.com/recipes/view.aspx?id=20213636		f	1
67	Asian Raw Kale Salad	Cookie + Kate	https://cookieandkate.com/2011/raw-kale-asian-salad/	4	First you have to make the dressing. Simply blend all dressing ingredients thoroughly in a food processor or blender.\r\n\r\nPull the kale leaves off from the tough stem, and break into small, bite sized pieces. \r\n\r\nSprinkle with sea salt and massage the leaves for a couple of minutes, meaning that you should scrunch handfuls of kale in your hands, release, repeat. The kale will become darker in color and more fragrant. This step improves the taste of raw kale.\r\n\r\nThrow the kale into a bowl, drizzle in the salad dressing (don’t skimp), and toss thoroughly.\r\n\r\nAdd the avocado, carrots, cabbage and red onion.\r\n\r\nTop with cilantro and a big sprinkle of sesame seeds. Enjoy!	2019-02-16 21:57:20.4353	2019-02-23 22:11:36.610391	60	0	http://cdn2.pepperplate.com/recipes/eebd1e4d5b7e4a4b8e143c745ac5e180.jpg	0	http://www.pepperplate.com/recipes/view.aspx?id=20582867		f	1
73	Potato Leek Soup	Bon Appétit	https://www.bonappetit.com/recipe/potato-leek-soup-toasted-nuts-seeds	6	Trim dark green leaves from leeks; discard all but 2. Tuck thyme, rosemary, and bay leaves inside leek leaves; tie closed with kitchen twine. Thinly slice light and pale-green parts of leeks.\r\n\r\nHeat butter in a large heavy pot over medium-high. Add celery and sliced leeks and season with salt and pepper. Cook, stirring, until leeks begin to soften, about 5 minutes. Reduce heat to medium-low, add herb bundle, cover pot, and cook, checking and stirring occasionally, until leeks and celery are very soft, 25–30 minutes (this long, slow cooking draws maximum flavor out of the vegetables). Increase heat to medium-high, add potato and 5 cups broth, and bring to a boil. Reduce heat and simmer, stirring occasionally, until potato is very tender, 10–15 minutes. Let cool slightly.\r\n\r\nWorking in batches, purée leek mixture in a blender until very smooth (make sure lid is slightly ajar to let steam escape; cover with a towel). Transfer to a large bowl or pitcher.\r\nPour soup back into pot and add cream. Thin with broth, if needed. Taste and season with salt and pepper; keep warm.\r\n\r\nHeat oil in a small skillet over medium. Add almonds, sunflower seeds, and coriander seeds and sprinkle sugar over; cook, stirring, until nuts and seeds are golden, about 4 minutes. Transfer nuts to paper towels to drain; season with salt and pepper.\r\n\r\nServe soup topped with crème fraîche and nut mixture.\r\n\r\nDo ahead: Soup and nut mixture can be made 4 days ahead. Let soup cool; cover and chill. Store nut mixture airtight at room temperature.	2019-02-17 18:40:21.821345	2019-02-23 22:11:36.613224	60	30	http://cdn2.pepperplate.com/recipes/8e88c9c12e3c4ffc93084d97ba476877.jpg	10	http://www.pepperplate.com/recipes/view.aspx?id=22778959		f	1
83	Lentil & Kale Egg Noodle Bowl	Clean and Delicious	https://cleananddelicious.com/2017/10/06/lentil-kale-whole-grain-noodle-bowl/	4	Heat olive oil in a large sauce pan before adding in onion. Cook for about 5 minutes or until the onions are tender and translucent.\r\n\r\nAdd in garlic, cumin and lentils. Gently mix together and season with salt and pepper. Next, add the veggie broth and let everything simmer until heated through.\r\n\r\nIn the meantime, cook your noodles according to the package directions and drain.\r\n\r\nPlace kale on the bottom of the pot and then pour hot noodles over the kale. Top with the lentil mixture and mix everything together. Finish with parmesan cheese and enjoy!	2019-02-19 03:43:20.393281	2019-02-23 22:11:36.616284	5	20	http://cdn2.pepperplate.com/recipes/35d6e74b67b74514954b65988119b7c9.jpg	5	http://www.pepperplate.com/recipes/view.aspx?id=22997172		f	1
70	Pierogi Pizza	All Recipes	https://www.allrecipes.com/recipe/245593/pierogi-pizza/	4	Place potatoes in a large pot and pour in enough water to cover. Add bouillon. Bring to a boil; cook until potatoes are just tender, about 10 minutes. Drain.\r\n\r\nHeat 2 tablespoons olive oil in a large skillet over medium-high heat; add potatoes and cook until lightly golden, about 5 minutes.\r\n\r\nPreheat oven to 400 degrees F (200 degrees C).\r\n\r\nWhisk sour cream and garlic powder together in a small bowl to make pizza "sauce".\r\n\r\nGently pat and stretch pizza dough out to a 12-inch circle on a pizza stone. Spread sauce evenly over dough. Layer potatoes on top to cover dough completely. Sprinkle Cheddar cheese, green onions, and bacon bits on top.\r\n\r\nBake pizza in the preheated oven until crust is golden brown, 15 to 20 minutes.	2019-02-16 22:42:00.267881	2019-02-23 22:11:36.625341	60	30	https://images.media-allrecipes.com/userphotos/560x315/3383420.jpg	20	\N	\N	f	1
71	Sweet Potato Gnocchis	Original Creation	/	4	Boil water in a medium sauce pan\r\n\r\nPrepare spices and chop the broccolini\r\n\r\nWhen the water is boiling, drop in the gnocchi. Boil until they float and then drain immediately.\r\n\r\nMeanwhile, start melting butter in a skillet. When the gnocchis are sufficiently drained, add them plus the broccolini and spices to the skillet. \r\n\r\nCook just enough to brown everything a little bit. \r\n\r\nRemove from skillet and mix in with a little goat cheese until well combined. Serve immediately. 	2019-02-16 22:44:48.728087	2019-02-23 22:11:36.62831	10	20		20	\N	\N	f	1
72	Corn Chowder	I Eat Green	http://www.ieatgreen.com/vegan-corn-chowder/	6	Sautee the onion in the pot with the lid on\r\n\r\nAdd the rest of the veg and spices and close the lid. Cook down for about 15 minutes.\r\n\r\nAdd the vegetable stock and simmer on low for 20 min.\r\n\r\nRemove from heat. Add the can of coconut milk and parsley to the pot.\r\n\r\nBlend with the immersion blender, until chunky.	2019-02-16 22:59:10.209139	2019-02-23 22:11:36.631203	15	30	http://www.ieatgreen.com/wp-content/uploads/2012/08/IMG_0422-1024x941.jpg	15	\N	\N	f	1
69	City O City Breakfast Burrito	Original Creation	/	6	Cube and bake the potato\r\n\r\nChop and sautee: onion, bell pepper, anaheim\r\n\r\nOnce softened, mix in crumbled tofu and add spices\r\n\r\nWhen potatoes are done, mix them into the tofu\r\n\r\nUse the Toaster oven to soften the large tortillas\r\n\r\nPut each one on a plate, fill with mixture and fixins.\r\n\r\nRoll & top with salsa.	2019-02-16 22:37:55.590917	2019-02-23 22:11:36.63439	20	5	http://cdn2.pepperplate.com/recipes/49fb0f90f37f4c5190840f7565b6d821.jpg	20	http://www.pepperplate.com/recipes/view.aspx?id=19268430		f	1
77	Curried Satay Veggie Bowls	Jessica In the Kitchen	https://jessicainthekitchen.com/curried-satay-veggie-bowls/	4	Weekly meal prep notes\r\nSpiralize or peel the zucchini into ribbons. Cook them briefly in a little oil to soften.\r\nCook the spaghetti.\r\nSet aside the zucchini and spaghetti.\r\nPlace everything else in a quart mason jar\r\nBlend with the immersion blender\r\nAdd water until it is a saucy consistency\r\nStore the sauce in the same jar that you blended it in. Plan to use 1/2 of it for (2 servings) at a time.\r\nStore the zucchini, sauce, and cooked spaghetti separately.\r\n\r\nWhen reheating\r\nWarm the pasta with warm water\r\nWarm the sauce and zucchini in a pot\r\nMix in the pasta before serving	2019-02-18 23:46:30.920188	2019-02-23 22:11:36.64036	20	10	http://cdn2.pepperplate.com/recipes/b734213a02984cbb83a471eca370fd45.jpg	10	http://www.pepperplate.com/recipes/view.aspx?id=22657139		f	1
76	Wild Rice and Mushroom Soup	Pinch of Yum	https://pinchofyum.com/instant-pot-wild-rice-soup	6	Stovetop: When the soup is done, melt the butter in a saucepan. Whisk in the flour. Let the mixture cook for a minute or two to remove the floury taste. Whisk the milk, a little bit at a time, until you have a smooth, thickened sauce. Throw a little salt in there for good measure.\r\n	2019-02-17 19:32:45.998001	2019-02-23 22:11:36.643169	20	60	http://cdn2.pepperplate.com/recipes/f758b85c4a374355a63df720998097d2.jpg	10	http://www.pepperplate.com/recipes/view.aspx?id=23158236		f	1
75	Jackfruit Melt Sandwich	Keepin It Kind	http://keepinitkind.com/jackfruit-tuna-melt-sandwich/	6	Sautee onion & garlic\r\n\r\nAdd tarragon, jackfruit, and beans to warm\r\n\r\nOnce warmed, pour mixture into a bowl\r\n\r\nMix with mayo, celery, mustard, relish, lemon juice, and mash it up together. Mashing the beans is nice, but don't expect to mash them completely.\r\n\r\nLightly pre-toast the bread\r\n\r\nWhen done, put a slice of cheese on each face and toast it enough to melt it and harden the bread slightly\r\n\r\nSpoon some jackfruit mix onto a slice of bread, top with tomato & greens, put the other slice on and cut in half.\r\n\r\nDelicious hot or cold.	2019-02-17 19:25:06.272584	2019-02-23 22:11:36.651475	15	10	http://cdn2.pepperplate.com/recipes/47b2f69c8d0d43dda4afe9d63f442a3f.jpg	15	http://www.pepperplate.com/recipes/view.aspx?id=19099296		f	1
78	Tortilla Soup	Cookie + Kate	https://cookieandkate.com/2013/vegetarian-tortilla-soup/	6	Prep work: Preheat the oven to 475 degrees Fahrenheit. Stack the tortillas and slice them into 1/2-inch-wide, 2-inch-long strips. Remove the seeds and membranes from the jalapeno (and poblano, if using) and chop the peppers. Wash your hands. Pit, peel, and medium dice the avocado, then squeeze some lime juice over the avocado to prevent browning.\r\n\r\nBake the tortillas: Coat a baking sheet with a thin layer of oil. Toss the tortilla strips in the oil to coat and arrange the strips in a single layer. Bake 6 to 8 minutes, or until golden brown. While the strips are hot, season them with salt.\r\n\r\nToast the chili pepper: Place the dried chili pepper onto a baking sheet and bake for about 1 minute, or until the pepper is warmed through. When cool enough to handle, cut the pepper open and remove the seeds. (Wash your hands afterward and avoid touching your eyes!)\r\n\r\nMake the soup: In a medium pot or Dutch oven, heat some olive oil on medium until hot. Add the onion, garlic, jalapeno and poblano peppers (if using). Cook 4 to 5 minutes, or until softened, stirring occasionally. Stir in the cumin, then the canned tomatoes and vegetable stock. Simmer for about 3 minutes, then add the hominy, black beans and the seeded chili pepper. Cook for 8 to 10 minutes, or until slightly thickened, stirring occasionally. Season with salt and pepper to taste.\r\n\r\nServe the soup: First, discard the dried chili pepper. Place some of the avocado, radishes, tortilla strips, and queso fresco (or feta) at the bottom of 2 to 4 bowls. Divide the soup between the bowls. Top the soup with the remaining avocado, radishes, tortilla strips, and queso fresco (or feta). Garnish with some cilantro and serve with lime wedges and hot sauce, if desired.\r\n	2019-02-18 23:51:46.451153	2019-02-23 22:11:36.655121	15	30	http://cdn2.pepperplate.com/recipes/5fce923917ca4cc684742e986d778104.jpg	10	http://www.pepperplate.com/recipes/view.aspx?id=22025023		f	1
81	Ginger Broccolini Stir Fry	All Recipes	http://allrecipes.com/recipe/24712/ginger-veggie-stir-fry/	4	Put 2 cups water in a pot, add 1 cup dry rice. Turn burner on high. Bring to boil and then move to new burner on low.\r\n\r\nprepare stir fry to store for the week\r\nchop all of the things and divide them equally between 2 yogurt containers\r\nmake the rice and divide it between 2 containers\r\n\r\nmake stir fry to eat now\r\nreheat the rice somehow. your choice.\r\nadd a little oil to a skillet\r\ndump 1 of the yogurt containers in the skillet, turn burner to level 8\r\nadd the sauce ingredients, stir & cover\r\nonly let this cook for a few minutes. watch it carefully (with the lid on). You want the veg to soften slightly while still being crispy-ish.\r\nserve over rice.	2019-02-19 03:32:43.982094	2019-02-23 22:11:36.658229	20	10		10	http://www.pepperplate.com/recipes/view.aspx?id=18986094		f	1
80	Spicy Black Bean Soup	Cookie + Kate	https://cookieandkate.com/2016/spicy-vegan-black-bean-soup/	4	Cook down the onions, celery and carrot until soft, about 10 to 15 minutes.\r\n\r\nAdd in spices and stir for 30 seconds\r\n\r\nPour in the beans and broth and bring to a gentle simmer.\r\n\r\nSimmer until the broth is flavorful and the beans are very tender, about 30 minutes.\r\n\r\nTake it off the heat and use the immersion blender + water to your liking to get it your preferred consistency.	2019-02-19 03:27:35.346283	2019-02-23 22:11:36.660855	20	30	http://cdn2.pepperplate.com/recipes/9380a9a30a0e47cfa4bb65f61b9c3834.jpg	10	http://www.pepperplate.com/recipes/view.aspx?id=22230216		f	1
82	Chorizo Sweet Potato Skillet	Budget Bytes	http://www.budgetbytes.com/2014/06/chorizo-sweet-potato-skillet/	6	Peel and dice the sweet potato into 1/2 to 3/4 inch cubes (size matters, make them small). Sauté the sweet potato cubes in a large skillet with olive oil over medium heat for about 5 minutes, or until the sweet potatoes have softened about half way through (they'll cook more later).\r\n\r\nSqueeze the chorizo out of its casing into the skillet with the sweet potatoes. Sauté the chorizo and sweet potatoes together, breaking the chorizo up into small pieces as it browns.\r\n\r\nOnce the chorizo is fully browned, pour off any excess grease if needed. Rinse and drain the black beans. Add the beans, salsa, and uncooked rice to the skillet. Stir them into the sweet potatoes and chorizo until everything is well combined.\r\n\r\nAdd the chicken broth, stir briefly, then place a lid on the skillet. Allow the contents of the skillet to come up to a boil, then turn the heat down to low. Let the skillet simmer on low for 30 minutes. Make sure it is simmering the whole time (you should be able to hear it quietly simmer away). If it is not, turn the heat up slightly.\r\n\r\nAfter 30 minutes the rice should be tender and have absorbed all of the liquid. Turn off the heat, fluff the mixture, sprinkle the cheese on top, then return the lid to trap the residual heat and help the cheese melt. Slice the green onions while the cheese is melting, then sprinkle them on top and serve.\r\n	2019-02-19 03:38:40.489568	2019-02-23 22:11:36.673427	10	30	http://cdn2.pepperplate.com/recipes/da3e6c1a7731400dbddfba8d6c9f9413.jpg	10	http://www.pepperplate.com/recipes/view.aspx?id=15454413		f	1
85	Sweet Potato Pie	ThroughmyiMedia	https://youtu.be/BOYWrXVGV5E?t=148	8	Heat oven to 350F\r\n\r\nWash sweet potatoes and poke holes in them with a fork\r\n\r\nRub them in butter and wrap them in foil.\r\n\r\nBake for an hour or until they are soft. Cool them for 20 minutes before peeling. \r\n\r\nPre-bake empty pie shell for 15-20 minutes until dough starts to brown. Remember to cover the edges with foil so they don't brown too fast. \r\n\r\nMash them in a bowl with all of the dry ingredients.\r\n\r\nBeat eggs and add to the potato mix. Incorporate completely. \r\n\r\nAdd butter and milk and mix on slow speed until well incorporated.\r\n\r\nPour mixture into pie shell and bake at 350F for 45 minutes until the pie has set and the crust edges are golden brown.\r\n	2019-02-19 14:00:41.21195	2019-02-23 22:11:36.67599	0	0		0			f	1
86	test recipe	Original Creation	/	4	Boil the water\r\n\r\nCool the water	2019-02-20 03:11:26.659849	2019-02-23 22:11:36.678382	30	30	http://i.dailymail.co.uk/i/pix/2015/05/22/13/28F805FD00000578-0-image-a-36_1432299542585.jpg	15			f	1
87	Twice-Baked Sweet Potatoes	Rachael Ray	https://www.rachaelrayshow.com/recipe/15311_Twice_Baked_Sweet_Potatoes	4	Preheat oven to 350F.\r\n\r\nPlace the potatoes on a small baking sheet. Drizzle with a little EVOO and rub them with some salt and freshly ground black pepper. Bake them 45 minutes to an hour, until tender. When the potatoes have finished baking, remove them from the oven and allow them to cool enough that you can handle them.\r\n\r\nWhile the potatoes are cooling, heat a small skillet over medium heat and saut the chorizo until crisp, 4-5 minutes. Remove the cooked chorizo from the pan to a paper towel-lined plate and reserve. Preheat broiler to high.\r\n\r\nWhen youre able to handle the potatoes, cut them lengthwise, being careful not to cut them all the way through (you should be able to open the potato like a book). Scoop out the cooked insides using a spoon, then transfer them to the same pan you cooked the chorizo in. Make sure not pierce the skin of the potato, you want it to keep its shape.\r\n\r\nTo the pan, add the chicken stock, butter, pumpkin, honey, garlic, chipotle and adobo sauce, orange zest, juice of 1/2 orange, nutmeg, salt and freshly ground pepper. Mash everything together using a potato masher.\r\n\r\nCarefully refill the potato skin shells with the mashed potato mixture and transfer them back to the baking sheet. Top each potato with some of the reserved crispy chorizo and a small handful of shredded cheese. Place the potatoes under the broiler to melt the cheese, about 1 minute.\r\n\r\nTo serve, top each potato with some chopped scallions and serve a simple salad alongside.	2019-02-20 03:26:11.178865	2019-02-23 22:11:36.680811	30	120	https://www.rachaelrayshow.com/sites/default/files/styles/1100x620/public/images/2018-07/e3d3df46b70f76b21404bf38e34f3802.jpg?itok=o48-G2nP	20			f	1
61	Enfrijoladas	Budget Bytes	https://www.budgetbytes.com/enfrijoladas-tortillas-in-black-bean-sauce/	6	To make the black bean sauce, combine the drained black beans, chipotle peppers plus about 1 Tbsp of the adobo sauce, 1/4 of the sweet onion (diced), cumin, and garlic in a blender or food processor. Starting with one cup, add the broth as you blend until a smooth, thick sauce forms. Taste and adjust the salt as needed (this will depend on the salt content of the broth you use).\r\n\r\nPreheat the oven to 350ºF. Heat the tortillas by either microwaving the stack for 30 seconds, toasting them in a skillet, or directly on a gas burner until lightly browned. Cover the stacked warmed tortillas with foil to retain the heat and steam.\r\n\r\nFinely dice the rest of the sweet onion. Roughly chop the cilantro leaves, add them to the diced onion along with a pinch of salt, and stir to combine. Set the onion and cilantro mixture aside to marinate.\r\n\r\nPour a small amount of the black bean sauce into a casserole dish and spread it around to cover the bottom. Pour more sauce into a wide shallow bowl or dish for dipping the tortillas.\r\n\r\nOne by one, dip the tortillas in the black bean sauce until both sides are coated in the thick sauce. Sprinkle a little cheese and a little of the onion cilantro mixture over half of the tortilla, fold it closed, then fold in half once more to make a triangle. Place the dipped, filled, and folded tortillas in the prepared casserole dish. Be careful to only place a very small amount of filling in the tortillas to make them easier to fold. More filling will be placed on top after baking.\r\n\r\nOnce all the tortillas are dipped, filled, folded, and placed in the casserole dish, pour any remaining black bean sauce over top. Bake the tortillas in the preheated oven for about 15 minutes, or just until heated through. Top with the remaining cheese and onion cilantro mixture after baking, then serve.\r\n\r\nRECIPE NOTES\r\n\r\nI use Better Than Bouillon to mix up broth when I need it and in the amount that I need.	2018-08-30 16:43:52.66932	2019-02-23 22:11:36.599245	30	30	http://cdn2.pepperplate.com/recipes/3daaf5a950cf4ac6a91489feb1f69ddd.jpg?preset=sitethumb	30	http://www.pepperplate.com/recipes/view.aspx?id=22709115		f	1
63	Apricot Lentil Soup	The Stingy Vegan	https://thestingyvegan.com/vegan-lentil-soup/	4	Heat a medium-sized pot over medium-high heat and add a splash of water (or oil if you prefer), the onion and garlic. Fry (add more water as necessary if the pot is dry) until the onion is soft and translucent then add the carrots. Fry until the carrots are beginning to soften then add the apricots and cumin. Give it another minute or so, stirring, until the cumin is fragrant.\r\n\r\nAdd the lentils, can of tomatoes and vegetable stock and bring to a boil. Reduce the heat to medium-low and cover the pot. Simmer very gently until the lentils are tender – about 20 minutes. Use an immersion blender, or remove some of the soup from the pot into a stand blender, and blitz until you reach the consistency that you want. You can make all the soup totally smooth or keep some texture.\r\n\r\nStir in the lemon juice, salt and pepper. Serve the soup garnished with pomegranate seeds and the herb of your choice, if using.	2019-01-26 16:41:11.400467	2019-02-23 22:11:36.604381	15	30	https://thestingyvegan.com/wp-content/uploads/2018/01/vegan-lentil-soup-photo.jpg	10	\N	\N	f	1
60	Spicy Roasted Cauliflower with Queso	Budget Bytes	https://www.budgetbytes.com/spicy-roasted-cauliflower-cheese-sauce/	4	Make Queso: <a href="http://www.pepperplate.com/recipes/view.aspx?id=22615079">Cashew Vegan Queso</a>\r\n\r\nPreheat the oven to 400ºF. In a small bowl combine the smoked paprika, garlic powder, cayenne, salt, and some freshly cracked pepper.\r\n\r\nSpread the frozen cauliflower florets out onto a baking sheet (no need to thaw first), then drizzle with olive oil and sprinkle the spices over top. Toss the cauliflower in the oil and spices until they are fairly evenly coated.\r\n\r\nTransfer the seasoned cauliflower to the preheated oven and roast for 30 minutes, stirring once half way through.\r\n\r\nAbout half way through the roasting time, begin the cheese sauce. Add the evaporated milk and butter to a small sauce pot. Heat over medium, while stirring, until the butter has melted and the evaporated milk is hot. This should only take a couple of minutes.\r\n\r\nTurn the heat under the evaporated milk to LOW and begin whisking in the shredded cheddar, one handful at a time, making sure the cheese is fully melted before adding the next handful. Once all the cheese is melted into the evaporated milk the sauce will thicken. If it's still very liquidy, keep the sauce over low heat and whisk constantly until it thickens. Often the cheese appears to be completely melted, but it has not yet totally emulsified. Remove the cheese sauce from the heat until ready to serve.*\r\n\r\nOnce the cauliflower has finished roasting, divide it into bowls or place it in a serving platter, then pour the cheese sauce over top. Serve immediately.	2018-08-30 15:32:59.072666	2019-02-23 22:11:36.619514	20	30	http://cdn2.pepperplate.com/recipes/4a948fe22cb84ea5b7f55bc7a5c3dff0.jpg	30	http://www.pepperplate.com/recipes/view.aspx?id=22615064		f	1
68	Bread Pudding with Roasted Vegetables	Taste Love and Nourish	http://www.tasteloveandnourish.com/2013/09/16/savory-vegetable-bread-pudding/	8	In a 12 inch skillet over medium high heat, add 2 T. of the olive oil then the onions, celery, red pepper. \r\n\r\nSauté for about two or three minutes then add the mushrooms, eggplant and zucchini. \r\nContinue cooking for another 2 to 3 minutes. Add the tomato, garlic and thyme and cook for just another minute. Season with just a pinch of salt and pepper. Remove from heat and set aside to cool a bit.\r\n\r\nPreheat your oven to 350 degrees.\r\n\r\nSpread the cubes of bread on a large baking sheet. Drizzle 1 T. (or a bit more if needed) of the olive oil over the cubes. Toss to coat. Toast them up a bit in the oven for about 20 minutes, tossing them every so often. When golden, remove from the oven and allow to cool a bit on the sheet.\r\n\r\nIn a medium bowl, beat the eggs then whisk in the milk, salt pepper and nutmeg.\r\n\r\nIn your largest casserole dish, butter the bottom and sides a bit and spread the cubes of bread throughout. Add the veggie mixture and pour the egg mixture over the top. Now, sprinkle the Gruyere in and give it all a little toss to get the cubes coated and to spread the love.\r\n\r\nAt this point, you can cover the dish up with wrap and put it in the fridge for later. Just remember to take the casserole out at least 20 minutes before baking.\r\n\r\nIf you are ready to bake, place the dish in the preheated oven and bake for about 45 minutes.\r\n\r\nRemove from the oven, sprinkle on some fresh parsley (and some fresh thyme if you’ve got some left over) and serve!	2019-02-16 22:12:56.099401	2019-02-23 22:11:36.622477	45	30	http://cdn2.pepperplate.com/recipes/08d4329ba51b4f07ac2a501e5249a9d3.jpg	15	http://www.pepperplate.com/recipes/view.aspx?id=15772212		f	1
88	Sample Archived Recipe	Original Creation	/	10	Make the food.	2019-02-20 03:44:39.248378	2019-02-23 22:11:36.683752	10	20	https://images.media-allrecipes.com/userphotos/560x315/3383420.jpg	10	http://www.pepperplate.com/recipes/view.aspx?id=22709198	This recipe was poooo! so it's archived now.	t	1
59	Cashew Vegan Queso	Minimalist Baker	https://minimalistbaker.com/roasted-jalapeno-vegan-queso-7-ingredients/	4	Be sure to soak your cashews overnight in cool water or in very hot water for 1 hour before starting this recipe. Drain and then proceed with recipe.\r\nPreheat oven to medium broil and add jalapeños to a baking sheet. Broil on the top oven rack for 4-7 minutes or until slightly blackened on the outside. Wrap in foil to steam for a few minutes. Then carefully peel outside skin away and remove any seeds/stems. (Note: Be sure to wash your hands after peeling to avoid getting any lingering heat on your skin or your eyes.)\r\nAdd soaked, drained cashews and jalapeños to a blender along with nutritional yeast, water, chili powder, cumin, garlic powder, salt, and hot sauce (optional).\r\nBlend, adding more water as needed to create a creamy, pourable cheese sauce. Scrape down sides as needed.\r\nTaste and adjust flavor as needed, adding more nutritional yeast for depth of flavor and cheesiness, remaining jalapeńo or chili powder for heat, cumin for smokiness, salt for saltiness, or hot sauce for additional heat.\r\nServe immediately. Will be fine at room temperature for several hours. Store leftovers covered in the refrigerator up to 5 days. Reheat on the stovetop or in the microwave.	2018-08-30 15:31:05.181915	2019-02-23 22:11:36.637422	90	0	http://cdn2.pepperplate.com/recipes/3e405e27409441d6a9d75d12e7adde0d.jpg?preset=sitethumb	5	http://www.pepperplate.com/recipes/view.aspx?id=22615079		f	1
74	Greek Stuffed Peppers	Edible Perspecitve	http://www.edibleperspective.com/home/2013/10/8/greek-stuffed-peppers.html	4	Bring broth and sundried tomatoes to a boil.\r\n\r\nAdd couscous, cover, and remove from heat.\r\n\r\nCut bell peppers in half, deseed, oil, and roast them for 30 min.\r\n\r\nContinue on to old instructions below. This is WIP\r\n\r\nHeat a pot with a swirl of oil over medium.\r\n\r\nRinse + drain the millet then add to the pot and toast [stirring] for 3-4 minutes.\r\n\r\nAdd the veggie stock and water and bring to a boil.\r\n\r\nStir once then reduce heat to simmer and cover for 20min. Do not stir during this time.\r\n\r\nBe sure the liquid has absorbed [tip the pan to check]\r\nthen remove from the heat and let sit for 10 minutes, keeping covered. Fluff with a fork.\r\nPreheat your oven to broil and lightly oil, salt, and pepper the halved peppers and place on a baking sheet.\r\n\r\nJust as you remove the millet from the burner, heat a large pan over medium and add 2-3 teaspoons of olive oil.\r\n\r\nOnce hot, add the onion and stir occasionally until translucent and soft. About 5-8 minutes.\r\nStir in the garlic, oregano, and black pepper for 30 seconds until fragrant, then add in the chickpeas and cook for about 6-8 minutes until starting to brown.\r\n\r\nWhile cooking, place peppers under the broiler for a 2-4 minutes, then flip and broil for another 2-4 minutes. You want them slightly tender, not limp. Set aside.\r\n\r\nTo your pan add the olives, sun-dried tomatoes, and 2 cups of fluffed millet and stir together.\r\n\r\nAdd in your spinach and incorporate until just starting to wilt, another 3-4 minutes.\r\n\r\nAdd half the feta, lemon juice, and lemon zest, then give it one more stir and taste. Add more salt if desired. The olives, sun-dried tomatoes, and cheese have a hefty amount of sodium so taste and add as desired.\r\n\r\nLightly pack into peppers, top with remaining feta, and place under the broiler until the mixture starts to brown. About 2-3 minutes.\r\n	2019-02-17 18:46:57.562268	2019-02-23 22:11:36.647341	45	30	http://cdn2.pepperplate.com/recipes/e7c04e9e839f4b8a9d8a2f6854e30e24.jpg	20	http://www.pepperplate.com/recipes/view.aspx?id=17619375		f	1
84	Shakshuka	Serious Eats	http://www.seriouseats.com/recipes/2016/09/shakshuka-north-african-shirred-eggs-tomato-pepper-recipe.html	4	Heat olive oil in a large, deep skillet or straight-sided sauté pan over high heat until shimmering. Add onion, red pepper, and chili and spread into an even layer. Cook, without moving, until vegetables on the bottom are deeply browned and beginning to char in spots, about 6 minutes. Stir and repeat. Continue to cook until vegetables are fully softened and spottily charred, about another 4 minutes. Add garlic and cook, stirring, until softened and fragrant, about 30 seconds. Add paprika and cumin and cook, stirring, until fragrant, about 30 seconds. Immediately add tomatoes and stir to combine (see note above). Reduce heat to a bare simmer and simmer for 10 minutes, then season to taste with salt and pepper and stir in half of cilantro or parsley.\r\n\r\nUsing a large spoon, make a well near the perimeter of the pan and break an egg directly into it. Spoon a little sauce over edges of egg white to partially submerge and contain it, leaving yolk exposed. Repeat with remaining 5 eggs, working around pan as you go. Season eggs with a little salt, cover, reduce heat to lowest setting, and cook until egg whites are barely set and yolks are still runny, 5 to 8 minutes.\r\n\r\nSprinkle with remaining cilantro or parsley, along with any of the optional toppings. Serve immediately with crusty bread.	2019-02-19 03:47:58.915324	2019-02-23 22:11:36.66365	10	30	http://cdn2.pepperplate.com/recipes/c8c943ac278f498a8f62fdce5448ad94.jpg	10	http://www.pepperplate.com/recipes/view.aspx?id=18051887	vasu says he makes this and he doesn't like lame ass southern indian food\r\n	f	1
79	Yellow Lentil Dal	Food & Wine	https://www.foodandwine.com/recipes/yellow-lentil-dal-with-fragrant-basmati-rice	6	Soak the lentils overnight\r\n\r\nIn a large saucepan, combine the yellow lentils with 3 cups of the chicken stock, the ginger and turmeric and bring to a boil. Cover partially and cook over moderate heat, stirring occasionally, until the lentils are just tender, about 20 minutes.\r\n\r\nTransfer 1 cup of the lentils to a food processor or blender and puree until smooth. Return the puree to the saucepan, add the remaining 1 cup of stock and the zucchini and bring to a simmer. Season with salt, cover and cook over moderately low heat, stirring, until the zucchini is tender, about 15 minutes.\r\n\r\nMeanwhile, in a medium skillet, heat the oil until shimmering. Add the mustard seeds and cook over moderate heat, shaking the pan, until they begin to pop, about 30 seconds. Add the onion and cook, stirring occasionally, until softened, about 7 minutes. Add the garlic and serranos and cook for 1 minute. Add the cumin and curry leaves and cook until fragrant, about 1 minute. Add the tomato and cook, stirring, until softened, about 7 minutes. Stir the tomato mixture into the dal and simmer for 5 minutes. Stir in the lemon juice, season with salt and serve with Fragrant Basmati Rice.	2019-02-18 23:57:55.658693	2019-02-23 22:11:36.666818	20	45	http://cdn2.pepperplate.com/recipes/023af666fb0d47869f31b85ec74dca6c.jpg	15	http://www.pepperplate.com/recipes/view.aspx?id=22515951		f	1
56	Creamy Cherry Tomato & Summer Squash Gnocchi	Cookie + Kate	http://cookieandkate.com/2015/creamy-cherry-tomato-summer-squash-pasta/	4	When Preparing in Advance\r\n\r\n\r\n\r\nDivide all of the veg into 2 containers.\r\n\r\n\r\n\r\nCook the gnocchi when you plan to eat it, not in advance\r\n\r\n\r\n\r\nUse 8oz of a 16oz package for each 2-person meal\r\n\r\n\r\n\r\nGeneral Prep Notes\r\n\r\n\r\n\r\nPreheat oven to 400F\r\n\r\n\r\n\r\nSlice the squashes and zucchini into half moons that are about 1/8 inch thick\r\n\r\n\r\n\r\nLube up the baking tray\r\n\r\n\r\n\r\nPlace the squashes and zucchini and whole cherry tomatoes on the baking tray in a single layer\r\n\r\n\r\n\r\nSprinkle with salt and pepper\r\n\r\n\r\n\r\nRoast for about 25 minutes, stirring to keep from sticking\r\n\r\n\r\n\r\nIt's done when the cherry tomatoes have burst and the squash is tender.\r\n\r\n\r\n\r\nCook the pasta (Use the large soup pot because we're going to put the pasta back in it) NOTE: Don't drain the pasta without consulting the next step.\r\n\r\n\r\n\r\nSet aside about a cup of pasta water when you strain the pasta.\r\n\r\n\r\n\r\nAdd 2 TBSP oil to the bottom of the soup pot then put the pasta back in and stir.\r\n\r\n\r\n\r\nImmediately add the goat cheese, garlic, and red pepper flakes\r\n\r\n\r\n\r\nPut the small mesh strainer over the pot and juice the lemon into the mix. (you may have to put one end of the strainer on the pot and the other on a wooden spoon across the pot)\r\n\r\n\r\n\r\nAdd about 1/4 cup of the reserved pasta cooking water and gently toss the pasta until the ingredients are evenly mixed together and the pasta is coated in a light sauce (add more reserved cooking water if the pasta seems dry).\r\n\r\n\r\n\r\nOnce the tomatoes and squash are done, pour the whole thing into the pot, jusices and all\r\n\r\n\r\n\r\nSeason to taste with salt and pepper\r\n\r\n\r\n\r\nStir in the basil and oregano	2018-08-30 02:42:21.097506	2019-02-23 22:11:36.670583	10	30	http://cdn2.pepperplate.com/recipes/5b2d05dbb7f34128a19cd42869d30848.jpg	30	http://www.pepperplate.com/recipes/view.aspx?id=16885372		f	1
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.schema_migrations (version) FROM stdin;
20180827151902
20180827154648
20180828021319
20180828021902
20180828123302
20180828124131
20190126164446
20190214031821
20190219035332
20190220002603
20190223215521
20190223220915
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, email, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, created_at, updated_at) FROM stdin;
1	admin@email.com	$2a$11$aIPAWHhrp5aaegKv7k2NjO/1/P7v3HcyoKsIFhfmZrzBnLiD4wCVq	\N	\N	\N	2019-02-23 21:57:59.864773	2019-02-23 21:57:59.864773
\.


--
-- Name: ingredients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ingredients_id_seq', 667, true);


--
-- Name: meal_plan_recipes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.meal_plan_recipes_id_seq', 146, true);


--
-- Name: meal_plans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.meal_plans_id_seq', 44, true);


--
-- Name: recipes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.recipes_id_seq', 88, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: ingredients ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ingredients
    ADD CONSTRAINT ingredients_pkey PRIMARY KEY (id);


--
-- Name: meal_plan_recipes meal_plan_recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meal_plan_recipes
    ADD CONSTRAINT meal_plan_recipes_pkey PRIMARY KEY (id);


--
-- Name: meal_plans meal_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meal_plans
    ADD CONSTRAINT meal_plans_pkey PRIMARY KEY (id);


--
-- Name: recipes recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_ingredients_on_recipe_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ingredients_on_recipe_id ON public.ingredients USING btree (recipe_id);


--
-- Name: index_meal_plan_recipes_on_meal_plan_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_meal_plan_recipes_on_meal_plan_id ON public.meal_plan_recipes USING btree (meal_plan_id);


--
-- Name: index_meal_plan_recipes_on_recipe_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_meal_plan_recipes_on_recipe_id ON public.meal_plan_recipes USING btree (recipe_id);


--
-- Name: index_recipes_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recipes_on_user_id ON public.recipes USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: meal_plan_recipes fk_rails_023615d474; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meal_plan_recipes
    ADD CONSTRAINT fk_rails_023615d474 FOREIGN KEY (meal_plan_id) REFERENCES public.meal_plans(id);


--
-- Name: ingredients fk_rails_3ee351e1cd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ingredients
    ADD CONSTRAINT fk_rails_3ee351e1cd FOREIGN KEY (recipe_id) REFERENCES public.recipes(id);


--
-- Name: meal_plan_recipes fk_rails_5a632fcef8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meal_plan_recipes
    ADD CONSTRAINT fk_rails_5a632fcef8 FOREIGN KEY (recipe_id) REFERENCES public.recipes(id);


--
-- Name: recipes fk_rails_9606fce865; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT fk_rails_9606fce865 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

