--
-- PostgreSQL database dump
--

-- Dumped from database version 12.7 (Ubuntu 12.7-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.7 (Ubuntu 12.7-0ubuntu0.20.04.1)

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
-- Name: flights; Type: TABLE; Schema: public; Owner: sean
--

CREATE TABLE public.flights (
    id integer NOT NULL,
    airline character varying(30) NOT NULL,
    flight_number numeric(4,0) NOT NULL,
    destination character(3) NOT NULL,
    departure_time timestamp(0) with time zone NOT NULL,
    CONSTRAINT flights_destination_check CHECK ((length(destination) = 3))
);


ALTER TABLE public.flights OWNER TO sean;

--
-- Name: flights_id_seq; Type: SEQUENCE; Schema: public; Owner: sean
--

CREATE SEQUENCE public.flights_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.flights_id_seq OWNER TO sean;

--
-- Name: flights_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sean
--

ALTER SEQUENCE public.flights_id_seq OWNED BY public.flights.id;


--
-- Name: flights id; Type: DEFAULT; Schema: public; Owner: sean
--

ALTER TABLE ONLY public.flights ALTER COLUMN id SET DEFAULT nextval('public.flights_id_seq'::regclass);


--
-- Data for Name: flights; Type: TABLE DATA; Schema: public; Owner: sean
--



--
-- Name: flights_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sean
--

SELECT pg_catalog.setval('public.flights_id_seq', 1, false);


--
-- Name: flights flights_pkey; Type: CONSTRAINT; Schema: public; Owner: sean
--

ALTER TABLE ONLY public.flights
    ADD CONSTRAINT flights_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

