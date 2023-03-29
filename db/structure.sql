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
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: billables; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.billables (
    id bigint NOT NULL,
    booking_id bigint NOT NULL,
    gross_rate numeric(10,2) DEFAULT 0.0 NOT NULL,
    collected numeric(10,2) DEFAULT 0.0 NOT NULL,
    commission_rate numeric(5,4) DEFAULT 0.1 NOT NULL,
    commission numeric(10,2) DEFAULT 0.0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT billables_commission_rate_chk CHECK (((commission_rate >= (0)::numeric) AND (commission_rate <= (1)::numeric)))
);


--
-- Name: billables_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.billables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: billables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.billables_id_seq OWNED BY public.billables.id;


--
-- Name: bookings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bookings (
    id bigint NOT NULL,
    client_id bigint NOT NULL,
    vendor_id bigint NOT NULL,
    date date NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: bookings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bookings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bookings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bookings_id_seq OWNED BY public.bookings.id;


--
-- Name: clients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clients (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.clients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.clients_id_seq OWNED BY public.clients.id;


--
-- Name: receipts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.receipts (
    id bigint NOT NULL,
    date date NOT NULL,
    reference_no character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: receipts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.receipts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: receipts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.receipts_id_seq OWNED BY public.receipts.id;


--
-- Name: receivables; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.receivables (
    id bigint NOT NULL,
    billable_id bigint NOT NULL,
    receipt_id bigint NOT NULL,
    gross_rate numeric(10,2) NOT NULL,
    commission_rate numeric(10,2) NOT NULL,
    commission numeric(10,2) NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT receivables_commission_rate_chk CHECK (((commission_rate >= (0)::numeric) AND (commission_rate <= (1)::numeric)))
);


--
-- Name: receivables_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.receivables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: receivables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.receivables_id_seq OWNED BY public.receivables.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: vendors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vendors (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: vendors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vendors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vendors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vendors_id_seq OWNED BY public.vendors.id;


--
-- Name: billables id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.billables ALTER COLUMN id SET DEFAULT nextval('public.billables_id_seq'::regclass);


--
-- Name: bookings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookings ALTER COLUMN id SET DEFAULT nextval('public.bookings_id_seq'::regclass);


--
-- Name: clients id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients ALTER COLUMN id SET DEFAULT nextval('public.clients_id_seq'::regclass);


--
-- Name: receipts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receipts ALTER COLUMN id SET DEFAULT nextval('public.receipts_id_seq'::regclass);


--
-- Name: receivables id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receivables ALTER COLUMN id SET DEFAULT nextval('public.receivables_id_seq'::regclass);


--
-- Name: vendors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendors ALTER COLUMN id SET DEFAULT nextval('public.vendors_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: billables billables_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.billables
    ADD CONSTRAINT billables_pkey PRIMARY KEY (id);


--
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);


--
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- Name: receipts receipts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receipts
    ADD CONSTRAINT receipts_pkey PRIMARY KEY (id);


--
-- Name: receivables receivables_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receivables
    ADD CONSTRAINT receivables_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: vendors vendors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT vendors_pkey PRIMARY KEY (id);


--
-- Name: index_billables_on_booking_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_billables_on_booking_id ON public.billables USING btree (booking_id);


--
-- Name: index_bookings_on_client_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bookings_on_client_id ON public.bookings USING btree (client_id);


--
-- Name: index_bookings_on_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bookings_on_date ON public.bookings USING btree (date);


--
-- Name: index_bookings_on_vendor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bookings_on_vendor_id ON public.bookings USING btree (vendor_id);


--
-- Name: index_clients_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_clients_on_name ON public.clients USING btree (name);


--
-- Name: index_clients_on_name_using_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clients_on_name_using_gin ON public.clients USING gin (name public.gin_trgm_ops);


--
-- Name: index_receipts_on_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_receipts_on_date ON public.receipts USING btree (date);


--
-- Name: index_receipts_on_reference_no; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_receipts_on_reference_no ON public.receipts USING btree (reference_no);


--
-- Name: index_receivables_on_billable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_receivables_on_billable_id ON public.receivables USING btree (billable_id);


--
-- Name: index_receivables_on_receipt_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_receivables_on_receipt_id ON public.receivables USING btree (receipt_id);


--
-- Name: index_vendors_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_vendors_on_name ON public.vendors USING btree (name);


--
-- Name: index_vendors_on_name_using_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vendors_on_name_using_gin ON public.vendors USING gin (name public.gin_trgm_ops);


--
-- Name: receivables fk_rails_0245ee2586; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receivables
    ADD CONSTRAINT fk_rails_0245ee2586 FOREIGN KEY (receipt_id) REFERENCES public.receipts(id) ON DELETE CASCADE;


--
-- Name: bookings fk_rails_22fb9d2368; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT fk_rails_22fb9d2368 FOREIGN KEY (vendor_id) REFERENCES public.vendors(id) ON DELETE RESTRICT;


--
-- Name: bookings fk_rails_2c503ea743; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT fk_rails_2c503ea743 FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE RESTRICT;


--
-- Name: billables fk_rails_b413ca5783; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.billables
    ADD CONSTRAINT fk_rails_b413ca5783 FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON DELETE CASCADE;


--
-- Name: receivables fk_rails_e525b66766; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receivables
    ADD CONSTRAINT fk_rails_e525b66766 FOREIGN KEY (billable_id) REFERENCES public.billables(id) ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20230329132102'),
('20230329132202'),
('20230329132521'),
('20230329134354'),
('20230329140247'),
('20230329141424'),
('20230329141644');


