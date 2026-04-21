--
-- PostgreSQL database dump
--

\restrict vYOnEfeWsMWqQli8qdAxT3WqGkkmz7jxJqsP0vEpS7WeLeLV9iiGVR7aql54d5X

-- Dumped from database version 16.10
-- Dumped by pg_dump version 16.10

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: conversations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.conversations (
    id integer NOT NULL,
    title text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    user_id integer
);


ALTER TABLE public.conversations OWNER TO postgres;

--
-- Name: conversations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.conversations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.conversations_id_seq OWNER TO postgres;

--
-- Name: conversations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.conversations_id_seq OWNED BY public.conversations.id;


--
-- Name: keyword_lib; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.keyword_lib (
    id integer NOT NULL,
    category text NOT NULL,
    key text NOT NULL,
    keywords text[]
);


ALTER TABLE public.keyword_lib OWNER TO postgres;

--
-- Name: keyword_lib_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.keyword_lib_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.keyword_lib_id_seq OWNER TO postgres;

--
-- Name: keyword_lib_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.keyword_lib_id_seq OWNED BY public.keyword_lib.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.messages (
    id integer NOT NULL,
    conversation_id integer NOT NULL,
    role text NOT NULL,
    content text NOT NULL,
    wine_recommendations jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.messages OWNER TO postgres;

--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.messages_id_seq OWNER TO postgres;

--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.messages_id_seq OWNED BY public.messages.id;


--
-- Name: occasion_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.occasion_types (
    id integer NOT NULL,
    occasion text NOT NULL,
    occasion_en text,
    description text,
    use_hint text,
    keywords text[]
);


ALTER TABLE public.occasion_types OWNER TO postgres;

--
-- Name: occasion_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.occasion_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.occasion_types_id_seq OWNER TO postgres;

--
-- Name: occasion_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.occasion_types_id_seq OWNED BY public.occasion_types.id;


--
-- Name: price_ranges; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_ranges (
    id integer NOT NULL,
    range_name text NOT NULL,
    min_price integer NOT NULL,
    max_price integer NOT NULL,
    keywords text[] DEFAULT '{}'::text[]
);


ALTER TABLE public.price_ranges OWNER TO postgres;

--
-- Name: price_ranges_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.price_ranges_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.price_ranges_id_seq OWNER TO postgres;

--
-- Name: price_ranges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.price_ranges_id_seq OWNED BY public.price_ranges.id;


--
-- Name: session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.session (
    sid character varying NOT NULL,
    sess json NOT NULL,
    expire timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.session OWNER TO postgres;

--
-- Name: taste_levels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.taste_levels (
    id integer NOT NULL,
    attribute text NOT NULL,
    level integer NOT NULL,
    keywords text[] DEFAULT '{}'::text[]
);


ALTER TABLE public.taste_levels OWNER TO postgres;

--
-- Name: taste_levels_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.taste_levels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.taste_levels_id_seq OWNER TO postgres;

--
-- Name: taste_levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.taste_levels_id_seq OWNED BY public.taste_levels.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    name text,
    role text DEFAULT 'user'::text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: wine_occasions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wine_occasions (
    id integer NOT NULL,
    wine_id character varying(20) NOT NULL,
    occasion_id integer NOT NULL
);


ALTER TABLE public.wine_occasions OWNER TO postgres;

--
-- Name: wine_occasions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.wine_occasions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.wine_occasions_id_seq OWNER TO postgres;

--
-- Name: wine_occasions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.wine_occasions_id_seq OWNED BY public.wine_occasions.id;


--
-- Name: wines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wines (
    id character varying(20) NOT NULL,
    name_en text,
    name_kr text NOT NULL,
    producer text,
    nation text,
    region text,
    varieties text,
    type text,
    use text,
    abv real,
    sweet real,
    acidity real,
    body real,
    tannin real,
    price integer,
    year text,
    ml integer,
    stock integer,
    vivino_rating real,
    summary text,
    notes text,
    description text,
    tasting_note text,
    pairing text,
    sample_group text
);


ALTER TABLE public.wines OWNER TO postgres;

--
-- Name: conversations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversations ALTER COLUMN id SET DEFAULT nextval('public.conversations_id_seq'::regclass);


--
-- Name: keyword_lib id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keyword_lib ALTER COLUMN id SET DEFAULT nextval('public.keyword_lib_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.messages_id_seq'::regclass);


--
-- Name: occasion_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.occasion_types ALTER COLUMN id SET DEFAULT nextval('public.occasion_types_id_seq'::regclass);


--
-- Name: price_ranges id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_ranges ALTER COLUMN id SET DEFAULT nextval('public.price_ranges_id_seq'::regclass);


--
-- Name: taste_levels id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taste_levels ALTER COLUMN id SET DEFAULT nextval('public.taste_levels_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: wine_occasions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wine_occasions ALTER COLUMN id SET DEFAULT nextval('public.wine_occasions_id_seq'::regclass);


--
-- Data for Name: conversations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.conversations (id, title, created_at, user_id) FROM stdin;
7	Wine Consultation	2026-01-31 01:32:49.850865	\N
\.


--
-- Data for Name: keyword_lib; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.keyword_lib (id, category, key, keywords) FROM stdin;
2	nation	Argentina	{말벡,멘도사,페냐플로르,트라피체,"탄닌이 강한",강한맛}
3	nation	Australia	{쉬라즈,바로사밸리,펜폴즈,스파이시한,"매운음식과 잘어울리는",옐로우테일}
4	nation	Austria	{"그뤼너 벨트리너",니더외스터라이히,니콜라이호프,내추럴와인,"특이한 와인","쉽게 접할수 없는"}
5	nation	Bulgaria	{마부러드,트라시안밸리,도멘베사밸리,"저평가된 와인","생소한 국가",발칸반도}
6	nation	Canada	{아이스와인,온타리오,필리터리,"아주 달은","길쭉한 병",하프보틀}
7	nation	Chile	{까르미네르,마이포밸리,콘차이토로,"가성비 와인",1865,몬테스알파}
8	nation	China	{카베르네소비뇽,닝샤,장비쉬,고량주,"아시아 와인","중국 와인"}
9	nation	Croatia	{딩가츠,이스트리아,토미슬라브토마츠,"많이 수입되지 않는",역사깊은,지중해}
10	nation	France	{카베르네소비뇽,보르도,무통로칠드,구대륙,5대샤또,"호불호 없는"}
11	nation	Georgia	{사페라비,에파노미,아스카넬리,"고대 와인",아르메니아,그루지아}
12	nation	Germany	{리슬링,모젤,바인구트로베르트바일,"청량한 느낌","휘발유 향","산미가 강한"}
13	nation	Greece	{레치나,산토리니,알파에스테이트,"잘 알려지지 않은","프리미엄 와인","자주 접하지 못하는"}
14	nation	Hungary	{푸르민트,빌라니,복,"토카이 와인","디저트 와인",골드빛}
15	nation	Israel	{네그레트,갈릴리,골란하이츠,"독특한 와인","지중해 요리","성경의 포도주"}
16	nation	Italy	{산지오베제,토스카나,안티노리,수퍼투스칸,"선물용 와인","피자 먹을때"}
17	nation	Japan	{야마사치,야마나시,타카히코,"와인 싸게 살때","해산물과 같이","고구마 맛"}
18	nation	Korea	{청수,대부도,영동와인,캠벨,"한식 와인",닝닝한}
19	nation	Moldova	{페테아스카,코드루,라다치니,"잘 모르는","처음 마셔보는","호기심 강한"}
20	nation	New Zealand	{소비뇽블랑,말보로,브란콧,"클라우디 베이","가성비 좋은 화이트","열대 과실향"}
21	nation	Portugal	{투리가프란카,도우루,도루밸리,"알콜도수 높은","위스키 색깔","포트 와인"}
22	nation	Romania	{페테아스카네아그라,트란실바니아,부두레아스카,"선물하기 좋은","생소한 품종","동유럽 와인"}
23	nation	Slovenia	{말바지아,비파바,레이아,"유기농 와인","내추럴 방식","화이트 와인으로 유명한"}
24	nation	Spain	{템프라니요,리오하,알바로팔라시오스,"바디감이 무거운","눅진한 스타일","가성비좋은 구대륙 와인"}
25	nation	the Republic of South Africa	{피노타지,이스텔렌보스,크리스탈럼,"신대륙 와인","슈냉블랑이 유명한","야생미 넘치는"}
26	nation	UK	{피노누아,에식스,해크니,"추운 나라 와인","런던 와인","테스코마트 와인"}
27	nation	Uruguay	{타나,후아니코,보데가그라츠,역사깊은,"손수확하는 와인","양념요리와 페어링"}
28	nation	USA	{진판델,나파밸리,로버트몬다비,"감칠맛나는 와인","아저씨들이 좋아하는","와인 입문자에게 적합한"}
37	type	Fortified	{"주정강화 와인","위스키맛 나는 와인","알코올 도수 높은","소주보다 센","포트 와인"}
38	type	Hard	{"깊은 여운을 주는","묵직하고 깊은","개성이 뚜렷한","젊은층이 좋아하는","타닌이 많은"}
39	type	RED	{작업주,와인다운,"무난한 선물용","고기랑 어울리는","탄닌이 있는"}
40	type	Rose	{"핑크빛 와인","보기에 이쁜","발렌타인 데이 선물","항아리 병처럼 생긴","커플 와인"}
41	type	SPARKLING	{"펑 하고 터지는","뚱뚱한 병 와인","철사로 감겨져있는","축하하는 자리","거품이 있는"}
42	type	WHITE	{"청포도로 만든","해산물과 잘어울리는","떫지 않은","안주없이 마실수 있는","돌려서 따는 마개"}
43	use	Appetizer	{"식사전에 마시는 와인","샐러드와 어울리는","알코올 도수 낮은","입맛을 돋구는 와인","호텔 웰컴주 와인",상쾌함,가벼움,첫잔,식전,입맛}
44	use	Dessert	{"소화를 돕는 와인","달달한 와인","스위트 와인","작은잔에 마시는 와인","식후에 마시는 와인",단맛,여운,마무리,응축,풍미}
45	use	Table	{"식사떄 마시는 와인","메인음식과 함께 먹는","많이 비싸지 않은","식욕을 증진시키는","글라스 와인 용",균형,구조감,음식과함께,중심,메인}
46	use	ETC	{"피크닉용으로 마시는 와인","수면을 돕기위해 마시는 와인","파티용 와인","행사용으로 적합한 와인","안주없이 마실수 있는 와인",특별함,집중,소량,대화,컨셉}
\.


--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.messages (id, conversation_id, role, content, wine_recommendations, created_at) FROM stdin;
25	7	user	데이트할 때 마실 와인 추천해줘	\N	2026-01-31 01:32:58.449509
26	7	assistant	데이트 상황이라면 **너무 무겁지 않으면서도 분위기를 살려주는 ‘향과 밸런스’**가 중요한 포인트입니다. 아래에서 취향을 크게 타지 않는 스타일로 추천드릴게요.\n\n## 데이트 와인 추천 (상황 맞춤)\n\n### 1) 레드로 로맨틱하게: [헌터스 HUNTERS 2023](#wine-ta022)\n- **왜 데이트에 적합한가**: 피노 누아 특유의 섬세함 덕분에 대화 흐름을 깨지 않고, 음식과도 폭넓게 맞아서 코스가 바뀌어도 무난합니다. 무겁게 취하지 않는 스타일이라 데이트에 안정적입니다.\n- **맛과 분위기**: 산미가 또렷하고(3.5/5) 바디는 가벼운 편(2/5)이라 **붉은 과실 중심의 산뜻한 로맨틱 무드**를 기대할 수 있어요. 탄닌도 과하지 않아(2/5) 거칠지 않습니다.\n- **잘 맞는 메뉴**: 파스타(토마토/크림), 치킨, 버섯요리, 가벼운 스테이크\n\n### 2) 화이트로 산뜻하고 세련되게: [헌터스 HUNTERS 2024](#wine-ta023)\n- **왜 데이트에 적합한가**: 상큼한 산미(4/5)가 입맛을 살려주고, 첫 잔부터 반응이 좋아 **초반 분위기 띄우기**에 탁월합니다. 해산물/샐러드/가벼운 안주에 특히 강합니다.\n- **맛과 분위기**: 드라이(단맛 1/5)하고 산뜻해서 **깔끔하고 경쾌한 데이트 무드**를 만들어줍니다. 향도 또렷해 “와인 마시는 느낌”이 분명합니다.\n- **잘 맞는 메뉴**: 굴/새우/회, 샐러드, 치즈, 튀김류\n\n### 3) 조금 더 ‘격식 있는’ 레스토랑이라면: [부르고뉴 앙드레구아쇼 2020](#wine-ta012)\n- **왜 데이트에 적합한가**: 부르고뉴 피노 누아의 클래식한 인상이 있어 **레스토랑 데이트에서 품격을 만들기** 좋습니다.\n- **맛과 분위기**: 드라이(1/5)하고 균형감 있는 바디(3/5)로 **차분하고 우아한 분위기**를 기대할 수 있어요. 탄닌이 부드러워(2/5) 부담이 적습니다.\n\n---\n\n원하시면 더 정확히 맞춰드릴게요.  \n1) **레드/화이트** 중 어떤 쪽이 더 끌리세요?  \n2) 메뉴가 **고기/파스타/해산물** 중 뭐에 가까운가요?  \n3) 예산은 **3만/5만/7만/10만+** 중 어디가 편하실까요?	\N	2026-01-31 01:33:08.896332
27	7	user	가벼운 바디감의 달콤한 와인	\N	2026-01-31 03:02:19.420887
28	7	assistant	요청하신 조건( **가벼운 바디 + 달콤한 쪽** )을 기준으로 현재 DB에서 가장 잘 맞는 선택지는 아래 2가지입니다.\n\n## 추천 1) 가장 “달콤+가벼움”에 가까운 화이트\n- [캐슬락 2019](#wine-ta021)\n  - **왜 이 상황에 적합한가**: 단맛이 있는 편(2.5/5)이라 드라이 와인이 부담스러울 때 데이트나 가벼운 자리에서 편하게 들어갑니다.\n  - **맛과 분위기**: 잘 익은 과일 느낌의 **부드럽고 둥근 달콤함**을 기대할 수 있어요. 다만 바디는 4/5로 **‘가벼운 바디’보다는 제법 묵직한 편**이라, “달콤함” 우선일 때 추천드립니다.\n\n## 추천 2) 달콤하진 않지만, 바디 가볍고 ‘편하게’ 마시는 스타일\n- [Concha y Toro Sauvignon-blanc Central Valley 2019](#wine-ta055)\n  - **왜 이 상황에 적합한가**: 바디가 가볍고(2/5) 산미가 상큼해서, 달달함 없이도 **가볍게 술술** 넘어가는 타입입니다.\n  - **맛과 분위기**: 단맛은 거의 없고(1/5) **상큼·깔끔한 무드**—입맛 돋우는 느낌을 기대할 수 있어요.\n\n### 정리\n- **“달콤함”이 최우선**이면 → [캐슬락 2019](#wine-ta021)  \n- **“가벼운 바디”가 최우선**이면 → [Concha y Toro Sauvignon-blanc Central Valley 2019](#wine-ta055)\n\n원하시는 “달콤함”이 **디저트처럼 확실한 단맛**(모스카토/스위트 와인 느낌)인지, 아니면 **살짝 반달콤** 정도인지 알려주시면 DB 안에서 가장 가깝게 다시 좁혀드릴게요.	\N	2026-01-31 03:02:29.568067
\.


--
-- Data for Name: occasion_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.occasion_types (id, occasion, occasion_en, description, use_hint, keywords) FROM stdin;
1	피크닉	Picnic	야외에서 가볍게 즐기는 상황(휴대·캐주얼·상쾌함을 선호).	Appetizer	{야외,가볍게,시원하게,휴대,캐주얼}
2	파티	Party	여럿이 모여 분위기를 내며 마시는 상황(환영·건배·가벼운 페어링).	Appetizer	{모임,건배,분위기,축하,스파클링}
3	혼술	Solo	혼자 편하게 마시는 상황(부담 적고 밸런스 좋은 스타일 선호).	Table	{혼자,편하게,부담없이,잔술,힐링}
4	데이트	Date	대화와 분위기를 중시하는 상황(부드러움·균형·향 중심).	Table	{분위기,로맨틱,대화,부드러운,향}
5	데일리	Daily	일상적으로 자주 마시는 상황(가성비·밸런스·범용성).	Table	{매일,가성비,밸런스,무난한,기본}
6	행사	Event	공식/비공식 행사에서 다수에게 제공하는 상황(대중성·안정감·수급 용이).	Table	{대량,무난한,호불호적음,선물용,행사}
7	선물	Gift	누군가에게 주는 상황(이야깃거리·브랜드·포장/인지도).	Table	{선물,기념,고급,브랜드,패키지}
8	안주없이	No Food	음식 없이 단독으로 즐기는 상황(밸런스·산도·탄닌 부담 낮음).	Appetizer	{단독,그냥,가볍게,깔끔,목넘김}
9	첫잔	First Glass	식전/시작에 입맛을 여는 상황(상쾌함·산도·가벼움).	Appetizer	{식전,시작,상쾌,산도,가벼움}
10	마무리	Finish	하루/식사의 마무리 상황(여운·부드러움·달콤함 가능).	Dessert	{마무리,여운,식후,디저트,부드럽게}
11	대화용	Conversation	대화 중심으로 천천히 즐기는 상황(과하지 않고 향/균형).	Table	{대화,천천히,잔잔하게,향,편안}
12	집중음용	Meditation	소량으로 집중해 음미하는 상황(특이성·개성·학습/테이스팅).	ETC	{테이스팅,집중,개성,특이한,소량}
\.


--
-- Data for Name: price_ranges; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_ranges (id, range_name, min_price, max_price, keywords) FROM stdin;
6	budget	0	9000	{"저렴이 와인","싼 와인","편의점 와인","특가 와인","요리용 막 와인"}
7	entry	9000	20000	{"마트 와인","초심자용 와인","데일리 와인","입문 와인","시중 와인"}
8	value	20000	50000	{"실속형 와인","무난한 와인","캠핑 와인으로 좋은","가성비 와인","먹을만한 와인"}
9	mid	50000	100000	{"발렌타인날 마시기 좋은","이지 드링크 와인","답례용품으로 좋은","가격이 부담스럽지 않은 와인","데이트때 마시기 좋은"}
10	premium	100000	200000	{"특별한날 마시기 좋은","선물하기 좋은 와인","와인 모임에 들고가기 좋은","결혼 선물로 적당한","고급 와인"}
11	high	300000	500000	{"고마운 분에게 선물하기 좋은","프리미엄 와인","장기 숙성하기 좋은","거품이 심하게 들어간","품질이 뛰어난 와인"}
12	luxury	500000	1000000	{"한정판으로 나온","그랑크뤼 와인","소중한 사람들과 마시기 좋은 와인","평생 한번 먹을까말까 한","수상을 많이 한 와인"}
13	exclusive	1000000	100000000	{"최고급 와인으로 꼽는","아무나 쉽게 못마시는","국내에서는 구하기 어려운","정식 수입이 되지 않는","쟁여놓을 가치가 있는 와인"}
\.


--
-- Data for Name: session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.session (sid, sess, expire) FROM stdin;
S7d9L6MeT9l6rbOp9l1FiyOhTzWPyJwM	{"cookie":{"originalMaxAge":604800000,"expires":"2026-02-07T04:24:10.981Z","secure":false,"httpOnly":true,"path":"/"},"userId":1}	2026-02-07 04:25:00
\.


--
-- Data for Name: taste_levels; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.taste_levels (id, attribute, level, keywords) FROM stdin;
1	sweet	1	{"향기가 좋은","음료수같은 와인","순한 맛","밋밋한 와인","단맛이 조금 나는"}
2	sweet	2	{"시트러스한 향의 와인",달짝지근한,"좋은 냄새가 나는","달콤한 맛의","감미로운 맛의"}
3	sweet	3	{달달한,"스위트한 맛의",달큰한,"잔당감 있는","입맛 땡기는"}
4	sweet	4	{"과일주스같은 느낌의","단맛이 강한","뒤끝이 좋은","과실향이 나는",향긋한}
5	sweet	5	{"시럽같은 맛","설탕물 같은","점성을 띠고있는",꿀같은,"달콤한 향이 나는"}
6	acidity	1	{"깔끔한 스타일",상큼한,"상쾌한 느낌","산뜻한 느낌이 나는","환타 맛이 나는"}
7	acidity	2	{"톡톡 쏘는","알싸한 맛",짜릿한,"미끌미끌한 느낌","유자향이 좀 나는"}
8	acidity	3	{"입에 침이 고이는 정도",시큼한,"새콤한 맛","입안이 개운한","산미가 조금 있는"}
9	acidity	4	{"짜릿한 맛","침샘이 자극되는","입안이 얼얼한",탄산음료같은,"맛이 신"}
10	acidity	5	{레몬같은,"식초같은 신맛이 나는","눈이 감길정도로 신","매실청같은 느낌","산도가 강한 와인"}
11	body	1	{"밍밍한 와인","찰랑찰랑한 느낌",맹물같은,"후레쉬한 느낌","담백한 맛"}
12	body	2	{라이트한,"마시기 적당한","묵직한 느낌의","부드러운 느낌의","구수한 맛의"}
13	body	3	{"걸쭉한 맛",막걸리같은,농익은,"잼같은 느낌","졸인듯한 느낌의"}
14	body	4	{"무게감이 느껴지는",농축된,"점성이 강한","포도 원액 느낌","끈끈한 느낌의"}
15	body	5	{눅진한,"위스키 느낌의","진득한 느낌의","꿀같은 와인","끈기가 아주 많은"}
16	tannin	1	{"목넘김이 좋은",둥글둥글한,"리치한 느낌","부담없이 넘어가는","약간 비린맛의"}
17	tannin	2	{"까칠까칠한 맛","홍차를 마시는것같은","무난한 느낌","혀가 아리는 느낌","맛깔스러운 맛"}
18	tannin	3	{"떫떠름한 느낌",씁쓸한,"입안이 까끌까끌한",쓴맛,"쌍화탕같은 맛의"}
19	tannin	4	{"쿰쿰한 맛이 느껴지는","입술이 오므라드는","매케한 느낌","쌉싸름한 맛",달콤쌉쌀한}
20	tannin	5	{"입안이 마르는듯한","혀끝이 조여드는 느낌","완전 떫은 맛","찌꺼기가 있는","자극적인 맛"}
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, password, name, role, created_at) FROM stdin;
1	wine@dunet.kr	$2b$10$HokzdSwTq9ZOFVRvkX8n9O3B.2QyBZpw4.gyBPaPiK/APDvfAzeQS	관리자	admin	2026-01-31 02:35:38.886073
\.


--
-- Data for Name: wine_occasions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wine_occasions (id, wine_id, occasion_id) FROM stdin;
1	ta007	5
2	ta007	3
3	ta007	4
4	ta007	8
5	ta008	5
6	ta008	11
7	ta009	5
8	ta009	3
9	ta009	4
10	ta009	8
11	ta012	5
12	ta012	3
13	ta012	4
14	ta012	8
15	ta013	5
16	ta013	3
17	ta013	4
18	ta013	8
19	ta014	5
20	ta014	3
21	ta014	4
22	ta014	8
23	ta015	5
24	ta015	3
25	ta015	4
26	ta015	8
27	ta016	5
28	ta016	3
29	ta016	4
30	ta016	8
31	ta017	5
32	ta017	3
33	ta017	4
34	ta017	8
35	ta019	5
36	ta019	3
37	ta019	4
38	ta019	8
39	ta020	5
40	ta020	3
41	ta020	4
42	ta020	8
43	ta021	5
44	ta021	11
45	ta022	5
46	ta022	3
47	ta022	4
48	ta022	8
49	ta023	5
50	ta023	3
51	ta023	4
52	ta023	8
53	ta024	5
54	ta024	3
55	ta024	4
56	ta024	8
57	ta032	5
58	ta032	11
59	ta033	5
60	ta033	11
61	ta034	5
62	ta034	11
63	ta028	5
64	ta028	11
65	ta035	5
66	ta035	11
67	ta036	5
68	ta036	11
69	ta037	5
70	ta037	11
71	ta038	5
72	ta038	11
73	ta039	5
74	ta039	11
75	ta219	9
76	ta219	2
77	ta219	8
78	ta040	5
79	ta040	11
80	ta041	5
81	ta041	11
82	ta042	5
83	ta042	11
84	ta043	5
85	ta043	11
86	ta044	5
87	ta044	11
88	ta025	5
89	ta025	3
90	ta025	4
91	ta025	8
92	ta045	5
93	ta045	11
94	ta046	5
95	ta046	11
96	ta047	5
97	ta047	11
98	ta048	5
99	ta048	11
100	ta049	5
101	ta049	11
102	ta026	5
103	ta026	11
104	ta026	7
105	ta050	5
106	ta050	11
107	ta051	5
108	ta051	11
109	ta052	5
110	ta052	11
111	ta053	5
112	ta053	11
113	ta054	5
114	ta054	11
115	ta027	5
116	ta027	11
117	ta027	7
118	ta055	5
119	ta055	11
120	ta056	5
121	ta056	11
122	ta057	5
123	ta057	11
124	ta058	5
125	ta058	11
126	ta059	5
127	ta059	11
128	ta029	9
129	ta029	2
130	ta029	1
131	ta029	8
132	ta060	5
133	ta060	11
134	ta061	5
135	ta061	11
136	ta062	5
137	ta062	11
138	ta063	5
139	ta063	11
140	ta064	5
141	ta064	11
142	ta030	9
143	ta030	2
144	ta030	1
145	ta030	8
146	ta065	5
147	ta065	11
148	ta066	5
149	ta066	11
150	ta067	5
151	ta067	11
152	ta068	5
153	ta068	11
154	ta069	5
155	ta069	11
156	ta031	9
157	ta031	2
158	ta031	1
159	ta031	8
160	ta070	5
161	ta070	11
162	ta071	5
163	ta071	11
164	ta072	5
165	ta072	11
166	ta073	5
167	ta073	11
168	ta074	5
169	ta074	11
170	ta106	5
171	ta106	11
172	ta075	5
173	ta075	11
174	ta076	5
175	ta076	11
176	ta077	5
177	ta077	11
178	ta078	5
179	ta078	11
180	ta079	5
181	ta079	11
182	ta112	5
183	ta112	11
184	ta080	5
185	ta080	11
186	ta081	5
187	ta081	11
188	ta082	5
189	ta082	11
190	ta083	5
191	ta083	11
192	ta084	5
193	ta084	11
194	ta085	5
195	ta085	11
196	ta086	5
197	ta086	11
198	ta087	5
199	ta087	11
200	ta088	5
201	ta088	11
202	ta089	5
203	ta089	11
204	ta090	5
205	ta090	11
206	ta091	5
207	ta091	11
208	ta092	5
209	ta092	11
210	ta093	5
211	ta093	11
212	ta094	5
213	ta094	11
214	ta095	5
215	ta095	11
216	ta096	5
217	ta096	11
218	ta097	5
219	ta097	11
220	ta098	5
221	ta098	11
222	ta099	5
223	ta099	11
224	ta100	5
225	ta100	11
226	ta101	5
227	ta101	11
228	ta102	5
229	ta102	11
230	ta103	5
231	ta103	11
232	ta104	5
233	ta104	11
234	ta105	5
235	ta105	11
236	ta107	5
237	ta107	11
238	ta108	5
239	ta108	11
240	ta109	5
241	ta109	11
242	ta110	5
243	ta110	11
244	ta111	5
245	ta111	11
246	ta113	5
247	ta113	11
248	ta114	5
249	ta114	11
250	ta115	5
251	ta115	11
252	ta116	9
253	ta116	2
254	ta116	8
255	ta117	9
256	ta117	2
257	ta117	8
258	ta118	5
259	ta118	11
260	ta119	9
261	ta119	2
262	ta119	8
263	ta120	9
264	ta120	2
265	ta120	8
266	ta121	5
267	ta121	11
268	ta122	9
269	ta122	2
270	ta122	8
271	ta123	9
272	ta123	2
273	ta123	8
274	ta124	5
275	ta124	11
276	ta125	5
277	ta125	11
278	ta126	9
279	ta126	8
280	ta127	9
281	ta127	2
282	ta127	8
283	ta128	9
284	ta128	2
285	ta128	8
286	ta129	5
287	ta129	11
288	ta130	5
289	ta130	11
290	ta131	9
291	ta131	2
292	ta131	8
293	ta132	9
294	ta132	2
295	ta132	8
296	ta133	9
297	ta133	2
298	ta133	8
299	ta134	9
300	ta134	2
301	ta134	8
302	ta135	9
303	ta135	2
304	ta135	8
305	ta136	9
306	ta136	2
307	ta136	8
308	ta137	10
309	ta137	11
310	ta138	10
311	ta138	11
312	ta139	10
313	ta139	11
314	ta140	10
315	ta140	11
316	ta141	10
317	ta141	11
318	ta142	10
319	ta142	11
320	ta143	10
321	ta143	11
322	ta144	10
323	ta144	11
324	ta145	10
325	ta145	11
326	ta146	10
327	ta146	11
328	ta173	5
329	ta173	11
330	ta147	10
331	ta147	11
332	ta148	10
333	ta148	11
334	ta149	10
335	ta149	11
336	ta150	10
337	ta150	11
338	ta151	10
339	ta151	11
340	ta179	5
341	ta179	11
342	ta152	10
343	ta152	11
344	ta153	10
345	ta153	11
346	ta154	10
347	ta154	11
348	ta155	10
349	ta155	11
350	ta156	10
351	ta156	11
352	ta157	10
353	ta157	11
354	ta158	12
355	ta158	11
356	ta159	5
357	ta159	11
358	ta160	5
359	ta160	11
360	ta161	5
361	ta161	11
362	ta162	5
363	ta162	11
364	ta163	5
365	ta163	11
366	ta164	5
367	ta164	11
368	ta165	5
369	ta165	11
370	ta166	10
371	ta166	11
372	ta167	5
373	ta167	11
374	ta168	5
375	ta168	11
376	ta169	5
377	ta169	11
378	ta170	5
379	ta170	11
380	ta171	5
381	ta171	11
382	ta172	5
383	ta172	11
384	ta174	5
385	ta174	11
386	ta175	5
387	ta175	11
388	ta176	5
389	ta176	11
390	ta177	5
391	ta177	11
392	ta178	10
393	ta178	11
394	ta180	5
395	ta180	11
396	ta181	5
397	ta181	11
398	ta182	5
399	ta182	11
400	ta183	5
401	ta183	11
402	ta184	5
403	ta184	11
404	ta185	10
405	ta185	11
406	ta186	5
407	ta186	11
408	ta187	5
409	ta187	11
410	ta188	5
411	ta188	11
412	ta189	10
413	ta189	11
414	ta190	5
415	ta190	11
416	ta191	5
417	ta191	11
418	ta192	5
419	ta192	11
420	ta193	10
421	ta193	11
422	ta194	5
423	ta194	11
424	ta195	5
425	ta195	11
426	ta196	9
427	ta196	2
428	ta196	8
429	ta197	5
430	ta197	11
431	ta198	5
432	ta198	11
433	ta199	5
434	ta199	11
435	ta200	5
436	ta200	11
437	ta201	5
438	ta201	11
439	ta213	5
440	ta213	11
441	ta202	5
442	ta202	11
443	ta203	5
444	ta203	11
445	ta204	5
446	ta204	11
447	ta205	5
448	ta205	11
449	ta206	5
450	ta206	11
451	ta207	5
452	ta207	11
453	ta208	5
454	ta208	11
455	ta209	10
456	ta209	11
457	ta210	5
458	ta210	11
459	ta211	10
460	ta211	11
461	ta212	5
462	ta212	11
463	ta214	9
464	ta214	2
465	ta214	8
466	ta215	5
467	ta215	11
468	ta216	5
469	ta216	11
470	ta217	5
471	ta217	11
472	ta218	5
473	ta218	11
474	ta220	5
475	ta220	11
476	ta221	5
477	ta221	11
478	ta222	5
479	ta222	11
480	ta223	5
481	ta223	11
482	ta224	5
483	ta224	11
484	ta225	10
485	ta225	11
486	ta226	5
487	ta226	11
488	ta227	5
489	ta227	11
490	ta228	10
491	ta228	11
492	ta229	10
493	ta229	11
494	ta230	5
495	ta230	11
496	ta231	5
497	ta231	11
498	ta001	5
499	ta001	11
500	ta002	5
501	ta002	11
502	ta003	5
503	ta003	3
504	ta003	4
505	ta003	8
506	ta004	5
507	ta004	11
508	ta005	5
509	ta005	3
510	ta005	4
511	ta005	8
512	ta006	5
513	ta006	11
514	ta010	5
515	ta010	11
516	ta011	5
517	ta011	3
518	ta011	4
519	ta011	8
520	ta018	5
521	ta018	11
\.


--
-- Data for Name: wines; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wines (id, name_en, name_kr, producer, nation, region, varieties, type, use, abv, sweet, acidity, body, tannin, price, year, ml, stock, vivino_rating, summary, notes, description, tasting_note, pairing, sample_group) FROM stdin;
ta007	Cusumano Terre Siciliane IGT (Sicilia) Inzolia 2021	쿠수마노 2021	Cusumano	Italy	Terre Siciliane IGT (Sicilia)	Inzolia	WHITE	Table	12.5	1	3	3	0	32000	2021	750	100	\N	토양에 뿌리를 둔 와인	James Suckling 91 | EN명:자동생성	흰 꽃향, 감귤류, 열대 과일과 향신료 향	시트러스·허니듀 멜론, 감귤 껍질·미네랄, 상큼한 산미	샐러드, 해산물	rep
ta008	San Pedro Central Valley Cabernet-Sauvignon 2023	아우란틴 2023	San Pedro	Chile	Central Valley	Cabernet-Sauvignon	RED	Table	13	1	3	2	3	27000	2023	750	200	\N	편안한 신대륙의 레드와인	와인 초보자에게도 친근한 와인 | EN명:자동생성	센트럴 밸리의 프리미엄 지역인 콜차구아에서 수확한  대중적이면서도 높은 퍼포먼스로 평가받는 와인. 퍼플 컬러, 블루베리, 제비꽃 향, 와인 초보자에게도 친근한 와인	블랙 체리·커런트, 스파이스·오크 터치, 중간~강한 바디	소고기 스튜, 양고기	rep
ta009	San Pedro Central Valley Chardonnay 2023	아우란틴 2023	San Pedro	Chile	Central Valley	Chardonnay	WHITE	Table	12.5	1	3	2	0	27000	2023	750	30	\N	편안한 신대륙의 레드와인	와인 초보자에게도 친근한 와인 | EN명:자동생성	오렌지, 라임, 레몬의 시트러스 풍미	배·사과·복숭아, 버터·토스트, 드라이·부드러운 피니시	로브스터, 크림 소스	rep
ta012	Maison André Goichot Bourgogne Pinot Noir 2020	부르고뉴 앙드레구아쇼 2020	Maison André Goichot	France	Bourgogne	Pinot Noir	RED	Table	13	1	3	3	2	75000	2020	750	5	\N	부담없는 가격의 Pinot Noir	부르고뉴의 스타 생산자 | EN명:자동생성	체리, 딸기, 라즈베리 등 신선한 붉은 과일향	체리·라즈베리, 꽃 향·버섯 흙내, 우아한 바디	치킨, 송아지 고기	rep
ta013	Maison André Goichot Bourgogne Chardonnay 2020	부르고뉴 앙드레구아쇼 2020	Maison André Goichot	France	Bourgogne	Chardonnay	WHITE	Table	13	1	4	2	0	60000	2020	750	3	\N	산뜻한 봄의 아로마 느낌	부르고뉴 화이트의 강자 | EN명:자동생성	청사과, 황도, 열대 과일, 바닐라, 아몬드, 버터의 아로마	살구·사과·레몬, 산미·미네랄, 토스트 오크	생선, 치즈	rep
ta014	Lupé‑Cholet Bourgogne Pinot Noir 2020	부르고뉴 도멘 루페숄레 2020	Lupé‑Cholet	France	Bourgogne	Pinot Noir	RED	Table	13	1	3	3	2	80000	2020	750	40	\N	꼬뜨도르 유명 도멘	스웨덴 왕실 납품 공식 와이너리 | EN명:자동생성	루이 14세의 결혼식에 와인을 공급했넌 와이너리로 유명. 밝은 가넷 빛, 딸기, 블랙커런트, 달콤한 향신료 아로마	딸기·체리, 허브·흙내, 부드러운 탄닌	양고기, 버섯 요리	rep
ta015	Lupé‑Cholet Bourgogne Chardonnay 2020	부르고뉴 도멘 루페숄레 2020	Lupé‑Cholet	France	Bourgogne	Chardonnay	WHITE	Table	13	1	3	3	0	80000	2020	750	100	\N	부르고뉴의 품격있는 와인	스웨덴 왕실 납품 공식 와이너리 | EN명:자동생성	루이 14세의 결혼식에 와인을 공급했넌 와이너리로 유명. 신선하고 산뜻한 복숭아, 사과와 꿀처럼 달달하면서도 은은하게 퍼지는 꽃 향	백도·배, 레몬 제스트, 크리미 오크	치즈 샐러드, 크림파스타	rep
ta016	Terres Gentiles Bourgogne Pinot Noir 2022	도멘 데 떼레 정띠에 2022	Terres Gentiles	France	Bourgogne	Pinot Noir	RED	Table	13	1	3	2	2	70000	2022	750	200	\N	부르고뉴 Pinot Noir	떼루아 중심의 전통적 양조 방식 | EN명:자동생성	붉은 과일 체리,라즈베리의 향과 향신료의 미묘한 향이 매력적	체리·라즈베리, 붉은 꽃, 미네랄 터치	구운 닭고기, 송아지 스테이크	rep
ta017	Terres Gentiles Bourgogne Chardonnay 2022	도멘 데 떼레 정띠에 2022	Terres Gentiles	France	Bourgogne	Chardonnay	WHITE	Table	13	1	3	2	0	60000	2022	750	30	\N	부르고뉴 Pinot Noir   샤르도네	떼루아 중심의 전통적 양조 방식 | EN명:자동생성	말린 살구와 파인애플, 오렌지 아로마.	복숭아·배, 버터·오크, 산미·미네랄	생선, 조개	rep
ta019	Hedges Columbia Valley Sauvignon-blanc 2022	헤지스 CMS 2022	Hedges	USA	Columbia Valley	Sauvignon-blanc	WHITE	Table	13	1	3	3	0	60000	2022	750	20	\N	USA 와인 매니아를 위한	워싱턴 최고의 토양 | EN명:자동생성	레몬, 자몽, 복숭아, 패션 프루츠의 아로마	풀·허브, 라임·자몽, 상쾌하고 가벼움	샐러드, 타르타르	rep
ta020	Castle Rock Central Coast Pinot Noir 2019	캐슬락 2019	Castle Rock	USA	Central Coast	Pinot Noir	RED	Table	13.5	1	3	2.5	2	70000	2019	750	5	\N	메리트있는 가격의 Pinot Noir	음식과 매칭이 훌륭한 와인 | EN명:자동생성	음식 매칭이 좋은 Pinot Noir	체리·라즈베리, 약간 토스트, 가볍고 우아함	감자구이, 전채요리	rep
ta021	Castle Rock Central Coast Chardonnay 2019	캐슬락 2019	Castle Rock	USA	Central Coast	Chardonnay	WHITE	Table	13.5	2.5	3	4	0	60000	2019	750	3	\N	호불호 없는 USA Chardonnay	드라이한 USA Chardonnay | EN명:자동생성	USA 드라이 Chardonnay	사과·배, 바닐라·버터, 부드러운 마감	연어, 크림 소스	rep
ta022	Hunters Marlborough Pinot Noir 2023	헌터스 HUNTERS 2023	Hunters	New Zealand	Marlborough	Pinot Noir	RED	Table	13	1.5	3.5	2	2	50000	2023	750	40	\N	죽기전에 마셔야할 1001 와인	유기농, 비건 기술 등 독보적인 와인 생산 | EN명:자동생성	죽기전에 마셔야할 1001 와인 선정	라즈베리·체리, 꽃 향, 미네랄	파스타, 버섯 요리	rep
ta023	Hunters Marlborough Sauvignon-blanc 2024	헌터스 HUNTERS 2024	Hunters	New Zealand	Marlborough	Sauvignon-blanc	WHITE	Table	13	1	4	3	0	40000	2024	750	100	\N	죽기전에 마셔야할 1001 와인	Wine Spectator 90 | EN명:자동생성	1982년 첫 빈티지부터 말보로 대회에서 각종 상을 휩쓸며 주목받은 와이너리. 라임, 자몽, 패션프루트, 구즈베리, 흰 꽃의 향을 중심으로 싱그러운 풀, 허브 캐릭터가 매력적	시트러스·패션프루트·청사과, 산미 강함	해산물, 샐러드	rep
ta024	Terres Gentiles Bourgogne Chardonnay 2023	레 떼레 정띠에 샤블리 2023	Terres Gentiles	France	Bourgogne	Chardonnay	WHITE	Table	12.5	1	3	3	0	70000	2023	750	200	\N	가성비 샤르도네 샤블리	깔끔한 산도의 세련된 맛 | EN명:자동생성	은은한 황금빛 컬러. 풍부한 과실향과 세련된 맛. 미네랄리티와 깔끔한 산도	레몬·청사과·흰 꽃, 미네랄, 산미 선명	굴, 초밥	rep
ta032	SeaSmoke, Southing Pinot Noir	Sea Smoke Estate 피노 누아 California Santa Barbara County 2018	Sea Smoke Estate	USA	California Santa Barbara County	Pinot Noir	RED	Table	14	1	4	3	3	450000	2018	750	5	\N	감칠맛나는 와인 무드의 피노 누아 레드 — 입안이 까끌까끌한 결이 살아 있고 막걸리같은가 탄탄해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	로버트몬다비의 무난한 선물용 와인 Sea Smoke Estate 피노 누아 California Santa Barbara County 2018 (2018). 도수 14~15, 750ml.\n\n전체 톤은 막걸리같은와 짜릿한 맛의 균형. 타닌은 쓴맛, 단맛은 음료수같은 와인 쪽으로 읽힙니다. 그리고 식욕을 증진시키는 쪽으로 즐기기 좋아요.\n구조감 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (데일리·대화용)	전체 톤은 막걸리같은와 짜릿한 맛의 균형. 타닌은 쓴맛, 단맛은 음료수같은 와인 쪽으로 읽힙니다. 그리고 식욕을 증진시키는 쪽으로 즐기기 좋아요.	미트볼(토마토 라구), 숙성 치즈, 미트소스/라구	rep
ta033	Catena Zapata, Alamos Torrontes	Catena Zapata Torrontes Mendoza 2018	Catena Zapata	Argentina	Mendoza	Torrontes	WHITE	Table	13	1	3	2	1	26000	2018	750	5	\N	구조감에 어울리는 Torrontes 화이트. 입안이 개운한가 살아 있고 마시기 적당한는 담백해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Catena Zapata Torrontes Mendoza 2018는 탄닌이 강한에서 온 청포도로 만든 스타일입니다. 2018 빈티지 기준 13~14 도수, 750ml 구성.\n\n키워드로 보면 묵직한 느낌의 텍스처 위에 입에 침이 고이는 정도가 살아 있고, 마무리는 목넘김이 좋은이 정돈합니다. 순한 맛 뉘앙스는 과하지 않아요. 특히 해산물과 잘어울리는 상황에 잘 어울립니다.\n추천 상황은 데일리·대화용 쪽이에요.	묵직한 느낌의 텍스처 위에 입에 침이 고이는 정도가 살아 있고, 마무리는 목넘김이 좋은이 정돈합니다. 순한 맛 뉘앙스는 과하지 않아요. 특히 해산물과 잘어울리는 상황에 잘 어울립니다.	회/초밥, 치즈 플래터	rep
ta034	Yering Station Little Yering Cabernet Shiraz Merlot	Yering Station 메를로 Victoria Yarra Valley 2005	Yering Station	Australia	Victoria Yarra Valley	Merlot	RED	Table	13	1	3	3	2	28000	2005	750	5	\N	오늘은 캠핑 와인으로 좋은 레드. 막걸리같은 중심으로 가고 홍차를 마시는것같은은 과하지 않아요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Yering Station 메를로 Victoria Yarra Valley 2005는 매운음식과 잘어울리는에서 온 와인다운 스타일입니다. 2005 빈티지 기준 13~14 도수, 750ml 구성.\n\n키워드로 보면 향에서는 향기가 좋은 인상이 먼저 오고, 입안에서는 산미가 조금 있는가 균형을 잡습니다. 질감은 걸쭉한 맛, 여운은 까칠까칠한 맛 쪽으로 정리돼요. — 작업주 무드로 이해하면 좋아요.\n추천 상황은 데일리·대화용 쪽이에요.	향에서는 향기가 좋은 인상이 먼저 오고, 입안에서는 산미가 조금 있는가 균형을 잡습니다. 질감은 걸쭉한 맛, 여운은 까칠까칠한 맛 쪽으로 정리돼요. — 작업주 무드로 이해하면 좋아요.	햄·살라미(트러플), 숙성 치즈, 미트소스/라구	rep
ta028	San Fabiano Calcinaia Chianti Sangiovese 2021	산 파비아노, 깔치나이아 끼안티 클라시코 DOCG 2021	San Fabiano Calcinaia	Italy	Chianti	Sangiovese	RED	Table	13	1	4	3	3	55000	2021	750	5	3.8	끼안티를 빛내는 와이너리 ★3.8	2016 키안티를 빛낸 와이너리 선정 | EN명:자동생성 | Vivino:표기(있을때만)	적색 루비, 밝은 가넷 색, 잘익은 과일과 향신료 아로마가 매력적인 견고한 구조감의 와인 (Vivino 평점 3.8). 유기농, 비오디나믹 농법으로 재배	라즈베리·체리, 오크 스파이스, 선명한 산도	피자, 토마토 파스타	rep
ta035	Schloss Lieser, Riesling Dry	Schloss Lieser 리슬링 MoselSaarRuwer 2011	Schloss Lieser	Germany	MoselSaarRuwer	Riesling	WHITE	Table	13	1	5	3	1	68000	2011	750	5	\N	답례용품으로 좋은 리슬링 화이트. 식초같은 신맛이 나는 느낌으로 메인에 산뜻해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	청량한 느낌 생산자의 떫지 않은 와인 Schloss Lieser 리슬링 MoselSaarRuwer 2011. 2011 빈티지, 도수 13~14, 750ml.\n\n입안에서는 막걸리같은/레몬같은가 중심을 잡고, 마무리는 리치한 느낌이 정돈합니다.\n식사떄 마시는 와인에 두면 실패 확률이 낮아요. (데일리·대화용)	눈이 감길정도로 신가 입맛을 깨우고, 걸쭉한 맛는 담백하게 이어집니다. 리치한 느낌은 거칠지 않고 음료수같은 와인 느낌은 은근해요. 특히 해산물과 잘어울리는 상황에 잘 어울립니다.	회/초밥, 흰살 생선구이, 치즈 플래터	rep
ta036	Blossom Hill, Merlot	Blossom Hill 메를로 California 2007	Blossom Hill	USA	California	Merlot	RED	Table	13	2	3	3	3	20000	2007	750	5	\N	오늘은 먹을만한 와인 레드. 농익은 중심으로 가고 쓴맛은 과하지 않아요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Blossom Hill 메를로 California 2007는 나파밸리에서 온 고기랑 어울리는 스타일입니다. 2007 빈티지 기준 13 도수, 750ml 구성.\n\n키워드로 보면 첫 인상은 입에 침이 고이는 정도가 또렷하고, 텍스처는 농익은로 느껴집니다. 피니시는 입안이 까끌까끌한, 단맛은 감미로운 맛의 쪽으로 해석할 수 있어요. 특히 고기랑 어울리는 상황에 잘 어울립니다.\n추천 상황은 데일리·대화용 쪽이에요.	첫 인상은 입에 침이 고이는 정도가 또렷하고, 텍스처는 농익은로 느껴집니다. 피니시는 입안이 까끌까끌한, 단맛은 감미로운 맛의 쪽으로 해석할 수 있어요. 특히 고기랑 어울리는 상황에 잘 어울립니다.	햄·살라미(트러플), 숙성 치즈, 미트소스/라구	rep
ta037	Philippe Colin, Chassagne Montrachet 1er Cru 'Chenevottes'	Philippe Colin 샤르도네 Bourgogne Cote de Beaune 2010	Philippe Colin	France	Bourgogne Cote de Beaune	Chardonnay	WHITE	Table	14	1	4	4	1	216000	2010	750	5	\N	실속형 샤르도네 화이트. 침샘이 자극되는 느낌으로 메인에 산뜻해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	구대륙의 해산물과 잘어울리는 와인 Philippe Colin 샤르도네 Bourgogne Cote de Beaune 2010 (2010). 도수 14~15, 750ml.\n\n첫 인상은 짜릿한 맛가 또렷하고, 텍스처는 무게감이 느껴지는로 느껴집니다. 피니시는 둥글둥글한, 단맛은 음료수같은 와인 쪽으로 해석할 수 있어요. — 청포도로 만든 무드로 이해하면 좋아요.\n많이 비싸지 않은 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (데일리·대화용)	첫 인상은 짜릿한 맛가 또렷하고, 텍스처는 무게감이 느껴지는로 느껴집니다. 피니시는 둥글둥글한, 단맛은 음료수같은 와인 쪽으로 해석할 수 있어요. — 청포도로 만든 무드로 이해하면 좋아요.	버터 소스 생선, 치즈 플래터	rep
ta038	Vindivin, Cabalie Cuvee Vieilles Vignes Rouge	Vindivin Grenache Carignan Southern France Languedoc Roussillon 2018	Vindivin	France	Southern France Languedoc Roussillon	Grenache Carignan	RED	Table	13	1	4	3	3	68000	2018	750	5	\N	이지 드링크 와인 선택지로 좋은 Grenache Carignan 레드. 쌍화탕같은 맛의/걸쭉한 맛 밸런스형.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	5대샤또의 탄닌이 있는 와인 Vindivin Grenache Carignan Southern France Languedoc Roussillon 2018 (2018). 도수 13~14, 750ml.\n\n향에서는 밋밋한 와인 인상이 먼저 오고, 입안에서는 짜릿한 맛가 균형을 잡습니다. 질감은 농익은, 여운은 떫떠름한 느낌 쪽으로 정리돼요. 특히 음식과함께 상황에 잘 어울립니다.\n중심 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (데일리·대화용)	향에서는 밋밋한 와인 인상이 먼저 오고, 입안에서는 짜릿한 맛가 균형을 잡습니다. 질감은 농익은, 여운은 떫떠름한 느낌 쪽으로 정리돼요. 특히 음식과함께 상황에 잘 어울립니다.	치킨 스테이크(후추/허브), 숙성 치즈, 미트소스/라구	rep
ta039	Wyndham Estate, Show Reserve Chardonnay	Wyndham Estate 샤르도네 New South Wales Hunter Valley 2001	Wyndham Estate	Australia	New South Wales Hunter Valley	Chardonnay	WHITE	Table	12.9	1	3	3	1	50000	2001	750	5	\N	가격이 부담스럽지 않은 와인 데일리 화이트. 새콤한 맛/막걸리같은 균형이 안정적이에요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Wyndham Estate 샤르도네 New South Wales Hunter Valley 2001는 옐로우테일 감성을 담은 떫지 않은입니다. 2001 빈티지, 12.9 도수, 750ml.\n\n첫 인상은 새콤한 맛가 또렷하고, 텍스처는 농익은로 느껴집니다. 피니시는 약간 비린맛의, 단맛은 단맛이 조금 나는 쪽으로 해석할 수 있어요. — 균형 무드로 이해하면 좋아요.\n데일리·대화용에 두고 천천히 즐기면 밸런스가 더 살아나요.	첫 인상은 새콤한 맛가 또렷하고, 텍스처는 농익은로 느껴집니다. 피니시는 약간 비린맛의, 단맛은 단맛이 조금 나는 쪽으로 해석할 수 있어요. — 균형 무드로 이해하면 좋아요.	회/초밥, 흰살 생선구이, 치즈 플래터	rep
ta219	BRIDE VALLEY Rose Bella	Bride Valley Chardonnay Pinot Meunier Pinot Noir 2014	Bride Valley	UK	Pinot Noir	Chardonnay Pinot Meunier	SPARKLING	Appetizer	15	1	5	3	1	110000	2014	750	5	\N	선물하기 좋은 와인 스파클링 한 병. 포인트는 매실청같은 느낌 청량감이에요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	해크니 생산자의 거품이 있는 와인 Bride Valley Chardonnay Pinot Meunier Pinot Noir 2014. 2014 빈티지, 도수 15~16, 750ml.\n\n입안에서는 농익은/산도가 강한 와인가 중심을 잡고, 마무리는 목넘김이 좋은이 정돈합니다.\n호텔 웰컴주 와인에 두면 실패 확률이 낮아요. (첫잔·파티)	레몬같은가 입맛을 깨우고, 졸인듯한 느낌의는 담백하게 이어집니다. 부담없이 넘어가는은 거칠지 않고 순한 맛 느낌은 은근해요. 특히 철사로 감겨져있는 상황에 잘 어울립니다.	카나페, 튀김, 프라이드 치킨	edge
ta040	Cosme Palacio Reserva	Bodegas Palacio 템프라니요 Rioja 2008	Bodegas Palacio	Spain	Rioja	Tempranillo	RED	Table	13	1	3	4	4	100000	2008	750	5	\N	템프라니요 무드의 템프라니요 레드 — 쌉싸름한 맛 결이 살아 있고 점성이 강한가 탄탄해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Bodegas Palacio 템프라니요 Rioja 2008는 와인다운 카테고리에서 특별한날 마시기 좋은 선택지로 좋은 편입니다. 2008 빈티지, 13~14 도수, 750ml.\n\n첫 인상은 입안이 개운한가 또렷하고, 텍스처는 농축된로 느껴집니다. 피니시는 매케한 느낌, 단맛은 순한 맛 쪽으로 해석할 수 있어요. 특히 무난한 선물용 상황에 잘 어울립니다.\n데일리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	첫 인상은 입안이 개운한가 또렷하고, 텍스처는 농축된로 느껴집니다. 피니시는 매케한 느낌, 단맛은 순한 맛 쪽으로 해석할 수 있어요. 특히 무난한 선물용 상황에 잘 어울립니다.	스테이크(트러플), 숙성 치즈, 미트소스/라구	rep
ta041	Acacia, Chardonnay	Acacia Vineyard 샤르도네 California Napa County 2006	Acacia Vineyard	USA	California Napa County	Chardonnay	WHITE	Table	14.5	1	3	3	1	54000	2006	750	5	\N	데이트때 마시기 좋은 데일리 화이트. 새콤한 맛/졸인듯한 느낌의 균형이 안정적이에요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Acacia Vineyard 샤르도네 California Napa County 2006는 로버트몬다비 감성을 담은 청포도로 만든입니다. 2006 빈티지, 14.5 도수, 750ml.\n\n전체 톤은 잼같은 느낌와 새콤한 맛의 균형. 타닌은 목넘김이 좋은, 단맛은 밋밋한 와인 쪽으로 읽힙니다. 특히 메인음식과 함께 먹는 상황에 잘 어울립니다.\n데일리·대화용에 두고 천천히 즐기면 밸런스가 더 살아나요.	전체 톤은 잼같은 느낌와 새콤한 맛의 균형. 타닌은 목넘김이 좋은, 단맛은 밋밋한 와인 쪽으로 읽힙니다. 특히 메인음식과 함께 먹는 상황에 잘 어울립니다.	새우/조개, 흰살 생선구이, 치즈 플래터	rep
ta042	Chris Ringland, Dimchurh Shriaz	Chris Ringland 시라 South Australia Barossa Valley 2012	Chris Ringland	Australia	South Australia Barossa Valley	Syrah&Shiraz	RED	Table	17	1	3	5	5	850000	2012	750	5	\N	한정판으로 나온 선택지로 좋은 시라 레드. 자극적인 맛/진득한 느낌의 밸런스형.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	쉬라즈 생산자의 와인다운 와인 Chris Ringland 시라 South Australia Barossa Valley 2012. 2012 빈티지, 도수 17, 750ml.\n\n입안에서는 위스키 느낌의/입에 침이 고이는 정도가 중심을 잡고, 마무리는 입안이 마르는듯한이 정돈합니다.\n식사떄 마시는 와인에 두면 실패 확률이 낮아요. (데일리·대화용)	눅진한 텍스처 위에 입안이 개운한가 살아 있고, 마무리는 입안이 마르는듯한이 정돈합니다. 순한 맛 뉘앙스는 과하지 않아요. 그리고 메인음식과 함께 먹는 쪽으로 즐기기 좋아요.	스테이크(토마토 라구), 숙성 치즈, 미트소스/라구	rep
ta043	Domaine Coudray Bizot, Vosne Romanee 1er Cru La Croix Rameau	Domaine Coudray Bizot 피노 누아 Bourgogne Cote de Nuits 2012	Domaine Coudray Bizot	France	Bourgogne Cote de Nuits	Pinot Noir	RED	Table	13	1	4	4	3	425000	2012	750	5	\N	오늘은 고마운 분에게 선물하기 좋은 레드. 끈끈한 느낌의 중심으로 가고 떫떠름한 느낌은 과하지 않아요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Domaine Coudray Bizot 피노 누아 Bourgogne Cote de Nuits 2012는 와인다운 카테고리에서 거품이 심하게 들어간 선택지로 좋은 편입니다. 2012 빈티지, 13~14 도수, 750ml.\n\n첫 인상은 탄산음료같은가 또렷하고, 텍스처는 농축된로 느껴집니다. 피니시는 쓴맛, 단맛은 순한 맛 쪽으로 해석할 수 있어요. — 메인음식과 함께 먹는 무드로 이해하면 좋아요.\n데일리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	첫 인상은 탄산음료같은가 또렷하고, 텍스처는 농축된로 느껴집니다. 피니시는 쓴맛, 단맛은 순한 맛 쪽으로 해석할 수 있어요. — 메인음식과 함께 먹는 무드로 이해하면 좋아요.	바비큐 립(그릴), 숙성 치즈, 미트소스/라구	rep
ta044	Nicolas Rossignol, Volnay 1er Cru 'Fremiets'	Nicolas Rossignol 피노 누아 Bourgogne Cote de Beaune 2015	Nicolas Rossignol	France	Bourgogne Cote de Beaune	Pinot Noir	RED	Table	14	1	3	3	3	350000	2015	750	5	\N	구대륙 무드의 피노 누아 레드 — 쓴맛 결이 살아 있고 졸인듯한 느낌의가 탄탄해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	호불호 없는의 작업주 와인 Nicolas Rossignol 피노 누아 Bourgogne Cote de Beaune 2015 (2015). 도수 14~15, 750ml.\n\n향에서는 단맛이 조금 나는 인상이 먼저 오고, 입안에서는 입안이 개운한가 균형을 잡습니다. 질감은 잼같은 느낌, 여운은 쌍화탕같은 맛의 쪽으로 정리돼요. 그리고 메인음식과 함께 먹는 쪽으로 즐기기 좋아요.\n메인 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (데일리·대화용)	향에서는 단맛이 조금 나는 인상이 먼저 오고, 입안에서는 입안이 개운한가 균형을 잡습니다. 질감은 잼같은 느낌, 여운은 쌍화탕같은 맛의 쪽으로 정리돼요. 그리고 메인음식과 함께 먹는 쪽으로 즐기기 좋아요.	피자(훈제), 숙성 치즈, 미트소스/라구	rep
ta025	Maison André Goichot Bourgogne Chardonnay 2020	앙드레구아쇼 뫼르소 레비레이 2020	Maison André Goichot	France	Bourgogne	Chardonnay	WHITE	Table	13	1	3	3	1	150000	2020	750	30	4.1	부르고뉴 화이트의 강자 앙드레구아쇼 ★4.1	프리미엄 Chardonnay의 고급스러운 멋 | EN명:자동생성 | Vivino:표기(있을때만)	오로지 소비자만 생각하며 와인을 만든다는 가족 경영 네고시앙 (Vivino 평점 4.1). 엘더플라워, 라임 등 플로럴한 향과 구운 아몬드, 헤이즐넛, 버터의 고소함, 미네랄 등의 아로마. 장기 숙성에도 적합	복숭아·배·토스트, 크리미 질감, 미네랄	치즈, 크림요리	rep
ta045	Oveja Negra Carmenere Merlot	Oveja Negra Carmenere Merlot Maule Valley 2016	Oveja Negra	Chile	Maule Valley	Carmenere Merlot	RED	Table	13	1	3	3	3	38000	2016	750	5	\N	실속형 와인 선택지로 좋은 Carmenere Merlot 레드. 쌍화탕같은 맛의/졸인듯한 느낌의 밸런스형.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	마이포밸리의 무난한 선물용 와인 Oveja Negra Carmenere Merlot Maule Valley 2016 (2016). 도수 13~14, 750ml.\n\n첫 인상은 입안이 개운한가 또렷하고, 텍스처는 잼같은 느낌로 느껴집니다. 피니시는 입안이 까끌까끌한, 단맛은 순한 맛 쪽으로 해석할 수 있어요. 그리고 탄닌이 있는 쪽으로 즐기기 좋아요.\n메인음식과 함께 먹는 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (데일리·대화용)	첫 인상은 입안이 개운한가 또렷하고, 텍스처는 잼같은 느낌로 느껴집니다. 피니시는 입안이 까끌까끌한, 단맛은 순한 맛 쪽으로 해석할 수 있어요. 그리고 탄닌이 있는 쪽으로 즐기기 좋아요.	치킨 스테이크(토마토 라구), 숙성 치즈, 미트소스/라구	rep
ta046	Ceretto, Monsordo Langhe Rosso	Ceretto Cabernet-Sauvignon Merlot Syrah Piemonte Langhe 2017	Ceretto	Italy	Piemonte Langhe	Cabernet-Sauvignon Merlot Syrah&Shiraz	RED	Table	14	1	4	5	4	90000	2017	750	5	\N	토스카나 무드의 Cabernet-Sauvignon Merlot Syrah 레드 — 쿰쿰한 맛이 느껴지는 결이 살아 있고 위스키 느낌의가 탄탄해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Ceretto Cabernet-Sauvignon Merlot Syrah Piemonte Langhe 2017는 선물용 와인 감성을 담은 탄닌이 있는입니다. 2017 빈티지, 14 도수, 750ml.\n\n눅진한 텍스처 위에 탄산음료같은가 살아 있고, 마무리는 달콤쌉쌀한이 정돈합니다. 밋밋한 와인 뉘앙스는 과하지 않아요. 특히 무난한 선물용 상황에 잘 어울립니다.\n데일리·대화용에 두고 천천히 즐기면 밸런스가 더 살아나요.	눅진한 텍스처 위에 탄산음료같은가 살아 있고, 마무리는 달콤쌉쌀한이 정돈합니다. 밋밋한 와인 뉘앙스는 과하지 않아요. 특히 무난한 선물용 상황에 잘 어울립니다.	로스트 비프(후추/허브), 숙성 치즈, 미트소스/라구	rep
ta047	Thunevin, Bad Girl	Thunevin Semillon Cabernet-Franc Muscadet Bordeaux 2010	Thunevin	France	Bordeaux	Semillon Cabernet-Franc Muscadet	SPARKLING	Table	12	1	3	2	1	70000	2010	750	5	\N	답례용품으로 좋은 스파클링. 입안이 개운한 톤이라 식욕을 증진시키는에 경쾌해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Thunevin Semillon Cabernet-Franc Muscadet Bordeaux 2010는 무통로칠드에서 온 철사로 감겨져있는 스타일입니다. 2010 빈티지 기준 12~13 도수, 750ml 구성.\n\n키워드로 보면 향에서는 향기가 좋은 인상이 먼저 오고, 입안에서는 새콤한 맛가 균형을 잡습니다. 질감은 묵직한 느낌의, 여운은 목넘김이 좋은 쪽으로 정리돼요. — 식사떄 마시는 와인 무드로 이해하면 좋아요.\n추천 상황은 데일리·대화용 쪽이에요.	향에서는 향기가 좋은 인상이 먼저 오고, 입안에서는 새콤한 맛가 균형을 잡습니다. 질감은 묵직한 느낌의, 여운은 목넘김이 좋은 쪽으로 정리돼요. — 식사떄 마시는 와인 무드로 이해하면 좋아요.	튀김, 굴/해산물	rep
ta048	Finca Flichman Misterio Cabernet-Sauvignon	Finca Flichman Cabernet-Sauvignon Mendoza 2015	Finca Flichman	Argentina	Mendoza	Cabernet-Sauvignon	RED	Table	13.5	1	3	3	3	35000	2015	750	5	\N	탄닌이 강한 무드의 카베르네 소비뇽 레드 — 쌍화탕같은 맛의 결이 살아 있고 막걸리같은가 탄탄해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Finca Flichman Cabernet-Sauvignon Mendoza 2015는 무난한 선물용 카테고리에서 먹을만한 와인 선택지로 좋은 편입니다. 2015 빈티지, 13.5 도수, 750ml.\n\n막걸리같은 텍스처 위에 산미가 조금 있는가 살아 있고, 마무리는 떫떠름한 느낌이 정돈합니다. 향기가 좋은 뉘앙스는 과하지 않아요. 그리고 글라스 와인 용 쪽으로 즐기기 좋아요.\n데일리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	막걸리같은 텍스처 위에 산미가 조금 있는가 살아 있고, 마무리는 떫떠름한 느낌이 정돈합니다. 향기가 좋은 뉘앙스는 과하지 않아요. 그리고 글라스 와인 용 쪽으로 즐기기 좋아요.	햄·살라미(트러플), 숙성 치즈, 미트소스/라구	rep
ta049	Sensi, Mantello Sangiovese Syrah	Sensi Sensi vini Sangiovese Colorino Merlot Toscana 2010	Sensi Sensi vini	Italy	Toscana	Sangiovese Colorino Merlot	RED	Table	13.5	1	4	4	4	110000	2010	750	5	\N	와인 모임에 들고가기 좋은 Sangiovese Colorino Merlot 레드. 끈끈한 느낌의 질감에 입술이 오므라드는 여운, 음식과함께에 편하게.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Sensi Sensi vini Sangiovese Colorino Merlot Toscana 2010는 안티노리 감성을 담은 고기랑 어울리는입니다. 2010 빈티지, 13.5 도수, 750ml.\n\n전체 톤은 점성이 강한와 짜릿한 맛의 균형. 타닌은 쿰쿰한 맛이 느껴지는, 단맛은 향기가 좋은 쪽으로 읽힙니다. — 와인다운 무드로 이해하면 좋아요.\n데일리·대화용에 두고 천천히 즐기면 밸런스가 더 살아나요.	전체 톤은 점성이 강한와 짜릿한 맛의 균형. 타닌은 쿰쿰한 맛이 느껴지는, 단맛은 향기가 좋은 쪽으로 읽힙니다. — 와인다운 무드로 이해하면 좋아요.	양갈비(토마토 라구), 숙성 치즈, 미트소스/라구	rep
ta026	Fratelli Revello Piedmont Nebbiolo 2020	프라텔레 레벨로, 바롤로 DOCG 2020	Fratelli Revello	Italy	Piedmont	Nebbiolo	RED	Table	15	1	4	4	4	105000	2020	750	10	92	설명이 필요없는 와인의 왕 ★92.0	로버트 파커 90points | EN명:자동생성 | Vivino:표기(있을때만)	깊고 진한 자주 가넷 컬러, 숲, 젖은 흙내음, 허브향, 풍성한 트러플 향 (Vivino 평점 92.0).  탄닌, 산도, 바디감의 좋은 밸런스로 훌륭한 퍼포먼스를 보여줌.	체리·장미·스파이스·가죽, 강한 탄닌·산미	스테이크, 트러플	rep
ta050	Concha y Toro, Trio Reserva Cabernet-Sauvignon	Concha y Toro Cabernet-Sauvignon Syrah Maipo Valley 2017	Concha y Toro	Chile	Maipo Valley	Cabernet-Sauvignon Syrah&Shiraz Cabernet-Franc	RED	Table	14	1	3	3	3	40000	2017	750	5	\N	메인음식과 함께 먹는 자리에서 빛나는 Cabernet-Sauvignon Syrah 레드. 쓴맛은 정돈되고 잼같은 느낌는 또렷해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Concha y Toro Cabernet-Sauvignon Syrah Maipo Valley 2017는 콘차이토로 감성을 담은 무난한 선물용입니다. 2017 빈티지, 14~15 도수, 750ml.\n\n산미가 조금 있는가 입맛을 깨우고, 잼같은 느낌는 담백하게 이어집니다. 입안이 까끌까끌한은 거칠지 않고 음료수같은 와인 느낌은 은근해요. 특히 메인 상황에 잘 어울립니다.\n데일리·대화용에 두고 천천히 즐기면 밸런스가 더 살아나요.	산미가 조금 있는가 입맛을 깨우고, 잼같은 느낌는 담백하게 이어집니다. 입안이 까끌까끌한은 거칠지 않고 음료수같은 와인 느낌은 은근해요. 특히 메인 상황에 잘 어울립니다.	햄·살라미(그릴), 숙성 치즈, 미트소스/라구	rep
ta051	Langmeil Jackaman's Cabernet-Sauvignon	Langmeil Winery Cabernet-Sauvignon South Australia Barossa Valley 2012	Langmeil Winery	Australia	South Australia Barossa Valley	Cabernet-Sauvignon	RED	Table	14.5	1	4	5	5	240000	2012	750	5	\N	중심 자리에서 빛나는 카베르네 소비뇽 레드. 찌꺼기가 있는은 정돈되고 위스키 느낌의는 또렷해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	스파이시한 생산자의 와인다운 와인 Langmeil Winery Cabernet-Sauvignon South Australia Barossa Valley 2012. 2012 빈티지, 도수 14.5, 750ml.\n\n입안에서는 눅진한/침샘이 자극되는가 중심을 잡고, 마무리는 입안이 마르는듯한이 정돈합니다.\n균형에 두면 실패 확률이 낮아요. (데일리·대화용)	끈기가 아주 많은 텍스처 위에 탄산음료같은가 살아 있고, 마무리는 입안이 마르는듯한이 정돈합니다. 단맛이 조금 나는 뉘앙스는 과하지 않아요. — 작업주 무드로 이해하면 좋아요.	스테이크(훈제), 숙성 치즈, 미트소스/라구	rep
ta052	Romito del Romitorio Sant'antimo Rosso	Castello Romitorio 산지오베제 Toscana Montalcino 2014	Castello Romitorio	Italy	Toscana Montalcino	Sangiovese	RED	Table	14	1	3	4	4	100000	2014	750	5	\N	고급 와인 선택지로 좋은 Sangiovese 레드. 쌉싸름한 맛/무게감이 느껴지는 밸런스형.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Castello Romitorio 산지오베제 Toscana Montalcino 2014는 고기랑 어울리는 카테고리에서 결혼 선물로 적당한 선택지로 좋은 편입니다. 2014 빈티지, 14~15 도수, 750ml.\n\n산미가 조금 있는가 입맛을 깨우고, 무게감이 느껴지는는 담백하게 이어집니다. 입술이 오므라드는은 거칠지 않고 단맛이 조금 나는 느낌은 은근해요. 그리고 와인다운 쪽으로 즐기기 좋아요.\n데일리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	산미가 조금 있는가 입맛을 깨우고, 무게감이 느껴지는는 담백하게 이어집니다. 입술이 오므라드는은 거칠지 않고 단맛이 조금 나는 느낌은 은근해요. 그리고 와인다운 쪽으로 즐기기 좋아요.	양갈비(토마토 라구), 숙성 치즈, 미트소스/라구	rep
ta053	Star Lane Cabernet-Sauvignon	Star Lane Vineyard Cabernet-Sauvignon California Santa Barbara County 2015	Star Lane Vineyard	USA	California Santa Barbara County	Cabernet-Sauvignon	RED	Table	14	1	3	5	4	220000	2015	750	5	\N	오늘은 실속형 레드. 위스키 느낌의 중심으로 가고 매케한 느낌은 과하지 않아요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Star Lane Vineyard Cabernet-Sauvignon California Santa Barbara County 2015는 감칠맛나는 와인에서 온 무난한 선물용 스타일입니다. 2015 빈티지 기준 14~15 도수, 750ml 구성.\n\n키워드로 보면 첫 인상은 새콤한 맛가 또렷하고, 텍스처는 끈기가 아주 많은로 느껴집니다. 피니시는 입술이 오므라드는, 단맛은 밋밋한 와인 쪽으로 해석할 수 있어요. — 식욕을 증진시키는 무드로 이해하면 좋아요.\n추천 상황은 데일리·대화용 쪽이에요.	첫 인상은 새콤한 맛가 또렷하고, 텍스처는 끈기가 아주 많은로 느껴집니다. 피니시는 입술이 오므라드는, 단맛은 밋밋한 와인 쪽으로 해석할 수 있어요. — 식욕을 증진시키는 무드로 이해하면 좋아요.	양갈비(트러플), 숙성 치즈, 미트소스/라구	rep
ta054	La Demoiselle de by	Domaine Rollan de By Merlot Cabernet-Sauvignon Bordeaux Medoc 2010	Domaine Rollan de By	France	Bordeaux Medoc	Merlot Cabernet-Sauvignon	RED	Table	14	1	3	3	3	38000	2010	750	5	\N	카베르네소비뇽 무드의 Merlot Cabernet-Sauvignon 레드 — 씁쓸한 결이 살아 있고 졸인듯한 느낌의가 탄탄해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Domaine Rollan de By Merlot Cabernet-Sauvignon Bordeaux Medoc 2010는 5대샤또 감성을 담은 탄닌이 있는입니다. 2010 빈티지, 14~15 도수, 750ml.\n\n향에서는 음료수같은 와인 인상이 먼저 오고, 입안에서는 입에 침이 고이는 정도가 균형을 잡습니다. 질감은 막걸리같은, 여운은 씁쓸한 쪽으로 정리돼요. 그리고 작업주 쪽으로 즐기기 좋아요.\n데일리·대화용에 두고 천천히 즐기면 밸런스가 더 살아나요.	향에서는 음료수같은 와인 인상이 먼저 오고, 입안에서는 입에 침이 고이는 정도가 균형을 잡습니다. 질감은 막걸리같은, 여운은 씁쓸한 쪽으로 정리돼요. 그리고 작업주 쪽으로 즐기기 좋아요.	치킨 스테이크(훈제), 숙성 치즈, 미트소스/라구	rep
ta027	Fossacolle toscana Sangiovese Grosso 2017	포사콜레, 브루넬로 디 몬탈치노 DOCG 2017	Fossacolle	Italy	toscana	Sangiovese Grosso	RED	Table	14.5	1	3	4	3	190000	2017	750	20	93	몬탈치노의 탄탄한 부티끄와이너리 ★93.0	Sangiovese  의 집약된 맛 | EN명:자동생성 | Vivino:표기(있을때만)	(Vivino 평점 93.0) 작지만 탄탄하게 성장해 온 부티크 와이너리	말린 체리·허브·토바코·가죽, 강한 탄닌·무게감	양고기 스튜	rep
ta055	Concha y Toro, Casillero del Diablo Sauvignon-blanc	Concha y Toro Sauvignon-blanc Central Valley 2019	Concha y Toro	Chile	Central Valley	Sauvignon-blanc	WHITE	Table	13.5	1	4	2	1	12800	2019	750	5	\N	마이포밸리 스타일 Sauvignon-blanc 화이트 — 침샘이 자극되는가 또렷하고 마시기 적당한가 깔끔해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	까르미네르의 떫지 않은 와인 Concha y Toro Sauvignon-blanc Central Valley 2019 (2019). 도수 13.5, 750ml.\n\n향에서는 밋밋한 와인 인상이 먼저 오고, 입안에서는 침샘이 자극되는가 균형을 잡습니다. 질감은 마시기 적당한, 여운은 둥글둥글한 쪽으로 정리돼요. — 해산물과 잘어울리는 무드로 이해하면 좋아요.\n음식과함께 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (데일리·대화용)	향에서는 밋밋한 와인 인상이 먼저 오고, 입안에서는 침샘이 자극되는가 균형을 잡습니다. 질감은 마시기 적당한, 여운은 둥글둥글한 쪽으로 정리돼요. — 해산물과 잘어울리는 무드로 이해하면 좋아요.	새우/조개, 샐러드, 치즈 플래터	rep
ta056	Autoritas, Carmenere	Autoritas 까르메네르 Rapel Valley Colchagua Valley 2013	Autoritas	Chile	Rapel Valley Colchagua Valley	Carmenere	RED	Table	13	1	3	3	3	20000	2013	750	5	\N	무난한 와인 Carmenere 레드. 잼같은 느낌 질감에 입안이 까끌까끌한 여운, 식욕을 증진시키는에 편하게.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	콘차이토로의 무난한 선물용 와인 Autoritas 까르메네르 Rapel Valley Colchagua Valley 2013 (2013). 도수 13, 750ml.\n\n첫 인상은 입안이 개운한가 또렷하고, 텍스처는 걸쭉한 맛로 느껴집니다. 피니시는 쌍화탕같은 맛의, 단맛은 순한 맛 쪽으로 해석할 수 있어요. — 작업주 무드로 이해하면 좋아요.\n식사떄 마시는 와인 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (데일리·대화용)	첫 인상은 입안이 개운한가 또렷하고, 텍스처는 걸쭉한 맛로 느껴집니다. 피니시는 쌍화탕같은 맛의, 단맛은 순한 맛 쪽으로 해석할 수 있어요. — 작업주 무드로 이해하면 좋아요.	미트볼(트러플), 숙성 치즈, 미트소스/라구	rep
ta057	Ceretto, Piana Barbera d'Alba	Ceretto Barbera Piemonte Alba 2011	Ceretto	Italy	Piemonte Alba	Barbera	RED	Table	14.5	1	4	3	3	79000	2011	750	5	\N	균형 자리에서 빛나는 Barbera 레드. 쓴맛은 정돈되고 막걸리같은는 또렷해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Ceretto Barbera Piemonte Alba 2011는 고기랑 어울리는 카테고리에서 데이트때 마시기 좋은 선택지로 좋은 편입니다. 2011 빈티지, 14.5~23 도수, 750ml.\n\n첫 인상은 입안이 얼얼한가 또렷하고, 텍스처는 걸쭉한 맛로 느껴집니다. 피니시는 쓴맛, 단맛은 밋밋한 와인 쪽으로 해석할 수 있어요. 특히 글라스 와인 용 상황에 잘 어울립니다.\n데일리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	첫 인상은 입안이 얼얼한가 또렷하고, 텍스처는 걸쭉한 맛로 느껴집니다. 피니시는 쓴맛, 단맛은 밋밋한 와인 쪽으로 해석할 수 있어요. 특히 글라스 와인 용 상황에 잘 어울립니다.	피자(트러플), 숙성 치즈, 미트소스/라구	rep
ta058	Gianni Masciarelli, Montepulciano d'Abruzzo	Giani Masciarelli Montepulciano Abruzzo 2010	Giani Masciarelli	Italy	Abruzzo	Montepulciano	RED	Table	13	1	3	4	4	54000	2010	750	5	\N	데이트때 마시기 좋은 Montepulciano 레드. 무게감이 느껴지는 질감에 달콤쌉쌀한 여운, 많이 비싸지 않은에 편하게.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Giani Masciarelli Montepulciano Abruzzo 2010는 무난한 선물용 카테고리에서 가격이 부담스럽지 않은 와인 선택지로 좋은 편입니다. 2010 빈티지, 13 도수, 750ml.\n\n입안이 개운한가 입맛을 깨우고, 무게감이 느껴지는는 담백하게 이어집니다. 쌉싸름한 맛은 거칠지 않고 향기가 좋은 느낌은 은근해요. 그리고 메인 쪽으로 즐기기 좋아요.\n데일리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	입안이 개운한가 입맛을 깨우고, 무게감이 느껴지는는 담백하게 이어집니다. 쌉싸름한 맛은 거칠지 않고 향기가 좋은 느낌은 은근해요. 그리고 메인 쪽으로 즐기기 좋아요.	로스트 비프(후추/허브), 숙성 치즈, 미트소스/라구	rep
ta059	Cave de Tain l'Hermitage, Cornas	Cave de Tain lHermitage Blend Rhone Cornas 2001	Cave de Tain lHermitage	France	Rhone Cornas	Blend	RED	Table	13	1	4	4	4	59000	2001	750	5	\N	균형 자리에서 빛나는 Blend 레드. 쌉싸름한 맛은 정돈되고 끈끈한 느낌의는 또렷해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	5대샤또의 작업주 와인 Cave de Tain lHermitage Blend Rhone Cornas 2001 (2001). 도수 13~14, 750ml.\n\n끈끈한 느낌의 텍스처 위에 탄산음료같은가 살아 있고, 마무리는 달콤쌉쌀한이 정돈합니다. 음료수같은 와인 뉘앙스는 과하지 않아요. 그리고 와인다운 쪽으로 즐기기 좋아요.\n중심 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (데일리·대화용)	끈끈한 느낌의 텍스처 위에 탄산음료같은가 살아 있고, 마무리는 달콤쌉쌀한이 정돈합니다. 음료수같은 와인 뉘앙스는 과하지 않아요. 그리고 와인다운 쪽으로 즐기기 좋아요.	스테이크(훈제), 숙성 치즈, 미트소스/라구	rep
ta029	Andreola Veneto Glera et al. 2023	안드레올라 디루포 발도비에데네 엑스트라드라이  DOCG (스파클링) 2023	Andreola	Italy	Veneto	Glera et al.	SPARKLING	Appetizer	11.5	2	4	3	1	48000	2023	750	3	3.7	현대식 자연 친화 농법 ★3.7	베네토의 고급산지 발도비에데네 | EN명:자동생성 | Vivino:표기(있을때만)	맑고 깨끗한 느낌의 과실 풍미와 풍성하게 입 안을 채우는 부드러운 버블 (Vivino 평점 3.7). 효모 숙성 뉘앙스의 여운.현대식 자연 친화 농법, 베네토의 고급산지 발도비에데네	사과·복숭아·아카시아, 미세 버블, 상쾌한 피니시	카나페, 해산물	rep
ta060	Scagliola, Frem Barbera d'Asti	Scagliola Azienda Agricola Barbera Piemonte Asti 2015	Scagliola Azienda Agricola	Italy	Piemonte Asti	Barbera	RED	Table	13	1	4	3	2	28000	2015	750	5	\N	가성비 와인 선택지로 좋은 Barbera 레드. 혀가 아리는 느낌/막걸리같은 밸런스형.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	선물용 와인 생산자의 고기랑 어울리는 와인 Scagliola Azienda Agricola Barbera Piemonte Asti 2015. 2015 빈티지, 도수 13~14, 750ml.\n\n입안에서는 잼같은 느낌/침샘이 자극되는가 중심을 잡고, 마무리는 무난한 느낌이 정돈합니다.\n식욕을 증진시키는에 두면 실패 확률이 낮아요. (데일리·대화용)	첫 인상은 입안이 얼얼한가 또렷하고, 텍스처는 농익은로 느껴집니다. 피니시는 무난한 느낌, 단맛은 음료수같은 와인 쪽으로 해석할 수 있어요. — 무난한 선물용 무드로 이해하면 좋아요.	미트볼(후추/허브), 숙성 치즈, 미트소스/라구	rep
ta061	Robert Hall, Cabernet-Sauvignon	Robert Hall Cabernet-Sauvignon Cabernet-Franc Petite Sirah California San Luis Obispo County 2018	Robert Hall	USA	California San Luis Obispo County	Cabernet-Sauvignon Cabernet-Franc Petite Sirah	RED	Table	15	1	2	3	3	82000	2018	750	5	\N	이지 드링크 와인 Cabernet-Sauvignon Cabernet-Franc Petite Sirah 레드. 막걸리같은 질감에 떫떠름한 느낌 여운, 많이 비싸지 않은에 편하게.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Robert Hall Cabernet-Sauvignon Cabernet-Franc Petite Sirah California San Luis Obispo County 2018는 진판델 감성을 담은 와인다운입니다. 2018 빈티지, 15 도수, 750ml.\n\n첫 인상은 미끌미끌한 느낌가 또렷하고, 텍스처는 막걸리같은로 느껴집니다. 피니시는 씁쓸한, 단맛은 순한 맛 쪽으로 해석할 수 있어요. 그리고 고기랑 어울리는 쪽으로 즐기기 좋아요.\n데일리·대화용에 두고 천천히 즐기면 밸런스가 더 살아나요.	첫 인상은 미끌미끌한 느낌가 또렷하고, 텍스처는 막걸리같은로 느껴집니다. 피니시는 씁쓸한, 단맛은 순한 맛 쪽으로 해석할 수 있어요. 그리고 고기랑 어울리는 쪽으로 즐기기 좋아요.	버섯 그릴(후추/허브), 숙성 치즈, 미트소스/라구	rep
ta062	Meo Camuzet, Morey St Denis	Domaine Meo Camuzet 피노 누아 Bourgogne Cote de Nuits 2017	Domaine Meo Camuzet	France	Bourgogne Cote de Nuits	Pinot Noir	RED	Table	13	1	4	3	2	155000	2017	750	5	\N	오늘은 결혼 선물로 적당한 레드. 졸인듯한 느낌의 중심으로 가고 까칠까칠한 맛은 과하지 않아요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	구대륙 생산자의 고기랑 어울리는 와인 Domaine Meo Camuzet 피노 누아 Bourgogne Cote de Nuits 2017. 2017 빈티지, 도수 13~14, 750ml.\n\n입안에서는 농익은/침샘이 자극되는가 중심을 잡고, 마무리는 맛깔스러운 맛이 정돈합니다.\n많이 비싸지 않은에 두면 실패 확률이 낮아요. (데일리·대화용)	전체 톤은 잼같은 느낌와 입안이 얼얼한의 균형. 타닌은 무난한 느낌, 단맛은 단맛이 조금 나는 쪽으로 읽힙니다. — 탄닌이 있는 무드로 이해하면 좋아요.	버섯 그릴(후추/허브), 숙성 치즈, 미트소스/라구	rep
ta063	Duck Pond, Syrah	Duck Pond Cellars 시라 Oregon Eastern Oregon 2011	Duck Pond Cellars	USA	Oregon Eastern Oregon	Syrah&Shiraz Merlot	RED	Table	13.5	1	4	4	4	50000	2011	750	5	\N	많이 비싸지 않은 자리에서 빛나는 시라 레드. 매케한 느낌은 정돈되고 점성이 강한는 또렷해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Duck Pond Cellars 시라 Oregon Eastern Oregon 2011는 작업주 카테고리에서 이지 드링크 와인 선택지로 좋은 편입니다. 2011 빈티지, 13.5 도수, 750ml.\n\n첫 인상은 입안이 얼얼한가 또렷하고, 텍스처는 포도 원액 느낌로 느껴집니다. 피니시는 달콤쌉쌀한, 단맛은 순한 맛 쪽으로 해석할 수 있어요. 특히 식욕을 증진시키는 상황에 잘 어울립니다.\n데일리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	첫 인상은 입안이 얼얼한가 또렷하고, 텍스처는 포도 원액 느낌로 느껴집니다. 피니시는 달콤쌉쌀한, 단맛은 순한 맛 쪽으로 해석할 수 있어요. 특히 식욕을 증진시키는 상황에 잘 어울립니다.	소갈비(토마토 라구), 숙성 치즈, 미트소스/라구	rep
ta064	Chateau du Grand Sud	Groupe Val dOrbieu Cabernet-Sauvignon Carmenere Bordeaux 2017	Groupe Val dOrbieu	France	Bordeaux	Cabernet-Sauvignon Carmenere	RED	Table	14	1	3	3	3	35000	2017	750	5	\N	무난한 와인 Cabernet-Sauvignon Carmenere 레드. 졸인듯한 느낌의 질감에 씁쓸한 여운, 균형에 편하게.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Groupe Val dOrbieu Cabernet-Sauvignon Carmenere Bordeaux 2017는 보르도 감성을 담은 고기랑 어울리는입니다. 2017 빈티지, 14~15 도수, 750ml.\n\n향에서는 밋밋한 와인 인상이 먼저 오고, 입안에서는 시큼한가 균형을 잡습니다. 질감은 졸인듯한 느낌의, 여운은 떫떠름한 느낌 쪽으로 정리돼요. 특히 작업주 상황에 잘 어울립니다.\n데일리·대화용에 두고 천천히 즐기면 밸런스가 더 살아나요.	향에서는 밋밋한 와인 인상이 먼저 오고, 입안에서는 시큼한가 균형을 잡습니다. 질감은 졸인듯한 느낌의, 여운은 떫떠름한 느낌 쪽으로 정리돼요. 특히 작업주 상황에 잘 어울립니다.	치킨 스테이크(후추/허브), 숙성 치즈, 미트소스/라구	rep
ta030	Beatrix de Gimbres Champagne Pinot Noir et al. non-vintage	베아트리스 드 짐브르 떼루아 프리미에 크뤼 브뤼 NV(non-vintage)	Beatrix de Gimbres	France	Champagne	Pinot Noir et al.	SPARKLING	Appetizer	12	1	4	3	0	99000	non-vintage	750	40	4.1	전통방식으로 만들어진 프리미에 크뤼 ★4.1	세상 모든 요리와 좋은 궁합 | EN명:자동생성 | Vivino:표기(있을때만)	(Vivino 평점 4.1) 과일과 꽃의 풍미가 좋은 섬세한 샴페인, 전통방식으로 만들어진 프리미에 크뤼, 세상 모든 요리와 좋은 궁합	레몬·브리오슈·흰 꽃, 크리미 버블·미네랄	굴, 캐비어	rep
ta065	Murrieta's, Well Red 'The Spur'	Murrietas Well Petite Sirah Cabernet-Sauvignon Petit Verdot California Alameda County 2016	Murrietas Well	USA	California Alameda County	Petite Sirah Cabernet-Sauvignon Petit Verdot	RED	Table	14	1	3	4	5	140000	2016	750	5	\N	결혼 선물로 적당한 선택지로 좋은 Petite Sirah Cabernet-Sauvignon Petit Verdot 레드. 찌꺼기가 있는/무게감이 느껴지는 밸런스형.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	와인 입문자에게 적합한의 무난한 선물용 와인 Murrietas Well Petite Sirah Cabernet-Sauvignon Petit Verdot California Alameda County 2016 (2016). 도수 14~15, 750ml.\n\n끈끈한 느낌의 텍스처 위에 시큼한가 살아 있고, 마무리는 혀끝이 조여드는 느낌이 정돈합니다. 순한 맛 뉘앙스는 과하지 않아요. 특히 음식과함께 상황에 잘 어울립니다.\n메인음식과 함께 먹는 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (데일리·대화용)	끈끈한 느낌의 텍스처 위에 시큼한가 살아 있고, 마무리는 혀끝이 조여드는 느낌이 정돈합니다. 순한 맛 뉘앙스는 과하지 않아요. 특히 음식과함께 상황에 잘 어울립니다.	양갈비(훈제), 숙성 치즈, 미트소스/라구	rep
ta066	LFE 360 Carignan	Luis Felipe Edwards Carignan Maule Valley 2014	Luis Felipe Edwards	Chile	Maule Valley	Carignan	RED	Table	13	1	3	4	4	120000	2014	750	5	\N	고급 와인 선택지로 좋은 Carignan 레드. 입술이 오므라드는/끈끈한 느낌의 밸런스형.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Luis Felipe Edwards Carignan Maule Valley 2014는 몬테스알파 감성을 담은 작업주입니다. 2014 빈티지, 13~14 도수, 750ml.\n\n향에서는 음료수같은 와인 인상이 먼저 오고, 입안에서는 산미가 조금 있는가 균형을 잡습니다. 질감은 무게감이 느껴지는, 여운은 달콤쌉쌀한 쪽으로 정리돼요. 특히 작업주 상황에 잘 어울립니다.\n데일리·대화용에 두고 천천히 즐기면 밸런스가 더 살아나요.	향에서는 음료수같은 와인 인상이 먼저 오고, 입안에서는 산미가 조금 있는가 균형을 잡습니다. 질감은 무게감이 느껴지는, 여운은 달콤쌉쌀한 쪽으로 정리돼요. 특히 작업주 상황에 잘 어울립니다.	로스트 비프(후추/허브), 숙성 치즈, 미트소스/라구	rep
ta067	Maison Bader Mimeur, Bourgogne Pinot Noir	Domaine Bader Mimeur 피노 누아 Bourgogne 2009	Domaine Bader Mimeur	France	Bourgogne	Pinot Noir	RED	Table	13	1	4	2	2	60000	2009	750	5	\N	오늘은 이지 드링크 와인 레드. 라이트한 중심으로 가고 무난한 느낌은 과하지 않아요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Domaine Bader Mimeur 피노 누아 Bourgogne 2009는 구대륙 감성을 담은 작업주입니다. 2009 빈티지, 13 도수, 750ml.\n\n전체 톤은 묵직한 느낌의와 침샘이 자극되는의 균형. 타닌은 무난한 느낌, 단맛은 순한 맛 쪽으로 읽힙니다. 특히 작업주 상황에 잘 어울립니다.\n데일리·대화용에 두고 천천히 즐기면 밸런스가 더 살아나요.	전체 톤은 묵직한 느낌의와 침샘이 자극되는의 균형. 타닌은 무난한 느낌, 단맛은 순한 맛 쪽으로 읽힙니다. 특히 작업주 상황에 잘 어울립니다.	버섯 그릴(트러플), 숙성 치즈, 미트소스/라구	rep
ta068	Blanc de Chasse Spleen	Chateau Chasse Spleen Bordeaux Blend White Bordeaux 2017	Chateau Chasse Spleen	France	Bordeaux	Bordeaux Blend White	WHITE	Appetizer, Table	15	1	4	3	1	55000	2017	750	5	\N	보르도 스타일 Bordeaux Blend White 화이트 — 맛이 신가 또렷하고 졸인듯한 느낌의가 깔끔해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	무통로칠드의 돌려서 따는 마개 와인 Chateau Chasse Spleen Bordeaux Blend White Bordeaux 2017 (2017). 도수 15~16, 750ml.\n\n첫 인상은 짜릿한 맛가 또렷하고, 텍스처는 걸쭉한 맛로 느껴집니다. 피니시는 리치한 느낌, 단맛은 향기가 좋은 쪽으로 해석할 수 있어요. — 돌려서 따는 마개 무드로 이해하면 좋아요.\n호텔 웰컴주 와인 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (데일리·대화용)	첫 인상은 짜릿한 맛가 또렷하고, 텍스처는 걸쭉한 맛로 느껴집니다. 피니시는 리치한 느낌, 단맛은 향기가 좋은 쪽으로 해석할 수 있어요. — 돌려서 따는 마개 무드로 이해하면 좋아요.	오일 파스타, 샐러드, 치즈 플래터	rep
ta069	Bien Nacido, Well Born Cuv챕e Pinot Noir	Bien Nacido  Solomon Hills Estates 피노 누아 California Santa Barbara County 2019	Bien Nacido  Solomon Hills Estates	USA	California Santa Barbara County	Pinot Noir	RED	Table	13	1	4	3	3	130000	2019	750	5	\N	오늘은 결혼 선물로 적당한 레드. 농익은 중심으로 가고 쓴맛은 과하지 않아요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	나파밸리 생산자의 무난한 선물용 와인 Bien Nacido Solomon Hills Estates 피노 누아 California Santa Barbara County 2019. 2019 빈티지, 도수 13~14, 750ml.\n\n입안에서는 걸쭉한 맛/맛이 신가 중심을 잡고, 마무리는 입안이 까끌까끌한이 정돈합니다.\n중심에 두면 실패 확률이 낮아요. (데일리·대화용)	농익은 텍스처 위에 침샘이 자극되는가 살아 있고, 마무리는 입안이 까끌까끌한이 정돈합니다. 음료수같은 와인 뉘앙스는 과하지 않아요. 특히 탄닌이 있는 상황에 잘 어울립니다.	햄·살라미(그릴), 숙성 치즈, 미트소스/라구	rep
ta031	Beatrix de Gimbres Champagne Pinot Noir et al. non-vintage	베아트리스 드 짐브르 로제 프리미에 크뤼 브뤼 NV(non-vintage)	Beatrix de Gimbres	France	Champagne	Pinot Noir et al.	SPARKLING	Appetizer	12	1.5	5	3.5	1	120000	non-vintage	750	100	4	화사한 핑크빛과 아름다운 버블 ★4.0	기분좋은 산미와 매혹적인 컬러 | EN명:자동생성 | Vivino:표기(있을때만)	(Vivino 평점 4.0) 산뜻하면서 기분좋은 산미, 화사한 핑크빛과 아름다운 버블의 매혹적인 컬러	체리·장미·블러드 오렌지, 풍부한 버블·산미	디저트, 애피타이저	rep
ta070	Pierre Gaillard, Saint-Joseph Rouge	Pierre Gaillard Domaine Pierre Gaillard 시라 Rhone SaintJoseph 2016	Pierre Gaillard Domaine Pierre Gaillard	France	Rhone SaintJoseph	Syrah&Shiraz	RED	Table	13	1	3	5	4	90000	2016	750	5	\N	데이트때 마시기 좋은 시라 레드. 진득한 느낌의 질감에 매케한 느낌 여운, 메인음식과 함께 먹는에 편하게.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	무통로칠드 생산자의 탄닌이 있는 와인 Pierre Gaillard Domaine Pierre Gaillard 시라 Rhone SaintJoseph 2016. 2016 빈티지, 도수 13~14, 750ml.\n\n입안에서는 끈기가 아주 많은/시큼한가 중심을 잡고, 마무리는 쿰쿰한 맛이 느껴지는이 정돈합니다.\n식욕을 증진시키는에 두면 실패 확률이 낮아요. (데일리·대화용)	전체 톤은 꿀같은 와인와 새콤한 맛의 균형. 타닌은 매케한 느낌, 단맛은 밋밋한 와인 쪽으로 읽힙니다. 그리고 작업주 쪽으로 즐기기 좋아요.	소갈비(토마토 라구), 숙성 치즈, 미트소스/라구	rep
ta071	Norton, Reserva Chardonnay	Norton 샤르도네 Mendoza 2018	Norton	Argentina	Mendoza	Chardonnay	WHITE	Table	13	1	3	3	1	60000	2018	750	5	\N	답례용품으로 좋은 데일리 화이트. 산미가 조금 있는/졸인듯한 느낌의 균형이 안정적이에요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Norton 샤르도네 Mendoza 2018는 해산물과 잘어울리는 카테고리에서 이지 드링크 와인 선택지로 좋은 편입니다. 2018 빈티지, 13~14 도수, 750ml.\n\n첫 인상은 새콤한 맛가 또렷하고, 텍스처는 막걸리같은로 느껴집니다. 피니시는 약간 비린맛의, 단맛은 향기가 좋은 쪽으로 해석할 수 있어요. 특히 많이 비싸지 않은 상황에 잘 어울립니다.\n데일리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	첫 인상은 새콤한 맛가 또렷하고, 텍스처는 막걸리같은로 느껴집니다. 피니시는 약간 비린맛의, 단맛은 향기가 좋은 쪽으로 해석할 수 있어요. 특히 많이 비싸지 않은 상황에 잘 어울립니다.	회/초밥, 치즈 플래터	rep
ta072	Amuse Bouche	Amuse Bouche Merlot Cabernet-Franc California Napa County 2010	Amuse Bouche	USA	California Napa County	Merlot Cabernet-Franc	RED	Table	14.6	1	3	5	4	1510000	2010	750	5	\N	최고급 와인으로 꼽는 선택지로 좋은 Merlot Cabernet-Franc 레드. 쿰쿰한 맛이 느껴지는/눅진한 밸런스형.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Amuse Bouche Merlot Cabernet-Franc California Napa County 2010는 진판델에서 온 와인다운 스타일입니다. 2010 빈티지 기준 14.6 도수, 750ml 구성.\n\n키워드로 보면 산미가 조금 있는가 입맛을 깨우고, 위스키 느낌의는 담백하게 이어집니다. 달콤쌉쌀한은 거칠지 않고 밋밋한 와인 느낌은 은근해요. 그리고 음식과함께 쪽으로 즐기기 좋아요.\n추천 상황은 데일리·대화용 쪽이에요.	산미가 조금 있는가 입맛을 깨우고, 위스키 느낌의는 담백하게 이어집니다. 달콤쌉쌀한은 거칠지 않고 밋밋한 와인 느낌은 은근해요. 그리고 음식과함께 쪽으로 즐기기 좋아요.	바비큐 립(훈제), 숙성 치즈, 미트소스/라구	rep
ta073	Felix Solis, FYI Red Blend	Felix Solis Tempranillo Cabernet-Sauvignon Garnacha 2017	Felix Solis	Spain	\N	Tempranillo Cabernet-Sauvignon Garnacha	RED	Table	14	1	3	3	3	42000	2017	750	5	\N	오늘은 실속형 와인 레드. 막걸리같은 중심으로 가고 떫떠름한 느낌은 과하지 않아요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	리오하 생산자의 탄닌이 있는 와인 Felix Solis Tempranillo Cabernet-Sauvignon Garnacha 2017. 2017 빈티지, 도수 14~15, 750ml.\n\n입안에서는 졸인듯한 느낌의/새콤한 맛가 중심을 잡고, 마무리는 씁쓸한이 정돈합니다.\n균형에 두면 실패 확률이 낮아요. (데일리·대화용)	향에서는 단맛이 조금 나는 인상이 먼저 오고, 입안에서는 시큼한가 균형을 잡습니다. 질감은 막걸리같은, 여운은 떫떠름한 느낌 쪽으로 정리돼요. 그리고 무난한 선물용 쪽으로 즐기기 좋아요.	치킨 스테이크(후추/허브), 숙성 치즈, 미트소스/라구	rep
ta074	Casas Patronales, Privada Cabernet-Sauvignon	Casas Patronales Cabernet-Sauvignon Maule Valley 2007	Casas Patronales	Chile	Maule Valley	Cabernet-Sauvignon	RED	Table	14	1	3	4	3	60000	2007	750	5	\N	많이 비싸지 않은 자리에서 빛나는 카베르네 소비뇽 레드. 씁쓸한은 정돈되고 농축된는 또렷해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Casas Patronales Cabernet-Sauvignon Maule Valley 2007는 탄닌이 있는 카테고리에서 답례용품으로 좋은 선택지로 좋은 편입니다. 2007 빈티지, 14 도수, 750ml.\n\n첫 인상은 산미가 조금 있는가 또렷하고, 텍스처는 점성이 강한로 느껴집니다. 피니시는 입안이 까끌까끌한, 단맛은 음료수같은 와인 쪽으로 해석할 수 있어요. 그리고 탄닌이 있는 쪽으로 즐기기 좋아요.\n데일리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	첫 인상은 산미가 조금 있는가 또렷하고, 텍스처는 점성이 강한로 느껴집니다. 피니시는 입안이 까끌까끌한, 단맛은 음료수같은 와인 쪽으로 해석할 수 있어요. 그리고 탄닌이 있는 쪽으로 즐기기 좋아요.	바비큐 립(후추/허브), 숙성 치즈, 미트소스/라구	rep
ta106	Sette Ponti, Oreno	Tenuta Sette Ponti Sauvignon-blanc Etc Toscana 2017	Tenuta Sette Ponti	Italy	Toscana	Sauvignon-blanc Etc	RED	Table	14.5	1	3	5	4	210000	2017	750	5	\N	산지오베제 무드의 Sauvignon-blanc Etc 레드 — 달콤쌉쌀한 결이 살아 있고 진득한 느낌의가 탄탄해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	피자 먹을때의 탄닌이 있는 와인 Tenuta Sette Ponti Sauvignon-blanc Etc Toscana 2017 (2017). 도수 14.5, 750ml.\n\n전체 톤은 눅진한와 시큼한의 균형. 타닌은 쿰쿰한 맛이 느껴지는, 단맛은 밋밋한 와인 쪽으로 읽힙니다. — 구조감 무드로 이해하면 좋아요.\n글라스 와인 용 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (데일리·대화용)	전체 톤은 눅진한와 시큼한의 균형. 타닌은 쿰쿰한 맛이 느껴지는, 단맛은 밋밋한 와인 쪽으로 읽힙니다. — 구조감 무드로 이해하면 좋아요.	스테이크(그릴), 숙성 치즈, 미트소스/라구	rep
ta075	Santa Isabel,  Malbec	Bodegas Nieto Senetiner 말벡 Mendoza 2008	Bodegas Nieto Senetiner	Argentina	Mendoza	Malbec	RED	Table	14	1	3	3	4	28000	2008	750	5	\N	먹을만한 와인 말벡 레드. 잼같은 느낌 질감에 쿰쿰한 맛이 느껴지는 여운, 메인에 편하게.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Bodegas Nieto Senetiner 말벡 Mendoza 2008는 고기랑 어울리는 카테고리에서 가성비 와인 선택지로 좋은 편입니다. 2008 빈티지, 14 도수, 750ml.\n\n향에서는 단맛이 조금 나는 인상이 먼저 오고, 입안에서는 입안이 개운한가 균형을 잡습니다. 질감은 농익은, 여운은 쿰쿰한 맛이 느껴지는 쪽으로 정리돼요. 특히 식사떄 마시는 와인 상황에 잘 어울립니다.\n데일리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	향에서는 단맛이 조금 나는 인상이 먼저 오고, 입안에서는 입안이 개운한가 균형을 잡습니다. 질감은 농익은, 여운은 쿰쿰한 맛이 느껴지는 쪽으로 정리돼요. 특히 식사떄 마시는 와인 상황에 잘 어울립니다.	스테이크(그릴), 숙성 치즈, 미트소스/라구	rep
ta076	Sileni, Cellar Selection Riesling	Sileni Estate 리슬링 South Island Marlborough 2019	Sileni Estate	New Zealand	South Island Marlborough	Riesling	WHITE	Appetizer, Table	11	1	3	3	1	60000	2019	750	5	\N	이지 드링크 와인 데일리 화이트. 새콤한 맛/걸쭉한 맛 균형이 안정적이에요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	브란콧 생산자의 청포도로 만든 와인 Sileni Estate 리슬링 South Island Marlborough 2019. 2019 빈티지, 도수 11~12, 750ml.\n\n입안에서는 농익은/입에 침이 고이는 정도가 중심을 잡고, 마무리는 둥글둥글한이 정돈합니다.\n입맛에 두면 실패 확률이 낮아요. (데일리·대화용)	첫 인상은 입안이 개운한가 또렷하고, 텍스처는 농익은로 느껴집니다. 피니시는 부담없이 넘어가는, 단맛은 향기가 좋은 쪽으로 해석할 수 있어요. 특히 안주없이 마실수 있는 상황에 잘 어울립니다.	샐러드, 회/초밥, 치즈 플래터	rep
ta077	Neil Ellis, Vineyard Selection Pinotage	Neil Ellis Pinotage Coastal Region Stellenbosch 2010	Neil Ellis	the Republic of South Africa	Coastal Region Stellenbosch	Pinotage	RED	Table	13	1	3	4	3	99000	2010	750	5	\N	이지 드링크 와인 Pinotage 레드. 무게감이 느껴지는 질감에 떫떠름한 느낌 여운, 중심에 편하게.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Neil Ellis Pinotage Coastal Region Stellenbosch 2010는 피노타지 감성을 담은 고기랑 어울리는입니다. 2010 빈티지, 13~14 도수, 750ml.\n\n첫 인상은 입안이 개운한가 또렷하고, 텍스처는 무게감이 느껴지는로 느껴집니다. 피니시는 떫떠름한 느낌, 단맛은 밋밋한 와인 쪽으로 해석할 수 있어요. 특히 많이 비싸지 않은 상황에 잘 어울립니다.\n데일리·대화용에 두고 천천히 즐기면 밸런스가 더 살아나요.	첫 인상은 입안이 개운한가 또렷하고, 텍스처는 무게감이 느껴지는로 느껴집니다. 피니시는 떫떠름한 느낌, 단맛은 밋밋한 와인 쪽으로 해석할 수 있어요. 특히 많이 비싸지 않은 상황에 잘 어울립니다.	로스트 비프(트러플), 숙성 치즈, 미트소스/라구	rep
ta078	Chateau Teyssier Le Dome	Chateau Teyssier Cabernet-Franc Merlot Bordeaux SaintEmilion 2016	Chateau Teyssier	France	Bordeaux SaintEmilion	Cabernet-Franc Merlot	RED	Table	14	1	4	4	4	1040000	2016	750	5	\N	5대샤또 무드의 Cabernet-Franc Merlot 레드 — 입술이 오므라드는 결이 살아 있고 무게감이 느껴지는가 탄탄해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Chateau Teyssier Cabernet-Franc Merlot Bordeaux SaintEmilion 2016는 5대샤또 감성을 담은 탄닌이 있는입니다. 2016 빈티지, 14~15 도수, 750ml.\n\n첫 인상은 탄산음료같은가 또렷하고, 텍스처는 포도 원액 느낌로 느껴집니다. 피니시는 쿰쿰한 맛이 느껴지는, 단맛은 향기가 좋은 쪽으로 해석할 수 있어요. — 탄닌이 있는 무드로 이해하면 좋아요.\n데일리·대화용에 두고 천천히 즐기면 밸런스가 더 살아나요.	첫 인상은 탄산음료같은가 또렷하고, 텍스처는 포도 원액 느낌로 느껴집니다. 피니시는 쿰쿰한 맛이 느껴지는, 단맛은 향기가 좋은 쪽으로 해석할 수 있어요. — 탄닌이 있는 무드로 이해하면 좋아요.	소갈비(후추/허브), 숙성 치즈, 미트소스/라구	rep
ta079	Kaesler, Stonehorse Shiraz	Kaesler Wines 시라 South Australia Barossa Valley 2011	Kaesler Wines	Australia	South Australia Barossa Valley	Syrah&Shiraz	RED	Table	15	1	3	4	4	84000	2011	750	5	\N	답례용품으로 좋은 시라 레드. 농축된 질감에 달콤쌉쌀한 여운, 균형에 편하게.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	스파이시한 생산자의 무난한 선물용 와인 Kaesler Wines 시라 South Australia Barossa Valley 2011. 2011 빈티지, 도수 15, 750ml.\n\n입안에서는 농축된/산미가 조금 있는가 중심을 잡고, 마무리는 달콤쌉쌀한이 정돈합니다.\n메인에 두면 실패 확률이 낮아요. (데일리·대화용)	시큼한가 입맛을 깨우고, 끈끈한 느낌의는 담백하게 이어집니다. 매케한 느낌은 거칠지 않고 밋밋한 와인 느낌은 은근해요. 특히 작업주 상황에 잘 어울립니다.	스테이크(훈제), 숙성 치즈, 미트소스/라구	rep
ta112	Ropiteau Freres Macon Villages	Ropiteau Freres 샤르도네 Bourgogne Maconnais 2010	Ropiteau Freres	France	Bourgogne Maconnais	Chardonnay	WHITE	Table	13	1	4	3	1	55000	2010	750	5	\N	구조감에 어울리는 샤르도네 화이트. 입안이 얼얼한가 살아 있고 걸쭉한 맛는 담백해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	무통로칠드 생산자의 해산물과 잘어울리는 와인 Ropiteau Freres 샤르도네 Bourgogne Maconnais 2010. 2010 빈티지, 도수 13, 750ml.\n\n입안에서는 졸인듯한 느낌의/짜릿한 맛가 중심을 잡고, 마무리는 리치한 느낌이 정돈합니다.\n구조감에 두면 실패 확률이 낮아요. (데일리·대화용)	전체 톤은 졸인듯한 느낌의와 맛이 신의 균형. 타닌은 리치한 느낌, 단맛은 향기가 좋은 쪽으로 읽힙니다. — 많이 비싸지 않은 무드로 이해하면 좋아요.	회/초밥, 샐러드, 치즈 플래터	rep
ta080	Silverado, GEO	Silverado Vineyards Cabernet-Sauvignon Petit Verdot California Napa County 2014	Silverado Vineyards	USA	California Napa County	Cabernet-Sauvignon Petit Verdot	RED	Table	14	1	4	5	5	280000	2014	750	5	\N	메인 자리에서 빛나는 Cabernet-Sauvignon Petit Verdot 레드. 혀끝이 조여드는 느낌은 정돈되고 눅진한는 또렷해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	진판델 생산자의 와인다운 와인 Silverado Vineyards Cabernet-Sauvignon Petit Verdot California Napa County 2014. 2014 빈티지, 도수 14~15, 750ml.\n\n입안에서는 진득한 느낌의/침샘이 자극되는가 중심을 잡고, 마무리는 찌꺼기가 있는이 정돈합니다.\n많이 비싸지 않은에 두면 실패 확률이 낮아요. (데일리·대화용)	첫 인상은 침샘이 자극되는가 또렷하고, 텍스처는 눅진한로 느껴집니다. 피니시는 입안이 마르는듯한, 단맛은 밋밋한 와인 쪽으로 해석할 수 있어요. 특히 탄닌이 있는 상황에 잘 어울립니다.	스테이크(토마토 라구), 숙성 치즈, 미트소스/라구	rep
ta081	Henri Billiot, Brut Millesime	Henri Billiot Fils 샤르도네 Champagne 2002	Henri Billiot Fils	France	Champagne	Chardonnay	SPARKLING	Appetizer, Table	12.5	1	5	2	1	249000	2002	750	5	\N	실속형 스파클링. 눈이 감길정도로 신 톤이라 샐러드와 어울리는에 경쾌해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Henri Billiot Fils 샤르도네 Champagne 2002는 5대샤또에서 온 축하하는 자리 스타일입니다. 2002 빈티지 기준 12.5 도수, 750ml 구성.\n\n키워드로 보면 전체 톤은 마시기 적당한와 산도가 강한 와인의 균형. 타닌은 목넘김이 좋은, 단맛은 밋밋한 와인 쪽으로 읽힙니다. 특히 입맛을 돋구는 와인 상황에 잘 어울립니다.\n추천 상황은 데일리·대화용 쪽이에요.	전체 톤은 마시기 적당한와 산도가 강한 와인의 균형. 타닌은 목넘김이 좋은, 단맛은 밋밋한 와인 쪽으로 읽힙니다. 특히 입맛을 돋구는 와인 상황에 잘 어울립니다.	굴/해산물, 프라이드 치킨	rep
ta082	Chateau La Gaffeliere	Chateau La Gaffeliere  1st Grand Cru ClasseB Merlot Cabernet-Franc Cabernet-Sauvignon Bordeaux SaintEmilion Grand Cru 2017	Chateau La Gaffeliere  1st Grand Cru ClasseB	France	Bordeaux SaintEmilion Grand Cru	Merlot Cabernet-Franc Cabernet-Sauvignon	RED	Table	14	1	3	4	4	175000	2017	750	5	\N	와인 모임에 들고가기 좋은 Merlot Cabernet-Franc Cabernet-Sauvignon 레드. 점성이 강한 질감에 쿰쿰한 맛이 느껴지는 여운, 식욕을 증진시키는에 편하게.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	카베르네소비뇽 생산자의 와인다운 와인 Chateau La Gaffeliere 1st Grand Cru ClasseB Merlot Cabernet-Franc Cabernet-Sauvignon Bordeaux SaintEmilion Grand Cru 2017. 2017 빈티지, 도수 14~15, 750ml.\n\n입안에서는 농축된/입안이 개운한가 중심을 잡고, 마무리는 쌉싸름한 맛이 정돈합니다.\n글라스 와인 용에 두면 실패 확률이 낮아요. (데일리·대화용)	점성이 강한 텍스처 위에 새콤한 맛가 살아 있고, 마무리는 입술이 오므라드는이 정돈합니다. 단맛이 조금 나는 뉘앙스는 과하지 않아요. — 고기랑 어울리는 무드로 이해하면 좋아요.	양갈비(트러플), 숙성 치즈, 미트소스/라구	rep
ta083	Bonny Doon, Syrah Le Pousseur	Bonny Doon Vineyard 시라 California Central Coast 2005	Bonny Doon Vineyard	USA	California Central Coast	Syrah&Shiraz Grenache	RED	Table	13	1	3	4	3	58000	2005	750	5	\N	데이트때 마시기 좋은 시라 레드. 포도 원액 느낌 질감에 쓴맛 여운, 식사떄 마시는 와인에 편하게.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Bonny Doon Vineyard 시라 California Central Coast 2005는 아저씨들이 좋아하는 감성을 담은 와인다운입니다. 2005 빈티지, 13~14 도수, 750ml.\n\n농축된 텍스처 위에 입에 침이 고이는 정도가 살아 있고, 마무리는 쓴맛이 정돈합니다. 음료수같은 와인 뉘앙스는 과하지 않아요. — 식사떄 마시는 와인 무드로 이해하면 좋아요.\n데일리·대화용에 두고 천천히 즐기면 밸런스가 더 살아나요.	농축된 텍스처 위에 입에 침이 고이는 정도가 살아 있고, 마무리는 쓴맛이 정돈합니다. 음료수같은 와인 뉘앙스는 과하지 않아요. — 식사떄 마시는 와인 무드로 이해하면 좋아요.	소갈비(그릴), 숙성 치즈, 미트소스/라구	rep
ta084	Cono Sur, Bicicleta Carmenere	Cono Sur Carmenere Etc Central Valley 2016	Cono Sur	Chile	Central Valley	Carmenere Etc	RED	Table	13	1	3	3	2	18000	2016	750	5	\N	오늘은 입문 와인 레드. 잼같은 느낌 중심으로 가고 홍차를 마시는것같은은 과하지 않아요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Cono Sur Carmenere Etc Central Valley 2016는 마이포밸리 감성을 담은 작업주입니다. 2016 빈티지, 13~14 도수, 750ml.\n\n첫 인상은 새콤한 맛가 또렷하고, 텍스처는 막걸리같은로 느껴집니다. 피니시는 까칠까칠한 맛, 단맛은 향기가 좋은 쪽으로 해석할 수 있어요. 그리고 음식과함께 쪽으로 즐기기 좋아요.\n데일리·대화용에 두고 천천히 즐기면 밸런스가 더 살아나요.	첫 인상은 새콤한 맛가 또렷하고, 텍스처는 막걸리같은로 느껴집니다. 피니시는 까칠까칠한 맛, 단맛은 향기가 좋은 쪽으로 해석할 수 있어요. 그리고 음식과함께 쪽으로 즐기기 좋아요.	버섯 그릴(훈제), 숙성 치즈, 미트소스/라구	rep
ta085	Chateau Parenchere Cuvee Raphael	Chateau Parenchere Cabernet-Sauvignon Merlot Bordeaux Bordeaux Superieur 2006	Chateau Parenchere	France	Bordeaux Bordeaux Superieur	Cabernet-Sauvignon Merlot	RED	Table	12	1	4	3	3	49000	2006	750	5	\N	중심 자리에서 빛나는 Cabernet-Sauvignon Merlot 레드. 입안이 까끌까끌한은 정돈되고 졸인듯한 느낌의는 또렷해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	구대륙의 무난한 선물용 와인 Chateau Parenchere Cabernet-Sauvignon Merlot Bordeaux Bordeaux Superieur 2006 (2006). 도수 12, 750ml.\n\n걸쭉한 맛 텍스처 위에 입안이 얼얼한가 살아 있고, 마무리는 입안이 까끌까끌한이 정돈합니다. 밋밋한 와인 뉘앙스는 과하지 않아요. — 무난한 선물용 무드로 이해하면 좋아요.\n균형 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (데일리·대화용)	걸쭉한 맛 텍스처 위에 입안이 얼얼한가 살아 있고, 마무리는 입안이 까끌까끌한이 정돈합니다. 밋밋한 와인 뉘앙스는 과하지 않아요. — 무난한 선물용 무드로 이해하면 좋아요.	치킨 스테이크(트러플), 숙성 치즈, 미트소스/라구	rep
ta086	Tarima Blanco	Bodegas Volver Merseguera Macabeo Moscatel Jumilla 2017	Bodegas Volver	Spain	Jumilla	Merseguera Macabeo Moscatel	WHITE	Table	12	1	3	2	1	42000	2017	750	5	\N	템프라니요 스타일 Merseguera Macabeo Moscatel 화이트 — 산미가 조금 있는가 또렷하고 구수한 맛의가 깔끔해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	바디감이 무거운의 떫지 않은 와인 Bodegas Volver Merseguera Macabeo Moscatel Jumilla 2017 (2017). 도수 12~13, 750ml.\n\n첫 인상은 시큼한가 또렷하고, 텍스처는 마시기 적당한로 느껴집니다. 피니시는 목넘김이 좋은, 단맛은 밋밋한 와인 쪽으로 해석할 수 있어요. — 떫지 않은 무드로 이해하면 좋아요.\n글라스 와인 용 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (데일리·대화용)	첫 인상은 시큼한가 또렷하고, 텍스처는 마시기 적당한로 느껴집니다. 피니시는 목넘김이 좋은, 단맛은 밋밋한 와인 쪽으로 해석할 수 있어요. — 떫지 않은 무드로 이해하면 좋아요.	흰살 생선구이, 치즈 플래터	rep
ta087	Desert Wind Merlot	Desert Wind Winery Merlot Syrah Washington State Columbia Valley 2013	Desert Wind Winery	USA	Washington State Columbia Valley	Merlot Syrah&Shiraz	RED	Table	14.5	1	4	5	3	110000	2013	750	5	\N	오늘은 선물하기 좋은 와인 레드. 위스키 느낌의 중심으로 가고 쓴맛은 과하지 않아요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Desert Wind Winery Merlot Syrah Washington State Columbia Valley 2013는 감칠맛나는 와인에서 온 와인다운 스타일입니다. 2013 빈티지 기준 14.5 도수, 750ml 구성.\n\n키워드로 보면 전체 톤은 진득한 느낌의와 탄산음료같은의 균형. 타닌은 쌍화탕같은 맛의, 단맛은 음료수같은 와인 쪽으로 읽힙니다. — 고기랑 어울리는 무드로 이해하면 좋아요.\n추천 상황은 데일리·대화용 쪽이에요.	전체 톤은 진득한 느낌의와 탄산음료같은의 균형. 타닌은 쌍화탕같은 맛의, 단맛은 음료수같은 와인 쪽으로 읽힙니다. — 고기랑 어울리는 무드로 이해하면 좋아요.	로스트 비프(그릴), 숙성 치즈, 미트소스/라구	rep
ta088	Chateau Los Boldos, Sensatione  Merlot	Chateau Los Boldos 메를로 Rapel Valley 2009	Chateau Los Boldos	Chile	Rapel Valley	Merlot	RED	Table	14.3	1	3	3	3	45000	2009	750	5	\N	가성비 와인 무드의 메를로 레드 — 쌍화탕같은 맛의 결이 살아 있고 졸인듯한 느낌의가 탄탄해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	마이포밸리 생산자의 탄닌이 있는 와인 Chateau Los Boldos 메를로 Rapel Valley 2009. 2009 빈티지, 도수 14.3, 750ml.\n\n입안에서는 걸쭉한 맛/시큼한가 중심을 잡고, 마무리는 입안이 까끌까끌한이 정돈합니다.\n균형에 두면 실패 확률이 낮아요. (데일리·대화용)	걸쭉한 맛 텍스처 위에 산미가 조금 있는가 살아 있고, 마무리는 쓴맛이 정돈합니다. 밋밋한 와인 뉘앙스는 과하지 않아요. 그리고 무난한 선물용 쪽으로 즐기기 좋아요.	치킨 스테이크(그릴), 숙성 치즈, 미트소스/라구	rep
ta089	Chateau Le Marin	Chateau Le Marin Merlot Cabernet-Franc Cabernet-Sauvignon Bordeaux 2013	Chateau Le Marin	France	Bordeaux	Merlot Cabernet-Franc Cabernet-Sauvignon	RED	Table	14	1	3	3	3	35000	2013	750	5	\N	오늘은 캠핑 와인으로 좋은 레드. 걸쭉한 맛 중심으로 가고 입안이 까끌까끌한은 과하지 않아요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	무통로칠드의 와인다운 와인 Chateau Le Marin Merlot Cabernet-Franc Cabernet-Sauvignon Bordeaux 2013 (2013). 도수 14~15, 750ml.\n\n막걸리같은 텍스처 위에 입안이 개운한가 살아 있고, 마무리는 입안이 까끌까끌한이 정돈합니다. 향기가 좋은 뉘앙스는 과하지 않아요. 그리고 메인음식과 함께 먹는 쪽으로 즐기기 좋아요.\n구조감 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (데일리·대화용)	막걸리같은 텍스처 위에 입안이 개운한가 살아 있고, 마무리는 입안이 까끌까끌한이 정돈합니다. 향기가 좋은 뉘앙스는 과하지 않아요. 그리고 메인음식과 함께 먹는 쪽으로 즐기기 좋아요.	치킨 스테이크(토마토 라구), 숙성 치즈, 미트소스/라구	rep
ta090	Mario Schiopetto, Pinot Grigio	Mario Schiopetto 피노 그리지오 Friuli Venezia Giulia 2015	Mario Schiopetto	Italy	Friuli Venezia Giulia	Pinot Grigio	WHITE	Table	13.5	1	3	3	1	55000	2015	750	5	\N	가볍게 시작하기 좋은 가격이 부담스럽지 않은 와인 화이트. 입에 침이 고이는 정도가 상쾌한 쪽이에요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	산지오베제의 청포도로 만든 와인 Mario Schiopetto 피노 그리지오 Friuli Venezia Giulia 2015 (2015). 도수 13.5, 750ml.\n\n첫 인상은 시큼한가 또렷하고, 텍스처는 잼같은 느낌로 느껴집니다. 피니시는 부담없이 넘어가는, 단맛은 순한 맛 쪽으로 해석할 수 있어요. 그리고 안주없이 마실수 있는 쪽으로 즐기기 좋아요.\n균형 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (데일리·대화용)	첫 인상은 시큼한가 또렷하고, 텍스처는 잼같은 느낌로 느껴집니다. 피니시는 부담없이 넘어가는, 단맛은 순한 맛 쪽으로 해석할 수 있어요. 그리고 안주없이 마실수 있는 쪽으로 즐기기 좋아요.	회/초밥, 흰살 생선구이, 치즈 플래터	rep
ta091	Louis Max, Chablis Saint Jean	Louis Max 샤르도네 Bourgogne Chablis 2015	Louis Max	France	Bourgogne Chablis	Chardonnay	WHITE	Appetizer, Table	13	1	4	3	1	120000	2015	750	5	\N	호불호 없는 스타일 샤르도네 화이트 — 입안이 얼얼한가 또렷하고 잼같은 느낌가 깔끔해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Louis Max 샤르도네 Bourgogne Chablis 2015는 5대샤또에서 온 안주없이 마실수 있는 스타일입니다. 2015 빈티지 기준 13 도수, 750ml 구성.\n\n키워드로 보면 향에서는 순한 맛 인상이 먼저 오고, 입안에서는 침샘이 자극되는가 균형을 잡습니다. 질감은 졸인듯한 느낌의, 여운은 약간 비린맛의 쪽으로 정리돼요. — 떫지 않은 무드로 이해하면 좋아요.\n추천 상황은 데일리·대화용 쪽이에요.	향에서는 순한 맛 인상이 먼저 오고, 입안에서는 침샘이 자극되는가 균형을 잡습니다. 질감은 졸인듯한 느낌의, 여운은 약간 비린맛의 쪽으로 정리돼요. — 떫지 않은 무드로 이해하면 좋아요.	새우/조개, 치즈 플래터	rep
ta092	Domaine Emmanuel Rouget, Vosne-Romanee 1er Cru 'Les Beaumonts'	Domaine Emmanuel Rouget 피노 누아 Bourgogne Cote de Nuits 2009	Domaine Emmanuel Rouget	France	Bourgogne Cote de Nuits	Pinot Noir	RED	Table	13	1	4	4	3	600000	2009	750	5	\N	소중한 사람들과 마시기 좋은 와인 피노 누아 레드. 포도 원액 느낌 질감에 쓴맛 여운, 식욕을 증진시키는에 편하게.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	카베르네소비뇽의 무난한 선물용 와인 Domaine Emmanuel Rouget 피노 누아 Bourgogne Cote de Nuits 2009 (2009). 도수 13~14, 750ml.\n\n전체 톤은 무게감이 느껴지는와 침샘이 자극되는의 균형. 타닌은 씁쓸한, 단맛은 밋밋한 와인 쪽으로 읽힙니다. 그리고 작업주 쪽으로 즐기기 좋아요.\n균형 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (데일리·대화용)	전체 톤은 무게감이 느껴지는와 침샘이 자극되는의 균형. 타닌은 씁쓸한, 단맛은 밋밋한 와인 쪽으로 읽힙니다. 그리고 작업주 쪽으로 즐기기 좋아요.	바비큐 립(훈제), 숙성 치즈, 미트소스/라구	rep
ta093	Silverado, Chardonnay	Silverado Vineyards 샤르도네 California Napa County 2018	Silverado Vineyards	USA	California Napa County	Chardonnay	WHITE	Table	14	1	3	4	1	130000	2018	750	5	\N	아저씨들이 좋아하는 스타일 샤르도네 화이트 — 산미가 조금 있는가 또렷하고 농축된가 깔끔해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Silverado Vineyards 샤르도네 California Napa County 2018는 아저씨들이 좋아하는에서 온 돌려서 따는 마개 스타일입니다. 2018 빈티지 기준 14~15 도수, 750ml 구성.\n\n키워드로 보면 점성이 강한 텍스처 위에 산미가 조금 있는가 살아 있고, 마무리는 목넘김이 좋은이 정돈합니다. 단맛이 조금 나는 뉘앙스는 과하지 않아요. — 안주없이 마실수 있는 무드로 이해하면 좋아요.\n추천 상황은 데일리·대화용 쪽이에요.	점성이 강한 텍스처 위에 산미가 조금 있는가 살아 있고, 마무리는 목넘김이 좋은이 정돈합니다. 단맛이 조금 나는 뉘앙스는 과하지 않아요. — 안주없이 마실수 있는 무드로 이해하면 좋아요.	리조또, 크림 파스타, 치즈 플래터	rep
ta094	Luis Felipe Edwards Sauvignon-blanc	Luis Felipe Edwards Sauvignon-blanc Central Valley 2017	Luis Felipe Edwards	Chile	Central Valley	Sauvignon-blanc	WHITE	Table	13	1	4	2	1	25000	2017	750	5	\N	메인음식과 함께 먹는에 어울리는 Sauvignon-blanc 화이트. 입안이 얼얼한가 살아 있고 부드러운 느낌의는 담백해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Luis Felipe Edwards Sauvignon-blanc Central Valley 2017는 안주없이 마실수 있는 카테고리에서 실속형 와인 선택지로 좋은 편입니다. 2017 빈티지, 13 도수, 750ml.\n\n짜릿한 맛가 입맛을 깨우고, 부드러운 느낌의는 담백하게 이어집니다. 약간 비린맛의은 거칠지 않고 향기가 좋은 느낌은 은근해요. 그리고 청포도로 만든 쪽으로 즐기기 좋아요.\n데일리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	짜릿한 맛가 입맛을 깨우고, 부드러운 느낌의는 담백하게 이어집니다. 약간 비린맛의은 거칠지 않고 향기가 좋은 느낌은 은근해요. 그리고 청포도로 만든 쪽으로 즐기기 좋아요.	오일 파스타, 치즈 플래터	rep
ta095	Patrice Rion, Cote de Nuits Villages	Domaine Michelle et Patrice Rion 피노 누아 Bourgogne Cote de Nuits 2017	Domaine Michelle et Patrice Rion	France	Bourgogne Cote de Nuits	Pinot Noir	RED	Table	13	1	3	3	3	100000	2017	750	5	\N	와인 모임에 들고가기 좋은 선택지로 좋은 피노 누아 레드. 쌍화탕같은 맛의/농익은 밸런스형.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	카베르네소비뇽의 무난한 선물용 와인 Domaine Michelle et Patrice Rion 피노 누아 Bourgogne Cote de Nuits 2017 (2017). 도수 13~14, 750ml.\n\n졸인듯한 느낌의 텍스처 위에 시큼한가 살아 있고, 마무리는 떫떠름한 느낌이 정돈합니다. 향기가 좋은 뉘앙스는 과하지 않아요. — 메인 무드로 이해하면 좋아요.\n많이 비싸지 않은 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (데일리·대화용)	졸인듯한 느낌의 텍스처 위에 시큼한가 살아 있고, 마무리는 떫떠름한 느낌이 정돈합니다. 향기가 좋은 뉘앙스는 과하지 않아요. — 메인 무드로 이해하면 좋아요.	미트볼(후추/허브), 숙성 치즈, 미트소스/라구	rep
ta096	Boekenhoutskloof, Wolftrap	Boekenhoutskloof 시라 Coastal Region Franschhoek  Franschhoek Valley 2012	Boekenhoutskloof	the Republic of South Africa	Coastal Region Franschhoek  Franschhoek Valley	Syrah&Shiraz mourvedre Viognier	RED	Table	14.5	1	4	4	4	34000	2012	750	5	\N	먹을만한 와인 시라 레드. 무게감이 느껴지는 질감에 매케한 느낌 여운, 식욕을 증진시키는에 편하게.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	피노타지 생산자의 탄닌이 있는 와인 Boekenhoutskloof 시라 Coastal Region Franschhoek Franschhoek Valley 2012. 2012 빈티지, 도수 14.5, 750ml.\n\n입안에서는 포도 원액 느낌/맛이 신가 중심을 잡고, 마무리는 쌉싸름한 맛이 정돈합니다.\n많이 비싸지 않은에 두면 실패 확률이 낮아요. (데일리·대화용)	첫 인상은 맛이 신가 또렷하고, 텍스처는 점성이 강한로 느껴집니다. 피니시는 달콤쌉쌀한, 단맛은 음료수같은 와인 쪽으로 해석할 수 있어요. 특히 식사떄 마시는 와인 상황에 잘 어울립니다.	바비큐 립(훈제), 숙성 치즈, 미트소스/라구	rep
ta097	Chateau St. Jean, Sonoma Coast Pinot Noir	Chateau St Jean 피노 누아 California Sonoma County 2016	Chateau St Jean	USA	California Sonoma County	Pinot Noir	RED	Table	14.2	1	3	3	2	70000	2016	750	5	\N	오늘은 답례용품으로 좋은 레드. 졸인듯한 느낌의 중심으로 가고 홍차를 마시는것같은은 과하지 않아요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Chateau St Jean 피노 누아 California Sonoma County 2016는 작업주 카테고리에서 답례용품으로 좋은 선택지로 좋은 편입니다. 2016 빈티지, 14.2 도수, 750ml.\n\n첫 인상은 시큼한가 또렷하고, 텍스처는 막걸리같은로 느껴집니다. 피니시는 홍차를 마시는것같은, 단맛은 단맛이 조금 나는 쪽으로 해석할 수 있어요. 그리고 메인 쪽으로 즐기기 좋아요.\n데일리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	첫 인상은 시큼한가 또렷하고, 텍스처는 막걸리같은로 느껴집니다. 피니시는 홍차를 마시는것같은, 단맛은 단맛이 조금 나는 쪽으로 해석할 수 있어요. 그리고 메인 쪽으로 즐기기 좋아요.	미트볼(그릴), 숙성 치즈, 미트소스/라구	rep
ta098	Domaine Benoit Ente, Burgogne Pinot Noir Mathilde	Benoit Ente 피노 누아 Bourgogne Cote de Beaune 2017	Benoit Ente	France	Bourgogne Cote de Beaune	Pinot Noir	RED	Table	13	1	4	2	2	110000	2017	750	5	\N	메인음식과 함께 먹는 자리에서 빛나는 피노 누아 레드. 홍차를 마시는것같은은 정돈되고 마시기 적당한는 또렷해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Benoit Ente 피노 누아 Bourgogne Cote de Beaune 2017는 카베르네소비뇽 감성을 담은 고기랑 어울리는입니다. 2017 빈티지, 13~14 도수, 750ml.\n\n첫 인상은 입안이 얼얼한가 또렷하고, 텍스처는 구수한 맛의로 느껴집니다. 피니시는 혀가 아리는 느낌, 단맛은 순한 맛 쪽으로 해석할 수 있어요. 그리고 식욕을 증진시키는 쪽으로 즐기기 좋아요.\n데일리·대화용에 두고 천천히 즐기면 밸런스가 더 살아나요.	첫 인상은 입안이 얼얼한가 또렷하고, 텍스처는 구수한 맛의로 느껴집니다. 피니시는 혀가 아리는 느낌, 단맛은 순한 맛 쪽으로 해석할 수 있어요. 그리고 식욕을 증진시키는 쪽으로 즐기기 좋아요.	피자(후추/허브), 숙성 치즈, 미트소스/라구	rep
ta099	Mount Riley Pinot Noir	Mount Riley 피노 누아 South Island Marlborough 2010	Mount Riley	New Zealand	South Island Marlborough	Pinot Noir	RED	Table	13.5	1	5	3	3	64000	2010	750	5	\N	데이트때 마시기 좋은 피노 누아 레드. 졸인듯한 느낌의 질감에 쌍화탕같은 맛의 여운, 중심에 편하게.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	클라우디 베이 생산자의 탄닌이 있는 와인 Mount Riley 피노 누아 South Island Marlborough 2010. 2010 빈티지, 도수 13.5, 750ml.\n\n입안에서는 농익은/레몬같은가 중심을 잡고, 마무리는 떫떠름한 느낌이 정돈합니다.\n식욕을 증진시키는에 두면 실패 확률이 낮아요. (데일리·대화용)	전체 톤은 농익은와 매실청같은 느낌의 균형. 타닌은 쓴맛, 단맛은 단맛이 조금 나는 쪽으로 읽힙니다. — 탄닌이 있는 무드로 이해하면 좋아요.	버섯 그릴(그릴), 숙성 치즈, 미트소스/라구	rep
ta100	P. Ferraud et Fils, Saint Amour	Pierre Ferraud et Fils 가메 Bourgogne Beaujolais 2011	Pierre Ferraud et Fils	France	Bourgogne Beaujolais	Gamay	RED	Table	12	1	4	3	2	54000	2011	750	5	\N	데이트때 마시기 좋은 선택지로 좋은 Gamay 레드. 혀가 아리는 느낌/졸인듯한 느낌의 밸런스형.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Pierre Ferraud et Fils 가메 Bourgogne Beaujolais 2011는 구대륙에서 온 작업주 스타일입니다. 2011 빈티지 기준 12~13 도수, 750ml 구성.\n\n키워드로 보면 입안이 얼얼한가 입맛을 깨우고, 잼같은 느낌는 담백하게 이어집니다. 무난한 느낌은 거칠지 않고 밋밋한 와인 느낌은 은근해요. 특히 메인 상황에 잘 어울립니다.\n추천 상황은 데일리·대화용 쪽이에요.	입안이 얼얼한가 입맛을 깨우고, 잼같은 느낌는 담백하게 이어집니다. 무난한 느낌은 거칠지 않고 밋밋한 와인 느낌은 은근해요. 특히 메인 상황에 잘 어울립니다.	피자(훈제), 숙성 치즈, 미트소스/라구	rep
ta101	Domaine Lafage, Nicloas	Domaine lafage 그르나슈 Southern France Languedoc Roussillon 2018	Domaine lafage	France	Southern France Languedoc Roussillon	Grenache	RED	Table	13	1	4	3	3	32000	2018	750	5	\N	보르도 무드의 그르나슈 레드 — 쌍화탕같은 맛의 결이 살아 있고 걸쭉한 맛가 탄탄해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Domaine lafage 그르나슈 Southern France Languedoc Roussillon 2018는 카베르네소비뇽에서 온 탄닌이 있는 스타일입니다. 2018 빈티지 기준 13~14 도수, 750ml 구성.\n\n키워드로 보면 졸인듯한 느낌의 텍스처 위에 짜릿한 맛가 살아 있고, 마무리는 입안이 까끌까끌한이 정돈합니다. 음료수같은 와인 뉘앙스는 과하지 않아요. 특히 균형 상황에 잘 어울립니다.\n추천 상황은 데일리·대화용 쪽이에요.	졸인듯한 느낌의 텍스처 위에 짜릿한 맛가 살아 있고, 마무리는 입안이 까끌까끌한이 정돈합니다. 음료수같은 와인 뉘앙스는 과하지 않아요. 특히 균형 상황에 잘 어울립니다.	미트볼(트러플), 숙성 치즈, 미트소스/라구	rep
ta102	Taurino, Reserve Cabernet-Sauvignon	Taurino Cabernet-Sauvignon Rapel Valley 2007	Taurino	Chile	Rapel Valley	Cabernet-Sauvignon	RED	Table	14.5	1	4	3	3	48000	2007	750	5	\N	오늘은 무난한 와인 레드. 졸인듯한 느낌의 중심으로 가고 씁쓸한은 과하지 않아요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Taurino Cabernet-Sauvignon Rapel Valley 2007는 작업주 카테고리에서 캠핑 와인으로 좋은 선택지로 좋은 편입니다. 2007 빈티지, 14.5 도수, 750ml.\n\n잼같은 느낌 텍스처 위에 맛이 신가 살아 있고, 마무리는 씁쓸한이 정돈합니다. 밋밋한 와인 뉘앙스는 과하지 않아요. 그리고 작업주 쪽으로 즐기기 좋아요.\n데일리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	잼같은 느낌 텍스처 위에 맛이 신가 살아 있고, 마무리는 씁쓸한이 정돈합니다. 밋밋한 와인 뉘앙스는 과하지 않아요. 그리고 작업주 쪽으로 즐기기 좋아요.	피자(그릴), 숙성 치즈, 미트소스/라구	rep
ta103	Louis Roederer, Nature Brut	Louis Roederer Pinot Noir Pinot Meunier Chardonnay Champagne 2012	Louis Roederer	France	Champagne	Pinot Noir Pinot Meunier Chardonnay	SPARKLING	Appetizer, Table	11	1	5	3	1	300000	2012	750	5	\N	분위기 올리는 품질이 뛰어난 와인 스파클링 — 산도가 강한 와인가 깔끔하게 받쳐줘요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	보르도 생산자의 거품이 있는 와인 Louis Roederer Pinot Noir Pinot Meunier Chardonnay Champagne 2012. 2012 빈티지, 도수 11~12, 750ml.\n\n입안에서는 농익은/매실청같은 느낌가 중심을 잡고, 마무리는 리치한 느낌이 정돈합니다.\n상쾌함에 두면 실패 확률이 낮아요. (데일리·대화용)	향에서는 밋밋한 와인 인상이 먼저 오고, 입안에서는 매실청같은 느낌가 균형을 잡습니다. 질감은 걸쭉한 맛, 여운은 목넘김이 좋은 쪽으로 정리돼요. — 상쾌함 무드로 이해하면 좋아요.	카나페, 프라이드 치킨	rep
ta104	La Chamiza, Polo Amateur Malbec	La Chamiza 말벡 Mendoza 2007	La Chamiza	Argentina	Mendoza	Malbec	RED	Table	13	1	3	3	3	20000	2007	750	5	\N	탄닌이 강한 무드의 말벡 레드 — 쓴맛 결이 살아 있고 졸인듯한 느낌의가 탄탄해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	강한맛 생산자의 무난한 선물용 와인 La Chamiza 말벡 Mendoza 2007. 2007 빈티지, 도수 13, 750ml.\n\n입안에서는 잼같은 느낌/산미가 조금 있는가 중심을 잡고, 마무리는 씁쓸한이 정돈합니다.\n식욕을 증진시키는에 두면 실패 확률이 낮아요. (데일리·대화용)	잼같은 느낌 텍스처 위에 산미가 조금 있는가 살아 있고, 마무리는 씁쓸한이 정돈합니다. 음료수같은 와인 뉘앙스는 과하지 않아요. 그리고 탄닌이 있는 쪽으로 즐기기 좋아요.	미트볼(그릴), 숙성 치즈, 미트소스/라구	rep
ta105	Agricola de Cadalso, Garnacha	Agricola de Cadalso Sauvignon-blanc Vinos de Madrid 2017	Agricola de Cadalso	Spain	Vinos de Madrid	Sauvignon-blanc	RED	Table	14	1	3	3	3	30000	2017	750	5	\N	글라스 와인 용 자리에서 빛나는 Sauvignon-blanc 레드. 씁쓸한은 정돈되고 막걸리같은는 또렷해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Agricola de Cadalso Sauvignon-blanc Vinos de Madrid 2017는 템프라니요 감성을 담은 작업주입니다. 2017 빈티지, 14~15 도수, 750ml.\n\n전체 톤은 막걸리같은와 새콤한 맛의 균형. 타닌은 입안이 까끌까끌한, 단맛은 음료수같은 와인 쪽으로 읽힙니다. 그리고 메인 쪽으로 즐기기 좋아요.\n데일리·대화용에 두고 천천히 즐기면 밸런스가 더 살아나요.	전체 톤은 막걸리같은와 새콤한 맛의 균형. 타닌은 입안이 까끌까끌한, 단맛은 음료수같은 와인 쪽으로 읽힙니다. 그리고 메인 쪽으로 즐기기 좋아요.	피자(후추/허브), 숙성 치즈, 미트소스/라구	rep
ta107	Marcel Deiss Gewurztraminer Saint Hippolyte	Domaine Marcel Deiss Gewurztraminer Alsace 2006	Domaine Marcel Deiss	France	Alsace	Gewurztraminer	WHITE	Table	13	3	3	3	1	98000	2006	750	5	\N	가볍게 시작하기 좋은 데이트때 마시기 좋은 화이트. 산미가 조금 있는가 상쾌한 쪽이에요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Domaine Marcel Deiss Gewurztraminer Alsace 2006는 카베르네소비뇽에서 온 해산물과 잘어울리는 스타일입니다. 2006 빈티지 기준 13 도수, 750ml 구성.\n\n키워드로 보면 잼같은 느낌 텍스처 위에 입안이 개운한가 살아 있고, 마무리는 리치한 느낌이 정돈합니다. 달큰한 뉘앙스는 과하지 않아요. 특히 균형 상황에 잘 어울립니다.\n추천 상황은 데일리·대화용 쪽이에요.	잼같은 느낌 텍스처 위에 입안이 개운한가 살아 있고, 마무리는 리치한 느낌이 정돈합니다. 달큰한 뉘앙스는 과하지 않아요. 특히 균형 상황에 잘 어울립니다.	흰살 생선구이, 샐러드, 치즈 플래터	rep
ta108	Joel Robuchon Collection, Cotes du Rhone	Joel Robuchon Collection 시라 Rhone Cotes du Rhone 2015	Joel Robuchon Collection	France	Rhone Cotes du Rhone	Syrah&Shiraz Grenache mourvedre	RED	Table	14.5	1	3	3	3	33000	2015	750	5	\N	음식과함께 자리에서 빛나는 시라 레드. 입안이 까끌까끌한은 정돈되고 잼같은 느낌는 또렷해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Joel Robuchon Collection 시라 Rhone Cotes du Rhone 2015는 카베르네소비뇽에서 온 고기랑 어울리는 스타일입니다. 2015 빈티지 기준 14.5~23 도수, 750ml 구성.\n\n키워드로 보면 향에서는 향기가 좋은 인상이 먼저 오고, 입안에서는 새콤한 맛가 균형을 잡습니다. 질감은 졸인듯한 느낌의, 여운은 쓴맛 쪽으로 정리돼요. — 식욕을 증진시키는 무드로 이해하면 좋아요.\n추천 상황은 데일리·대화용 쪽이에요.	향에서는 향기가 좋은 인상이 먼저 오고, 입안에서는 새콤한 맛가 균형을 잡습니다. 질감은 졸인듯한 느낌의, 여운은 쓴맛 쪽으로 정리돼요. — 식욕을 증진시키는 무드로 이해하면 좋아요.	치킨 스테이크(훈제), 숙성 치즈, 미트소스/라구	rep
ta109	Chateau de La Tour, Pierre Labet Beaune Rouge	Chateau de La Tour 피노 누아 Bourgogne Cote de Beaune 2012	Chateau de La Tour	France	Bourgogne Cote de Beaune	Pinot Noir	RED	Table	13	1	5	3	2	145000	2012	750	5	\N	오늘은 와인 모임에 들고가기 좋은 레드. 막걸리같은 중심으로 가고 혀가 아리는 느낌은 과하지 않아요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	구대륙 생산자의 무난한 선물용 와인 Chateau de La Tour 피노 누아 Bourgogne Cote de Beaune 2012. 2012 빈티지, 도수 13~14, 750ml.\n\n입안에서는 잼같은 느낌/눈이 감길정도로 신가 중심을 잡고, 마무리는 홍차를 마시는것같은이 정돈합니다.\n식사떄 마시는 와인에 두면 실패 확률이 낮아요. (데일리·대화용)	첫 인상은 매실청같은 느낌가 또렷하고, 텍스처는 걸쭉한 맛로 느껴집니다. 피니시는 홍차를 마시는것같은, 단맛은 순한 맛 쪽으로 해석할 수 있어요. 그리고 고기랑 어울리는 쪽으로 즐기기 좋아요.	햄·살라미(트러플), 숙성 치즈, 미트소스/라구	rep
ta110	Chateau Sainte Marie	Chateau Saint Marie Merlot Cabernet-Sauvignon Cabernet-Franc Bordeaux Bordeaux Superieur 2005	Chateau Saint Marie	France	Bordeaux Bordeaux Superieur	Merlot Cabernet-Sauvignon Cabernet-Franc	RED	Table	13	1	3	3	3	34000	2005	750	5	\N	메인음식과 함께 먹는 자리에서 빛나는 Merlot Cabernet-Sauvignon Cabernet-Franc 레드. 쌍화탕같은 맛의은 정돈되고 농익은는 또렷해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Chateau Saint Marie Merlot Cabernet-Sauvignon Cabernet-Franc Bordeaux Bordeaux Superieur 2005는 호불호 없는에서 온 작업주 스타일입니다. 2005 빈티지 기준 13 도수, 750ml 구성.\n\n키워드로 보면 입안이 개운한가 입맛을 깨우고, 걸쭉한 맛는 담백하게 이어집니다. 씁쓸한은 거칠지 않고 순한 맛 느낌은 은근해요. 특히 균형 상황에 잘 어울립니다.\n추천 상황은 데일리·대화용 쪽이에요.	입안이 개운한가 입맛을 깨우고, 걸쭉한 맛는 담백하게 이어집니다. 씁쓸한은 거칠지 않고 순한 맛 느낌은 은근해요. 특히 균형 상황에 잘 어울립니다.	버섯 그릴(트러플), 숙성 치즈, 미트소스/라구	rep
ta111	Quinta da Vista Alegre Red	Vista Alegre Touriga Nacional Touriga Franca Tinta Roriz Douro 2009	Vista Alegre	Portugal	Douro	Touriga Nacional Touriga Franca Tinta Roriz	RED	Table	13	1	4	4	3	60000	2009	750	5	\N	오늘은 발렌타인날 마시기 좋은 레드. 농축된 중심으로 가고 씁쓸한은 과하지 않아요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	도루밸리의 와인다운 와인 Vista Alegre Touriga Nacional Touriga Franca Tinta Roriz Douro 2009 (2009). 도수 13, 750ml.\n\n전체 톤은 농축된와 입안이 얼얼한의 균형. 타닌은 씁쓸한, 단맛은 단맛이 조금 나는 쪽으로 읽힙니다. 그리고 식사떄 마시는 와인 쪽으로 즐기기 좋아요.\n많이 비싸지 않은 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (데일리·대화용)	전체 톤은 농축된와 입안이 얼얼한의 균형. 타닌은 씁쓸한, 단맛은 단맛이 조금 나는 쪽으로 읽힙니다. 그리고 식사떄 마시는 와인 쪽으로 즐기기 좋아요.	양갈비(그릴), 숙성 치즈, 미트소스/라구	rep
ta113	Louis Jadot, Clos de La Roche Grand Cru	Louis Jadot 피노 누아 Bourgogne Cote de Nuits 2009	Louis Jadot	France	Bourgogne Cote de Nuits	Pinot Noir	RED	Table	13.5	1	4	4	3	470000	2009	750	5	\N	프리미엄 와인 피노 누아 레드. 점성이 강한 질감에 떫떠름한 느낌 여운, 메인음식과 함께 먹는에 편하게.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Louis Jadot 피노 누아 Bourgogne Cote de Nuits 2009는 보르도에서 온 와인다운 스타일입니다. 2009 빈티지 기준 13.5 도수, 750ml 구성.\n\n키워드로 보면 전체 톤은 농축된와 짜릿한 맛의 균형. 타닌은 떫떠름한 느낌, 단맛은 순한 맛 쪽으로 읽힙니다. 특히 탄닌이 있는 상황에 잘 어울립니다.\n추천 상황은 데일리·대화용 쪽이에요.	전체 톤은 농축된와 짜릿한 맛의 균형. 타닌은 떫떠름한 느낌, 단맛은 순한 맛 쪽으로 읽힙니다. 특히 탄닌이 있는 상황에 잘 어울립니다.	스테이크(트러플), 숙성 치즈, 미트소스/라구	rep
ta114	La Chablisienne, Chablis 'La Pierrelee'	La Chablisienne 샤르도네 Bourgogne Chablis 2015	La Chablisienne	France	Bourgogne Chablis	Chardonnay	WHITE	Table	12	1	4	2	1	56000	2015	750	5	\N	중심에 어울리는 샤르도네 화이트. 맛이 신가 살아 있고 마시기 적당한는 담백해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	La Chablisienne 샤르도네 Bourgogne Chablis 2015는 구대륙에서 온 안주없이 마실수 있는 스타일입니다. 2015 빈티지 기준 12~13 도수, 750ml 구성.\n\n키워드로 보면 향에서는 순한 맛 인상이 먼저 오고, 입안에서는 탄산음료같은가 균형을 잡습니다. 질감은 부드러운 느낌의, 여운은 부담없이 넘어가는 쪽으로 정리돼요. 그리고 떫지 않은 쪽으로 즐기기 좋아요.\n추천 상황은 데일리·대화용 쪽이에요.	향에서는 순한 맛 인상이 먼저 오고, 입안에서는 탄산음료같은가 균형을 잡습니다. 질감은 부드러운 느낌의, 여운은 부담없이 넘어가는 쪽으로 정리돼요. 그리고 떫지 않은 쪽으로 즐기기 좋아요.	흰살 생선구이, 새우/조개, 치즈 플래터	rep
ta115	Martius Magnificat White	LGI Wines Colombard Ugni blanc Southwest France Cahors 2017	LGI Wines	France	Southwest France Cahors	Colombard Ugni blanc	WHITE	Table	11.5	1	3	3	1	25000	2017	750	5	\N	식사떄 마시는 와인에 어울리는 Colombard Ugni blanc 화이트. 산미가 조금 있는가 살아 있고 막걸리같은는 담백해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	LGI Wines Colombard Ugni blanc Southwest France Cahors 2017는 무통로칠드 감성을 담은 안주없이 마실수 있는입니다. 2017 빈티지, 11.5 도수, 750ml.\n\n첫 인상은 산미가 조금 있는가 또렷하고, 텍스처는 농익은로 느껴집니다. 피니시는 리치한 느낌, 단맛은 음료수같은 와인 쪽으로 해석할 수 있어요. — 구조감 무드로 이해하면 좋아요.\n데일리·대화용에 두고 천천히 즐기면 밸런스가 더 살아나요.	첫 인상은 산미가 조금 있는가 또렷하고, 텍스처는 농익은로 느껴집니다. 피니시는 리치한 느낌, 단맛은 음료수같은 와인 쪽으로 해석할 수 있어요. — 구조감 무드로 이해하면 좋아요.	새우/조개, 샐러드, 치즈 플래터	rep
ta116	Savart La Dame de Coeur 1er Blanc de Blancs Extra Brut	Champagne Savart 샤르도네 Champagne 2012	Champagne Savart	France	Champagne	Chardonnay	SPARKLING	Appetizer	5	1	5	3	1	303000	2012	750	5	\N	거품이 심하게 들어간 스파클링 한 병. 포인트는 눈이 감길정도로 신 청량감이에요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Champagne Savart 샤르도네 Champagne 2012는 호불호 없는에서 온 거품이 있는 스타일입니다. 2012 빈티지 기준 5~6 도수, 750ml 구성.\n\n키워드로 보면 첫 인상은 눈이 감길정도로 신가 또렷하고, 텍스처는 졸인듯한 느낌의로 느껴집니다. 피니시는 리치한 느낌, 단맛은 밋밋한 와인 쪽으로 해석할 수 있어요. 그리고 펑 하고 터지는 쪽으로 즐기기 좋아요.\n추천 상황은 첫잔·파티 쪽이에요.	첫 인상은 눈이 감길정도로 신가 또렷하고, 텍스처는 졸인듯한 느낌의로 느껴집니다. 피니시는 리치한 느낌, 단맛은 밋밋한 와인 쪽으로 해석할 수 있어요. 그리고 펑 하고 터지는 쪽으로 즐기기 좋아요.	치즈, 튀김, 카나페	rep
ta117	Loxarel, Vintage Cava	Loxarel Blend Penedes 2006	Loxarel	Spain	Penedes	Blend	SPARKLING	Appetizer	15	2	4	3	1	42500	2006	750	5	\N	톡 쏘는 매력의 무난한 와인 스파클링. 짜릿한 맛/걸쭉한 맛가 산뜻한 쪽.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	눅진한 스타일 생산자의 뚱뚱한 병 와인 와인 Loxarel Blend Penedes 2006. 2006 빈티지, 도수 15~16, 750ml.\n\n입안에서는 졸인듯한 느낌의/탄산음료같은가 중심을 잡고, 마무리는 리치한 느낌이 정돈합니다.\n가벼움에 두면 실패 확률이 낮아요. (첫잔·파티)	전체 톤은 잼같은 느낌와 침샘이 자극되는의 균형. 타닌은 둥글둥글한, 단맛은 달짝지근한 쪽으로 읽힙니다. 특히 입맛을 돋구는 와인 상황에 잘 어울립니다.	프라이드 치킨, 카나페, 치즈	rep
ta118	Cantine Gemma Moscato d'Asti Vigna Fiorita	Cantine Gemma 모스카토 Piemonte 2013	Cantine Gemma	Italy	Piemonte	Moscato	WHITE	Appetizer, Dessert	5.6	4	2	2	1	46000	2013	750	5	\N	가성비 와인 Moscato 화이트. 알싸한 맛 느낌으로 마무리에 산뜻해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Cantine Gemma 모스카토 Piemonte 2013는 수퍼투스칸에서 온 돌려서 따는 마개 스타일입니다. 2013 빈티지 기준 5.6 도수, 750ml 구성.\n\n키워드로 보면 첫 인상은 톡톡 쏘는가 또렷하고, 텍스처는 부드러운 느낌의로 느껴집니다. 피니시는 목넘김이 좋은, 단맛은 향긋한 쪽으로 해석할 수 있어요. 그리고 해산물과 잘어울리는 쪽으로 즐기기 좋아요.\n추천 상황은 데일리·대화용 쪽이에요.	첫 인상은 톡톡 쏘는가 또렷하고, 텍스처는 부드러운 느낌의로 느껴집니다. 피니시는 목넘김이 좋은, 단맛은 향긋한 쪽으로 해석할 수 있어요. 그리고 해산물과 잘어울리는 쪽으로 즐기기 좋아요.	말린 과일 / 티라미수 / 치즈	rep
ta119	Louis Roederer, Cristal	Louis Roederer Pinot Noir Chardonnay Champagne 2012	Louis Roederer	France	Champagne	Pinot Noir Chardonnay	SPARKLING	Appetizer	11	1	4	4	1	750000	2012	750	5	\N	한정판으로 나온 스파클링 한 병. 포인트는 짜릿한 맛 청량감이에요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Louis Roederer Pinot Noir Chardonnay Champagne 2012는 호불호 없는 감성을 담은 뚱뚱한 병 와인입니다. 2012 빈티지, 11~12 도수, 750ml.\n\n침샘이 자극되는가 입맛을 깨우고, 점성이 강한는 담백하게 이어집니다. 부담없이 넘어가는은 거칠지 않고 순한 맛 느낌은 은근해요. 특히 호텔 웰컴주 와인 상황에 잘 어울립니다.\n첫잔·파티에 두고 천천히 즐기면 밸런스가 더 살아나요.	침샘이 자극되는가 입맛을 깨우고, 점성이 강한는 담백하게 이어집니다. 부담없이 넘어가는은 거칠지 않고 순한 맛 느낌은 은근해요. 특히 호텔 웰컴주 와인 상황에 잘 어울립니다.	치즈, 과일, 굴/해산물	rep
ta120	Laurent Benard, La Cle des Sept Arpents Extra Brut	Laurent Benard Pinot Meunier Pinot Noir Chardonnay Champagne 2014	Laurent Benard	France	Champagne	Pinot Meunier Pinot Noir Chardonnay	SPARKLING	Appetizer	8	1	5	2	1	180000	2014	750	5	\N	선물하기 좋은 와인 스파클링. 눈이 감길정도로 신 톤이라 식사전에 마시는 와인에 경쾌해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	무통로칠드의 축하하는 자리 와인 Laurent Benard Pinot Meunier Pinot Noir Chardonnay Champagne 2014 (2014). 도수 8~9, 750ml.\n\n전체 톤은 마시기 적당한와 산도가 강한 와인의 균형. 타닌은 둥글둥글한, 단맛은 밋밋한 와인 쪽으로 읽힙니다. 특히 입맛 상황에 잘 어울립니다.\n샐러드와 어울리는 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (첫잔·파티)	전체 톤은 마시기 적당한와 산도가 강한 와인의 균형. 타닌은 둥글둥글한, 단맛은 밋밋한 와인 쪽으로 읽힙니다. 특히 입맛 상황에 잘 어울립니다.	과일, 프라이드 치킨, 카나페	rep
ta121	Andriano, Moscato Giallo	Andriano 모스카토 2010	Andriano	Italy	\N	Moscato	WHITE	Appetizer, Dessert	12	4	1	3	1	34000	2010	750	5	\N	마무리에 어울리는 Moscato 화이트. 상큼한가 살아 있고 걸쭉한 맛는 담백해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Andriano 모스카토 2010는 안주없이 마실수 있는 카테고리에서 가성비 와인 선택지로 좋은 편입니다. 2010 빈티지, 12 도수, 750ml.\n\n향에서는 단맛이 강한 인상이 먼저 오고, 입안에서는 상쾌한 느낌가 균형을 잡습니다. 질감은 졸인듯한 느낌의, 여운은 둥글둥글한 쪽으로 정리돼요. 특히 마무리 상황에 잘 어울립니다.\n데일리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	향에서는 단맛이 강한 인상이 먼저 오고, 입안에서는 상쾌한 느낌가 균형을 잡습니다. 질감은 졸인듯한 느낌의, 여운은 둥글둥글한 쪽으로 정리돼요. 특히 마무리 상황에 잘 어울립니다.	과일 타르트 / 치즈	rep
ta122	Henri Giraud, Argonne Brut	Champagne Henri Giraud Pinot Noir Chardonnay Champagne 2012	Champagne Henri Giraud	France	Champagne	Pinot Noir Chardonnay	SPARKLING	Appetizer	5	1	5	3	1	1284000	2012	750	5	\N	톡 쏘는 매력의 아무나 쉽게 못마시는 스파클링. 레몬같은/졸인듯한 느낌의가 산뜻한 쪽.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Champagne Henri Giraud Pinot Noir Chardonnay Champagne 2012는 호불호 없는 감성을 담은 펑 하고 터지는입니다. 2012 빈티지, 5~6 도수, 750ml.\n\n향에서는 음료수같은 와인 인상이 먼저 오고, 입안에서는 눈이 감길정도로 신가 균형을 잡습니다. 질감은 농익은, 여운은 둥글둥글한 쪽으로 정리돼요. 특히 거품이 있는 상황에 잘 어울립니다.\n첫잔·파티에 두고 천천히 즐기면 밸런스가 더 살아나요.	향에서는 음료수같은 와인 인상이 먼저 오고, 입안에서는 눈이 감길정도로 신가 균형을 잡습니다. 질감은 농익은, 여운은 둥글둥글한 쪽으로 정리돼요. 특히 거품이 있는 상황에 잘 어울립니다.	치즈, 튀김, 굴/해산물	rep
ta123	Fleury Cepages Blanc Extra Brut	Fleury 샤르도네 Champagne 1992	Fleury	France	Champagne	Chardonnay	SPARKLING	Appetizer	7	1	5	3	1	320000	1992	750	5	\N	톡 쏘는 매력의 고마운 분에게 선물하기 좋은 스파클링. 레몬같은/걸쭉한 맛가 산뜻한 쪽.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Fleury 샤르도네 Champagne 1992는 펑 하고 터지는 카테고리에서 고마운 분에게 선물하기 좋은 선택지로 좋은 편입니다. 1992 빈티지, 7~8 도수, 750ml.\n\n전체 톤은 졸인듯한 느낌의와 매실청같은 느낌의 균형. 타닌은 둥글둥글한, 단맛은 순한 맛 쪽으로 읽힙니다. 특히 식전 상황에 잘 어울립니다.\n첫잔·파티에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	전체 톤은 졸인듯한 느낌의와 매실청같은 느낌의 균형. 타닌은 둥글둥글한, 단맛은 순한 맛 쪽으로 읽힙니다. 특히 식전 상황에 잘 어울립니다.	과일, 프라이드 치킨, 카나페	rep
ta124	Arione, Mama mango	Arione Blend 2020	Arione	Italy	\N	Blend	SPARKLING	Appetizer, Dessert	6	3	3	1	1	40000	2020	750	5	\N	톡 쏘는 매력의 가성비 와인 스파클링. 새콤한 맛/담백한 맛가 산뜻한 쪽.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Arione Blend 2020는 수퍼투스칸에서 온 거품이 있는 스타일입니다. 2020 빈티지 기준 6 도수, 750ml 구성.\n\n키워드로 보면 전체 톤은 후레쉬한 느낌와 산미가 조금 있는의 균형. 타닌은 약간 비린맛의, 단맛은 달큰한 쪽으로 읽힙니다. — 철사로 감겨져있는 무드로 이해하면 좋아요.\n추천 상황은 데일리·대화용 쪽이에요.	전체 톤은 후레쉬한 느낌와 산미가 조금 있는의 균형. 타닌은 약간 비린맛의, 단맛은 달큰한 쪽으로 읽힙니다. — 철사로 감겨져있는 무드로 이해하면 좋아요.	티라미수 / 블루치즈 / 치즈	rep
ta125	Finest Steillage Mosel Riesling	Tesco Finest 리슬링 MoselSaarRuwer 2011	Tesco Finest	Germany	MoselSaarRuwer	Riesling	WHITE	Appetizer, Dessert	11	3	5	1	1	29000	2011	750	5	\N	휘발유 향 스타일 리슬링 화이트 — 눈이 감길정도로 신가 또렷하고 담백한 맛가 깔끔해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Tesco Finest 리슬링 MoselSaarRuwer 2011는 떫지 않은 카테고리에서 캠핑 와인으로 좋은 선택지로 좋은 편입니다. 2011 빈티지, 11 도수, 750ml.\n\n첫 인상은 레몬같은가 또렷하고, 텍스처는 담백한 맛로 느껴집니다. 피니시는 목넘김이 좋은, 단맛은 잔당감 있는 쪽으로 해석할 수 있어요. 그리고 마무리 쪽으로 즐기기 좋아요.\n데일리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	첫 인상은 레몬같은가 또렷하고, 텍스처는 담백한 맛로 느껴집니다. 피니시는 목넘김이 좋은, 단맛은 잔당감 있는 쪽으로 해석할 수 있어요. 그리고 마무리 쪽으로 즐기기 좋아요.	말린 과일 / 다크 초콜릿 / 치즈	rep
ta126	Marquis de Bataille Blanc	Maison Bouey Semillon Colombard Ugni blanc 2015	Maison Bouey	France	\N	Semillon Colombard Ugni blanc	WHITE	Appetizer	11	2	3	2	1	35000	2015	750	5	\N	샐러드와 어울리는에 어울리는 Semillon Colombard Ugni blanc 화이트. 시큼한가 살아 있고 부드러운 느낌의는 담백해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	5대샤또의 떫지 않은 와인 Maison Bouey Semillon Colombard Ugni blanc 2015 (2015). 도수 11~12, 750ml.\n\n전체 톤은 부드러운 느낌의와 시큼한의 균형. 타닌은 둥글둥글한, 단맛은 달짝지근한 쪽으로 읽힙니다. — 돌려서 따는 마개 무드로 이해하면 좋아요.\n식사전에 마시는 와인 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (첫잔·안주없이)	전체 톤은 부드러운 느낌의와 시큼한의 균형. 타닌은 둥글둥글한, 단맛은 달짝지근한 쪽으로 읽힙니다. — 돌려서 따는 마개 무드로 이해하면 좋아요.	흰살 생선구이, 오일 파스타, 치즈 플래터	rep
ta127	Sumarroca, Brut Nature Gran Reserva	Sumarroca Parellada Macabeo Chardonnay Penedes 2000	Sumarroca	Spain	Penedes	Parellada Macabeo Chardonnay	SPARKLING	Appetizer	15	1	3	3	1	39000	2000	750	5	\N	분위기 올리는 먹을만한 와인 스파클링 — 입안이 개운한가 깔끔하게 받쳐줘요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	템프라니요 생산자의 펑 하고 터지는 와인 Sumarroca Parellada Macabeo Chardonnay Penedes 2000. 2000 빈티지, 도수 15~16, 750ml.\n\n입안에서는 막걸리같은/입에 침이 고이는 정도가 중심을 잡고, 마무리는 부담없이 넘어가는이 정돈합니다.\n입맛에 두면 실패 확률이 낮아요. (첫잔·파티)	향에서는 향기가 좋은 인상이 먼저 오고, 입안에서는 새콤한 맛가 균형을 잡습니다. 질감은 농익은, 여운은 둥글둥글한 쪽으로 정리돼요. 특히 철사로 감겨져있는 상황에 잘 어울립니다.	굴/해산물, 프라이드 치킨	rep
ta128	Champagne Lallier, R.010 Brut	Lallier Chardonnay Pinot Noir Champagne 2010	Lallier	France	Champagne	Chardonnay Pinot Noir	SPARKLING	Appetizer	8	1	5	3	1	220000	2010	750	5	\N	분위기 올리는 실속형 스파클링 — 식초같은 신맛이 나는가 깔끔하게 받쳐줘요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Lallier Chardonnay Pinot Noir Champagne 2010는 호불호 없는에서 온 뚱뚱한 병 와인 스타일입니다. 2010 빈티지 기준 8~9 도수, 750ml 구성.\n\n키워드로 보면 전체 톤은 걸쭉한 맛와 눈이 감길정도로 신의 균형. 타닌은 부담없이 넘어가는, 단맛은 음료수같은 와인 쪽으로 읽힙니다. — 철사로 감겨져있는 무드로 이해하면 좋아요.\n추천 상황은 첫잔·파티 쪽이에요.	전체 톤은 걸쭉한 맛와 눈이 감길정도로 신의 균형. 타닌은 부담없이 넘어가는, 단맛은 음료수같은 와인 쪽으로 읽힙니다. — 철사로 감겨져있는 무드로 이해하면 좋아요.	치즈, 카나페, 프라이드 치킨	rep
ta129	McGuigan, Black Label Moscato	Mcguigan 모스카토 South Eastern Australia 2018	Mcguigan	Australia	South Eastern Australia	Moscato	WHITE	Appetizer, Dessert	8	4	3	2	1	44000	2018	750	5	\N	가볍게 시작하기 좋은 먹을만한 와인 화이트. 새콤한 맛가 상쾌한 쪽이에요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	옐로우테일의 돌려서 따는 마개 와인 Mcguigan 모스카토 South Eastern Australia 2018 (2018). 도수 8~9, 750ml.\n\n전체 톤은 부드러운 느낌의와 시큼한의 균형. 타닌은 목넘김이 좋은, 단맛은 향긋한 쪽으로 읽힙니다. — 풍미 무드로 이해하면 좋아요.\n식후에 마시는 와인 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (데일리·대화용)	전체 톤은 부드러운 느낌의와 시큼한의 균형. 타닌은 목넘김이 좋은, 단맛은 향긋한 쪽으로 읽힙니다. — 풍미 무드로 이해하면 좋아요.	과일 타르트 / 블루치즈 / 치즈	rep
ta130	Domaine des Trottieres, Rose d'Anjou	Domaine des Trottieres Grolleau Gris Gamay Pineau d'Aunis Loire 2007	Domaine des Trottieres	France	Loire	Grolleau Gris Gamay Pineau d'Aunis	ROSE	Appetizer, Dessert	11	1	3	3	1	42000	2007	750	5	\N	기분 전환용 캠핑 와인으로 좋은 로제. 시큼한가 또렷한 편.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Domaine des Trottieres Grolleau Gris Gamay Pineau d'Aunis Loire 2007는 호불호 없는 감성을 담은 보기에 이쁜입니다. 2007 빈티지, 11 도수, 750ml.\n\n첫 인상은 입에 침이 고이는 정도가 또렷하고, 텍스처는 잼같은 느낌로 느껴집니다. 피니시는 부담없이 넘어가는, 단맛은 음료수같은 와인 쪽으로 해석할 수 있어요. — 작은잔에 마시는 와인 무드로 이해하면 좋아요.\n데일리·대화용에 두고 천천히 즐기면 밸런스가 더 살아나요.	첫 인상은 입에 침이 고이는 정도가 또렷하고, 텍스처는 잼같은 느낌로 느껴집니다. 피니시는 부담없이 넘어가는, 단맛은 음료수같은 와인 쪽으로 해석할 수 있어요. — 작은잔에 마시는 와인 무드로 이해하면 좋아요.	말린 과일 / 견과류 / 치즈	rep
ta131	Bollinger, Grand Annee	Bollinger Pinot Noir Chardonnay Champagne 2007	Bollinger	France	Champagne	Pinot Noir Chardonnay	SPARKLING	Appetizer	12	1	3	3	1	267000	2007	750	5	\N	톡 쏘는 매력의 실속형 스파클링. 입에 침이 고이는 정도/막걸리같은가 산뜻한 쪽.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Bollinger Pinot Noir Chardonnay Champagne 2007는 거품이 있는 카테고리에서 실속형 선택지로 좋은 편입니다. 2007 빈티지, 12~13 도수, 750ml.\n\n첫 인상은 새콤한 맛가 또렷하고, 텍스처는 잼같은 느낌로 느껴집니다. 피니시는 약간 비린맛의, 단맛은 향기가 좋은 쪽으로 해석할 수 있어요. 그리고 첫잔 쪽으로 즐기기 좋아요.\n첫잔·파티에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	첫 인상은 새콤한 맛가 또렷하고, 텍스처는 잼같은 느낌로 느껴집니다. 피니시는 약간 비린맛의, 단맛은 향기가 좋은 쪽으로 해석할 수 있어요. 그리고 첫잔 쪽으로 즐기기 좋아요.	카나페, 튀김, 굴/해산물	rep
ta132	Schramsberg, Brut Rose	Schramsberg Pinot Noir Chardonnay California 2016	Schramsberg	USA	California	Pinot Noir Chardonnay	SPARKLING	Appetizer	9	1	3	3	1	115000	2016	750	5	\N	와인 모임에 들고가기 좋은 스파클링. 산미가 조금 있는 톤이라 상쾌함에 경쾌해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Schramsberg Pinot Noir Chardonnay California 2016는 와인 입문자에게 적합한 감성을 담은 뚱뚱한 병 와인입니다. 2016 빈티지, 9~10 도수, 750ml.\n\n향에서는 음료수같은 와인 인상이 먼저 오고, 입안에서는 입안이 개운한가 균형을 잡습니다. 질감은 잼같은 느낌, 여운은 목넘김이 좋은 쪽으로 정리돼요. 그리고 축하하는 자리 쪽으로 즐기기 좋아요.\n첫잔·파티에 두고 천천히 즐기면 밸런스가 더 살아나요.	향에서는 음료수같은 와인 인상이 먼저 오고, 입안에서는 입안이 개운한가 균형을 잡습니다. 질감은 잼같은 느낌, 여운은 목넘김이 좋은 쪽으로 정리돼요. 그리고 축하하는 자리 쪽으로 즐기기 좋아요.	치즈, 과일, 카나페	rep
ta133	Henri Abele, Sourire de Reims Brut	Henri Abele Chardonnay Pinot Noir Champagne Cote des Blancs 2009	Henri Abele	France	Champagne Cote des Blancs	Chardonnay Pinot Noir	SPARKLING	Appetizer	11	1	4	4	1	380000	2009	750	5	\N	톡 쏘는 매력의 품질이 뛰어난 와인 스파클링. 짜릿한 맛/포도 원액 느낌가 산뜻한 쪽.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	호불호 없는의 철사로 감겨져있는 와인 Henri Abele Chardonnay Pinot Noir Champagne Cote des Blancs 2009 (2009). 도수 11~12, 750ml.\n\n향에서는 향기가 좋은 인상이 먼저 오고, 입안에서는 탄산음료같은가 균형을 잡습니다. 질감은 점성이 강한, 여운은 리치한 느낌 쪽으로 정리돼요. 그리고 입맛을 돋구는 와인 쪽으로 즐기기 좋아요.\n상쾌함 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (첫잔·파티)	향에서는 향기가 좋은 인상이 먼저 오고, 입안에서는 탄산음료같은가 균형을 잡습니다. 질감은 점성이 강한, 여운은 리치한 느낌 쪽으로 정리돼요. 그리고 입맛을 돋구는 와인 쪽으로 즐기기 좋아요.	치즈, 튀김	rep
ta134	Georges Laval Les Chenes	Georges Laval 샤르도네 Champagne 2014	Georges Laval	France	Champagne	Chardonnay	SPARKLING	Appetizer	7	1	5	4	1	512000	2014	750	5	\N	분위기 올리는 한정판으로 나온 스파클링 — 식초같은 신맛이 나는가 깔끔하게 받쳐줘요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Georges Laval 샤르도네 Champagne 2014는 펑 하고 터지는 카테고리에서 평생 한번 먹을까말까 한 선택지로 좋은 편입니다. 2014 빈티지, 7~8 도수, 750ml.\n\n점성이 강한 텍스처 위에 눈이 감길정도로 신가 살아 있고, 마무리는 부담없이 넘어가는이 정돈합니다. 음료수같은 와인 뉘앙스는 과하지 않아요. — 입맛을 돋구는 와인 무드로 이해하면 좋아요.\n첫잔·파티에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	점성이 강한 텍스처 위에 눈이 감길정도로 신가 살아 있고, 마무리는 부담없이 넘어가는이 정돈합니다. 음료수같은 와인 뉘앙스는 과하지 않아요. — 입맛을 돋구는 와인 무드로 이해하면 좋아요.	치즈, 카나페	rep
ta135	Fleury Brut	Fleury Pinot Noir Chardonnay Champagne 1990	Fleury	France	Champagne	Pinot Noir Chardonnay	SPARKLING	Appetizer	6	1	5	3	1	470000	1990	750	5	\N	장기 숙성하기 좋은 스파클링 한 병. 포인트는 식초같은 신맛이 나는 청량감이에요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Fleury Pinot Noir Chardonnay Champagne 1990는 무통로칠드 감성을 담은 펑 하고 터지는입니다. 1990 빈티지, 6~7 도수, 750ml.\n\n첫 인상은 매실청같은 느낌가 또렷하고, 텍스처는 농익은로 느껴집니다. 피니시는 둥글둥글한, 단맛은 단맛이 조금 나는 쪽으로 해석할 수 있어요. — 거품이 있는 무드로 이해하면 좋아요.\n첫잔·파티에 두고 천천히 즐기면 밸런스가 더 살아나요.	첫 인상은 매실청같은 느낌가 또렷하고, 텍스처는 농익은로 느껴집니다. 피니시는 둥글둥글한, 단맛은 단맛이 조금 나는 쪽으로 해석할 수 있어요. — 거품이 있는 무드로 이해하면 좋아요.	굴/해산물, 프라이드 치킨	rep
ta136	Philipponnat, Reserve Millesimee Brut	Philipponnat Pinot Noir Chardonnay Champagne 2002	Philipponnat	France	Champagne	Pinot Noir Chardonnay	SPARKLING	Appetizer	9	1	5	4	1	265000	2002	750	5	\N	톡 쏘는 매력의 실속형 스파클링. 매실청같은 느낌/점성이 강한가 산뜻한 쪽.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Philipponnat Pinot Noir Chardonnay Champagne 2002는 보르도 감성을 담은 철사로 감겨져있는입니다. 2002 빈티지, 9~10 도수, 750ml.\n\n향에서는 음료수같은 와인 인상이 먼저 오고, 입안에서는 레몬같은가 균형을 잡습니다. 질감은 포도 원액 느낌, 여운은 리치한 느낌 쪽으로 정리돼요. 특히 뚱뚱한 병 와인 상황에 잘 어울립니다.\n첫잔·파티에 두고 천천히 즐기면 밸런스가 더 살아나요.	향에서는 음료수같은 와인 인상이 먼저 오고, 입안에서는 레몬같은가 균형을 잡습니다. 질감은 포도 원액 느낌, 여운은 리치한 느낌 쪽으로 정리돼요. 특히 뚱뚱한 병 와인 상황에 잘 어울립니다.	카나페, 프라이드 치킨, 과일	rep
ta137	Clemens Busch Marienburg Trockenbeerenauslese	Clemens Busch 리슬링 MoselSaarRuwer Bereich Bernkastel 2018	Clemens Busch	Germany	MoselSaarRuwer Bereich Bernkastel	Riesling	WHITE	Dessert	14	5	3	5	1	871000	2018	375	5	\N	바인구트로베르트바일 스타일 리슬링 화이트 — 입에 침이 고이는 정도가 또렷하고 진득한 느낌의가 깔끔해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Clemens Busch 리슬링 MoselSaarRuwer Bereich Bernkastel 2018는 해산물과 잘어울리는 카테고리에서 그랑크뤼 와인 선택지로 좋은 편입니다. 2018 빈티지, 14~15 도수, 375ml.\n\n전체 톤은 위스키 느낌의와 입안이 개운한의 균형. 타닌은 부담없이 넘어가는, 단맛은 시럽같은 맛 쪽으로 읽힙니다. 특히 작은잔에 마시는 와인 상황에 잘 어울립니다.\n마무리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	전체 톤은 위스키 느낌의와 입안이 개운한의 균형. 타닌은 부담없이 넘어가는, 단맛은 시럽같은 맛 쪽으로 읽힙니다. 특히 작은잔에 마시는 와인 상황에 잘 어울립니다.	다크 초콜릿 / 티라미수 / 치즈	rep
ta138	Marcel Deiss, Riesling Vendanges Tardives	Domaine Marcel Deiss 리슬링 Alsace 2015	Domaine Marcel Deiss	France	Alsace	Riesling	WHITE	Dessert	12.5	4	4	4	1	120000	2015	750	5	\N	가볍게 시작하기 좋은 와인 모임에 들고가기 좋은 화이트. 침샘이 자극되는가 상쾌한 쪽이에요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	보르도 생산자의 돌려서 따는 마개 와인 Domaine Marcel Deiss 리슬링 Alsace 2015. 2015 빈티지, 도수 12.5~13.5, 750ml.\n\n입안에서는 무게감이 느껴지는/맛이 신가 중심을 잡고, 마무리는 목넘김이 좋은이 정돈합니다.\n달달한 와인에 두면 실패 확률이 낮아요. (마무리·대화용)	첫 인상은 탄산음료같은가 또렷하고, 텍스처는 포도 원액 느낌로 느껴집니다. 피니시는 리치한 느낌, 단맛은 과일주스같은 느낌의 쪽으로 해석할 수 있어요. — 돌려서 따는 마개 무드로 이해하면 좋아요.	티라미수 / 견과류 / 치즈	rep
ta139	Clemens Busch Marienburg Spatlese	Clemens Busch 리슬링 MoselSaarRuwer Bereich Bernkastel 2019	Clemens Busch	Germany	MoselSaarRuwer Bereich Bernkastel	Riesling	WHITE	Dessert	14	3	4	5	1	156000	2019	750	5	\N	와인 모임에 들고가기 좋은 리슬링 화이트. 맛이 신 느낌으로 단맛에 산뜻해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Clemens Busch 리슬링 MoselSaarRuwer Bereich Bernkastel 2019는 휘발유 향에서 온 떫지 않은 스타일입니다. 2019 빈티지 기준 14~15 도수, 750ml 구성.\n\n키워드로 보면 꿀같은 와인 텍스처 위에 짜릿한 맛가 살아 있고, 마무리는 리치한 느낌이 정돈합니다. 달달한 뉘앙스는 과하지 않아요. — 돌려서 따는 마개 무드로 이해하면 좋아요.\n추천 상황은 마무리·대화용 쪽이에요.	꿀같은 와인 텍스처 위에 짜릿한 맛가 살아 있고, 마무리는 리치한 느낌이 정돈합니다. 달달한 뉘앙스는 과하지 않아요. — 돌려서 따는 마개 무드로 이해하면 좋아요.	블루치즈 / 티라미수 / 치즈	rep
ta140	Oremus Tokaji Eszencia	Tokaj Oremus Furmint The Northeast 2005	Tokaj Oremus	Hungary	The Northeast	Furmint	WHITE	Dessert	14	5	3	5	1	450000	2005	375	5	\N	토카이 와인 스타일 Furmint 화이트 — 입안이 개운한가 또렷하고 끈기가 아주 많은가 깔끔해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	디저트 와인 생산자의 돌려서 따는 마개 와인 Tokaj Oremus Furmint The Northeast 2005. 2005 빈티지, 도수 14~15, 375ml.\n\n입안에서는 진득한 느낌의/입에 침이 고이는 정도가 중심을 잡고, 마무리는 약간 비린맛의이 정돈합니다.\n풍미에 두면 실패 확률이 낮아요. (마무리·대화용)	향에서는 시럽같은 맛 인상이 먼저 오고, 입안에서는 입안이 개운한가 균형을 잡습니다. 질감은 꿀같은 와인, 여운은 둥글둥글한 쪽으로 정리돼요. 특히 식후에 마시는 와인 상황에 잘 어울립니다.	말린 과일 / 블루치즈 / 치즈	rep
ta141	Oddity Dry	Royal Tokaji Mavrud The Northeast TokajHegyalja 2014	Royal Tokaji	Hungary	The Northeast TokajHegyalja	Mavrud	WHITE	Dessert	14	1	3	3	1	36000	2014	750	5	\N	가성비 와인 데일리 화이트. 시큼한/농익은 균형이 안정적이에요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	토카이 와인의 돌려서 따는 마개 와인 Royal Tokaji Mavrud The Northeast TokajHegyalja 2014 (2014). 도수 14~15, 750ml.\n\n전체 톤은 농익은와 입안이 개운한의 균형. 타닌은 약간 비린맛의, 단맛은 순한 맛 쪽으로 읽힙니다. 그리고 작은잔에 마시는 와인 쪽으로 즐기기 좋아요.\n여운 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (마무리·대화용)	전체 톤은 농익은와 입안이 개운한의 균형. 타닌은 약간 비린맛의, 단맛은 순한 맛 쪽으로 읽힙니다. 그리고 작은잔에 마시는 와인 쪽으로 즐기기 좋아요.	견과류 / 티라미수 / 치즈	rep
ta142	Alexander, Alambicco Prosecco	Alexander 모스카토 Veneto 2002	Alexander	Italy	Veneto	Moscato	HARD	Dessert	38	1	1	5	1	145000	2002	500	5	\N	여운 자리에서 빛나는 Moscato 레드. 목넘김이 좋은은 정돈되고 눅진한는 또렷해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Alexander 모스카토 Veneto 2002는 토스카나에서 온 젊은층이 좋아하는 스타일입니다. 2002 빈티지 기준 38 도수, 500ml 구성.\n\n키워드로 보면 깔끔한 스타일가 입맛을 깨우고, 위스키 느낌의는 담백하게 이어집니다. 리치한 느낌은 거칠지 않고 단맛이 조금 나는 느낌은 은근해요. — 타닌이 많은 무드로 이해하면 좋아요.\n추천 상황은 마무리·대화용 쪽이에요.	깔끔한 스타일가 입맛을 깨우고, 위스키 느낌의는 담백하게 이어집니다. 리치한 느낌은 거칠지 않고 단맛이 조금 나는 느낌은 은근해요. — 타닌이 많은 무드로 이해하면 좋아요.	과일 타르트 / 다크 초콜릿 / 치즈	rep
ta143	Chateau Le Rayssac	Chateau Le Rayssac Semillon Sauvignon-blanc Bordeaux 2017	Chateau Le Rayssac	France	Bordeaux	Semillon Sauvignon-blanc	WHITE	Dessert	14	4	2	3	1	50000	2017	750	5	\N	답례용품으로 좋은 데일리 화이트. 톡톡 쏘는/잼같은 느낌 균형이 안정적이에요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	구대륙 생산자의 돌려서 따는 마개 와인 Chateau Le Rayssac Semillon Sauvignon-blanc Bordeaux 2017. 2017 빈티지, 도수 14~15, 750ml.\n\n입안에서는 잼같은 느낌/미끌미끌한 느낌가 중심을 잡고, 마무리는 리치한 느낌이 정돈합니다.\n작은잔에 마시는 와인에 두면 실패 확률이 낮아요. (마무리·대화용)	알싸한 맛가 입맛을 깨우고, 농익은는 담백하게 이어집니다. 약간 비린맛의은 거칠지 않고 과실향이 나는 느낌은 은근해요. — 식후에 마시는 와인 무드로 이해하면 좋아요.	티라미수 / 다크 초콜릿 / 치즈	rep
ta144	Ibaci, Vidal Icewine	Pillitteri Estate Vidal Bear River Ontario 2005	Pillitteri Estate	Canada	Bear River Ontario	Vidal	WHITE	Dessert	10	5	3	3	1	84000	2005	375	5	\N	필리터리 스타일 Vidal 화이트 — 산미가 조금 있는가 또렷하고 걸쭉한 맛가 깔끔해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	아주 달은의 돌려서 따는 마개 와인 Pillitteri Estate Vidal Bear River Ontario 2005 (2005). 도수 10, 375ml.\n\n향에서는 달콤한 향이 나는 인상이 먼저 오고, 입안에서는 입안이 개운한가 균형을 잡습니다. 질감은 막걸리같은, 여운은 부담없이 넘어가는 쪽으로 정리돼요. 특히 해산물과 잘어울리는 상황에 잘 어울립니다.\n소화를 돕는 와인 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (마무리·대화용)	향에서는 달콤한 향이 나는 인상이 먼저 오고, 입안에서는 입안이 개운한가 균형을 잡습니다. 질감은 막걸리같은, 여운은 부담없이 넘어가는 쪽으로 정리돼요. 특히 해산물과 잘어울리는 상황에 잘 어울립니다.	견과류 / 치즈	rep
ta145	Villa Pillo, Vin Santo del Chianti	Villa Pillo 산지오베제 Toscana Chianti 2011	Villa Pillo	Italy	Toscana Chianti	Sangiovese	WHITE	Dessert	16	5	3	5	1	166000	2011	375	5	\N	선물하기 좋은 와인 Sangiovese 화이트. 입에 침이 고이는 정도 느낌으로 소화를 돕는 와인에 산뜻해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Villa Pillo 산지오베제 Toscana Chianti 2011는 돌려서 따는 마개 카테고리에서 결혼 선물로 적당한 선택지로 좋은 편입니다. 2011 빈티지, 16~17 도수, 375ml.\n\n첫 인상은 시큼한가 또렷하고, 텍스처는 눅진한로 느껴집니다. 피니시는 약간 비린맛의, 단맛은 시럽같은 맛 쪽으로 해석할 수 있어요. 그리고 청포도로 만든 쪽으로 즐기기 좋아요.\n마무리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	첫 인상은 시큼한가 또렷하고, 텍스처는 눅진한로 느껴집니다. 피니시는 약간 비린맛의, 단맛은 시럽같은 맛 쪽으로 해석할 수 있어요. 그리고 청포도로 만든 쪽으로 즐기기 좋아요.	티라미수 / 다크 초콜릿 / 치즈	rep
ta146	Icardi, Suri Vigin Brachetto	Icardi Brachetto Piemonte 2014	Icardi	Italy	Piemonte	Brachetto	RED	Dessert	6	4	1	3	2	60000	2014	750	5	\N	선물용 와인 무드의 Brachetto 레드 — 홍차를 마시는것같은 결이 살아 있고 막걸리같은가 탄탄해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Icardi Brachetto Piemonte 2014는 토스카나에서 온 무난한 선물용 스타일입니다. 2014 빈티지 기준 6~7 도수, 750ml 구성.\n\n키워드로 보면 첫 인상은 상쾌한 느낌가 또렷하고, 텍스처는 막걸리같은로 느껴집니다. 피니시는 혀가 아리는 느낌, 단맛은 과일주스같은 느낌의 쪽으로 해석할 수 있어요. 그리고 고기랑 어울리는 쪽으로 즐기기 좋아요.\n추천 상황은 마무리·대화용 쪽이에요.	첫 인상은 상쾌한 느낌가 또렷하고, 텍스처는 막걸리같은로 느껴집니다. 피니시는 혀가 아리는 느낌, 단맛은 과일주스같은 느낌의 쪽으로 해석할 수 있어요. 그리고 고기랑 어울리는 쪽으로 즐기기 좋아요.	과일 타르트 / 말린 과일 / 치즈	rep
ta173	Dom Brial, Rouge	Dom Brial mourvedre Syrah Southern France Languedoc Roussillon 2004	Dom Brial	France	Southern France Languedoc Roussillon	mourvedre Syrah&Shiraz Grenache Noir	RED	Table	13.5	1	4	3	3	12000	2004	375	5	\N	오늘은 시중 와인 레드. 농익은 중심으로 가고 떫떠름한 느낌은 과하지 않아요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	5대샤또의 작업주 와인 Dom Brial mourvedre Syrah Southern France Languedoc Roussillon 2004 (2004). 도수 13.5, 375ml.\n\n전체 톤은 농익은와 침샘이 자극되는의 균형. 타닌은 떫떠름한 느낌, 단맛은 향기가 좋은 쪽으로 읽힙니다. — 작업주 무드로 이해하면 좋아요.\n메인음식과 함께 먹는 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (데일리·대화용)	전체 톤은 농익은와 침샘이 자극되는의 균형. 타닌은 떫떠름한 느낌, 단맛은 향기가 좋은 쪽으로 읽힙니다. — 작업주 무드로 이해하면 좋아요.	햄·살라미(트러플), 숙성 치즈, 미트소스/라구	edge
ta147	Vina El Aromo, Infinito Cabernet-Sauvignon	Vina Aromo Cabernet-Sauvignon Maule Valley 2017	Vina Aromo	Chile	Maule Valley	Cabernet-Sauvignon	RED	Dessert	12	2	2	3	3	27500	2017	750	5	\N	까르미네르 무드의 카베르네 소비뇽 레드 — 입안이 까끌까끌한 결이 살아 있고 졸인듯한 느낌의가 탄탄해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Vina Aromo Cabernet-Sauvignon Maule Valley 2017는 탄닌이 있는 카테고리에서 캠핑 와인으로 좋은 선택지로 좋은 편입니다. 2017 빈티지, 12~13 도수, 750ml.\n\n첫 인상은 미끌미끌한 느낌가 또렷하고, 텍스처는 막걸리같은로 느껴집니다. 피니시는 떫떠름한 느낌, 단맛은 좋은 냄새가 나는 쪽으로 해석할 수 있어요. 특히 작업주 상황에 잘 어울립니다.\n마무리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	첫 인상은 미끌미끌한 느낌가 또렷하고, 텍스처는 막걸리같은로 느껴집니다. 피니시는 떫떠름한 느낌, 단맛은 좋은 냄새가 나는 쪽으로 해석할 수 있어요. 특히 작업주 상황에 잘 어울립니다.	티라미수 / 과일 타르트 / 치즈	rep
ta148	Navarro Correas, Alegoria Late Harvest	Bodega Navarro Correas Semillon Sauvignon-blanc Mendoza 2006	Bodega Navarro Correas	Argentina	Mendoza	Semillon Sauvignon-blanc	WHITE	Dessert	10	5	1	2	1	80000	2006	500	5	\N	답례용품으로 좋은 데일리 화이트. 상쾌한 느낌/묵직한 느낌의 균형이 안정적이에요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	말벡 생산자의 떫지 않은 와인 Bodega Navarro Correas Semillon Sauvignon-blanc Mendoza 2006. 2006 빈티지, 도수 10, 500ml.\n\n입안에서는 라이트한/상쾌한 느낌가 중심을 잡고, 마무리는 리치한 느낌이 정돈합니다.\n작은잔에 마시는 와인에 두면 실패 확률이 낮아요. (마무리·대화용)	향에서는 점성을 띠고있는 인상이 먼저 오고, 입안에서는 환타 맛이 나는가 균형을 잡습니다. 질감은 묵직한 느낌의, 여운은 부담없이 넘어가는 쪽으로 정리돼요. 특히 떫지 않은 상황에 잘 어울립니다.	티라미수 / 과일 타르트 / 치즈	rep
ta149	Weltachs Trockenbeerenauslese	Weltachs Ortega Albalonga Huxelrebe Pfalz 2015	Weltachs	Germany	Pfalz	Ortega Albalonga Huxelrebe	WHITE	Dessert	14	5	3	5	1	60000	2015	375	5	\N	산미가 강한 스타일 Ortega Albalonga Huxelrebe 화이트 — 시큼한가 또렷하고 끈기가 아주 많은가 깔끔해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	청량한 느낌의 청포도로 만든 와인 Weltachs Ortega Albalonga Huxelrebe Pfalz 2015 (2015). 도수 14~15, 375ml.\n\n첫 인상은 입안이 개운한가 또렷하고, 텍스처는 끈기가 아주 많은로 느껴집니다. 피니시는 약간 비린맛의, 단맛은 꿀같은 쪽으로 해석할 수 있어요. 그리고 달달한 와인 쪽으로 즐기기 좋아요.\n풍미 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (마무리·대화용)	첫 인상은 입안이 개운한가 또렷하고, 텍스처는 끈기가 아주 많은로 느껴집니다. 피니시는 약간 비린맛의, 단맛은 꿀같은 쪽으로 해석할 수 있어요. 그리고 달달한 와인 쪽으로 즐기기 좋아요.	다크 초콜릿 / 치즈	rep
ta150	Seasons Vidal Icewine	Diamond Estates Vidal Bear River Ontario 2011	Diamond Estates	Canada	Bear River Ontario	Vidal	WHITE	Dessert	14	5	4	4	1	28800	2011	375	5	\N	먹을만한 와인 Vidal 화이트. 맛이 신 느낌으로 달달한 와인에 산뜻해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Diamond Estates Vidal Bear River Ontario 2011는 아이스와인 감성을 담은 떫지 않은입니다. 2011 빈티지, 14~15 도수, 375ml.\n\n전체 톤은 점성이 강한와 입안이 얼얼한의 균형. 타닌은 목넘김이 좋은, 단맛은 달콤한 향이 나는 쪽으로 읽힙니다. — 떫지 않은 무드로 이해하면 좋아요.\n마무리·대화용에 두고 천천히 즐기면 밸런스가 더 살아나요.	전체 톤은 점성이 강한와 입안이 얼얼한의 균형. 타닌은 목넘김이 좋은, 단맛은 달콤한 향이 나는 쪽으로 읽힙니다. — 떫지 않은 무드로 이해하면 좋아요.	과일 타르트 / 블루치즈 / 치즈	rep
ta151	Jackson Triggs Riesling Ice Wine	Jackson Triggs 리슬링 Bear River Niagara Peninsula 2004	Jackson Triggs	Canada	Bear River Niagara Peninsula	Riesling	WHITE	Dessert	10.2	5	4	4	1	203000	2004	375	5	\N	가볍게 시작하기 좋은 실속형 화이트. 입안이 얼얼한가 상쾌한 쪽이에요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Jackson Triggs 리슬링 Bear River Niagara Peninsula 2004는 해산물과 잘어울리는 카테고리에서 실속형 선택지로 좋은 편입니다. 2004 빈티지, 10.2 도수, 375ml.\n\n향에서는 꿀같은 인상이 먼저 오고, 입안에서는 탄산음료같은가 균형을 잡습니다. 질감은 무게감이 느껴지는, 여운은 둥글둥글한 쪽으로 정리돼요. 특히 풍미 상황에 잘 어울립니다.\n마무리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	향에서는 꿀같은 인상이 먼저 오고, 입안에서는 탄산음료같은가 균형을 잡습니다. 질감은 무게감이 느껴지는, 여운은 둥글둥글한 쪽으로 정리돼요. 특히 풍미 상황에 잘 어울립니다.	다크 초콜릿 / 견과류 / 치즈	rep
ta179	Stemberger, Vitovska	Stemberger Vitovska Kras Kras 2016	Stemberger	Slovenia	Kras Kras	Vitovska	WHITE	Table	13	1	3	3	1	200000	2016	750	5	\N	실속형 데일리 화이트. 입에 침이 고이는 정도/잼같은 느낌 균형이 안정적이에요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	레이아 생산자의 떫지 않은 와인 Stemberger Vitovska Kras Kras 2016. 2016 빈티지, 도수 13~14, 750ml.\n\n입안에서는 막걸리같은/새콤한 맛가 중심을 잡고, 마무리는 부담없이 넘어가는이 정돈합니다.\n메인에 두면 실패 확률이 낮아요. (데일리·대화용)	첫 인상은 새콤한 맛가 또렷하고, 텍스처는 졸인듯한 느낌의로 느껴집니다. 피니시는 부담없이 넘어가는, 단맛은 음료수같은 와인 쪽으로 해석할 수 있어요. 그리고 해산물과 잘어울리는 쪽으로 즐기기 좋아요.	흰살 생선구이, 오일 파스타, 치즈 플래터	edge
ta152	Errazuriz, Late Harvest Sauvignon-blanc	Vina Errazuriz Sauvignon-blanc Aconcagua Casablanca Valley 2007	Vina Errazuriz	Chile	Aconcagua Casablanca Valley	Sauvignon-blanc	WHITE	Dessert	11.5	5	1	4	1	29000	2007	375	5	\N	무난한 와인 데일리 화이트. 깔끔한 스타일/농축된 균형이 안정적이에요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Vina Errazuriz Sauvignon-blanc Aconcagua Casablanca Valley 2007는 까르미네르에서 온 떫지 않은 스타일입니다. 2007 빈티지 기준 11.5 도수, 375ml 구성.\n\n키워드로 보면 향에서는 꿀같은 인상이 먼저 오고, 입안에서는 환타 맛이 나는가 균형을 잡습니다. 질감은 끈끈한 느낌의, 여운은 둥글둥글한 쪽으로 정리돼요. 그리고 청포도로 만든 쪽으로 즐기기 좋아요.\n추천 상황은 마무리·대화용 쪽이에요.	향에서는 꿀같은 인상이 먼저 오고, 입안에서는 환타 맛이 나는가 균형을 잡습니다. 질감은 끈끈한 느낌의, 여운은 둥글둥글한 쪽으로 정리돼요. 그리고 청포도로 만든 쪽으로 즐기기 좋아요.	티라미수 / 치즈	rep
ta153	Steinmuhle Riesling Auslese	Weingut Steinmuhle 리슬링 Rheinhessen 2018	Weingut Steinmuhle	Germany	Rheinhessen	Riesling	WHITE	Dessert	8	4	2	3	1	90000	2018	750	5	\N	식후에 마시는 와인에 어울리는 리슬링 화이트. 톡톡 쏘는가 살아 있고 걸쭉한 맛는 담백해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	청량한 느낌 생산자의 돌려서 따는 마개 와인 Weingut Steinmuhle 리슬링 Rheinhessen 2018. 2018 빈티지, 도수 8, 750ml.\n\n입안에서는 잼같은 느낌/톡톡 쏘는가 중심을 잡고, 마무리는 둥글둥글한이 정돈합니다.\n작은잔에 마시는 와인에 두면 실패 확률이 낮아요. (마무리·대화용)	알싸한 맛가 입맛을 깨우고, 농익은는 담백하게 이어집니다. 리치한 느낌은 거칠지 않고 과실향이 나는 느낌은 은근해요. 그리고 돌려서 따는 마개 쪽으로 즐기기 좋아요.	과일 타르트 / 블루치즈 / 치즈	rep
ta154	B.LOVELY Late Harvest Riesling	Precept Wines 시라 Washington State 2014	Precept Wines	USA	Washington State	Syrah&Shiraz mourvedre Grenache	WHITE	Dessert	9	5	1	3	1	60000	2014	750	5	\N	응축에 어울리는 시라 화이트. 상쾌한 느낌가 살아 있고 걸쭉한 맛는 담백해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	와인 입문자에게 적합한의 안주없이 마실수 있는 와인 Precept Wines 시라 Washington State 2014 (2014). 도수 9~10, 750ml.\n\n환타 맛이 나는가 입맛을 깨우고, 농익은는 담백하게 이어집니다. 약간 비린맛의은 거칠지 않고 점성을 띠고있는 느낌은 은근해요. — 해산물과 잘어울리는 무드로 이해하면 좋아요.\n단맛 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (마무리·대화용)	환타 맛이 나는가 입맛을 깨우고, 농익은는 담백하게 이어집니다. 약간 비린맛의은 거칠지 않고 점성을 띠고있는 느낌은 은근해요. — 해산물과 잘어울리는 무드로 이해하면 좋아요.	티라미수 / 말린 과일 / 치즈	rep
ta155	Le Morre, Moscato d'Asti	Le Morre 모스카토 Piemonte Asti 2018	Le Morre	Italy	Piemonte Asti	Moscato	WHITE	Dessert	14	4	2	2	1	30000	2018	750	5	\N	가성비 와인 데일리 화이트. 유자향이 좀 나는/구수한 맛의 균형이 안정적이에요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Le Morre 모스카토 Piemonte Asti 2018는 떫지 않은 카테고리에서 먹을만한 와인 선택지로 좋은 편입니다. 2018 빈티지, 14~15 도수, 750ml.\n\n묵직한 느낌의 텍스처 위에 알싸한 맛가 살아 있고, 마무리는 부담없이 넘어가는이 정돈합니다. 과실향이 나는 뉘앙스는 과하지 않아요. 그리고 해산물과 잘어울리는 쪽으로 즐기기 좋아요.\n마무리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	묵직한 느낌의 텍스처 위에 알싸한 맛가 살아 있고, 마무리는 부담없이 넘어가는이 정돈합니다. 과실향이 나는 뉘앙스는 과하지 않아요. 그리고 해산물과 잘어울리는 쪽으로 즐기기 좋아요.	블루치즈 / 티라미수 / 치즈	rep
ta156	Crotta, Semi Sweet Red	Crotta Blend Mendoza 2006	Crotta	Argentina	Mendoza	Blend	RED	Dessert	13	3	2	3	2	9900	2006	750	5	\N	말벡 무드의 Blend 레드 — 홍차를 마시는것같은 결이 살아 있고 농익은가 탄탄해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Crotta Blend Mendoza 2006는 페냐플로르에서 온 고기랑 어울리는 스타일입니다. 2006 빈티지 기준 13 도수, 750ml 구성.\n\n키워드로 보면 졸인듯한 느낌의 텍스처 위에 유자향이 좀 나는가 살아 있고, 마무리는 까칠까칠한 맛이 정돈합니다. 스위트한 맛의 뉘앙스는 과하지 않아요. — 식후에 마시는 와인 무드로 이해하면 좋아요.\n추천 상황은 마무리·대화용 쪽이에요.	졸인듯한 느낌의 텍스처 위에 유자향이 좀 나는가 살아 있고, 마무리는 까칠까칠한 맛이 정돈합니다. 스위트한 맛의 뉘앙스는 과하지 않아요. — 식후에 마시는 와인 무드로 이해하면 좋아요.	티라미수 / 다크 초콜릿 / 치즈	rep
ta157	Fonseca, Vintage Port	Fonseca Blend Douro 2009	Fonseca	Portugal	Douro	Blend	FORTIFIED	Dessert	14	5	3	5	4	380000	2009	750	5	\N	품질이 뛰어난 와인 주정강화. 점성을 띠고있는 인상으로 마무리에 좋아요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	도루밸리의 알코올 도수 높은 와인 Fonseca Blend Douro 2009 (2009). 도수 14~15, 750ml.\n\n시큼한가 입맛을 깨우고, 끈기가 아주 많은는 담백하게 이어집니다. 매케한 느낌은 거칠지 않고 달콤한 향이 나는 느낌은 은근해요. 그리고 포트 와인 쪽으로 즐기기 좋아요.\n여운 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (마무리·대화용)	시큼한가 입맛을 깨우고, 끈기가 아주 많은는 담백하게 이어집니다. 매케한 느낌은 거칠지 않고 달콤한 향이 나는 느낌은 은근해요. 그리고 포트 와인 쪽으로 즐기기 좋아요.	블루치즈 / 치즈	rep
ta158	Domaine de la Romanee-Conti, Fine Bourgogne	Romanee Conti Domaine de la Romanee Conti 피노 누아 Bourgogne 1991	Romanee Conti Domaine de la Romanee Conti	France	Bourgogne	Pinot Noir	HARD	Etc	40	1	1	5	1	1275000	1991	700	5	\N	아무나 쉽게 못마시는 선택지로 좋은 피노 누아 레드. 리치한 느낌/위스키 느낌의 밸런스형.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Romanee Conti Domaine de la Romanee Conti 피노 누아 Bourgogne 1991는 묵직하고 깊은 카테고리에서 아무나 쉽게 못마시는 선택지로 좋은 편입니다. 1991 빈티지, 40 도수, 700ml.\n\n첫 인상은 상큼한가 또렷하고, 텍스처는 눅진한로 느껴집니다. 피니시는 부담없이 넘어가는, 단맛은 단맛이 조금 나는 쪽으로 해석할 수 있어요. 특히 깊은 여운을 주는 상황에 잘 어울립니다.\n집중음용·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	첫 인상은 상큼한가 또렷하고, 텍스처는 눅진한로 느껴집니다. 피니시는 부담없이 넘어가는, 단맛은 단맛이 조금 나는 쪽으로 해석할 수 있어요. 특히 깊은 여운을 주는 상황에 잘 어울립니다.	양갈비(후추/허브), 숙성 치즈, 미트소스/라구	rep
ta159	Santa Julia Cabernet-Sauvignon	Familia Zuccardi Cabernet-Sauvignon Mendoza 2009	Familia Zuccardi	Argentina	Mendoza	Cabernet-Sauvignon	RED	Table	13.5	1	3	3	3	20000	2009	750	5	\N	캠핑 와인으로 좋은 카베르네 소비뇽 레드. 농익은 질감에 입안이 까끌까끌한 여운, 메인음식과 함께 먹는에 편하게.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	탄닌이 강한 생산자의 무난한 선물용 와인 Familia Zuccardi Cabernet-Sauvignon Mendoza 2009. 2009 빈티지, 도수 13.5, 750ml.\n\n입안에서는 졸인듯한 느낌의/입에 침이 고이는 정도가 중심을 잡고, 마무리는 떫떠름한 느낌이 정돈합니다.\n식욕을 증진시키는에 두면 실패 확률이 낮아요. (데일리·대화용)	향에서는 단맛이 조금 나는 인상이 먼저 오고, 입안에서는 시큼한가 균형을 잡습니다. 질감은 걸쭉한 맛, 여운은 쓴맛 쪽으로 정리돼요. — 무난한 선물용 무드로 이해하면 좋아요.	햄·살라미(그릴), 숙성 치즈, 미트소스/라구	rep
ta160	Finca Las Moras Reserva Chardonnay	Finca Las Moras 샤르도네 San Juan UllumZonda 2017	Finca Las Moras	Argentina	San Juan UllumZonda	Chardonnay	WHITE	Table	13	1	3	3	1	60000	2017	750	5	\N	답례용품으로 좋은 데일리 화이트. 입안이 개운한/농익은 균형이 안정적이에요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Finca Las Moras 샤르도네 San Juan UllumZonda 2017는 안주없이 마실수 있는 카테고리에서 발렌타인날 마시기 좋은 선택지로 좋은 편입니다. 2017 빈티지, 13~14 도수, 750ml.\n\n전체 톤은 걸쭉한 맛와 시큼한의 균형. 타닌은 둥글둥글한, 단맛은 순한 맛 쪽으로 읽힙니다. — 음식과함께 무드로 이해하면 좋아요.\n데일리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	전체 톤은 걸쭉한 맛와 시큼한의 균형. 타닌은 둥글둥글한, 단맛은 순한 맛 쪽으로 읽힙니다. — 음식과함께 무드로 이해하면 좋아요.	오일 파스타, 흰살 생선구이, 치즈 플래터	rep
ta161	Domaine des Rouges Queues, Santenay Red	Domaine des RougesQueues 피노 누아 Bourgogne Cote de Beaune 2007	Domaine des RougesQueues	France	Bourgogne Cote de Beaune	Pinot Noir	RED	Table	13	1	4	2	2	106000	2007	750	5	\N	무통로칠드 무드의 피노 누아 레드 — 홍차를 마시는것같은 결이 살아 있고 마시기 적당한가 탄탄해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	호불호 없는의 와인다운 와인 Domaine des RougesQueues 피노 누아 Bourgogne Cote de Beaune 2007 (2007). 도수 13, 750ml.\n\n맛이 신가 입맛을 깨우고, 라이트한는 담백하게 이어집니다. 까칠까칠한 맛은 거칠지 않고 밋밋한 와인 느낌은 은근해요. 특히 무난한 선물용 상황에 잘 어울립니다.\n메인음식과 함께 먹는 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (데일리·대화용)	맛이 신가 입맛을 깨우고, 라이트한는 담백하게 이어집니다. 까칠까칠한 맛은 거칠지 않고 밋밋한 와인 느낌은 은근해요. 특히 무난한 선물용 상황에 잘 어울립니다.	햄·살라미(후추/허브), 숙성 치즈, 미트소스/라구	rep
ta162	Bottega Vinai, Pinot Grigio	Bottega Vinai 메를로 TrentinoAlto Adige 2018	Bottega Vinai	Italy	TrentinoAlto Adige	Merlot	WHITE	Appetizer, Table	12	1	3	2	1	55000	2018	750	5	\N	가볍게 시작하기 좋은 데이트때 마시기 좋은 화이트. 입에 침이 고이는 정도가 상쾌한 쪽이에요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	산지오베제의 안주없이 마실수 있는 와인 Bottega Vinai 메를로 TrentinoAlto Adige 2018 (2018). 도수 12~13, 750ml.\n\n라이트한 텍스처 위에 새콤한 맛가 살아 있고, 마무리는 리치한 느낌이 정돈합니다. 순한 맛 뉘앙스는 과하지 않아요. 특히 상쾌함 상황에 잘 어울립니다.\n상쾌함 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (데일리·대화용)	라이트한 텍스처 위에 새콤한 맛가 살아 있고, 마무리는 리치한 느낌이 정돈합니다. 순한 맛 뉘앙스는 과하지 않아요. 특히 상쾌함 상황에 잘 어울립니다.	흰살 생선구이, 회/초밥, 치즈 플래터	rep
ta163	Domaines Schlumberger, Pinot Gris	Domaines Schlumberger 피노 그리 Alsace 2016	Domaines Schlumberger	France	Alsace	Pinot Gris	WHITE	Table	13.5	2	3	2	1	29800	2016	750	5	\N	중심에 어울리는 Pinot Gris 화이트. 입에 침이 고이는 정도가 살아 있고 라이트한는 담백해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Domaines Schlumberger 피노 그리 Alsace 2016는 청포도로 만든 카테고리에서 실속형 와인 선택지로 좋은 편입니다. 2016 빈티지, 13.5 도수, 750ml.\n\n향에서는 달짝지근한 인상이 먼저 오고, 입안에서는 산미가 조금 있는가 균형을 잡습니다. 질감은 라이트한, 여운은 리치한 느낌 쪽으로 정리돼요. 특히 글라스 와인 용 상황에 잘 어울립니다.\n데일리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	향에서는 달짝지근한 인상이 먼저 오고, 입안에서는 산미가 조금 있는가 균형을 잡습니다. 질감은 라이트한, 여운은 리치한 느낌 쪽으로 정리돼요. 특히 글라스 와인 용 상황에 잘 어울립니다.	흰살 생선구이, 치즈 플래터	rep
ta164	Cono Sur, Bicicleta Cabernet-Sauvignon	Cono Sur Cabernet-Sauvignon Etc Central Valley 2016	Cono Sur	Chile	Central Valley	Cabernet-Sauvignon Etc	RED	Table	13	1	3	3	3	18000	2016	750	5	\N	가성비 와인 무드의 Cabernet-Sauvignon Etc 레드 — 쓴맛 결이 살아 있고 걸쭉한 맛가 탄탄해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	1865 생산자의 와인다운 와인 Cono Sur Cabernet-Sauvignon Etc Central Valley 2016. 2016 빈티지, 도수 13~14, 750ml.\n\n입안에서는 걸쭉한 맛/입안이 개운한가 중심을 잡고, 마무리는 떫떠름한 느낌이 정돈합니다.\n많이 비싸지 않은에 두면 실패 확률이 낮아요. (데일리·대화용)	시큼한가 입맛을 깨우고, 막걸리같은는 담백하게 이어집니다. 씁쓸한은 거칠지 않고 순한 맛 느낌은 은근해요. — 와인다운 무드로 이해하면 좋아요.	버섯 그릴(훈제), 숙성 치즈, 미트소스/라구	rep
ta165	Domaine des Rouges Queues, Bourgogne Hautes Cotes de Beaune Red	Domaine des RougesQueues 피노 누아 Bourgogne Cote de Beaune 2007	Domaine des RougesQueues	France	Bourgogne Cote de Beaune	Pinot Noir	RED	Table	12.5	1	5	2	2	86000	2007	750	5	\N	이지 드링크 와인 피노 누아 레드. 구수한 맛의 질감에 까칠까칠한 맛 여운, 메인음식과 함께 먹는에 편하게.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Domaine des RougesQueues 피노 누아 Bourgogne Cote de Beaune 2007는 보르도 감성을 담은 고기랑 어울리는입니다. 2007 빈티지, 12.5 도수, 750ml.\n\n향에서는 순한 맛 인상이 먼저 오고, 입안에서는 눈이 감길정도로 신가 균형을 잡습니다. 질감은 부드러운 느낌의, 여운은 홍차를 마시는것같은 쪽으로 정리돼요. — 무난한 선물용 무드로 이해하면 좋아요.\n데일리·대화용에 두고 천천히 즐기면 밸런스가 더 살아나요.	향에서는 순한 맛 인상이 먼저 오고, 입안에서는 눈이 감길정도로 신가 균형을 잡습니다. 질감은 부드러운 느낌의, 여운은 홍차를 마시는것같은 쪽으로 정리돼요. — 무난한 선물용 무드로 이해하면 좋아요.	피자(후추/허브), 숙성 치즈, 미트소스/라구	rep
ta166	Blue Nun, Eiswein Riesling	Langguth  Blue nun 리슬링 Rheinhessen 2005	Langguth  Blue nun	Germany	Rheinhessen	Riesling	WHITE	Dessert	10	5	2	3	1	120000	2005	500	5	\N	모젤 스타일 리슬링 화이트 — 알싸한 맛가 또렷하고 막걸리같은가 깔끔해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Langguth Blue nun 리슬링 Rheinhessen 2005는 돌려서 따는 마개 카테고리에서 고급 와인 선택지로 좋은 편입니다. 2005 빈티지, 10 도수, 500ml.\n\n향에서는 달콤한 향이 나는 인상이 먼저 오고, 입안에서는 알싸한 맛가 균형을 잡습니다. 질감은 걸쭉한 맛, 여운은 약간 비린맛의 쪽으로 정리돼요. 그리고 달달한 와인 쪽으로 즐기기 좋아요.\n마무리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	향에서는 달콤한 향이 나는 인상이 먼저 오고, 입안에서는 알싸한 맛가 균형을 잡습니다. 질감은 걸쭉한 맛, 여운은 약간 비린맛의 쪽으로 정리돼요. 그리고 달달한 와인 쪽으로 즐기기 좋아요.	과일 타르트 / 말린 과일 / 치즈	rep
ta167	Il Macchione Vino Noblie di Montepulciano Riserva	Il Macchione Prugnolo Gentile Sangiovese Toscana Montepulciano 1997	Il Macchione	Italy	Toscana Montepulciano	Prugnolo Gentile Sangiovese	RED	Table	13	1	4	4	4	192000	1997	1500	5	\N	결혼 선물로 적당한 선택지로 좋은 Prugnolo Gentile Sangiovese 레드. 달콤쌉쌀한/농축된 밸런스형.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Il Macchione Prugnolo Gentile Sangiovese Toscana Montepulciano 1997는 무난한 선물용 카테고리에서 와인 모임에 들고가기 좋은 선택지로 좋은 편입니다. 1997 빈티지, 13~14 도수, 1500ml.\n\n전체 톤은 점성이 강한와 침샘이 자극되는의 균형. 타닌은 매케한 느낌, 단맛은 밋밋한 와인 쪽으로 읽힙니다. 그리고 많이 비싸지 않은 쪽으로 즐기기 좋아요.\n데일리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	전체 톤은 점성이 강한와 침샘이 자극되는의 균형. 타닌은 매케한 느낌, 단맛은 밋밋한 와인 쪽으로 읽힙니다. 그리고 많이 비싸지 않은 쪽으로 즐기기 좋아요.	바비큐 립(그릴), 숙성 치즈, 미트소스/라구	rep
ta168	Lamblin & Fils, Bourgogne Pinot Noir	Lamblin  Fils 피노 누아 Bourgogne 2006	Lamblin  Fils	France	Bourgogne	Pinot Noir	RED	Table	12.5	1	4	2	2	60000	2006	750	5	\N	오늘은 발렌타인날 마시기 좋은 레드. 라이트한 중심으로 가고 혀가 아리는 느낌은 과하지 않아요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Lamblin Fils 피노 누아 Bourgogne 2006는 무난한 선물용 카테고리에서 가격이 부담스럽지 않은 와인 선택지로 좋은 편입니다. 2006 빈티지, 12.5 도수, 750ml.\n\n전체 톤은 묵직한 느낌의와 침샘이 자극되는의 균형. 타닌은 홍차를 마시는것같은, 단맛은 단맛이 조금 나는 쪽으로 읽힙니다. 그리고 음식과함께 쪽으로 즐기기 좋아요.\n데일리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	전체 톤은 묵직한 느낌의와 침샘이 자극되는의 균형. 타닌은 홍차를 마시는것같은, 단맛은 단맛이 조금 나는 쪽으로 읽힙니다. 그리고 음식과함께 쪽으로 즐기기 좋아요.	버섯 그릴(그릴), 숙성 치즈, 미트소스/라구	rep
ta169	Agricola Punica Montessu	Agricola Punica Carignano Cabernet-Sauvignon Merlot Sardegna 2017	Agricola Punica	Italy	Sardegna	Carignano Cabernet-Sauvignon Merlot	RED	Table	14	1	3	3	3	80000	2017	750	5	\N	데이트때 마시기 좋은 Carignano Cabernet-Sauvignon Merlot 레드. 걸쭉한 맛 질감에 쌍화탕같은 맛의 여운, 중심에 편하게.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Agricola Punica Carignano Cabernet-Sauvignon Merlot Sardegna 2017는 선물용 와인 감성을 담은 탄닌이 있는입니다. 2017 빈티지, 14~15 도수, 750ml.\n\n첫 인상은 산미가 조금 있는가 또렷하고, 텍스처는 잼같은 느낌로 느껴집니다. 피니시는 입안이 까끌까끌한, 단맛은 음료수같은 와인 쪽으로 해석할 수 있어요. 그리고 무난한 선물용 쪽으로 즐기기 좋아요.\n데일리·대화용에 두고 천천히 즐기면 밸런스가 더 살아나요.	첫 인상은 산미가 조금 있는가 또렷하고, 텍스처는 잼같은 느낌로 느껴집니다. 피니시는 입안이 까끌까끌한, 단맛은 음료수같은 와인 쪽으로 해석할 수 있어요. 그리고 무난한 선물용 쪽으로 즐기기 좋아요.	미트볼(그릴), 숙성 치즈, 미트소스/라구	rep
ta170	35 South, Reserva Cabernet-Sauvignon	San Pedro Cabernet-Sauvignon Central Valley 2017	San Pedro	Chile	Central Valley	Cabernet-Sauvignon	RED	Table	14	1	3	3	3	27000	2017	750	5	\N	가성비 와인 선택지로 좋은 카베르네 소비뇽 레드. 쓴맛/막걸리같은 밸런스형.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	San Pedro Cabernet-Sauvignon Central Valley 2017는 까르미네르 감성을 담은 무난한 선물용입니다. 2017 빈티지, 14~15 도수, 750ml.\n\n전체 톤은 잼같은 느낌와 입에 침이 고이는 정도의 균형. 타닌은 씁쓸한, 단맛은 순한 맛 쪽으로 읽힙니다. 특히 식사떄 마시는 와인 상황에 잘 어울립니다.\n데일리·대화용에 두고 천천히 즐기면 밸런스가 더 살아나요.	전체 톤은 잼같은 느낌와 입에 침이 고이는 정도의 균형. 타닌은 씁쓸한, 단맛은 순한 맛 쪽으로 읽힙니다. 특히 식사떄 마시는 와인 상황에 잘 어울립니다.	치킨 스테이크(후추/허브), 숙성 치즈, 미트소스/라구	rep
ta171	Villa Da Vinci, Santo Ippolito	Cantine Leonardo Da Vinci Cabernet-Sauvignon Toscana 2018	Cantine Leonardo Da Vinci	Italy	Toscana	Cabernet-Sauvignon	RED	Table	13	1	4	3	4	100000	2018	750	5	\N	메인 자리에서 빛나는 카베르네 소비뇽 레드. 매케한 느낌은 정돈되고 졸인듯한 느낌의는 또렷해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Cantine Leonardo Da Vinci Cabernet-Sauvignon Toscana 2018는 산지오베제 감성을 담은 탄닌이 있는입니다. 2018 빈티지, 13~14 도수, 750ml.\n\n첫 인상은 맛이 신가 또렷하고, 텍스처는 잼같은 느낌로 느껴집니다. 피니시는 쌉싸름한 맛, 단맛은 향기가 좋은 쪽으로 해석할 수 있어요. — 메인 무드로 이해하면 좋아요.\n데일리·대화용에 두고 천천히 즐기면 밸런스가 더 살아나요.	첫 인상은 맛이 신가 또렷하고, 텍스처는 잼같은 느낌로 느껴집니다. 피니시는 쌉싸름한 맛, 단맛은 향기가 좋은 쪽으로 해석할 수 있어요. — 메인 무드로 이해하면 좋아요.	양갈비(훈제), 숙성 치즈, 미트소스/라구	rep
ta172	Finca el Origen Malbec	Finca el Origen 말벡 Mendoza 2016	Finca el Origen	Argentina	Mendoza	Malbec	RED	Table	14	1	3	3	3	11000	2016	750	5	\N	강한맛 무드의 말벡 레드 — 떫떠름한 느낌 결이 살아 있고 잼같은 느낌가 탄탄해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Finca el Origen 말벡 Mendoza 2016는 작업주 카테고리에서 데일리 와인 선택지로 좋은 편입니다. 2016 빈티지, 14 도수, 750ml.\n\n향에서는 순한 맛 인상이 먼저 오고, 입안에서는 산미가 조금 있는가 균형을 잡습니다. 질감은 졸인듯한 느낌의, 여운은 씁쓸한 쪽으로 정리돼요. 그리고 메인음식과 함께 먹는 쪽으로 즐기기 좋아요.\n데일리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	향에서는 순한 맛 인상이 먼저 오고, 입안에서는 산미가 조금 있는가 균형을 잡습니다. 질감은 졸인듯한 느낌의, 여운은 씁쓸한 쪽으로 정리돼요. 그리고 메인음식과 함께 먹는 쪽으로 즐기기 좋아요.	버섯 그릴(트러플), 숙성 치즈, 미트소스/라구	edge
ta174	Kabaj, Sauvignon	Kabaj Sauvignon-blanc Goriska Brda 2013	Kabaj	Slovenia	Goriska Brda	Sauvignon-blanc	WHITE	Table	13	1	3	4	1	100000	2013	750	5	\N	가볍게 시작하기 좋은 고급 와인 화이트. 시큼한가 상쾌한 쪽이에요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Kabaj Sauvignon-blanc Goriska Brda 2013는 유기농 와인에서 온 돌려서 따는 마개 스타일입니다. 2013 빈티지 기준 13 도수, 750ml 구성.\n\n키워드로 보면 향에서는 밋밋한 와인 인상이 먼저 오고, 입안에서는 입안이 개운한가 균형을 잡습니다. 질감은 무게감이 느껴지는, 여운은 목넘김이 좋은 쪽으로 정리돼요. — 음식과함께 무드로 이해하면 좋아요.\n추천 상황은 데일리·대화용 쪽이에요.	향에서는 밋밋한 와인 인상이 먼저 오고, 입안에서는 입안이 개운한가 균형을 잡습니다. 질감은 무게감이 느껴지는, 여운은 목넘김이 좋은 쪽으로 정리돼요. — 음식과함께 무드로 이해하면 좋아요.	버터 소스 생선, 리조또, 치즈 플래터	edge
ta175	Chateau Haut Brion Blanc	Chateau HautBrion 1st Grand Cru Classe Sauvignon-blanc Semillon Bordeaux PessacLeognan 2016	Chateau HautBrion 1st Grand Cru Classe	France	Bordeaux PessacLeognan	Sauvignon-blanc Semillon	WHITE	Table	14	1	4	4	1	1500000	2016	750	5	\N	아무나 쉽게 못마시는 데일리 화이트. 맛이 신/농축된 균형이 안정적이에요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Chateau HautBrion 1st Grand Cru Classe Sauvignon-blanc Semillon Bordeaux PessacLeognan 2016는 안주없이 마실수 있는 카테고리에서 쟁여놓을 가치가 있는 와인 선택지로 좋은 편입니다. 2016 빈티지, 14~15 도수, 750ml.\n\n점성이 강한 텍스처 위에 침샘이 자극되는가 살아 있고, 마무리는 약간 비린맛의이 정돈합니다. 음료수같은 와인 뉘앙스는 과하지 않아요. — 해산물과 잘어울리는 무드로 이해하면 좋아요.\n데일리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	점성이 강한 텍스처 위에 침샘이 자극되는가 살아 있고, 마무리는 약간 비린맛의이 정돈합니다. 음료수같은 와인 뉘앙스는 과하지 않아요. — 해산물과 잘어울리는 무드로 이해하면 좋아요.	치즈 플래터, 버터 소스 생선	edge
ta176	Rene Barbier, Kraliner Seco White	Rene Barbier Macabeo Parellada Catalunya Xarello 2013	Rene Barbier	Spain	Catalunya Xarello	Macabeo Parellada	WHITE	Table	12	1	5	3	1	9900	2013	375	5	\N	마트 와인 Macabeo Parellada 화이트. 레몬같은 느낌으로 구조감에 산뜻해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Rene Barbier Macabeo Parellada Catalunya Xarello 2013는 안주없이 마실수 있는 카테고리에서 입문 와인 선택지로 좋은 편입니다. 2013 빈티지, 12~13 도수, 375ml.\n\n걸쭉한 맛 텍스처 위에 눈이 감길정도로 신가 살아 있고, 마무리는 부담없이 넘어가는이 정돈합니다. 밋밋한 와인 뉘앙스는 과하지 않아요. 특히 안주없이 마실수 있는 상황에 잘 어울립니다.\n데일리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	걸쭉한 맛 텍스처 위에 눈이 감길정도로 신가 살아 있고, 마무리는 부담없이 넘어가는이 정돈합니다. 밋밋한 와인 뉘앙스는 과하지 않아요. 특히 안주없이 마실수 있는 상황에 잘 어울립니다.	오일 파스타, 흰살 생선구이, 치즈 플래터	edge
ta177	Chateau Dereszla, Furmint Dry	Chateau Dereszla Tinta de Toro The Northeast TokajHegyalja 2019	Chateau Dereszla	Hungary	The Northeast TokajHegyalja	Tinta de Toro	WHITE	Appetizer, Table	12	1	4	2	1	40000	2019	750	5	\N	첫잔에 어울리는 Tinta de Toro 화이트. 맛이 신가 살아 있고 묵직한 느낌의는 담백해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	디저트 와인 생산자의 돌려서 따는 마개 와인 Chateau Dereszla Tinta de Toro The Northeast TokajHegyalja 2019. 2019 빈티지, 도수 12~13, 750ml.\n\n입안에서는 부드러운 느낌의/침샘이 자극되는가 중심을 잡고, 마무리는 리치한 느낌이 정돈합니다.\n샐러드와 어울리는에 두면 실패 확률이 낮아요. (데일리·대화용)	부드러운 느낌의 텍스처 위에 짜릿한 맛가 살아 있고, 마무리는 둥글둥글한이 정돈합니다. 순한 맛 뉘앙스는 과하지 않아요. 특히 상쾌함 상황에 잘 어울립니다.	오일 파스타, 새우/조개, 치즈 플래터	edge
ta178	Lang, Riesling Icewine	Lang 리슬링 British Columbia Okanagan Valley 2001	Lang	Canada	British Columbia Okanagan Valley	Riesling	WHITE	Dessert	9	5	3	3	1	178000	2001	375	5	\N	와인 모임에 들고가기 좋은 리슬링 화이트. 입안이 개운한 느낌으로 작은잔에 마시는 와인에 산뜻해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Lang 리슬링 British Columbia Okanagan Valley 2001는 청포도로 만든 카테고리에서 특별한날 마시기 좋은 선택지로 좋은 편입니다. 2001 빈티지, 9 도수, 375ml.\n\n걸쭉한 맛 텍스처 위에 새콤한 맛가 살아 있고, 마무리는 리치한 느낌이 정돈합니다. 시럽같은 맛 뉘앙스는 과하지 않아요. 특히 소화를 돕는 와인 상황에 잘 어울립니다.\n마무리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	걸쭉한 맛 텍스처 위에 새콤한 맛가 살아 있고, 마무리는 리치한 느낌이 정돈합니다. 시럽같은 맛 뉘앙스는 과하지 않아요. 특히 소화를 돕는 와인 상황에 잘 어울립니다.	블루치즈 / 티라미수 / 치즈	edge
ta180	Bree Pinot Noir Rose	Peter Mertes 피노 누아 Rheinhessen 2015	Peter Mertes	Germany	Rheinhessen	Pinot Noir	ROSE	Table	11	4	2	2	2	8800	2015	250	5	\N	특가 와인 로제. 미끌미끌한 느낌가 상큼해서 균형에 가볍게 좋아요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	바인구트로베르트바일의 커플 와인 와인 Peter Mertes 피노 누아 Rheinhessen 2015 (2015). 도수 11, 250ml.\n\n첫 인상은 짜릿한가 또렷하고, 텍스처는 라이트한로 느껴집니다. 피니시는 혀가 아리는 느낌, 단맛은 뒤끝이 좋은 쪽으로 해석할 수 있어요. — 항아리 병처럼 생긴 무드로 이해하면 좋아요.\n구조감 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (데일리·대화용)	첫 인상은 짜릿한가 또렷하고, 텍스처는 라이트한로 느껴집니다. 피니시는 혀가 아리는 느낌, 단맛은 뒤끝이 좋은 쪽으로 해석할 수 있어요. — 항아리 병처럼 생긴 무드로 이해하면 좋아요.	견과류 / 블루치즈 / 치즈	edge
ta181	Binekhi Binekhi Semi Dry	Vazi Rkatsiteli Mtsvane Etc 2007	Vazi	Georgia	\N	Rkatsiteli Mtsvane Etc	WHITE	Table	12	2	2	2	1	18000	2007	750	5	\N	식욕을 증진시키는에 어울리는 Rkatsiteli Mtsvane Etc 화이트. 톡톡 쏘는가 살아 있고 묵직한 느낌의는 담백해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	아스카넬리 생산자의 청포도로 만든 와인 Vazi Rkatsiteli Mtsvane Etc 2007. 2007 빈티지, 도수 12, 750ml.\n\n입안에서는 구수한 맛의/알싸한 맛가 중심을 잡고, 마무리는 부담없이 넘어가는이 정돈합니다.\n중심에 두면 실패 확률이 낮아요. (데일리·대화용)	짜릿한가 입맛을 깨우고, 묵직한 느낌의는 담백하게 이어집니다. 부담없이 넘어가는은 거칠지 않고 달짝지근한 느낌은 은근해요. 특히 글라스 와인 용 상황에 잘 어울립니다.	버터 소스 생선, 치즈 플래터	edge
ta182	Distell, Obikwa Shiraz	Distell 시라 Coastal Region Stellenbosch 2009	Distell	the Republic of South Africa	Coastal Region Stellenbosch	Syrah&Shiraz	RED	Table	13	1	4	2	4	13000	2009	750	5	\N	오늘은 데일리 와인 레드. 묵직한 느낌의 중심으로 가고 달콤쌉쌀한은 과하지 않아요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Distell 시라 Coastal Region Stellenbosch 2009는 와인다운 카테고리에서 초심자용 와인 선택지로 좋은 편입니다. 2009 빈티지, 13 도수, 750ml.\n\n향에서는 순한 맛 인상이 먼저 오고, 입안에서는 입안이 얼얼한가 균형을 잡습니다. 질감은 묵직한 느낌의, 여운은 쿰쿰한 맛이 느껴지는 쪽으로 정리돼요. 그리고 고기랑 어울리는 쪽으로 즐기기 좋아요.\n데일리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	향에서는 순한 맛 인상이 먼저 오고, 입안에서는 입안이 얼얼한가 균형을 잡습니다. 질감은 묵직한 느낌의, 여운은 쿰쿰한 맛이 느껴지는 쪽으로 정리돼요. 그리고 고기랑 어울리는 쪽으로 즐기기 좋아요.	양갈비(후추/허브), 숙성 치즈, 미트소스/라구	edge
ta183	Murfatlar	Ferdinand Pieroth 메를로 Cabernet-Sauvignon 2004	Ferdinand Pieroth	Romania	Cabernet-Sauvignon	Merlot	RED	Table	12	1	4	3	4	30000	2004	750	5	\N	중심 자리에서 빛나는 메를로 레드. 입술이 오므라드는은 정돈되고 졸인듯한 느낌의는 또렷해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	생소한 품종의 탄닌이 있는 와인 Ferdinand Pieroth 메를로 Cabernet-Sauvignon 2004 (2004). 도수 12~13, 750ml.\n\n향에서는 밋밋한 와인 인상이 먼저 오고, 입안에서는 탄산음료같은가 균형을 잡습니다. 질감은 막걸리같은, 여운은 쌉싸름한 맛 쪽으로 정리돼요. — 작업주 무드로 이해하면 좋아요.\n음식과함께 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (데일리·대화용)	향에서는 밋밋한 와인 인상이 먼저 오고, 입안에서는 탄산음료같은가 균형을 잡습니다. 질감은 막걸리같은, 여운은 쌉싸름한 맛 쪽으로 정리돼요. — 작업주 무드로 이해하면 좋아요.	스테이크(토마토 라구), 숙성 치즈, 미트소스/라구	edge
ta184	Rio Bueno Cabernet-Sauvignon	Quien  Co Cabernet-Sauvignon Central Valley 2009	Quien  Co	Chile	Central Valley	Cabernet-Sauvignon	RED	Table	13	1	3	2	3	6900	2009	750	5	\N	싼 와인 카베르네 소비뇽 레드. 라이트한 질감에 떫떠름한 느낌 여운, 중심에 편하게.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	가성비 와인 생산자의 와인다운 와인 Quien Co Cabernet-Sauvignon Central Valley 2009. 2009 빈티지, 도수 13, 750ml.\n\n입안에서는 마시기 적당한/산미가 조금 있는가 중심을 잡고, 마무리는 씁쓸한이 정돈합니다.\n식욕을 증진시키는에 두면 실패 확률이 낮아요. (데일리·대화용)	입에 침이 고이는 정도가 입맛을 깨우고, 마시기 적당한는 담백하게 이어집니다. 떫떠름한 느낌은 거칠지 않고 밋밋한 와인 느낌은 은근해요. 그리고 중심 쪽으로 즐기기 좋아요.	피자(토마토 라구), 숙성 치즈, 미트소스/라구	edge
ta185	Jackson Triggs Vidal Ice Wine	Jackson Triggs Vidal Bear River Niagara Peninsula 2006	Jackson Triggs	Canada	Bear River Niagara Peninsula	Vidal	WHITE	Dessert	10.5	5	4	4	1	177500	2006	375	5	\N	식후에 마시는 와인에 어울리는 Vidal 화이트. 탄산음료같은가 살아 있고 점성이 강한는 담백해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Jackson Triggs Vidal Bear River Niagara Peninsula 2006는 돌려서 따는 마개 카테고리에서 결혼 선물로 적당한 선택지로 좋은 편입니다. 2006 빈티지, 10.5 도수, 375ml.\n\n짜릿한 맛가 입맛을 깨우고, 점성이 강한는 담백하게 이어집니다. 약간 비린맛의은 거칠지 않고 시럽같은 맛 느낌은 은근해요. — 청포도로 만든 무드로 이해하면 좋아요.\n마무리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	짜릿한 맛가 입맛을 깨우고, 점성이 강한는 담백하게 이어집니다. 약간 비린맛의은 거칠지 않고 시럽같은 맛 느낌은 은근해요. — 청포도로 만든 무드로 이해하면 좋아요.	티라미수 / 말린 과일 / 치즈	edge
ta186	Lucien Le Moine, Batard Montrachet Grand Cru	Lucien Le Moine 샤르도네 Bourgogne Cote de Beaune 2007	Lucien Le Moine	France	Bourgogne Cote de Beaune	Chardonnay	WHITE	Table	13.5	1	5	4	1	2550000	2007	750	5	\N	아무나 쉽게 못마시는 데일리 화이트. 산도가 강한 와인/끈끈한 느낌의 균형이 안정적이에요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Lucien Le Moine 샤르도네 Bourgogne Cote de Beaune 2007는 무통로칠드에서 온 청포도로 만든 스타일입니다. 2007 빈티지 기준 13.5 도수, 750ml 구성.\n\n키워드로 보면 향에서는 음료수같은 와인 인상이 먼저 오고, 입안에서는 산도가 강한 와인가 균형을 잡습니다. 질감은 끈끈한 느낌의, 여운은 부담없이 넘어가는 쪽으로 정리돼요. 그리고 음식과함께 쪽으로 즐기기 좋아요.\n추천 상황은 데일리·대화용 쪽이에요.	향에서는 음료수같은 와인 인상이 먼저 오고, 입안에서는 산도가 강한 와인가 균형을 잡습니다. 질감은 끈끈한 느낌의, 여운은 부담없이 넘어가는 쪽으로 정리돼요. 그리고 음식과함께 쪽으로 즐기기 좋아요.	크림 파스타, 버터 소스 생선, 치즈 플래터	edge
ta187	Au sommet	Au sommet Cabernet-Sauvignon Petit Verdot California Napa County 2016	Au sommet	USA	California Napa County	Cabernet-Sauvignon Petit Verdot	RED	Table	13	1	3	5	4	1800000	2016	750	5	\N	쟁여놓을 가치가 있는 와인 선택지로 좋은 Cabernet-Sauvignon Petit Verdot 레드. 입술이 오므라드는/꿀같은 와인 밸런스형.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	나파밸리 생산자의 작업주 와인 Au sommet Cabernet-Sauvignon Petit Verdot California Napa County 2016. 2016 빈티지, 도수 13~14, 750ml.\n\n입안에서는 눅진한/시큼한가 중심을 잡고, 마무리는 쌉싸름한 맛이 정돈합니다.\n음식과함께에 두면 실패 확률이 낮아요. (데일리·대화용)	입에 침이 고이는 정도가 입맛을 깨우고, 꿀같은 와인는 담백하게 이어집니다. 달콤쌉쌀한은 거칠지 않고 향기가 좋은 느낌은 은근해요. 그리고 중심 쪽으로 즐기기 좋아요.	소갈비(토마토 라구), 숙성 치즈, 미트소스/라구	edge
ta188	Binekhi Kakhuri	Vazi Blend 2007	Vazi	Georgia	\N	Blend	WHITE	Table	13	1	3	2	1	22000	2007	750	5	\N	캠핑 와인으로 좋은 데일리 화이트. 시큼한/라이트한 균형이 안정적이에요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	아스카넬리의 안주없이 마실수 있는 와인 Vazi Blend 2007 (2007). 도수 13, 750ml.\n\n전체 톤은 구수한 맛의와 산미가 조금 있는의 균형. 타닌은 리치한 느낌, 단맛은 밋밋한 와인 쪽으로 읽힙니다. 그리고 돌려서 따는 마개 쪽으로 즐기기 좋아요.\n많이 비싸지 않은 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (데일리·대화용)	전체 톤은 구수한 맛의와 산미가 조금 있는의 균형. 타닌은 리치한 느낌, 단맛은 밋밋한 와인 쪽으로 읽힙니다. 그리고 돌려서 따는 마개 쪽으로 즐기기 좋아요.	오일 파스타, 회/초밥, 치즈 플래터	edge
ta189	Ibaci, Riesling Dolce	Pillitteri Estate 리슬링 Bear River Ontario 2005	Pillitteri Estate	Canada	Bear River Ontario	Riesling	WHITE	Dessert	11.5	4	2	3	1	27000	2005	750	5	\N	가볍게 시작하기 좋은 먹을만한 와인 화이트. 유자향이 좀 나는가 상쾌한 쪽이에요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	아이스와인의 떫지 않은 와인 Pillitteri Estate 리슬링 Bear River Ontario 2005 (2005). 도수 11.5, 750ml.\n\n알싸한 맛가 입맛을 깨우고, 농익은는 담백하게 이어집니다. 부담없이 넘어가는은 거칠지 않고 향긋한 느낌은 은근해요. 그리고 해산물과 잘어울리는 쪽으로 즐기기 좋아요.\n달달한 와인 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (마무리·대화용)	알싸한 맛가 입맛을 깨우고, 농익은는 담백하게 이어집니다. 부담없이 넘어가는은 거칠지 않고 향긋한 느낌은 은근해요. 그리고 해산물과 잘어울리는 쪽으로 즐기기 좋아요.	블루치즈 / 티라미수 / 치즈	edge
ta190	Aldo Conterno, Granbussia Barolo Riserva	Aldo Conterno Poderi Aldo Conterno 네비올로 Piemonte Barolo 2009	Aldo Conterno Poderi Aldo Conterno	Italy	Piemonte Barolo	Nebbiolo	RED	Table	15	1	4	4	5	2000000	2009	750	5	\N	많이 비싸지 않은 자리에서 빛나는 Nebbiolo 레드. 입안이 마르는듯한은 정돈되고 무게감이 느껴지는는 또렷해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Aldo Conterno Poderi Aldo Conterno 네비올로 Piemonte Barolo 2009는 선물용 와인 감성을 담은 무난한 선물용입니다. 2009 빈티지, 15 도수, 750ml.\n\n첫 인상은 침샘이 자극되는가 또렷하고, 텍스처는 점성이 강한로 느껴집니다. 피니시는 입안이 마르는듯한, 단맛은 음료수같은 와인 쪽으로 해석할 수 있어요. — 메인음식과 함께 먹는 무드로 이해하면 좋아요.\n데일리·대화용에 두고 천천히 즐기면 밸런스가 더 살아나요.	첫 인상은 침샘이 자극되는가 또렷하고, 텍스처는 점성이 강한로 느껴집니다. 피니시는 입안이 마르는듯한, 단맛은 음료수같은 와인 쪽으로 해석할 수 있어요. — 메인음식과 함께 먹는 무드로 이해하면 좋아요.	로스트 비프(후추/허브), 숙성 치즈, 미트소스/라구	edge
ta191	Cellier de Marrenon, Cotes du Luberon Rouge Cuvee Marie Claire	Marrenon Cellier de Marrenon Grenache Syrah Rhone Luberon 2005	Marrenon Cellier de Marrenon	France	Rhone Luberon	Grenache Syrah&Shiraz Carignan	RED	Table	13	1	3	3	3	14000	2005	750	5	\N	구조감 자리에서 빛나는 Grenache Syrah 레드. 씁쓸한은 정돈되고 졸인듯한 느낌의는 또렷해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	구대륙의 고기랑 어울리는 와인 Marrenon Cellier de Marrenon Grenache Syrah Rhone Luberon 2005 (2005). 도수 13~14, 750ml.\n\n첫 인상은 새콤한 맛가 또렷하고, 텍스처는 잼같은 느낌로 느껴집니다. 피니시는 쓴맛, 단맛은 순한 맛 쪽으로 해석할 수 있어요. — 무난한 선물용 무드로 이해하면 좋아요.\n글라스 와인 용 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (데일리·대화용)	첫 인상은 새콤한 맛가 또렷하고, 텍스처는 잼같은 느낌로 느껴집니다. 피니시는 쓴맛, 단맛은 순한 맛 쪽으로 해석할 수 있어요. — 무난한 선물용 무드로 이해하면 좋아요.	치킨 스테이크(훈제), 숙성 치즈, 미트소스/라구	edge
ta192	Vampire, Merlot Rose	Vampire Winery 메를로 2004	Vampire Winery	Romania	\N	Merlot	RED	Table	13	1	4	3	3	35000	2004	750	5	\N	캠핑 와인으로 좋은 메를로 레드. 농익은 질감에 입안이 까끌까끌한 여운, 중심에 편하게.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Vampire Winery 메를로 2004는 선물하기 좋은 감성을 담은 고기랑 어울리는입니다. 2004 빈티지, 13 도수, 750ml.\n\n걸쭉한 맛 텍스처 위에 침샘이 자극되는가 살아 있고, 마무리는 떫떠름한 느낌이 정돈합니다. 순한 맛 뉘앙스는 과하지 않아요. 그리고 고기랑 어울리는 쪽으로 즐기기 좋아요.\n데일리·대화용에 두고 천천히 즐기면 밸런스가 더 살아나요.	걸쭉한 맛 텍스처 위에 침샘이 자극되는가 살아 있고, 마무리는 떫떠름한 느낌이 정돈합니다. 순한 맛 뉘앙스는 과하지 않아요. 그리고 고기랑 어울리는 쪽으로 즐기기 좋아요.	미트볼(그릴), 숙성 치즈, 미트소스/라구	edge
ta193	Royal Tokaji, Aszu Essensia	Royal Tokaji Furmint Harslevelu Muscat The Northeast TokajHegyalja 1996	Royal Tokaji	Hungary	The Northeast TokajHegyalja	Furmint Harslevelu Muscat	WHITE	Dessert	14	5	3	5	1	352000	1996	500	5	\N	마무리에 어울리는 Furmint Harslevelu Muscat 화이트. 산미가 조금 있는가 살아 있고 눅진한는 담백해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Royal Tokaji Furmint Harslevelu Muscat The Northeast TokajHegyalja 1996는 안주없이 마실수 있는 카테고리에서 품질이 뛰어난 와인 선택지로 좋은 편입니다. 1996 빈티지, 14~15 도수, 500ml.\n\n전체 톤은 꿀같은 와인와 새콤한 맛의 균형. 타닌은 약간 비린맛의, 단맛은 꿀같은 쪽으로 읽힙니다. — 마무리 무드로 이해하면 좋아요.\n마무리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	전체 톤은 꿀같은 와인와 새콤한 맛의 균형. 타닌은 약간 비린맛의, 단맛은 꿀같은 쪽으로 읽힙니다. — 마무리 무드로 이해하면 좋아요.	티라미수 / 다크 초콜릿 / 치즈	edge
ta194	Santero, Tesco Moscato Spumante	Santero 모스카토 Piemonte 2007	Santero	Italy	Piemonte	Moscato	SPARKLING	Appetizer, Dessert	6.5	4	2	2	1	10800	2007	750	5	\N	스위트 와인의 첫 잔으로 좋은 스파클링. 라이트한는 가볍고 산뜻해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Santero 모스카토 Piemonte 2007는 수퍼투스칸에서 온 축하하는 자리 스타일입니다. 2007 빈티지 기준 6.5 도수, 750ml 구성.\n\n키워드로 보면 부드러운 느낌의 텍스처 위에 톡톡 쏘는가 살아 있고, 마무리는 약간 비린맛의이 정돈합니다. 과실향이 나는 뉘앙스는 과하지 않아요. 특히 철사로 감겨져있는 상황에 잘 어울립니다.\n추천 상황은 데일리·대화용 쪽이에요.	부드러운 느낌의 텍스처 위에 톡톡 쏘는가 살아 있고, 마무리는 약간 비린맛의이 정돈합니다. 과실향이 나는 뉘앙스는 과하지 않아요. 특히 철사로 감겨져있는 상황에 잘 어울립니다.	과일 타르트 / 견과류 / 치즈	edge
ta195	Palo Alto Sauvignon-blanc	Gallo Family Vineyard  EJ Gallo Winery Sauvignon-blanc Maule Valley 2014	Gallo Family Vineyard  EJ Gallo Winery	Chile	Maule Valley	Sauvignon-blanc	WHITE	Table	12	1	4	2	1	9900	2014	750	5	\N	시중 와인 Sauvignon-blanc 화이트. 탄산음료같은 느낌으로 메인에 산뜻해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	1865의 돌려서 따는 마개 와인 Gallo Family Vineyard EJ Gallo Winery Sauvignon-blanc Maule Valley 2014 (2014). 도수 12, 750ml.\n\n침샘이 자극되는가 입맛을 깨우고, 구수한 맛의는 담백하게 이어집니다. 둥글둥글한은 거칠지 않고 음료수같은 와인 느낌은 은근해요. 그리고 떫지 않은 쪽으로 즐기기 좋아요.\n메인음식과 함께 먹는 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (데일리·대화용)	침샘이 자극되는가 입맛을 깨우고, 구수한 맛의는 담백하게 이어집니다. 둥글둥글한은 거칠지 않고 음료수같은 와인 느낌은 은근해요. 그리고 떫지 않은 쪽으로 즐기기 좋아요.	새우/조개, 흰살 생선구이, 치즈 플래터	edge
ta196	Tesco Cava Demi Sec	Freixenet Macabeo Xarel.lo Parellada 2006	Freixenet	Spain	\N	Macabeo Xarel.lo Parellada	SPARKLING	Appetizer	11.5	3	2	2	1	13800	2006	750	5	\N	시중 와인 스파클링 한 병. 포인트는 미끌미끌한 느낌 청량감이에요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	눅진한 스타일 생산자의 펑 하고 터지는 와인 Freixenet Macabeo Xarel.lo Parellada 2006. 2006 빈티지, 도수 11.5, 750ml.\n\n입안에서는 부드러운 느낌의/유자향이 좀 나는가 중심을 잡고, 마무리는 부담없이 넘어가는이 정돈합니다.\n첫잔에 두면 실패 확률이 낮아요. (첫잔·파티)	향에서는 스위트한 맛의 인상이 먼저 오고, 입안에서는 톡톡 쏘는가 균형을 잡습니다. 질감은 마시기 적당한, 여운은 약간 비린맛의 쪽으로 정리돼요. — 첫잔 무드로 이해하면 좋아요.	굴/해산물, 튀김, 과일	edge
ta197	Martinez Bujanda, Candidato Tempranillo Red	Martinez Bujanda 템프라니요 La Mancha 2019	Martinez Bujanda	Spain	La Mancha	Tempranillo	RED	Table	12	1	3	3	2	9900	2019	750	5	\N	오늘은 입문 와인 레드. 걸쭉한 맛 중심으로 가고 혀가 아리는 느낌은 과하지 않아요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Martinez Bujanda 템프라니요 La Mancha 2019는 가성비좋은 구대륙 와인에서 온 무난한 선물용 스타일입니다. 2019 빈티지 기준 12 도수, 750ml 구성.\n\n키워드로 보면 향에서는 향기가 좋은 인상이 먼저 오고, 입안에서는 입에 침이 고이는 정도가 균형을 잡습니다. 질감은 농익은, 여운은 무난한 느낌 쪽으로 정리돼요. 그리고 많이 비싸지 않은 쪽으로 즐기기 좋아요.\n추천 상황은 데일리·대화용 쪽이에요.	향에서는 향기가 좋은 인상이 먼저 오고, 입안에서는 입에 침이 고이는 정도가 균형을 잡습니다. 질감은 농익은, 여운은 무난한 느낌 쪽으로 정리돼요. 그리고 많이 비싸지 않은 쪽으로 즐기기 좋아요.	버섯 그릴(후추/허브), 숙성 치즈, 미트소스/라구	edge
ta198	Chateau de Laborde	Chateau de Laborde Semillon Sauvignon-blanc Bordeaux 2004	Chateau de Laborde	France	Bordeaux	Semillon Sauvignon-blanc	WHITE	Table	14	1	3	2	1	14000	2004	750	5	\N	보르도 스타일 Semillon Sauvignon-blanc 화이트 — 입에 침이 고이는 정도가 또렷하고 라이트한가 깔끔해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Chateau de Laborde Semillon Sauvignon-blanc Bordeaux 2004는 보르도에서 온 청포도로 만든 스타일입니다. 2004 빈티지 기준 14~15 도수, 750ml 구성.\n\n키워드로 보면 새콤한 맛가 입맛을 깨우고, 부드러운 느낌의는 담백하게 이어집니다. 리치한 느낌은 거칠지 않고 순한 맛 느낌은 은근해요. 그리고 안주없이 마실수 있는 쪽으로 즐기기 좋아요.\n추천 상황은 데일리·대화용 쪽이에요.	새콤한 맛가 입맛을 깨우고, 부드러운 느낌의는 담백하게 이어집니다. 리치한 느낌은 거칠지 않고 순한 맛 느낌은 은근해요. 그리고 안주없이 마실수 있는 쪽으로 즐기기 좋아요.	새우/조개, 회/초밥, 치즈 플래터	edge
ta199	Sine Qua Non, Male Syrah	Sine Qua Non 시라 California 2013	Sine Qua Non	USA	California	Syrah&Shiraz Petite Sirah mourvedre	RED	Table	13	1	3	5	5	3000000	2013	1500	5	\N	식욕을 증진시키는 자리에서 빛나는 시라 레드. 혀끝이 조여드는 느낌은 정돈되고 꿀같은 와인는 또렷해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	나파밸리 생산자의 작업주 와인 Sine Qua Non 시라 California 2013. 2013 빈티지, 도수 13~14, 1500ml.\n\n입안에서는 눅진한/입에 침이 고이는 정도가 중심을 잡고, 마무리는 완전 떫은 맛이 정돈합니다.\n많이 비싸지 않은에 두면 실패 확률이 낮아요. (데일리·대화용)	꿀같은 와인 텍스처 위에 새콤한 맛가 살아 있고, 마무리는 찌꺼기가 있는이 정돈합니다. 향기가 좋은 뉘앙스는 과하지 않아요. 특히 많이 비싸지 않은 상황에 잘 어울립니다.	로스트 비프(토마토 라구), 숙성 치즈, 미트소스/라구	edge
ta200	Castel MiMi, Classic Merlot	Castel MiMi 메를로 2015	Castel MiMi	Moldova	\N	Merlot	RED	Table	14	1	3	3	3	48000	2015	750	5	\N	가성비 와인 선택지로 좋은 메를로 레드. 씁쓸한/걸쭉한 맛 밸런스형.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Castel MiMi 메를로 2015는 페테아스카에서 온 무난한 선물용 스타일입니다. 2015 빈티지 기준 14~15 도수, 750ml 구성.\n\n키워드로 보면 향에서는 향기가 좋은 인상이 먼저 오고, 입안에서는 시큼한가 균형을 잡습니다. 질감은 농익은, 여운은 쌍화탕같은 맛의 쪽으로 정리돼요. 특히 구조감 상황에 잘 어울립니다.\n추천 상황은 데일리·대화용 쪽이에요.	향에서는 향기가 좋은 인상이 먼저 오고, 입안에서는 시큼한가 균형을 잡습니다. 질감은 농익은, 여운은 쌍화탕같은 맛의 쪽으로 정리돼요. 특히 구조감 상황에 잘 어울립니다.	미트볼(훈제), 숙성 치즈, 미트소스/라구	edge
ta201	Finca el Origen Cabernet-Sauvignon	Finca el Origen Cabernet-Sauvignon Mendoza 2016	Finca el Origen	Argentina	Mendoza	Cabernet-Sauvignon	RED	Table	14	1	3	3	2	11000	2016	750	5	\N	오늘은 입문 와인 레드. 농익은 중심으로 가고 까칠까칠한 맛은 과하지 않아요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Finca el Origen Cabernet-Sauvignon Mendoza 2016는 멘도사에서 온 탄닌이 있는 스타일입니다. 2016 빈티지 기준 14 도수, 750ml 구성.\n\n키워드로 보면 향에서는 밋밋한 와인 인상이 먼저 오고, 입안에서는 시큼한가 균형을 잡습니다. 질감은 농익은, 여운은 맛깔스러운 맛 쪽으로 정리돼요. 특히 무난한 선물용 상황에 잘 어울립니다.\n추천 상황은 데일리·대화용 쪽이에요.	향에서는 밋밋한 와인 인상이 먼저 오고, 입안에서는 시큼한가 균형을 잡습니다. 질감은 농익은, 여운은 맛깔스러운 맛 쪽으로 정리돼요. 특히 무난한 선물용 상황에 잘 어울립니다.	미트볼(후추/허브), 숙성 치즈, 미트소스/라구	edge
ta213	Alma Flamenca Smiseco	Bodegas Fernando Castro 템프라니요 2015	Bodegas Fernando Castro	Spain	\N	Tempranillo	RED	Table	14	3	2	3	3	11000	2015	750	5	\N	마트 와인 선택지로 좋은 템프라니요 레드. 입안이 까끌까끌한/걸쭉한 맛 밸런스형.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Bodegas Fernando Castro 템프라니요 2015는 고기랑 어울리는 카테고리에서 입문 와인 선택지로 좋은 편입니다. 2015 빈티지, 14~15 도수, 750ml.\n\n향에서는 달큰한 인상이 먼저 오고, 입안에서는 미끌미끌한 느낌가 균형을 잡습니다. 질감은 농익은, 여운은 쓴맛 쪽으로 정리돼요. 특히 무난한 선물용 상황에 잘 어울립니다.\n데일리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	향에서는 달큰한 인상이 먼저 오고, 입안에서는 미끌미끌한 느낌가 균형을 잡습니다. 질감은 농익은, 여운은 쓴맛 쪽으로 정리돼요. 특히 무난한 선물용 상황에 잘 어울립니다.	치킨 스테이크(그릴), 숙성 치즈, 미트소스/라구	edge
ta202	Zlatan Otok, Plavac Organic	Zlatan Otok Plavac Mali Dalmatia 2014	Zlatan Otok	Croatia	Dalmatia	Plavac Mali	RED	Table	13.8	1	2	4	3	39000	2014	750	5	\N	가성비 와인 Plavac Mali 레드. 무게감이 느껴지는 질감에 씁쓸한 여운, 식욕을 증진시키는에 편하게.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Zlatan Otok Plavac Mali Dalmatia 2014는 무난한 선물용 카테고리에서 무난한 와인 선택지로 좋은 편입니다. 2014 빈티지, 13.8 도수, 750ml.\n\n향에서는 단맛이 조금 나는 인상이 먼저 오고, 입안에서는 톡톡 쏘는가 균형을 잡습니다. 질감은 점성이 강한, 여운은 떫떠름한 느낌 쪽으로 정리돼요. — 고기랑 어울리는 무드로 이해하면 좋아요.\n데일리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	향에서는 단맛이 조금 나는 인상이 먼저 오고, 입안에서는 톡톡 쏘는가 균형을 잡습니다. 질감은 점성이 강한, 여운은 떫떠름한 느낌 쪽으로 정리돼요. — 고기랑 어울리는 무드로 이해하면 좋아요.	스테이크(후추/허브), 숙성 치즈, 미트소스/라구	edge
ta203	Domaine Leroy, Nuits Saint Georges 'Aux Bas de Combes'	Domaine Leroy 피노 누아 Bourgogne Cote de Nuits 2007	Domaine Leroy	France	Bourgogne Cote de Nuits	Pinot Noir	RED	Table	13	1	4	4	3	1750000	2007	750	5	\N	글라스 와인 용 자리에서 빛나는 피노 누아 레드. 떫떠름한 느낌은 정돈되고 포도 원액 느낌는 또렷해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	무통로칠드 생산자의 탄닌이 있는 와인 Domaine Leroy 피노 누아 Bourgogne Cote de Nuits 2007. 2007 빈티지, 도수 13~14, 750ml.\n\n입안에서는 무게감이 느껴지는/짜릿한 맛가 중심을 잡고, 마무리는 입안이 까끌까끌한이 정돈합니다.\n메인에 두면 실패 확률이 낮아요. (데일리·대화용)	맛이 신가 입맛을 깨우고, 무게감이 느껴지는는 담백하게 이어집니다. 씁쓸한은 거칠지 않고 밋밋한 와인 느낌은 은근해요. — 글라스 와인 용 무드로 이해하면 좋아요.	양갈비(토마토 라구), 숙성 치즈, 미트소스/라구	edge
ta204	Santemaru Apple Dry wine	Yeongju wine Apple Busa Gyeongsangbukdo Yeongju 2011	Yeongju wine	Korea	Gyeongsangbukdo Yeongju	Apple Busa	WHITE	Table	12	1	4	3	1	35000	2011	750	5	\N	청수 스타일 Apple Busa 화이트 — 입안이 얼얼한가 또렷하고 졸인듯한 느낌의가 깔끔해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Yeongju wine Apple Busa Gyeongsangbukdo Yeongju 2011는 청수 감성을 담은 안주없이 마실수 있는입니다. 2011 빈티지, 12 도수, 750ml.\n\n잼같은 느낌 텍스처 위에 침샘이 자극되는가 살아 있고, 마무리는 부담없이 넘어가는이 정돈합니다. 순한 맛 뉘앙스는 과하지 않아요. — 돌려서 따는 마개 무드로 이해하면 좋아요.\n데일리·대화용에 두고 천천히 즐기면 밸런스가 더 살아나요.	잼같은 느낌 텍스처 위에 침샘이 자극되는가 살아 있고, 마무리는 부담없이 넘어가는이 정돈합니다. 순한 맛 뉘앙스는 과하지 않아요. — 돌려서 따는 마개 무드로 이해하면 좋아요.	흰살 생선구이, 오일 파스타, 치즈 플래터	edge
ta205	Penfolds, Grange	Penfolds 시라 South Australia 2009	Penfolds	Australia	South Australia	Syrah&Shiraz Cabernet-Sauvignon	RED	Table	14	1	4	5	5	1500000	2009	750	5	\N	국내에서는 구하기 어려운 시라 레드. 위스키 느낌의 질감에 찌꺼기가 있는 여운, 음식과함께에 편하게.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	바로사밸리 생산자의 와인다운 와인 Penfolds 시라 South Australia 2009. 2009 빈티지, 도수 14~15, 750ml.\n\n입안에서는 위스키 느낌의/짜릿한 맛가 중심을 잡고, 마무리는 찌꺼기가 있는이 정돈합니다.\n식욕을 증진시키는에 두면 실패 확률이 낮아요. (데일리·대화용)	침샘이 자극되는가 입맛을 깨우고, 눅진한는 담백하게 이어집니다. 자극적인 맛은 거칠지 않고 밋밋한 와인 느낌은 은근해요. 그리고 중심 쪽으로 즐기기 좋아요.	바비큐 립(훈제), 숙성 치즈, 미트소스/라구	edge
ta206	Domaine Leroy, Clos de Vougeot Grand Cru	Domaine Leroy 피노 누아 Bourgogne Cote de Nuits 2009	Domaine Leroy	France	Bourgogne Cote de Nuits	Pinot Noir	RED	Table	13	1	4	3	3	4100000	2009	750	5	\N	최고급 와인으로 꼽는 선택지로 좋은 피노 누아 레드. 쓴맛/걸쭉한 맛 밸런스형.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Domaine Leroy 피노 누아 Bourgogne Cote de Nuits 2009는 탄닌이 있는 카테고리에서 최고급 와인으로 꼽는 선택지로 좋은 편입니다. 2009 빈티지, 13~14 도수, 750ml.\n\n침샘이 자극되는가 입맛을 깨우고, 졸인듯한 느낌의는 담백하게 이어집니다. 쓴맛은 거칠지 않고 향기가 좋은 느낌은 은근해요. — 무난한 선물용 무드로 이해하면 좋아요.\n데일리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	침샘이 자극되는가 입맛을 깨우고, 졸인듯한 느낌의는 담백하게 이어집니다. 쓴맛은 거칠지 않고 향기가 좋은 느낌은 은근해요. — 무난한 선물용 무드로 이해하면 좋아요.	햄·살라미(트러플), 숙성 치즈, 미트소스/라구	edge
ta207	Don Pascual Tannat Crianza Roble	Establecimiento Juanico Tannat 2015	Establecimiento Juanico	Uruguay	\N	Tannat	RED	Table	13	1	3	3	3	55000	2015	750	5	\N	메인 자리에서 빛나는 Tannat 레드. 쓴맛은 정돈되고 막걸리같은는 또렷해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Establecimiento Juanico Tannat 2015는 타나 감성을 담은 와인다운입니다. 2015 빈티지, 13~14 도수, 750ml.\n\n새콤한 맛가 입맛을 깨우고, 걸쭉한 맛는 담백하게 이어집니다. 입안이 까끌까끌한은 거칠지 않고 단맛이 조금 나는 느낌은 은근해요. 특히 글라스 와인 용 상황에 잘 어울립니다.\n데일리·대화용에 두고 천천히 즐기면 밸런스가 더 살아나요.	새콤한 맛가 입맛을 깨우고, 걸쭉한 맛는 담백하게 이어집니다. 입안이 까끌까끌한은 거칠지 않고 단맛이 조금 나는 느낌은 은근해요. 특히 글라스 와인 용 상황에 잘 어울립니다.	햄·살라미(트러플), 숙성 치즈, 미트소스/라구	edge
ta208	Sine Qua Non, Le Supplement Syrah	Sine Qua Non 시라 California Napa County 2013	Sine Qua Non	USA	California Napa County	Syrah&Shiraz Petite Sirah Grenache	RED	Table	13	1	4	5	5	3400000	2013	750	5	\N	아무나 쉽게 못마시는 선택지로 좋은 시라 레드. 찌꺼기가 있는/꿀같은 와인 밸런스형.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Sine Qua Non 시라 California Napa County 2013는 로버트몬다비 감성을 담은 탄닌이 있는입니다. 2013 빈티지, 13~14 도수, 750ml.\n\n첫 인상은 탄산음료같은가 또렷하고, 텍스처는 눅진한로 느껴집니다. 피니시는 혀끝이 조여드는 느낌, 단맛은 음료수같은 와인 쪽으로 해석할 수 있어요. — 많이 비싸지 않은 무드로 이해하면 좋아요.\n데일리·대화용에 두고 천천히 즐기면 밸런스가 더 살아나요.	첫 인상은 탄산음료같은가 또렷하고, 텍스처는 눅진한로 느껴집니다. 피니시는 혀끝이 조여드는 느낌, 단맛은 음료수같은 와인 쪽으로 해석할 수 있어요. — 많이 비싸지 않은 무드로 이해하면 좋아요.	스테이크(후추/허브), 숙성 치즈, 미트소스/라구	edge
ta209	Oremus, Tokaji Aszu 3 Puttonyos	Tokaj Oremus Malagousia Assyrtiko The Northeast TokajHegyalja 2010	Tokaj Oremus	Hungary	The Northeast TokajHegyalja	Malagousia Assyrtiko	WHITE	Dessert	14	5	2	4	1	66000	2010	500	5	\N	데이트때 마시기 좋은 Malagousia Assyrtiko 화이트. 알싸한 맛 느낌으로 소화를 돕는 와인에 산뜻해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Tokaj Oremus Malagousia Assyrtiko The Northeast TokajHegyalja 2010는 청포도로 만든 카테고리에서 가격이 부담스럽지 않은 와인 선택지로 좋은 편입니다. 2010 빈티지, 14~15 도수, 500ml.\n\n향에서는 꿀같은 인상이 먼저 오고, 입안에서는 유자향이 좀 나는가 균형을 잡습니다. 질감은 점성이 강한, 여운은 리치한 느낌 쪽으로 정리돼요. 그리고 떫지 않은 쪽으로 즐기기 좋아요.\n마무리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	향에서는 꿀같은 인상이 먼저 오고, 입안에서는 유자향이 좀 나는가 균형을 잡습니다. 질감은 점성이 강한, 여운은 리치한 느낌 쪽으로 정리돼요. 그리고 떫지 않은 쪽으로 즐기기 좋아요.	다크 초콜릿 / 치즈	edge
ta210	Reia, Rebula	Reia Rebula Goriska Brda 2017	Reia	Slovenia	Goriska Brda	Rebula	WHITE	Appetizer, Table	12	1	4	3	1	98000	2017	750	5	\N	알코올 도수 낮은에 어울리는 Rebula 화이트. 입안이 얼얼한가 살아 있고 농익은는 담백해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Reia Rebula Goriska Brda 2017는 안주없이 마실수 있는 카테고리에서 데이트때 마시기 좋은 선택지로 좋은 편입니다. 2017 빈티지, 12~13 도수, 750ml.\n\n전체 톤은 막걸리같은와 탄산음료같은의 균형. 타닌은 둥글둥글한, 단맛은 단맛이 조금 나는 쪽으로 읽힙니다. 특히 떫지 않은 상황에 잘 어울립니다.\n데일리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	전체 톤은 막걸리같은와 탄산음료같은의 균형. 타닌은 둥글둥글한, 단맛은 단맛이 조금 나는 쪽으로 읽힙니다. 특히 떫지 않은 상황에 잘 어울립니다.	회/초밥, 오일 파스타, 치즈 플래터	edge
ta211	Patricius Tokaji Late Harvest Katinka	Patricius Tokaji Limnio The Northeast TokajHegyalja 2017	Patricius Tokaji	Hungary	The Northeast TokajHegyalja	Limnio	WHITE	Dessert	12.5	5	1	4	1	80000	2017	375	5	\N	가볍게 시작하기 좋은 발렌타인날 마시기 좋은 화이트. 산뜻한 느낌이 나는가 상쾌한 쪽이에요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	토카이 와인의 안주없이 마실수 있는 와인 Patricius Tokaji Limnio The Northeast TokajHegyalja 2017 (2017). 도수 12.5, 375ml.\n\n첫 인상은 깔끔한 스타일가 또렷하고, 텍스처는 점성이 강한로 느껴집니다. 피니시는 부담없이 넘어가는, 단맛은 설탕물 같은 쪽으로 해석할 수 있어요. 그리고 안주없이 마실수 있는 쪽으로 즐기기 좋아요.\n달달한 와인 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (마무리·대화용)	첫 인상은 깔끔한 스타일가 또렷하고, 텍스처는 점성이 강한로 느껴집니다. 피니시는 부담없이 넘어가는, 단맛은 설탕물 같은 쪽으로 해석할 수 있어요. 그리고 안주없이 마실수 있는 쪽으로 즐기기 좋아요.	티라미수 / 과일 타르트 / 치즈	edge
ta212	Dugat Py, Mazis Chambertin Grand Cru	Domaine Bernard Dugat Py 피노 누아 Bourgogne Cote de Nuits 2010	Domaine Bernard Dugat Py	France	Bourgogne Cote de Nuits	Pinot Noir	RED	Table	13	1	4	4	3	2800000	2010	750	5	\N	식욕을 증진시키는 자리에서 빛나는 피노 누아 레드. 떫떠름한 느낌은 정돈되고 농축된는 또렷해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	구대륙 생산자의 무난한 선물용 와인 Domaine Bernard Dugat Py 피노 누아 Bourgogne Cote de Nuits 2010. 2010 빈티지, 도수 13~14, 750ml.\n\n입안에서는 농축된/탄산음료같은가 중심을 잡고, 마무리는 쌍화탕같은 맛의이 정돈합니다.\n균형에 두면 실패 확률이 낮아요. (데일리·대화용)	끈끈한 느낌의 텍스처 위에 짜릿한 맛가 살아 있고, 마무리는 씁쓸한이 정돈합니다. 음료수같은 와인 뉘앙스는 과하지 않아요. — 무난한 선물용 무드로 이해하면 좋아요.	양갈비(후추/허브), 숙성 치즈, 미트소스/라구	edge
ta214	Berry Bros. & Rudd, English Sparkling Wine	Berry Bros  Rudd Chardonnay Pinot Noir 2010	Berry Bros  Rudd	UK	\N	Chardonnay Pinot Noir	SPARKLING	Appetizer	12	1	4	2	1	49900	2010	750	5	\N	캠핑 와인으로 좋은 스파클링 한 병. 포인트는 짜릿한 맛 청량감이에요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Berry Bros Rudd Chardonnay Pinot Noir 2010는 해크니 감성을 담은 펑 하고 터지는입니다. 2010 빈티지, 12 도수, 750ml.\n\n첫 인상은 입안이 얼얼한가 또렷하고, 텍스처는 묵직한 느낌의로 느껴집니다. 피니시는 목넘김이 좋은, 단맛은 순한 맛 쪽으로 해석할 수 있어요. 특히 호텔 웰컴주 와인 상황에 잘 어울립니다.\n첫잔·파티에 두고 천천히 즐기면 밸런스가 더 살아나요.	첫 인상은 입안이 얼얼한가 또렷하고, 텍스처는 묵직한 느낌의로 느껴집니다. 피니시는 목넘김이 좋은, 단맛은 순한 맛 쪽으로 해석할 수 있어요. 특히 호텔 웰컴주 와인 상황에 잘 어울립니다.	치즈, 과일	edge
ta215	Domaine Bizot Echezeaux	Domaine Bizot 피노 누아 Bourgogne Cote de Nuits 2018	Domaine Bizot	France	Bourgogne Cote de Nuits	Pinot Noir	RED	Table	14.5	1	4	3	3	2475000	2018	750	5	\N	오늘은 아무나 쉽게 못마시는 레드. 막걸리같은 중심으로 가고 쌍화탕같은 맛의은 과하지 않아요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Domaine Bizot 피노 누아 Bourgogne Cote de Nuits 2018는 구대륙에서 온 와인다운 스타일입니다. 2018 빈티지 기준 14.5~18 도수, 750ml 구성.\n\n키워드로 보면 탄산음료같은가 입맛을 깨우고, 막걸리같은는 담백하게 이어집니다. 쓴맛은 거칠지 않고 순한 맛 느낌은 은근해요. 특히 많이 비싸지 않은 상황에 잘 어울립니다.\n추천 상황은 데일리·대화용 쪽이에요.	탄산음료같은가 입맛을 깨우고, 막걸리같은는 담백하게 이어집니다. 쓴맛은 거칠지 않고 순한 맛 느낌은 은근해요. 특히 많이 비싸지 않은 상황에 잘 어울립니다.	치킨 스테이크(토마토 라구), 숙성 치즈, 미트소스/라구	edge
ta216	Feudi Aragonesi, Montepulciano d'Abruzzo 'Casal Bordino'	Feudi Aragonesi Montepulciano Abruzzo 2005	Feudi Aragonesi	Italy	Abruzzo	Montepulciano	RED	Table	14	1	4	3	3	14000	2005	750	5	\N	데일리 와인 Montepulciano 레드. 졸인듯한 느낌의 질감에 쌍화탕같은 맛의 여운, 식사떄 마시는 와인에 편하게.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Feudi Aragonesi Montepulciano Abruzzo 2005는 무난한 선물용 카테고리에서 시중 와인 선택지로 좋은 편입니다. 2005 빈티지, 14~15 도수, 750ml.\n\n향에서는 순한 맛 인상이 먼저 오고, 입안에서는 탄산음료같은가 균형을 잡습니다. 질감은 졸인듯한 느낌의, 여운은 입안이 까끌까끌한 쪽으로 정리돼요. — 메인 무드로 이해하면 좋아요.\n데일리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	향에서는 순한 맛 인상이 먼저 오고, 입안에서는 탄산음료같은가 균형을 잡습니다. 질감은 졸인듯한 느낌의, 여운은 입안이 까끌까끌한 쪽으로 정리돼요. — 메인 무드로 이해하면 좋아요.	미트볼(후추/허브), 숙성 치즈, 미트소스/라구	edge
ta217	Kabaj, Sivi Pinot	Kabaj 피노 그리지오 Goriska Brda 2014	Kabaj	Slovenia	Goriska Brda	Pinot Grigio	WHITE	Table	13	1	3	4	1	90000	2014	750	5	\N	식욕을 증진시키는에 어울리는 Pinot Grigio 화이트. 산미가 조금 있는가 살아 있고 점성이 강한는 담백해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Kabaj 피노 그리지오 Goriska Brda 2014는 말바지아에서 온 돌려서 따는 마개 스타일입니다. 2014 빈티지 기준 13 도수, 750ml 구성.\n\n키워드로 보면 향에서는 단맛이 조금 나는 인상이 먼저 오고, 입안에서는 시큼한가 균형을 잡습니다. 질감은 끈끈한 느낌의, 여운은 리치한 느낌 쪽으로 정리돼요. — 안주없이 마실수 있는 무드로 이해하면 좋아요.\n추천 상황은 데일리·대화용 쪽이에요.	향에서는 단맛이 조금 나는 인상이 먼저 오고, 입안에서는 시큼한가 균형을 잡습니다. 질감은 끈끈한 느낌의, 여운은 리치한 느낌 쪽으로 정리돼요. — 안주없이 마실수 있는 무드로 이해하면 좋아요.	크림 파스타, 치킨 크림, 치즈 플래터	edge
ta218	Undurraga, U Merlot	Undurraga Vina Undurraga 메를로 Central Valley 2015	Undurraga Vina Undurraga	Chile	Central Valley	Merlot	RED	Table	14.5	1	3	3	3	14000	2015	750	5	\N	콘차이토로 무드의 메를로 레드 — 씁쓸한 결이 살아 있고 막걸리같은가 탄탄해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Undurraga Vina Undurraga 메를로 Central Valley 2015는 마이포밸리 감성을 담은 작업주입니다. 2015 빈티지, 14.5~20 도수, 750ml.\n\n첫 인상은 시큼한가 또렷하고, 텍스처는 막걸리같은로 느껴집니다. 피니시는 떫떠름한 느낌, 단맛은 음료수같은 와인 쪽으로 해석할 수 있어요. — 식욕을 증진시키는 무드로 이해하면 좋아요.\n데일리·대화용에 두고 천천히 즐기면 밸런스가 더 살아나요.	첫 인상은 시큼한가 또렷하고, 텍스처는 막걸리같은로 느껴집니다. 피니시는 떫떠름한 느낌, 단맛은 음료수같은 와인 쪽으로 해석할 수 있어요. — 식욕을 증진시키는 무드로 이해하면 좋아요.	햄·살라미(토마토 라구), 숙성 치즈, 미트소스/라구	edge
ta220	Domaine A.F. Gros Richebourg	AF  Domaine AF Gros 피노 누아 Bourgogne Cote de Nuits 2018	AF  Domaine AF Gros	France	Bourgogne Cote de Nuits	Pinot Noir	RED	Table	13	1	4	4	3	2109000	2018	750	5	\N	구조감 자리에서 빛나는 피노 누아 레드. 쓴맛은 정돈되고 농축된는 또렷해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	5대샤또의 고기랑 어울리는 와인 AF Domaine AF Gros 피노 누아 Bourgogne Cote de Nuits 2018 (2018). 도수 13~14, 750ml.\n\n포도 원액 느낌 텍스처 위에 짜릿한 맛가 살아 있고, 마무리는 쓴맛이 정돈합니다. 밋밋한 와인 뉘앙스는 과하지 않아요. — 작업주 무드로 이해하면 좋아요.\n식사떄 마시는 와인 맥락에서 한 병으로 분위기 만들기 좋은 타입입니다. (데일리·대화용)	포도 원액 느낌 텍스처 위에 짜릿한 맛가 살아 있고, 마무리는 쓴맛이 정돈합니다. 밋밋한 와인 뉘앙스는 과하지 않아요. — 작업주 무드로 이해하면 좋아요.	소갈비(트러플), 숙성 치즈, 미트소스/라구	edge
ta221	Martinez Bujanda, Candidato Tempranillo Rose	Martinez Bujanda 템프라니요 La Mancha 2012	Martinez Bujanda	Spain	La Mancha	Tempranillo	ROSE	Appetizer, Table	12	2	3	3	1	9900	2012	750	5	\N	데일리 와인 로제. 시큼한가 상큼해서 가벼움에 가볍게 좋아요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Martinez Bujanda 템프라니요 La Mancha 2012는 발렌타인 데이 선물 카테고리에서 데일리 와인 선택지로 좋은 편입니다. 2012 빈티지, 12 도수, 750ml.\n\n첫 인상은 입안이 개운한가 또렷하고, 텍스처는 농익은로 느껴집니다. 피니시는 둥글둥글한, 단맛은 시트러스한 향의 와인 쪽으로 해석할 수 있어요. 특히 발렌타인 데이 선물 상황에 잘 어울립니다.\n데일리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	첫 인상은 입안이 개운한가 또렷하고, 텍스처는 농익은로 느껴집니다. 피니시는 둥글둥글한, 단맛은 시트러스한 향의 와인 쪽으로 해석할 수 있어요. 특히 발렌타인 데이 선물 상황에 잘 어울립니다.	샌드위치, 타파스, 치즈	edge
ta222	Mansus, Dimenzija Rebula	Mansus Cabernet-Sauvignon Cabernet-Franc Merlot Vipava 2015	Mansus	Slovenia	Vipava	Cabernet-Sauvignon Cabernet-Franc Merlot	WHITE	Table	13	1	4	2	1	98000	2015	750	5	\N	음식과함께에 어울리는 Cabernet-Sauvignon Cabernet-Franc Merlot 화이트. 침샘이 자극되는가 살아 있고 구수한 맛의는 담백해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	유기농 와인 생산자의 해산물과 잘어울리는 와인 Mansus Cabernet-Sauvignon Cabernet-Franc Merlot Vipava 2015. 2015 빈티지, 도수 13~14, 750ml.\n\n입안에서는 라이트한/짜릿한 맛가 중심을 잡고, 마무리는 약간 비린맛의이 정돈합니다.\n식사떄 마시는 와인에 두면 실패 확률이 낮아요. (데일리·대화용)	첫 인상은 입안이 얼얼한가 또렷하고, 텍스처는 라이트한로 느껴집니다. 피니시는 부담없이 넘어가는, 단맛은 밋밋한 와인 쪽으로 해석할 수 있어요. — 메인 무드로 이해하면 좋아요.	새우/조개, 치즈 플래터	edge
ta223	Domaine Arnoux Lachaux, Grand Cru 'Romanee Saint Vivant'	Domaine ArnouxLachaux 피노 누아 Bourgogne Cote de Nuits 2017	Domaine ArnouxLachaux	France	Bourgogne Cote de Nuits	Pinot Noir	RED	Table	13	1	3	4	3	2750000	2017	750	5	\N	호불호 없는 무드의 피노 누아 레드 — 쌍화탕같은 맛의 결이 살아 있고 무게감이 느껴지는가 탄탄해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Domaine ArnouxLachaux 피노 누아 Bourgogne Cote de Nuits 2017는 탄닌이 있는 카테고리에서 아무나 쉽게 못마시는 선택지로 좋은 편입니다. 2017 빈티지, 13~14 도수, 750ml.\n\n첫 인상은 시큼한가 또렷하고, 텍스처는 농축된로 느껴집니다. 피니시는 씁쓸한, 단맛은 음료수같은 와인 쪽으로 해석할 수 있어요. 특히 중심 상황에 잘 어울립니다.\n데일리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	첫 인상은 시큼한가 또렷하고, 텍스처는 농축된로 느껴집니다. 피니시는 씁쓸한, 단맛은 음료수같은 와인 쪽으로 해석할 수 있어요. 특히 중심 상황에 잘 어울립니다.	바비큐 립(토마토 라구), 숙성 치즈, 미트소스/라구	edge
ta224	Maro Cellar, Mursa Yellow Muscat	Maro Cellar Grenache Carignan Stajerska Slovenija Stajerska Slovenija 2019	Maro Cellar	Slovenia	Stajerska Slovenija Stajerska Slovenija	Grenache Carignan	WHITE	Table, Etc	10	2	3	3	1	83000	2019	750	5	\N	비파바 스타일 Grenache Carignan 화이트 — 시큼한가 또렷하고 잼같은 느낌가 깔끔해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Maro Cellar Grenache Carignan Stajerska Slovenija Stajerska Slovenija 2019는 해산물과 잘어울리는 카테고리에서 가격이 부담스럽지 않은 와인 선택지로 좋은 편입니다. 2019 빈티지, 10~11 도수, 750ml.\n\n입안이 개운한가 입맛을 깨우고, 막걸리같은는 담백하게 이어집니다. 약간 비린맛의은 거칠지 않고 좋은 냄새가 나는 느낌은 은근해요. — 글라스 와인 용 무드로 이해하면 좋아요.\n데일리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	입안이 개운한가 입맛을 깨우고, 막걸리같은는 담백하게 이어집니다. 약간 비린맛의은 거칠지 않고 좋은 냄새가 나는 느낌은 은근해요. — 글라스 와인 용 무드로 이해하면 좋아요.	새우/조개, 회/초밥, 치즈 플래터	edge
ta225	Castlebrook, Muscat Ottonal	Castlebrook 뮈스까 2004	Castlebrook	Romania	\N	Muscat	WHITE	Dessert	12.5	5	1	3	1	25000	2004	750	5	\N	생소한 품종 스타일 Muscat 화이트 — 환타 맛이 나는가 또렷하고 막걸리같은가 깔끔해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Castlebrook 뮈스까 2004는 선물하기 좋은에서 온 해산물과 잘어울리는 스타일입니다. 2004 빈티지 기준 12.5 도수, 750ml 구성.\n\n키워드로 보면 향에서는 설탕물 같은 인상이 먼저 오고, 입안에서는 산뜻한 느낌이 나는가 균형을 잡습니다. 질감은 졸인듯한 느낌의, 여운은 리치한 느낌 쪽으로 정리돼요. — 응축 무드로 이해하면 좋아요.\n추천 상황은 마무리·대화용 쪽이에요.	향에서는 설탕물 같은 인상이 먼저 오고, 입안에서는 산뜻한 느낌이 나는가 균형을 잡습니다. 질감은 졸인듯한 느낌의, 여운은 리치한 느낌 쪽으로 정리돼요. — 응축 무드로 이해하면 좋아요.	견과류 / 다크 초콜릿 / 치즈	edge
ta226	Frelih, Modra Frankinja	Frelih Blaufrankisch 2016	Frelih	Slovenia	\N	Blaufrankisch	RED	Table	14	1	4	5	4	90000	2016	750	5	\N	가격이 부담스럽지 않은 와인 Blaufrankisch 레드. 눅진한 질감에 쿰쿰한 맛이 느껴지는 여운, 식욕을 증진시키는에 편하게.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Frelih Blaufrankisch 2016는 화이트 와인으로 유명한 감성을 담은 작업주입니다. 2016 빈티지, 14~15 도수, 750ml.\n\n향에서는 순한 맛 인상이 먼저 오고, 입안에서는 맛이 신가 균형을 잡습니다. 질감은 진득한 느낌의, 여운은 달콤쌉쌀한 쪽으로 정리돼요. 특히 글라스 와인 용 상황에 잘 어울립니다.\n데일리·대화용에 두고 천천히 즐기면 밸런스가 더 살아나요.	향에서는 순한 맛 인상이 먼저 오고, 입안에서는 맛이 신가 균형을 잡습니다. 질감은 진득한 느낌의, 여운은 달콤쌉쌀한 쪽으로 정리돼요. 특히 글라스 와인 용 상황에 잘 어울립니다.	로스트 비프(그릴), 숙성 치즈, 미트소스/라구	edge
ta227	T7 Merlot	G7 메를로 Maule Valley Loncomilla Valley 2016	G7	Chile	Maule Valley Loncomilla Valley	Merlot	RED	Table	13	2	3	2	2	6480	2016	750	5	\N	오늘은 편의점 와인 레드. 라이트한 중심으로 가고 무난한 느낌은 과하지 않아요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	G7 메를로 Maule Valley Loncomilla Valley 2016는 고기랑 어울리는 카테고리에서 편의점 와인 선택지로 좋은 편입니다. 2016 빈티지, 13~14 도수, 750ml.\n\n새콤한 맛가 입맛을 깨우고, 부드러운 느낌의는 담백하게 이어집니다. 맛깔스러운 맛은 거칠지 않고 달짝지근한 느낌은 은근해요. 그리고 고기랑 어울리는 쪽으로 즐기기 좋아요.\n데일리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	새콤한 맛가 입맛을 깨우고, 부드러운 느낌의는 담백하게 이어집니다. 맛깔스러운 맛은 거칠지 않고 달짝지근한 느낌은 은근해요. 그리고 고기랑 어울리는 쪽으로 즐기기 좋아요.	미트볼(그릴), 숙성 치즈, 미트소스/라구	edge
ta228	Vinal Ice Wine, White	Vinal 샤르도네 2015	Vinal	Bulgaria	\N	Chardonnay	WHITE	Dessert	11	5	2	3	1	50000	2015	750	5	\N	생소한 국가 스타일 샤르도네 화이트 — 톡톡 쏘는가 또렷하고 걸쭉한 맛가 깔끔해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Vinal 샤르도네 2015는 떫지 않은 카테고리에서 가격이 부담스럽지 않은 와인 선택지로 좋은 편입니다. 2015 빈티지, 11 도수, 750ml.\n\n미끌미끌한 느낌가 입맛을 깨우고, 농익은는 담백하게 이어집니다. 약간 비린맛의은 거칠지 않고 꿀같은 느낌은 은근해요. 특히 해산물과 잘어울리는 상황에 잘 어울립니다.\n마무리·대화용에 특히 잘 맞고, 부담 없이 한 잔씩 나누기 좋아요.	미끌미끌한 느낌가 입맛을 깨우고, 농익은는 담백하게 이어집니다. 약간 비린맛의은 거칠지 않고 꿀같은 느낌은 은근해요. 특히 해산물과 잘어울리는 상황에 잘 어울립니다.	과일 타르트 / 견과류 / 치즈	edge
ta229	Lakeview Cellars Vidal Icewine	Diamond Estates Vidal Bear River Niagara Peninsula 2017	Diamond Estates	Canada	Bear River Niagara Peninsula	Vidal	WHITE	Dessert	11.5	5	3	4	1	49000	2017	375	5	\N	스위트 와인에 어울리는 Vidal 화이트. 새콤한 맛가 살아 있고 무게감이 느껴지는는 담백해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Diamond Estates Vidal Bear River Niagara Peninsula 2017는 길쭉한 병 감성을 담은 안주없이 마실수 있는입니다. 2017 빈티지, 11.5 도수, 375ml.\n\n첫 인상은 새콤한 맛가 또렷하고, 텍스처는 무게감이 느껴지는로 느껴집니다. 피니시는 둥글둥글한, 단맛은 꿀같은 쪽으로 해석할 수 있어요. 그리고 해산물과 잘어울리는 쪽으로 즐기기 좋아요.\n마무리·대화용에 두고 천천히 즐기면 밸런스가 더 살아나요.	첫 인상은 새콤한 맛가 또렷하고, 텍스처는 무게감이 느껴지는로 느껴집니다. 피니시는 둥글둥글한, 단맛은 꿀같은 쪽으로 해석할 수 있어요. 그리고 해산물과 잘어울리는 쪽으로 즐기기 좋아요.	견과류 / 다크 초콜릿 / 치즈	edge
ta230	Batic, Cabernet-Franc	Batic Zelen Vipava 2014	Batic	Slovenia	Vipava	Zelen	RED	Table	13	1	4	4	2	190000	2014	750	5	\N	식사떄 마시는 와인 자리에서 빛나는 Zelen 레드. 맛깔스러운 맛은 정돈되고 점성이 강한는 또렷해요.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	비파바 생산자의 작업주 와인 Batic Zelen Vipava 2014. 2014 빈티지, 도수 13~14, 750ml.\n\n입안에서는 포도 원액 느낌/짜릿한 맛가 중심을 잡고, 마무리는 홍차를 마시는것같은이 정돈합니다.\n글라스 와인 용에 두면 실패 확률이 낮아요. (데일리·대화용)	전체 톤은 무게감이 느껴지는와 탄산음료같은의 균형. 타닌은 맛깔스러운 맛, 단맛은 단맛이 조금 나는 쪽으로 읽힙니다. 그리고 메인 쪽으로 즐기기 좋아요.	바비큐 립(트러플), 숙성 치즈, 미트소스/라구	edge
ta231	Harlan Estate	Harlan Estate Cabernet-Sauvignon Merlot Cabernet-Franc California Napa County 2014	Harlan Estate	USA	California Napa County	Cabernet-Sauvignon Merlot Cabernet-Franc	RED	Table	14.5	1	4	5	5	2800000	2014	750	5	\N	국내에서는 구하기 어려운 선택지로 좋은 Cabernet-Sauvignon Merlot Cabernet-Franc 레드. 혀끝이 조여드는 느낌/꿀같은 와인 밸런스형.	KR명:자동생성(검수필요) | 한줄요약:자동생성 | 테이스팅노트:자동생성 | 상세설명:자동생성 | 페어링:자동생성 | 재고:기본값(개발용) | Occasion:정규화 | 표현:정교화v2	Harlan Estate Cabernet-Sauvignon Merlot Cabernet-Franc California Napa County 2014는 와인 입문자에게 적합한 감성을 담은 탄닌이 있는입니다. 2014 빈티지, 14.5 도수, 750ml.\n\n향에서는 단맛이 조금 나는 인상이 먼저 오고, 입안에서는 짜릿한 맛가 균형을 잡습니다. 질감은 끈기가 아주 많은, 여운은 찌꺼기가 있는 쪽으로 정리돼요. — 와인다운 무드로 이해하면 좋아요.\n데일리·대화용에 두고 천천히 즐기면 밸런스가 더 살아나요.	향에서는 단맛이 조금 나는 인상이 먼저 오고, 입안에서는 짜릿한 맛가 균형을 잡습니다. 질감은 끈기가 아주 많은, 여운은 찌꺼기가 있는 쪽으로 정리돼요. — 와인다운 무드로 이해하면 좋아요.	소갈비(후추/허브), 숙성 치즈, 미트소스/라구	edge
ta001	Vignobles JeanJean Pays d'Oc IGP (Languedoc‑Roussillon) Merlot 2020	셰프의 추천 2020	Vignobles JeanJean	France	Pays d'Oc IGP (Languedoc‑Roussillon)	Merlot	RED	Table	13	1	2	3	3	25000	2020	750	30	3.8	France 현지 셰프들의 추천 와인 ★3.8	랑그독 루시용 대표 생산자의 가성비 와인 | EN명:자동생성 | Vivino:표기(있을때만)	France 현지 셰프들이 추천하는 랑그독 루시용 대표 생산자의 가성비 국민 와인 (Vivino 평점 3.8).Merlot   특유의 섬세하고 부드러운 맛이 특징. 육류와 함께  곁들였을 때 한층 음식의 맛을 업그레이드 시켜준다.	블랙 체리·자두 향, 코코아·오크 힌트, 미디엄 바디, 부드러운 탄닌, 긴 여운	구운 고기, 치즈 플래터	rep
ta002	LGI Pays d'Oc IGP (Languedoc‑Roussillon) Cabernet-Sauvignon 2023	라 풀 (LA FOULE) 2023	LGI	France	Pays d'Oc IGP (Languedoc‑Roussillon)	Cabernet-Sauvignon	RED	Table	13.5	1	3	4	2	32000	2023	750	10	3.8	France의 초상화 같은 와인 ★3.8	편하게 즐기는 남부 프리미엄 와인 | EN명:자동생성 | Vivino:표기(있을때만)	Edith Piaf가 부른 원곡 " La Foule"에 영감을 받아 만든 와인 (Vivino 평점 3.8). 진한 루비색과 잘 익은 건포도, 블랙 베리 , France의 초상화 같은 와인, 편하게 즐기는 남부 프리미엄 와인	블랙커런트·라즈베리, 스파이스와 오크 터치, 풀 바디, 탄탄한 구조감	스테이크, 진한 소스 요리	rep
ta003	LGI Pays d'Oc IGP (Languedoc‑Roussillon) Chardonnay 2023	라 풀 (LA FOULE) 2023	LGI	France	Pays d'Oc IGP (Languedoc‑Roussillon)	Chardonnay	WHITE	Table	13.5	1	3	3	0	32000	2023	750	20	3.7	France의 초상화 같은 와인 ★3.7	편하게 즐기는 남부 프리미엄 와인 | EN명:자동생성 | Vivino:표기(있을때만)	(Vivino 평점 3.7) 진하고 밝은 금 빛, 가벼운 바닐라 향, 편하게 즐기는 남부 프리미엄 와인, France의 초상화 같은 와인	사과·배·복숭아, 크리미한 버터·토스트, 산미와 밸런스	해산물, 크림 파스타	rep
ta004	Feudo Arancio Sicilia DOC Cabernet-Sauvignon 2022	페우도 아란치오 2022	Feudo Arancio	Italy	Sicilia DOC	Cabernet-Sauvignon	RED	Table	13.5	1	3	3.5	3	32000	2022	750	5	3.6	(2종)시칠리아 최고의 포트폴리오 ★3.6	세계적인 와인 메이커 페우도 아란치오 | EN명:자동생성 | Vivino:표기(있을때만)	시칠리아의 강한 햇살을 장점으로 승화시킨 와인 메이킹 (Vivino 평점 3.6). 시칠리아 최고의 포트폴리오,  블랙 커런트, 나무 향, 향신료, 풀바디	블랙 체리·다크 베리, 바닐라·초콜릿, 오크 숙성 노트, 묵직한 바디	양고기, 진한 파스타	rep
ta005	Feudo Arancio Sicilia DOC Chardonnay 2023	페우도 아란치오 2023	Feudo Arancio	Italy	Sicilia DOC	Chardonnay	WHITE	Table	13.5	1	3	3	0	32000	2023	750	3	3.5	시칠리아 최고의 조합 ★3.5	세계적인 와인 메이커 페우도 아란치오 | EN명:자동생성 | Vivino:표기(있을때만)	(Vivino 평점 3.5) 열대과일 바닐라 향, 산미의 밸런스가 뛰어남, 시칠리아 최고의 조합	살구·복숭아, 꿀·버터 터치, 드라이하고 부드러운 질감	치킨, 흰살 생선	rep
ta006	Cusumano Terre Siciliane IGT (Sicilia) Syrah&Shiraz 2020	쿠수마노 2020	Cusumano	Italy	Terre Siciliane IGT (Sicilia)	Syrah&Shiraz	RED	Table	14.5	1	3	3	3	32000	2020	750	40	3.7	토양에 뿌리를 둔 와인 ★3.7	James Suckling 91 | EN명:자동생성 | Vivino:표기(있을때만)	(Vivino 평점 3.7) 자두, 블랙 베리, 블루 베리, 은은한 스모크 향, 민트향 신선한 과즙과 부드러운 탄닌의 미디엄 바디 와인	후추·검은 베리, 자두·스모크, 강한 바디	바비큐, 구운 고기	rep
ta010	J. Bouchon Maule Valley Cabernet-Sauvignon 2022	부숑 리제르바 2022	J. Bouchon	Chile	Maule Valley	Cabernet-Sauvignon	RED	Table	14	1	3	3	3	32000	2022	750	10	3.8	150년 전통의 와이너리 ★3.8	VIVINO 3.8 | EN명:자동생성 | Vivino:표기(있을때만)	(Vivino 평점 3.8) Chile의 대표 품종인 Cabernet-Sauvignon    의 아로마가 균형을 이루며 좋은 바디감을 보여주는 와인	블랙베리·블루베리, 나무향·스파이스, 실키한 탄닌	그릴 요리, 치즈	rep
ta011	J. Bouchon Maule Valley Chardonnay 2022	부숑 리제르바 2022	J. Bouchon	Chile	Maule Valley	Chardonnay	WHITE	Table	13.5	1	3	2	0	32000	2022	750	20	3.7	151년 전통의 와이너리 ★3.7	VIVINO 3.9 | EN명:자동생성 | Vivino:표기(있을때만)	(Vivino 평점 3.7) France의 화이트와 견줄만한 품질	복숭아·살구, 버터·미네랄, 크리미한 질감	조개, 스모크 연어	rep
ta018	Hedges Columbia Valley Cabernet-Sauvignon 2021	헤지스 CMS 2021	Hedges	USA	Columbia Valley	Cabernet-Sauvignon	RED	Table	14	1	3	4	3	70000	2021	750	10	3.7	USA 와인 매니아를 위한 ★3.7	보르도 스타일의 블렌드 와인 | EN명:자동생성 | Vivino:표기(있을때만)	(Vivino 평점 3.7) 체리, 블랙 커런트, 자두, 가죽, earthy한 느낌의 아로마	자두·바닐라, 초콜릿·스모크, 중간 바디	버거, 바비큐	rep
\.


--
-- Name: conversations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.conversations_id_seq', 7, true);


--
-- Name: keyword_lib_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.keyword_lib_id_seq', 66, true);


--
-- Name: messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.messages_id_seq', 28, true);


--
-- Name: occasion_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.occasion_types_id_seq', 12, true);


--
-- Name: price_ranges_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.price_ranges_id_seq', 13, true);


--
-- Name: taste_levels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.taste_levels_id_seq', 20, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: wine_occasions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.wine_occasions_id_seq', 521, true);


--
-- Name: conversations conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT conversations_pkey PRIMARY KEY (id);


--
-- Name: keyword_lib keyword_lib_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keyword_lib
    ADD CONSTRAINT keyword_lib_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: occasion_types occasion_types_occasion_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.occasion_types
    ADD CONSTRAINT occasion_types_occasion_key UNIQUE (occasion);


--
-- Name: occasion_types occasion_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.occasion_types
    ADD CONSTRAINT occasion_types_pkey PRIMARY KEY (id);


--
-- Name: price_ranges price_ranges_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_ranges
    ADD CONSTRAINT price_ranges_pkey PRIMARY KEY (id);


--
-- Name: price_ranges price_ranges_range_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_ranges
    ADD CONSTRAINT price_ranges_range_name_key UNIQUE (range_name);


--
-- Name: session session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT session_pkey PRIMARY KEY (sid);


--
-- Name: taste_levels taste_levels_attribute_level_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taste_levels
    ADD CONSTRAINT taste_levels_attribute_level_key UNIQUE (attribute, level);


--
-- Name: taste_levels taste_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taste_levels
    ADD CONSTRAINT taste_levels_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: wine_occasions wine_occasions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wine_occasions
    ADD CONSTRAINT wine_occasions_pkey PRIMARY KEY (id);


--
-- Name: wines wines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wines
    ADD CONSTRAINT wines_pkey PRIMARY KEY (id);


--
-- Name: IDX_session_expire; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_session_expire" ON public.session USING btree (expire);


--
-- Name: idx_conversations_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_conversations_user_id ON public.conversations USING btree (user_id);


--
-- Name: idx_keyword_lib_category; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_keyword_lib_category ON public.keyword_lib USING btree (category);


--
-- Name: idx_messages_conversation_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_messages_conversation_id ON public.messages USING btree (conversation_id);


--
-- Name: idx_wine_occasions_occasion_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_wine_occasions_occasion_id ON public.wine_occasions USING btree (occasion_id);


--
-- Name: idx_wine_occasions_wine_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_wine_occasions_wine_id ON public.wine_occasions USING btree (wine_id);


--
-- Name: idx_wines_acidity; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_wines_acidity ON public.wines USING btree (acidity);


--
-- Name: idx_wines_body; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_wines_body ON public.wines USING btree (body);


--
-- Name: idx_wines_nation; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_wines_nation ON public.wines USING btree (nation);


--
-- Name: idx_wines_price; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_wines_price ON public.wines USING btree (price);


--
-- Name: idx_wines_sweet; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_wines_sweet ON public.wines USING btree (sweet);


--
-- Name: idx_wines_tannin; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_wines_tannin ON public.wines USING btree (tannin);


--
-- Name: idx_wines_taste_profile; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_wines_taste_profile ON public.wines USING btree (sweet, acidity, body, tannin);


--
-- Name: idx_wines_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_wines_type ON public.wines USING btree (type);


--
-- Name: idx_wines_type_nation; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_wines_type_nation ON public.wines USING btree (type, nation);


--
-- Name: idx_wines_vivino_rating; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_wines_vivino_rating ON public.wines USING btree (vivino_rating DESC NULLS LAST);


--
-- Name: conversations conversations_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT conversations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: messages messages_conversation_id_conversations_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_conversation_id_conversations_id_fk FOREIGN KEY (conversation_id) REFERENCES public.conversations(id) ON DELETE CASCADE;


--
-- Name: wine_occasions wine_occasions_occasion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wine_occasions
    ADD CONSTRAINT wine_occasions_occasion_id_fkey FOREIGN KEY (occasion_id) REFERENCES public.occasion_types(id);


--
-- Name: wine_occasions wine_occasions_wine_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wine_occasions
    ADD CONSTRAINT wine_occasions_wine_id_fkey FOREIGN KEY (wine_id) REFERENCES public.wines(id);


--
-- PostgreSQL database dump complete
--

\unrestrict vYOnEfeWsMWqQli8qdAxT3WqGkkmz7jxJqsP0vEpS7WeLeLV9iiGVR7aql54d5X

