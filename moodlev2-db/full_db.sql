DROP SCHEMA public CASCADE; 
CREATE SCHEMA public; 
GRANT ALL ON SCHEMA public TO postgres; 
GRANT ALL ON SCHEMA public TO public; 
--
-- PostgreSQL database dump
--

-- Dumped from database version 14.4
-- Dumped by pg_dump version 14.4

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
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


--
-- Name: intersected_section_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.intersected_section_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
begin
    refresh materialized view intersected_sections;
    return null;
end;
$$;


ALTER FUNCTION public.intersected_section_update() OWNER TO postgres;

--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

