--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE keycloak;
ALTER ROLE keycloak WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:4gTCp9B0lAtYbEcCmrpBRg==$bd5t2nrtQPt9UKR1ygP4VhAaybnUtNtuUF956JUcvHE=:1j8wiwwpySdRaTdf1ck4f25i1I9OKtTXPUCRSJ13yzU=';

--
-- User Configurations
--








--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.13 (Debian 15.13-1.pgdg120+1)
-- Dumped by pg_dump version 15.13 (Debian 15.13-1.pgdg120+1)

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
-- PostgreSQL database dump complete
--

--
-- Database "keycloak" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.13 (Debian 15.13-1.pgdg120+1)
-- Dumped by pg_dump version 15.13 (Debian 15.13-1.pgdg120+1)

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
-- Name: keycloak; Type: DATABASE; Schema: -; Owner: keycloak
--

CREATE DATABASE keycloak WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE keycloak OWNER TO keycloak;

\connect keycloak

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
-- Name: admin_event_entity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.admin_event_entity (
    id character varying(36) NOT NULL,
    admin_event_time bigint,
    realm_id character varying(255),
    operation_type character varying(255),
    auth_realm_id character varying(255),
    auth_client_id character varying(255),
    auth_user_id character varying(255),
    ip_address character varying(255),
    resource_path character varying(2550),
    representation text,
    error character varying(255),
    resource_type character varying(64),
    details_json text
);


ALTER TABLE public.admin_event_entity OWNER TO keycloak;

--
-- Name: associated_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.associated_policy (
    policy_id character varying(36) NOT NULL,
    associated_policy_id character varying(36) NOT NULL
);


ALTER TABLE public.associated_policy OWNER TO keycloak;

--
-- Name: authentication_execution; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authentication_execution (
    id character varying(36) NOT NULL,
    alias character varying(255),
    authenticator character varying(36),
    realm_id character varying(36),
    flow_id character varying(36),
    requirement integer,
    priority integer,
    authenticator_flow boolean DEFAULT false NOT NULL,
    auth_flow_id character varying(36),
    auth_config character varying(36)
);


ALTER TABLE public.authentication_execution OWNER TO keycloak;

--
-- Name: authentication_flow; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authentication_flow (
    id character varying(36) NOT NULL,
    alias character varying(255),
    description character varying(255),
    realm_id character varying(36),
    provider_id character varying(36) DEFAULT 'basic-flow'::character varying NOT NULL,
    top_level boolean DEFAULT false NOT NULL,
    built_in boolean DEFAULT false NOT NULL
);


ALTER TABLE public.authentication_flow OWNER TO keycloak;

--
-- Name: authenticator_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authenticator_config (
    id character varying(36) NOT NULL,
    alias character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.authenticator_config OWNER TO keycloak;

--
-- Name: authenticator_config_entry; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authenticator_config_entry (
    authenticator_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.authenticator_config_entry OWNER TO keycloak;

--
-- Name: broker_link; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.broker_link (
    identity_provider character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL,
    broker_user_id character varying(255),
    broker_username character varying(255),
    token text,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.broker_link OWNER TO keycloak;

--
-- Name: client; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client (
    id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    full_scope_allowed boolean DEFAULT false NOT NULL,
    client_id character varying(255),
    not_before integer,
    public_client boolean DEFAULT false NOT NULL,
    secret character varying(255),
    base_url character varying(255),
    bearer_only boolean DEFAULT false NOT NULL,
    management_url character varying(255),
    surrogate_auth_required boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    protocol character varying(255),
    node_rereg_timeout integer DEFAULT 0,
    frontchannel_logout boolean DEFAULT false NOT NULL,
    consent_required boolean DEFAULT false NOT NULL,
    name character varying(255),
    service_accounts_enabled boolean DEFAULT false NOT NULL,
    client_authenticator_type character varying(255),
    root_url character varying(255),
    description character varying(255),
    registration_token character varying(255),
    standard_flow_enabled boolean DEFAULT true NOT NULL,
    implicit_flow_enabled boolean DEFAULT false NOT NULL,
    direct_access_grants_enabled boolean DEFAULT false NOT NULL,
    always_display_in_console boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client OWNER TO keycloak;

--
-- Name: client_attributes; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_attributes (
    client_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.client_attributes OWNER TO keycloak;

--
-- Name: client_auth_flow_bindings; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_auth_flow_bindings (
    client_id character varying(36) NOT NULL,
    flow_id character varying(36),
    binding_name character varying(255) NOT NULL
);


ALTER TABLE public.client_auth_flow_bindings OWNER TO keycloak;

--
-- Name: client_initial_access; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_initial_access (
    id character varying(36) NOT NULL,
    realm_id character varying(36) NOT NULL,
    "timestamp" integer,
    expiration integer,
    count integer,
    remaining_count integer
);


ALTER TABLE public.client_initial_access OWNER TO keycloak;

--
-- Name: client_node_registrations; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_node_registrations (
    client_id character varying(36) NOT NULL,
    value integer,
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_node_registrations OWNER TO keycloak;

--
-- Name: client_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope (
    id character varying(36) NOT NULL,
    name character varying(255),
    realm_id character varying(36),
    description character varying(255),
    protocol character varying(255)
);


ALTER TABLE public.client_scope OWNER TO keycloak;

--
-- Name: client_scope_attributes; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope_attributes (
    scope_id character varying(36) NOT NULL,
    value character varying(2048),
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_scope_attributes OWNER TO keycloak;

--
-- Name: client_scope_client; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope_client (
    client_id character varying(255) NOT NULL,
    scope_id character varying(255) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client_scope_client OWNER TO keycloak;

--
-- Name: client_scope_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope_role_mapping (
    scope_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.client_scope_role_mapping OWNER TO keycloak;

--
-- Name: component; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.component (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_id character varying(36),
    provider_id character varying(36),
    provider_type character varying(255),
    realm_id character varying(36),
    sub_type character varying(255)
);


ALTER TABLE public.component OWNER TO keycloak;

--
-- Name: component_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.component_config (
    id character varying(36) NOT NULL,
    component_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.component_config OWNER TO keycloak;

--
-- Name: composite_role; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.composite_role (
    composite character varying(36) NOT NULL,
    child_role character varying(36) NOT NULL
);


ALTER TABLE public.composite_role OWNER TO keycloak;

--
-- Name: credential; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    user_id character varying(36),
    created_date bigint,
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer,
    version integer DEFAULT 0
);


ALTER TABLE public.credential OWNER TO keycloak;

--
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


ALTER TABLE public.databasechangelog OWNER TO keycloak;

--
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO keycloak;

--
-- Name: default_client_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.default_client_scope (
    realm_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.default_client_scope OWNER TO keycloak;

--
-- Name: event_entity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.event_entity (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    details_json character varying(2550),
    error character varying(255),
    ip_address character varying(255),
    realm_id character varying(255),
    session_id character varying(255),
    event_time bigint,
    type character varying(255),
    user_id character varying(255),
    details_json_long_value text
);


ALTER TABLE public.event_entity OWNER TO keycloak;

--
-- Name: fed_user_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_attribute (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    value character varying(2024),
    long_value_hash bytea,
    long_value_hash_lower_case bytea,
    long_value text
);


ALTER TABLE public.fed_user_attribute OWNER TO keycloak;

--
-- Name: fed_user_consent; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.fed_user_consent OWNER TO keycloak;

--
-- Name: fed_user_consent_cl_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_consent_cl_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.fed_user_consent_cl_scope OWNER TO keycloak;

--
-- Name: fed_user_credential; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    created_date bigint,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.fed_user_credential OWNER TO keycloak;

--
-- Name: fed_user_group_membership; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_group_membership OWNER TO keycloak;

--
-- Name: fed_user_required_action; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_required_action (
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_required_action OWNER TO keycloak;

--
-- Name: fed_user_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_role_mapping (
    role_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_role_mapping OWNER TO keycloak;

--
-- Name: federated_identity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.federated_identity (
    identity_provider character varying(255) NOT NULL,
    realm_id character varying(36),
    federated_user_id character varying(255),
    federated_username character varying(255),
    token text,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_identity OWNER TO keycloak;

--
-- Name: federated_user; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.federated_user (
    id character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_user OWNER TO keycloak;

--
-- Name: group_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.group_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_attribute OWNER TO keycloak;

--
-- Name: group_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.group_role_mapping (
    role_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_role_mapping OWNER TO keycloak;

--
-- Name: identity_provider; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.identity_provider (
    internal_id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    provider_alias character varying(255),
    provider_id character varying(255),
    store_token boolean DEFAULT false NOT NULL,
    authenticate_by_default boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    add_token_role boolean DEFAULT true NOT NULL,
    trust_email boolean DEFAULT false NOT NULL,
    first_broker_login_flow_id character varying(36),
    post_broker_login_flow_id character varying(36),
    provider_display_name character varying(255),
    link_only boolean DEFAULT false NOT NULL,
    organization_id character varying(255),
    hide_on_login boolean DEFAULT false
);


ALTER TABLE public.identity_provider OWNER TO keycloak;

--
-- Name: identity_provider_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.identity_provider_config (
    identity_provider_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.identity_provider_config OWNER TO keycloak;

--
-- Name: identity_provider_mapper; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.identity_provider_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    idp_alias character varying(255) NOT NULL,
    idp_mapper_name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.identity_provider_mapper OWNER TO keycloak;

--
-- Name: idp_mapper_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.idp_mapper_config (
    idp_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.idp_mapper_config OWNER TO keycloak;

--
-- Name: jgroups_ping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.jgroups_ping (
    address character varying(200) NOT NULL,
    name character varying(200),
    cluster_name character varying(200) NOT NULL,
    ip character varying(200) NOT NULL,
    coord boolean
);


ALTER TABLE public.jgroups_ping OWNER TO keycloak;

--
-- Name: keycloak_group; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.keycloak_group (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_group character varying(36) NOT NULL,
    realm_id character varying(36),
    type integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.keycloak_group OWNER TO keycloak;

--
-- Name: keycloak_role; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.keycloak_role (
    id character varying(36) NOT NULL,
    client_realm_constraint character varying(255),
    client_role boolean DEFAULT false NOT NULL,
    description character varying(255),
    name character varying(255),
    realm_id character varying(255),
    client character varying(36),
    realm character varying(36)
);


ALTER TABLE public.keycloak_role OWNER TO keycloak;

--
-- Name: migration_model; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.migration_model (
    id character varying(36) NOT NULL,
    version character varying(36),
    update_time bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.migration_model OWNER TO keycloak;

--
-- Name: offline_client_session; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.offline_client_session (
    user_session_id character varying(36) NOT NULL,
    client_id character varying(255) NOT NULL,
    offline_flag character varying(4) NOT NULL,
    "timestamp" integer,
    data text,
    client_storage_provider character varying(36) DEFAULT 'local'::character varying NOT NULL,
    external_client_id character varying(255) DEFAULT 'local'::character varying NOT NULL,
    version integer DEFAULT 0
);


ALTER TABLE public.offline_client_session OWNER TO keycloak;

--
-- Name: offline_user_session; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.offline_user_session (
    user_session_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    created_on integer NOT NULL,
    offline_flag character varying(4) NOT NULL,
    data text,
    last_session_refresh integer DEFAULT 0 NOT NULL,
    broker_session_id character varying(1024),
    version integer DEFAULT 0
);


ALTER TABLE public.offline_user_session OWNER TO keycloak;

--
-- Name: org; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.org (
    id character varying(255) NOT NULL,
    enabled boolean NOT NULL,
    realm_id character varying(255) NOT NULL,
    group_id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000),
    alias character varying(255) NOT NULL,
    redirect_url character varying(2048)
);


ALTER TABLE public.org OWNER TO keycloak;

--
-- Name: org_domain; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.org_domain (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    verified boolean NOT NULL,
    org_id character varying(255) NOT NULL
);


ALTER TABLE public.org_domain OWNER TO keycloak;

--
-- Name: policy_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.policy_config (
    policy_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.policy_config OWNER TO keycloak;

--
-- Name: protocol_mapper; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.protocol_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    protocol character varying(255) NOT NULL,
    protocol_mapper_name character varying(255) NOT NULL,
    client_id character varying(36),
    client_scope_id character varying(36)
);


ALTER TABLE public.protocol_mapper OWNER TO keycloak;

--
-- Name: protocol_mapper_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.protocol_mapper_config (
    protocol_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.protocol_mapper_config OWNER TO keycloak;

--
-- Name: realm; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm (
    id character varying(36) NOT NULL,
    access_code_lifespan integer,
    user_action_lifespan integer,
    access_token_lifespan integer,
    account_theme character varying(255),
    admin_theme character varying(255),
    email_theme character varying(255),
    enabled boolean DEFAULT false NOT NULL,
    events_enabled boolean DEFAULT false NOT NULL,
    events_expiration bigint,
    login_theme character varying(255),
    name character varying(255),
    not_before integer,
    password_policy character varying(2550),
    registration_allowed boolean DEFAULT false NOT NULL,
    remember_me boolean DEFAULT false NOT NULL,
    reset_password_allowed boolean DEFAULT false NOT NULL,
    social boolean DEFAULT false NOT NULL,
    ssl_required character varying(255),
    sso_idle_timeout integer,
    sso_max_lifespan integer,
    update_profile_on_soc_login boolean DEFAULT false NOT NULL,
    verify_email boolean DEFAULT false NOT NULL,
    master_admin_client character varying(36),
    login_lifespan integer,
    internationalization_enabled boolean DEFAULT false NOT NULL,
    default_locale character varying(255),
    reg_email_as_username boolean DEFAULT false NOT NULL,
    admin_events_enabled boolean DEFAULT false NOT NULL,
    admin_events_details_enabled boolean DEFAULT false NOT NULL,
    edit_username_allowed boolean DEFAULT false NOT NULL,
    otp_policy_counter integer DEFAULT 0,
    otp_policy_window integer DEFAULT 1,
    otp_policy_period integer DEFAULT 30,
    otp_policy_digits integer DEFAULT 6,
    otp_policy_alg character varying(36) DEFAULT 'HmacSHA1'::character varying,
    otp_policy_type character varying(36) DEFAULT 'totp'::character varying,
    browser_flow character varying(36),
    registration_flow character varying(36),
    direct_grant_flow character varying(36),
    reset_credentials_flow character varying(36),
    client_auth_flow character varying(36),
    offline_session_idle_timeout integer DEFAULT 0,
    revoke_refresh_token boolean DEFAULT false NOT NULL,
    access_token_life_implicit integer DEFAULT 0,
    login_with_email_allowed boolean DEFAULT true NOT NULL,
    duplicate_emails_allowed boolean DEFAULT false NOT NULL,
    docker_auth_flow character varying(36),
    refresh_token_max_reuse integer DEFAULT 0,
    allow_user_managed_access boolean DEFAULT false NOT NULL,
    sso_max_lifespan_remember_me integer DEFAULT 0 NOT NULL,
    sso_idle_timeout_remember_me integer DEFAULT 0 NOT NULL,
    default_role character varying(255)
);


ALTER TABLE public.realm OWNER TO keycloak;

--
-- Name: realm_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_attribute (
    name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    value text
);


ALTER TABLE public.realm_attribute OWNER TO keycloak;

--
-- Name: realm_default_groups; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_default_groups (
    realm_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_default_groups OWNER TO keycloak;

--
-- Name: realm_enabled_event_types; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_enabled_event_types (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_enabled_event_types OWNER TO keycloak;

--
-- Name: realm_events_listeners; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_events_listeners (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_events_listeners OWNER TO keycloak;

--
-- Name: realm_localizations; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_localizations (
    realm_id character varying(255) NOT NULL,
    locale character varying(255) NOT NULL,
    texts text NOT NULL
);


ALTER TABLE public.realm_localizations OWNER TO keycloak;

--
-- Name: realm_required_credential; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_required_credential (
    type character varying(255) NOT NULL,
    form_label character varying(255),
    input boolean DEFAULT false NOT NULL,
    secret boolean DEFAULT false NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_required_credential OWNER TO keycloak;

--
-- Name: realm_smtp_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_smtp_config (
    realm_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.realm_smtp_config OWNER TO keycloak;

--
-- Name: realm_supported_locales; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_supported_locales (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_supported_locales OWNER TO keycloak;

--
-- Name: redirect_uris; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.redirect_uris (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.redirect_uris OWNER TO keycloak;

--
-- Name: required_action_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.required_action_config (
    required_action_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.required_action_config OWNER TO keycloak;

--
-- Name: required_action_provider; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.required_action_provider (
    id character varying(36) NOT NULL,
    alias character varying(255),
    name character varying(255),
    realm_id character varying(36),
    enabled boolean DEFAULT false NOT NULL,
    default_action boolean DEFAULT false NOT NULL,
    provider_id character varying(255),
    priority integer
);


ALTER TABLE public.required_action_provider OWNER TO keycloak;

--
-- Name: resource_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    resource_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_attribute OWNER TO keycloak;

--
-- Name: resource_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_policy (
    resource_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_policy OWNER TO keycloak;

--
-- Name: resource_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_scope (
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_scope OWNER TO keycloak;

--
-- Name: resource_server; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server (
    id character varying(36) NOT NULL,
    allow_rs_remote_mgmt boolean DEFAULT false NOT NULL,
    policy_enforce_mode smallint NOT NULL,
    decision_strategy smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.resource_server OWNER TO keycloak;

--
-- Name: resource_server_perm_ticket; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_perm_ticket (
    id character varying(36) NOT NULL,
    owner character varying(255) NOT NULL,
    requester character varying(255) NOT NULL,
    created_timestamp bigint NOT NULL,
    granted_timestamp bigint,
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36),
    resource_server_id character varying(36) NOT NULL,
    policy_id character varying(36)
);


ALTER TABLE public.resource_server_perm_ticket OWNER TO keycloak;

--
-- Name: resource_server_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_policy (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    type character varying(255) NOT NULL,
    decision_strategy smallint,
    logic smallint,
    resource_server_id character varying(36) NOT NULL,
    owner character varying(255)
);


ALTER TABLE public.resource_server_policy OWNER TO keycloak;

--
-- Name: resource_server_resource; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_resource (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255),
    icon_uri character varying(255),
    owner character varying(255) NOT NULL,
    resource_server_id character varying(36) NOT NULL,
    owner_managed_access boolean DEFAULT false NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_resource OWNER TO keycloak;

--
-- Name: resource_server_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_scope (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    icon_uri character varying(255),
    resource_server_id character varying(36) NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_scope OWNER TO keycloak;

--
-- Name: resource_uris; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_uris (
    resource_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.resource_uris OWNER TO keycloak;

--
-- Name: revoked_token; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.revoked_token (
    id character varying(255) NOT NULL,
    expire bigint NOT NULL
);


ALTER TABLE public.revoked_token OWNER TO keycloak;

--
-- Name: role_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.role_attribute (
    id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255)
);


ALTER TABLE public.role_attribute OWNER TO keycloak;

--
-- Name: scope_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.scope_mapping (
    client_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_mapping OWNER TO keycloak;

--
-- Name: scope_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.scope_policy (
    scope_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_policy OWNER TO keycloak;

--
-- Name: server_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.server_config (
    server_config_key character varying(255) NOT NULL,
    value text NOT NULL,
    version integer DEFAULT 0
);


ALTER TABLE public.server_config OWNER TO keycloak;

--
-- Name: user_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_attribute (
    name character varying(255) NOT NULL,
    value character varying(255),
    user_id character varying(36) NOT NULL,
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    long_value_hash bytea,
    long_value_hash_lower_case bytea,
    long_value text
);


ALTER TABLE public.user_attribute OWNER TO keycloak;

--
-- Name: user_consent; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(36) NOT NULL,
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.user_consent OWNER TO keycloak;

--
-- Name: user_consent_client_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_consent_client_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.user_consent_client_scope OWNER TO keycloak;

--
-- Name: user_entity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_entity (
    id character varying(36) NOT NULL,
    email character varying(255),
    email_constraint character varying(255),
    email_verified boolean DEFAULT false NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    federation_link character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    realm_id character varying(255),
    username character varying(255),
    created_timestamp bigint,
    service_account_client_link character varying(255),
    not_before integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.user_entity OWNER TO keycloak;

--
-- Name: user_federation_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_config (
    user_federation_provider_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_config OWNER TO keycloak;

--
-- Name: user_federation_mapper; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    federation_provider_id character varying(36) NOT NULL,
    federation_mapper_type character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.user_federation_mapper OWNER TO keycloak;

--
-- Name: user_federation_mapper_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_mapper_config (
    user_federation_mapper_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_mapper_config OWNER TO keycloak;

--
-- Name: user_federation_provider; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_provider (
    id character varying(36) NOT NULL,
    changed_sync_period integer,
    display_name character varying(255),
    full_sync_period integer,
    last_sync integer,
    priority integer,
    provider_name character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.user_federation_provider OWNER TO keycloak;

--
-- Name: user_group_membership; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(36) NOT NULL,
    membership_type character varying(255) NOT NULL
);


ALTER TABLE public.user_group_membership OWNER TO keycloak;

--
-- Name: user_required_action; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_required_action (
    user_id character varying(36) NOT NULL,
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL
);


ALTER TABLE public.user_required_action OWNER TO keycloak;

--
-- Name: user_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_role_mapping (
    role_id character varying(255) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_role_mapping OWNER TO keycloak;

--
-- Name: web_origins; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.web_origins (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.web_origins OWNER TO keycloak;

--
-- Data for Name: admin_event_entity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.admin_event_entity (id, admin_event_time, realm_id, operation_type, auth_realm_id, auth_client_id, auth_user_id, ip_address, resource_path, representation, error, resource_type, details_json) FROM stdin;
\.


--
-- Data for Name: associated_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.associated_policy (policy_id, associated_policy_id) FROM stdin;
\.


--
-- Data for Name: authentication_execution; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authentication_execution (id, alias, authenticator, realm_id, flow_id, requirement, priority, authenticator_flow, auth_flow_id, auth_config) FROM stdin;
2494cd83-359c-4790-aaaa-30cb70581fab	\N	auth-cookie	98b2ec68-490d-4a88-b1bd-05b5707e88da	1ecdfd6c-7efb-4193-a807-843f0d4de9c0	2	10	f	\N	\N
49747f8d-ae3e-4af2-a273-2804a908d2b2	\N	auth-spnego	98b2ec68-490d-4a88-b1bd-05b5707e88da	1ecdfd6c-7efb-4193-a807-843f0d4de9c0	3	20	f	\N	\N
4b6e8bfa-a6ab-4283-96e7-0d17fc43454f	\N	identity-provider-redirector	98b2ec68-490d-4a88-b1bd-05b5707e88da	1ecdfd6c-7efb-4193-a807-843f0d4de9c0	2	25	f	\N	\N
e5cdb539-0f6e-445e-976f-d4bae130bbf3	\N	\N	98b2ec68-490d-4a88-b1bd-05b5707e88da	1ecdfd6c-7efb-4193-a807-843f0d4de9c0	2	30	t	72dda9ac-c476-45a0-8534-68edeab7d850	\N
f8077ae0-2a49-4f48-8f9f-55132c16e208	\N	auth-username-password-form	98b2ec68-490d-4a88-b1bd-05b5707e88da	72dda9ac-c476-45a0-8534-68edeab7d850	0	10	f	\N	\N
719983ba-07d3-4fcb-aa62-1bdec0d8dcca	\N	\N	98b2ec68-490d-4a88-b1bd-05b5707e88da	72dda9ac-c476-45a0-8534-68edeab7d850	1	20	t	e2552811-2e9f-412e-8f17-7ed065adaf6e	\N
deba1e53-2a6f-4324-98e6-ff65ebf17d59	\N	conditional-user-configured	98b2ec68-490d-4a88-b1bd-05b5707e88da	e2552811-2e9f-412e-8f17-7ed065adaf6e	0	10	f	\N	\N
fb93dd3b-f675-4189-b61d-7d0a5a29305f	\N	auth-otp-form	98b2ec68-490d-4a88-b1bd-05b5707e88da	e2552811-2e9f-412e-8f17-7ed065adaf6e	0	20	f	\N	\N
f78fb903-6f94-446c-94fb-3fe9509774ce	\N	direct-grant-validate-username	98b2ec68-490d-4a88-b1bd-05b5707e88da	db4d3e83-56c2-4ea2-ae34-5b3e14a54989	0	10	f	\N	\N
747a0c64-8039-4d02-8b02-f5bb4a0050fe	\N	direct-grant-validate-password	98b2ec68-490d-4a88-b1bd-05b5707e88da	db4d3e83-56c2-4ea2-ae34-5b3e14a54989	0	20	f	\N	\N
898190de-580c-496e-a633-f096e2ce53b2	\N	\N	98b2ec68-490d-4a88-b1bd-05b5707e88da	db4d3e83-56c2-4ea2-ae34-5b3e14a54989	1	30	t	4fee87ef-f58a-4165-8a66-56d3c3101dfd	\N
59f78f8b-54da-4cff-9c24-0071af21bf26	\N	conditional-user-configured	98b2ec68-490d-4a88-b1bd-05b5707e88da	4fee87ef-f58a-4165-8a66-56d3c3101dfd	0	10	f	\N	\N
9efecfe8-eac5-40ba-bb01-706f3b46939a	\N	direct-grant-validate-otp	98b2ec68-490d-4a88-b1bd-05b5707e88da	4fee87ef-f58a-4165-8a66-56d3c3101dfd	0	20	f	\N	\N
198d4cc2-14ac-471e-9c19-befddb0a7edf	\N	registration-page-form	98b2ec68-490d-4a88-b1bd-05b5707e88da	8d4fbdd4-9d6e-4a36-a1a8-7eec490d1c3f	0	10	t	63ebd547-865f-411b-aa26-582afc3ab9e0	\N
dc6eb1b0-236b-418e-ac3d-82ca6c683aea	\N	registration-user-creation	98b2ec68-490d-4a88-b1bd-05b5707e88da	63ebd547-865f-411b-aa26-582afc3ab9e0	0	20	f	\N	\N
79aa0626-4d10-4440-bb73-dbdf4d4d1881	\N	registration-password-action	98b2ec68-490d-4a88-b1bd-05b5707e88da	63ebd547-865f-411b-aa26-582afc3ab9e0	0	50	f	\N	\N
193c2b80-1352-4ab8-b8ad-63927f707f0f	\N	registration-recaptcha-action	98b2ec68-490d-4a88-b1bd-05b5707e88da	63ebd547-865f-411b-aa26-582afc3ab9e0	3	60	f	\N	\N
acf2a494-bcbe-45db-b00a-69a16579d7b3	\N	registration-terms-and-conditions	98b2ec68-490d-4a88-b1bd-05b5707e88da	63ebd547-865f-411b-aa26-582afc3ab9e0	3	70	f	\N	\N
e1f11551-42ff-484e-8ae7-476c0b597740	\N	reset-credentials-choose-user	98b2ec68-490d-4a88-b1bd-05b5707e88da	d572418c-ee37-441e-a5bb-6d487cea0d3c	0	10	f	\N	\N
fa017864-0509-49dd-abfb-3fb2714ae69f	\N	reset-credential-email	98b2ec68-490d-4a88-b1bd-05b5707e88da	d572418c-ee37-441e-a5bb-6d487cea0d3c	0	20	f	\N	\N
6b8b906c-bbbc-4bc3-8c72-70d4d19c050c	\N	reset-password	98b2ec68-490d-4a88-b1bd-05b5707e88da	d572418c-ee37-441e-a5bb-6d487cea0d3c	0	30	f	\N	\N
65f16a65-b3a1-4e3b-84f0-28e958b2b515	\N	\N	98b2ec68-490d-4a88-b1bd-05b5707e88da	d572418c-ee37-441e-a5bb-6d487cea0d3c	1	40	t	05aa3478-43fb-441d-a587-e6f64a95e42b	\N
460a52bf-27d0-4bb4-94ba-a2a3c4100d7d	\N	conditional-user-configured	98b2ec68-490d-4a88-b1bd-05b5707e88da	05aa3478-43fb-441d-a587-e6f64a95e42b	0	10	f	\N	\N
54fc17cb-6c59-43d6-a5d2-1568faa328e0	\N	reset-otp	98b2ec68-490d-4a88-b1bd-05b5707e88da	05aa3478-43fb-441d-a587-e6f64a95e42b	0	20	f	\N	\N
a3ffaf17-a778-40e7-95bd-1b6bc27c93cb	\N	client-secret	98b2ec68-490d-4a88-b1bd-05b5707e88da	f2a59aa2-f9b7-4785-98bc-f79de29cd083	2	10	f	\N	\N
4400b87a-4606-4519-be66-245a3c55457b	\N	client-jwt	98b2ec68-490d-4a88-b1bd-05b5707e88da	f2a59aa2-f9b7-4785-98bc-f79de29cd083	2	20	f	\N	\N
57803f41-c521-42c5-8764-990f0ca4c086	\N	client-secret-jwt	98b2ec68-490d-4a88-b1bd-05b5707e88da	f2a59aa2-f9b7-4785-98bc-f79de29cd083	2	30	f	\N	\N
312b0367-c095-4f90-ae27-5831a7e0f0eb	\N	client-x509	98b2ec68-490d-4a88-b1bd-05b5707e88da	f2a59aa2-f9b7-4785-98bc-f79de29cd083	2	40	f	\N	\N
fcb4e1a3-9234-4a2e-8c0c-4ea0100991bb	\N	idp-review-profile	98b2ec68-490d-4a88-b1bd-05b5707e88da	c9553ad0-c2f2-420e-b9e1-fb8f6a810481	0	10	f	\N	e9362a1c-f8d5-45b6-ae65-1bef6e2eb5c7
01d06ed1-2f0c-4e45-aaa6-f8c3c95534f3	\N	\N	98b2ec68-490d-4a88-b1bd-05b5707e88da	c9553ad0-c2f2-420e-b9e1-fb8f6a810481	0	20	t	5f83801f-a033-4fcf-a60a-a833756ea86f	\N
7e7cde9f-9c1c-4b92-8579-6e083514075f	\N	idp-create-user-if-unique	98b2ec68-490d-4a88-b1bd-05b5707e88da	5f83801f-a033-4fcf-a60a-a833756ea86f	2	10	f	\N	13e16d69-00b8-4604-8ae9-aec13af4755e
c3f8f90b-001f-4b1e-94b0-9de061928525	\N	\N	98b2ec68-490d-4a88-b1bd-05b5707e88da	5f83801f-a033-4fcf-a60a-a833756ea86f	2	20	t	60172b60-5d06-43f0-b4d3-3415e1f73b6f	\N
008efe3b-d004-401d-b310-c2863be99135	\N	idp-confirm-link	98b2ec68-490d-4a88-b1bd-05b5707e88da	60172b60-5d06-43f0-b4d3-3415e1f73b6f	0	10	f	\N	\N
ae99a0ea-f496-4dea-9831-501035b7d8ca	\N	\N	98b2ec68-490d-4a88-b1bd-05b5707e88da	60172b60-5d06-43f0-b4d3-3415e1f73b6f	0	20	t	af53c6de-846e-47bf-9e08-398175061e94	\N
442aa9fe-7b51-416e-b9b5-dfacdb0bc210	\N	idp-email-verification	98b2ec68-490d-4a88-b1bd-05b5707e88da	af53c6de-846e-47bf-9e08-398175061e94	2	10	f	\N	\N
ccf52c41-9cbd-430f-a593-6a3417c607e4	\N	\N	98b2ec68-490d-4a88-b1bd-05b5707e88da	af53c6de-846e-47bf-9e08-398175061e94	2	20	t	52ca07a9-0979-49a2-8c5b-355ca4b38534	\N
a83ce326-28f4-4d19-9e23-a711ef0ab7e4	\N	idp-username-password-form	98b2ec68-490d-4a88-b1bd-05b5707e88da	52ca07a9-0979-49a2-8c5b-355ca4b38534	0	10	f	\N	\N
ea4ad72e-67bc-4fb2-9b0c-25482f8262fa	\N	\N	98b2ec68-490d-4a88-b1bd-05b5707e88da	52ca07a9-0979-49a2-8c5b-355ca4b38534	1	20	t	bec3d108-b2d3-4832-8d03-8e03c91db02d	\N
a7b3d6c7-1f4c-4ff6-a95b-6109be34db20	\N	conditional-user-configured	98b2ec68-490d-4a88-b1bd-05b5707e88da	bec3d108-b2d3-4832-8d03-8e03c91db02d	0	10	f	\N	\N
e30e3886-ade4-44f2-9225-0624655371be	\N	auth-otp-form	98b2ec68-490d-4a88-b1bd-05b5707e88da	bec3d108-b2d3-4832-8d03-8e03c91db02d	0	20	f	\N	\N
69bf52b1-2800-4608-b18f-b705509a7251	\N	http-basic-authenticator	98b2ec68-490d-4a88-b1bd-05b5707e88da	b1da6cd6-1c7e-4cce-8d44-563c80392f1d	0	10	f	\N	\N
0164bcd1-f93b-4929-ad97-93a9b0799b8d	\N	docker-http-basic-authenticator	98b2ec68-490d-4a88-b1bd-05b5707e88da	35ebbc3b-5a52-4317-bf58-587e19cfce16	0	10	f	\N	\N
da0563bd-121e-4d3b-9420-65badfebe889	\N	auth-cookie	545899ec-2a73-4c95-b368-425da707cea1	9c3bb2d9-d2b6-43c2-8e15-e3b8ab94fab5	2	10	f	\N	\N
43f592ab-c423-4207-ba84-bb42471814da	\N	auth-spnego	545899ec-2a73-4c95-b368-425da707cea1	9c3bb2d9-d2b6-43c2-8e15-e3b8ab94fab5	3	20	f	\N	\N
6703d85a-b49c-4444-a941-dd9552ca9a63	\N	identity-provider-redirector	545899ec-2a73-4c95-b368-425da707cea1	9c3bb2d9-d2b6-43c2-8e15-e3b8ab94fab5	2	25	f	\N	\N
a485ef52-f2b5-4c5b-8dda-fb579711653c	\N	\N	545899ec-2a73-4c95-b368-425da707cea1	9c3bb2d9-d2b6-43c2-8e15-e3b8ab94fab5	2	30	t	60a46f42-ca24-4da0-ab01-4eb770562162	\N
daf02634-591b-40c0-aead-85cf2f753dab	\N	auth-username-password-form	545899ec-2a73-4c95-b368-425da707cea1	60a46f42-ca24-4da0-ab01-4eb770562162	0	10	f	\N	\N
913e6159-890e-4114-ac91-5e8d6c5ac191	\N	\N	545899ec-2a73-4c95-b368-425da707cea1	60a46f42-ca24-4da0-ab01-4eb770562162	1	20	t	d95cd43a-df17-4abf-96c7-c04c7812f478	\N
862da9a9-4d58-43c1-85c1-b0293f15f736	\N	conditional-user-configured	545899ec-2a73-4c95-b368-425da707cea1	d95cd43a-df17-4abf-96c7-c04c7812f478	0	10	f	\N	\N
81be54f1-f384-4e5b-ab8d-e299d721eb48	\N	auth-otp-form	545899ec-2a73-4c95-b368-425da707cea1	d95cd43a-df17-4abf-96c7-c04c7812f478	0	20	f	\N	\N
27ecd2e0-8fa5-44c5-a377-0a22b54b8977	\N	direct-grant-validate-username	545899ec-2a73-4c95-b368-425da707cea1	84cae261-4275-4b1a-814d-fcd9cca08788	0	10	f	\N	\N
b72c9524-2f70-4431-b545-f90ed0c38e98	\N	direct-grant-validate-password	545899ec-2a73-4c95-b368-425da707cea1	84cae261-4275-4b1a-814d-fcd9cca08788	0	20	f	\N	\N
39886248-8300-4834-862d-245ec7c12b40	\N	\N	545899ec-2a73-4c95-b368-425da707cea1	84cae261-4275-4b1a-814d-fcd9cca08788	1	30	t	d8a7bf21-6a4e-4223-9fef-c9f32783b305	\N
5229a8a6-24de-4765-95d9-6c647f77ffd2	\N	conditional-user-configured	545899ec-2a73-4c95-b368-425da707cea1	d8a7bf21-6a4e-4223-9fef-c9f32783b305	0	10	f	\N	\N
4feb850f-00e0-4ff3-81ea-23a1e8c1218a	\N	direct-grant-validate-otp	545899ec-2a73-4c95-b368-425da707cea1	d8a7bf21-6a4e-4223-9fef-c9f32783b305	0	20	f	\N	\N
5f8ca6b7-93cb-4447-a01c-1dc392d868b0	\N	registration-page-form	545899ec-2a73-4c95-b368-425da707cea1	42754e79-22e2-4cb9-9931-53214609601c	0	10	t	ef9c2179-ecc3-4c66-8817-064c09193f58	\N
6a78a441-5635-419b-b2d3-49b591046751	\N	registration-user-creation	545899ec-2a73-4c95-b368-425da707cea1	ef9c2179-ecc3-4c66-8817-064c09193f58	0	20	f	\N	\N
6d24ae34-1836-4a2f-b4fd-a3faf2bd5994	\N	registration-password-action	545899ec-2a73-4c95-b368-425da707cea1	ef9c2179-ecc3-4c66-8817-064c09193f58	0	50	f	\N	\N
8c8ce170-1935-47ff-8230-c1bf922387ec	\N	registration-recaptcha-action	545899ec-2a73-4c95-b368-425da707cea1	ef9c2179-ecc3-4c66-8817-064c09193f58	3	60	f	\N	\N
b596b7b2-8deb-4398-a0e9-d9ef7a4cb43e	\N	registration-terms-and-conditions	545899ec-2a73-4c95-b368-425da707cea1	ef9c2179-ecc3-4c66-8817-064c09193f58	3	70	f	\N	\N
db1e0d1a-0fc9-4708-b14d-25375bf4e8c6	\N	reset-credentials-choose-user	545899ec-2a73-4c95-b368-425da707cea1	d601a09a-058c-4610-a3fe-f1ef4f61ee51	0	10	f	\N	\N
005776d4-8b72-41dd-a991-bcdf3471d2a5	\N	reset-credential-email	545899ec-2a73-4c95-b368-425da707cea1	d601a09a-058c-4610-a3fe-f1ef4f61ee51	0	20	f	\N	\N
a8a171f7-de4a-4670-8934-95cef52df5d7	\N	reset-password	545899ec-2a73-4c95-b368-425da707cea1	d601a09a-058c-4610-a3fe-f1ef4f61ee51	0	30	f	\N	\N
bb68001f-d64f-4dde-835d-63bce6390299	\N	\N	545899ec-2a73-4c95-b368-425da707cea1	d601a09a-058c-4610-a3fe-f1ef4f61ee51	1	40	t	d4e9a5e9-8cb8-4659-a28e-90e399c48aab	\N
1bf417d7-c9ae-48b5-9ba3-c7e770c2fb3f	\N	conditional-user-configured	545899ec-2a73-4c95-b368-425da707cea1	d4e9a5e9-8cb8-4659-a28e-90e399c48aab	0	10	f	\N	\N
1256a385-cee9-404e-8107-fda6b3e25995	\N	reset-otp	545899ec-2a73-4c95-b368-425da707cea1	d4e9a5e9-8cb8-4659-a28e-90e399c48aab	0	20	f	\N	\N
276666fc-da64-4dc4-ba1e-e34dd8b9d1b2	\N	client-secret	545899ec-2a73-4c95-b368-425da707cea1	f6740fd6-b59e-49b7-8445-29b85c7ce410	2	10	f	\N	\N
2bc0cdb0-cd28-43d8-89e1-74e7ff6cdd8e	\N	client-jwt	545899ec-2a73-4c95-b368-425da707cea1	f6740fd6-b59e-49b7-8445-29b85c7ce410	2	20	f	\N	\N
421216f0-b575-4c94-aa84-423bf696d0b9	\N	client-secret-jwt	545899ec-2a73-4c95-b368-425da707cea1	f6740fd6-b59e-49b7-8445-29b85c7ce410	2	30	f	\N	\N
d39172a2-2e21-4777-9954-f6a4f7da5b14	\N	client-x509	545899ec-2a73-4c95-b368-425da707cea1	f6740fd6-b59e-49b7-8445-29b85c7ce410	2	40	f	\N	\N
2e4b91b5-9319-452d-8ca2-c711cbc7fc07	\N	idp-review-profile	545899ec-2a73-4c95-b368-425da707cea1	4eafe314-6dd8-4dc5-ba9b-63ffcf24d400	0	10	f	\N	9177ff7f-6aff-44d9-a70e-f9e2438d30bd
f1b0a833-43e6-4788-aebd-b066284356d0	\N	\N	545899ec-2a73-4c95-b368-425da707cea1	4eafe314-6dd8-4dc5-ba9b-63ffcf24d400	0	20	t	feec1b09-0801-4172-adf3-0906272b95bc	\N
1e63ddfa-432a-40b2-8af7-4848c3139959	\N	idp-create-user-if-unique	545899ec-2a73-4c95-b368-425da707cea1	feec1b09-0801-4172-adf3-0906272b95bc	2	10	f	\N	690a1609-6549-4284-baf7-e29326d769c9
a17095e5-9bf3-47c1-a8e4-ecac1f3bd656	\N	\N	545899ec-2a73-4c95-b368-425da707cea1	feec1b09-0801-4172-adf3-0906272b95bc	2	20	t	59e45fd6-6d9e-42ac-bec1-2de919c291ae	\N
f1e12beb-58eb-443a-9b70-1fa3c92d83aa	\N	idp-confirm-link	545899ec-2a73-4c95-b368-425da707cea1	59e45fd6-6d9e-42ac-bec1-2de919c291ae	0	10	f	\N	\N
55581bfc-db59-4ec4-9ad3-0e40349fd42d	\N	\N	545899ec-2a73-4c95-b368-425da707cea1	59e45fd6-6d9e-42ac-bec1-2de919c291ae	0	20	t	0e6b9c34-60c9-491c-9da8-53031bd185f8	\N
da276f21-05e0-495f-aeac-d3e581112b17	\N	idp-email-verification	545899ec-2a73-4c95-b368-425da707cea1	0e6b9c34-60c9-491c-9da8-53031bd185f8	2	10	f	\N	\N
f0f86fdd-84f6-45c3-8101-3512ed8595ef	\N	\N	545899ec-2a73-4c95-b368-425da707cea1	0e6b9c34-60c9-491c-9da8-53031bd185f8	2	20	t	a3171021-1cfb-476b-a209-85fd046658fc	\N
7e72ccc9-5bbb-4706-99ed-e4fa8fe6be4f	\N	idp-username-password-form	545899ec-2a73-4c95-b368-425da707cea1	a3171021-1cfb-476b-a209-85fd046658fc	0	10	f	\N	\N
8801e016-b403-4c60-bc8a-dc6e0ae91851	\N	\N	545899ec-2a73-4c95-b368-425da707cea1	a3171021-1cfb-476b-a209-85fd046658fc	1	20	t	90c3fc0b-2b4c-4daf-a827-7948dbcf12a2	\N
5b148eae-316e-4461-ba4b-d4b6864fc28f	\N	conditional-user-configured	545899ec-2a73-4c95-b368-425da707cea1	90c3fc0b-2b4c-4daf-a827-7948dbcf12a2	0	10	f	\N	\N
4b321a14-c467-4b3b-9021-490b43f0fd57	\N	auth-otp-form	545899ec-2a73-4c95-b368-425da707cea1	90c3fc0b-2b4c-4daf-a827-7948dbcf12a2	0	20	f	\N	\N
afa0efb4-3a9a-4bad-831e-061e67140cc3	\N	http-basic-authenticator	545899ec-2a73-4c95-b368-425da707cea1	a0e9d7a1-c145-4712-a918-77afd689e4ef	0	10	f	\N	\N
323aec67-db15-4c22-8ab0-e78d46b6d52f	\N	docker-http-basic-authenticator	545899ec-2a73-4c95-b368-425da707cea1	09b36483-2b72-4b71-b7a1-61a63e41220b	0	10	f	\N	\N
\.


--
-- Data for Name: authentication_flow; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authentication_flow (id, alias, description, realm_id, provider_id, top_level, built_in) FROM stdin;
1ecdfd6c-7efb-4193-a807-843f0d4de9c0	browser	browser based authentication	98b2ec68-490d-4a88-b1bd-05b5707e88da	basic-flow	t	t
72dda9ac-c476-45a0-8534-68edeab7d850	forms	Username, password, otp and other auth forms.	98b2ec68-490d-4a88-b1bd-05b5707e88da	basic-flow	f	t
e2552811-2e9f-412e-8f17-7ed065adaf6e	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	98b2ec68-490d-4a88-b1bd-05b5707e88da	basic-flow	f	t
db4d3e83-56c2-4ea2-ae34-5b3e14a54989	direct grant	OpenID Connect Resource Owner Grant	98b2ec68-490d-4a88-b1bd-05b5707e88da	basic-flow	t	t
4fee87ef-f58a-4165-8a66-56d3c3101dfd	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	98b2ec68-490d-4a88-b1bd-05b5707e88da	basic-flow	f	t
8d4fbdd4-9d6e-4a36-a1a8-7eec490d1c3f	registration	registration flow	98b2ec68-490d-4a88-b1bd-05b5707e88da	basic-flow	t	t
63ebd547-865f-411b-aa26-582afc3ab9e0	registration form	registration form	98b2ec68-490d-4a88-b1bd-05b5707e88da	form-flow	f	t
d572418c-ee37-441e-a5bb-6d487cea0d3c	reset credentials	Reset credentials for a user if they forgot their password or something	98b2ec68-490d-4a88-b1bd-05b5707e88da	basic-flow	t	t
05aa3478-43fb-441d-a587-e6f64a95e42b	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	98b2ec68-490d-4a88-b1bd-05b5707e88da	basic-flow	f	t
f2a59aa2-f9b7-4785-98bc-f79de29cd083	clients	Base authentication for clients	98b2ec68-490d-4a88-b1bd-05b5707e88da	client-flow	t	t
c9553ad0-c2f2-420e-b9e1-fb8f6a810481	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	98b2ec68-490d-4a88-b1bd-05b5707e88da	basic-flow	t	t
5f83801f-a033-4fcf-a60a-a833756ea86f	User creation or linking	Flow for the existing/non-existing user alternatives	98b2ec68-490d-4a88-b1bd-05b5707e88da	basic-flow	f	t
60172b60-5d06-43f0-b4d3-3415e1f73b6f	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	98b2ec68-490d-4a88-b1bd-05b5707e88da	basic-flow	f	t
af53c6de-846e-47bf-9e08-398175061e94	Account verification options	Method with which to verity the existing account	98b2ec68-490d-4a88-b1bd-05b5707e88da	basic-flow	f	t
52ca07a9-0979-49a2-8c5b-355ca4b38534	Verify Existing Account by Re-authentication	Reauthentication of existing account	98b2ec68-490d-4a88-b1bd-05b5707e88da	basic-flow	f	t
bec3d108-b2d3-4832-8d03-8e03c91db02d	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	98b2ec68-490d-4a88-b1bd-05b5707e88da	basic-flow	f	t
b1da6cd6-1c7e-4cce-8d44-563c80392f1d	saml ecp	SAML ECP Profile Authentication Flow	98b2ec68-490d-4a88-b1bd-05b5707e88da	basic-flow	t	t
35ebbc3b-5a52-4317-bf58-587e19cfce16	docker auth	Used by Docker clients to authenticate against the IDP	98b2ec68-490d-4a88-b1bd-05b5707e88da	basic-flow	t	t
9c3bb2d9-d2b6-43c2-8e15-e3b8ab94fab5	browser	browser based authentication	545899ec-2a73-4c95-b368-425da707cea1	basic-flow	t	t
60a46f42-ca24-4da0-ab01-4eb770562162	forms	Username, password, otp and other auth forms.	545899ec-2a73-4c95-b368-425da707cea1	basic-flow	f	t
d95cd43a-df17-4abf-96c7-c04c7812f478	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	545899ec-2a73-4c95-b368-425da707cea1	basic-flow	f	t
84cae261-4275-4b1a-814d-fcd9cca08788	direct grant	OpenID Connect Resource Owner Grant	545899ec-2a73-4c95-b368-425da707cea1	basic-flow	t	t
d8a7bf21-6a4e-4223-9fef-c9f32783b305	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	545899ec-2a73-4c95-b368-425da707cea1	basic-flow	f	t
42754e79-22e2-4cb9-9931-53214609601c	registration	registration flow	545899ec-2a73-4c95-b368-425da707cea1	basic-flow	t	t
ef9c2179-ecc3-4c66-8817-064c09193f58	registration form	registration form	545899ec-2a73-4c95-b368-425da707cea1	form-flow	f	t
d601a09a-058c-4610-a3fe-f1ef4f61ee51	reset credentials	Reset credentials for a user if they forgot their password or something	545899ec-2a73-4c95-b368-425da707cea1	basic-flow	t	t
d4e9a5e9-8cb8-4659-a28e-90e399c48aab	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	545899ec-2a73-4c95-b368-425da707cea1	basic-flow	f	t
f6740fd6-b59e-49b7-8445-29b85c7ce410	clients	Base authentication for clients	545899ec-2a73-4c95-b368-425da707cea1	client-flow	t	t
4eafe314-6dd8-4dc5-ba9b-63ffcf24d400	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	545899ec-2a73-4c95-b368-425da707cea1	basic-flow	t	t
feec1b09-0801-4172-adf3-0906272b95bc	User creation or linking	Flow for the existing/non-existing user alternatives	545899ec-2a73-4c95-b368-425da707cea1	basic-flow	f	t
59e45fd6-6d9e-42ac-bec1-2de919c291ae	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	545899ec-2a73-4c95-b368-425da707cea1	basic-flow	f	t
0e6b9c34-60c9-491c-9da8-53031bd185f8	Account verification options	Method with which to verity the existing account	545899ec-2a73-4c95-b368-425da707cea1	basic-flow	f	t
a3171021-1cfb-476b-a209-85fd046658fc	Verify Existing Account by Re-authentication	Reauthentication of existing account	545899ec-2a73-4c95-b368-425da707cea1	basic-flow	f	t
90c3fc0b-2b4c-4daf-a827-7948dbcf12a2	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	545899ec-2a73-4c95-b368-425da707cea1	basic-flow	f	t
a0e9d7a1-c145-4712-a918-77afd689e4ef	saml ecp	SAML ECP Profile Authentication Flow	545899ec-2a73-4c95-b368-425da707cea1	basic-flow	t	t
09b36483-2b72-4b71-b7a1-61a63e41220b	docker auth	Used by Docker clients to authenticate against the IDP	545899ec-2a73-4c95-b368-425da707cea1	basic-flow	t	t
\.


--
-- Data for Name: authenticator_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authenticator_config (id, alias, realm_id) FROM stdin;
e9362a1c-f8d5-45b6-ae65-1bef6e2eb5c7	review profile config	98b2ec68-490d-4a88-b1bd-05b5707e88da
13e16d69-00b8-4604-8ae9-aec13af4755e	create unique user config	98b2ec68-490d-4a88-b1bd-05b5707e88da
9177ff7f-6aff-44d9-a70e-f9e2438d30bd	review profile config	545899ec-2a73-4c95-b368-425da707cea1
690a1609-6549-4284-baf7-e29326d769c9	create unique user config	545899ec-2a73-4c95-b368-425da707cea1
\.


--
-- Data for Name: authenticator_config_entry; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authenticator_config_entry (authenticator_id, value, name) FROM stdin;
13e16d69-00b8-4604-8ae9-aec13af4755e	false	require.password.update.after.registration
e9362a1c-f8d5-45b6-ae65-1bef6e2eb5c7	missing	update.profile.on.first.login
690a1609-6549-4284-baf7-e29326d769c9	false	require.password.update.after.registration
9177ff7f-6aff-44d9-a70e-f9e2438d30bd	missing	update.profile.on.first.login
\.


--
-- Data for Name: broker_link; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.broker_link (identity_provider, storage_provider_id, realm_id, broker_user_id, broker_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client (id, enabled, full_scope_allowed, client_id, not_before, public_client, secret, base_url, bearer_only, management_url, surrogate_auth_required, realm_id, protocol, node_rereg_timeout, frontchannel_logout, consent_required, name, service_accounts_enabled, client_authenticator_type, root_url, description, registration_token, standard_flow_enabled, implicit_flow_enabled, direct_access_grants_enabled, always_display_in_console) FROM stdin;
fe642ed6-7328-4dc5-82c1-a7c74140cef4	t	f	master-realm	0	f	\N	\N	t	\N	f	98b2ec68-490d-4a88-b1bd-05b5707e88da	\N	0	f	f	master Realm	f	client-secret	\N	\N	\N	t	f	f	f
55bd8a5b-3f67-4667-9e35-9010417f108a	t	f	account	0	t	\N	/realms/master/account/	f	\N	f	98b2ec68-490d-4a88-b1bd-05b5707e88da	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
d2c379b9-8493-47e1-82d8-9f5b2791c11a	t	f	account-console	0	t	\N	/realms/master/account/	f	\N	f	98b2ec68-490d-4a88-b1bd-05b5707e88da	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
51a1b14f-346a-4213-a434-792f9f437336	t	f	broker	0	f	\N	\N	t	\N	f	98b2ec68-490d-4a88-b1bd-05b5707e88da	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
d4c63c03-da48-4170-b5dd-03fe25bc3bc7	t	t	security-admin-console	0	t	\N	/admin/purchase-service-realm/console/	f	\N	f	545899ec-2a73-4c95-b368-425da707cea1	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
93e6a496-3882-4eb1-b9de-54706ffadf03	t	f	realm-management	0	f	\N	\N	t	\N	f	545899ec-2a73-4c95-b368-425da707cea1	openid-connect	0	f	f	${client_realm-management}	f	client-secret	\N	\N	\N	t	f	f	f
7e6b42db-252d-4396-ac22-11917ef97257	t	f	broker	0	f	\N	\N	t	\N	f	545899ec-2a73-4c95-b368-425da707cea1	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
db7fb3a7-14a1-4b7e-9379-8905016349db	t	t	web-frontend-client	0	t	\N		f		f	545899ec-2a73-4c95-b368-425da707cea1	openid-connect	-1	t	f		f	client-secret		pkce client	\N	t	f	f	f
b47e2542-cc0b-453d-993f-e73422e7a44e	t	t	security-admin-console	0	t	\N	/admin/master/console/	f	\N	f	98b2ec68-490d-4a88-b1bd-05b5707e88da	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
3b9bf017-eac3-4f6f-a5ff-355ca092fa85	t	t	admin-cli	0	t	\N	\N	f	\N	f	98b2ec68-490d-4a88-b1bd-05b5707e88da	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
ba6a831d-ceef-4ba6-9157-1ebcf85c411c	t	t	admin-cli	0	t	\N	\N	f	\N	f	545899ec-2a73-4c95-b368-425da707cea1	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
50c8e8fd-de3b-4877-ac29-f8644a9d0bb0	t	t	purchase-service-client	0	f	RnYg7HfAeTDJJrOZ1ASFbg1gjzYZTbRf		f		f	545899ec-2a73-4c95-b368-425da707cea1	openid-connect	-1	t	f		f	client-secret			\N	t	f	f	f
9969ca14-fb6b-4b25-9ee4-8fca05889e15	t	f	purchase-service-realm-realm	0	f	\N	\N	t	\N	f	98b2ec68-490d-4a88-b1bd-05b5707e88da	\N	0	f	f	purchase-app-realm Realm	f	client-secret	\N	\N	\N	t	f	f	f
191b61d7-ca16-4c99-b7f7-828b3391d614	t	f	account-console	0	t	\N	/realms/purchase-service-realm/account/	f	\N	f	545899ec-2a73-4c95-b368-425da707cea1	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
8ed73690-8dd1-4434-b5ca-2665456bae8e	t	f	account	0	t	\N	/realms/purchase-service-realm/account/	f	\N	f	545899ec-2a73-4c95-b368-425da707cea1	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
\.


--
-- Data for Name: client_attributes; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_attributes (client_id, name, value) FROM stdin;
55bd8a5b-3f67-4667-9e35-9010417f108a	post.logout.redirect.uris	+
d2c379b9-8493-47e1-82d8-9f5b2791c11a	post.logout.redirect.uris	+
d2c379b9-8493-47e1-82d8-9f5b2791c11a	pkce.code.challenge.method	S256
b47e2542-cc0b-453d-993f-e73422e7a44e	post.logout.redirect.uris	+
b47e2542-cc0b-453d-993f-e73422e7a44e	pkce.code.challenge.method	S256
8ed73690-8dd1-4434-b5ca-2665456bae8e	post.logout.redirect.uris	+
191b61d7-ca16-4c99-b7f7-828b3391d614	post.logout.redirect.uris	+
191b61d7-ca16-4c99-b7f7-828b3391d614	pkce.code.challenge.method	S256
d4c63c03-da48-4170-b5dd-03fe25bc3bc7	post.logout.redirect.uris	+
d4c63c03-da48-4170-b5dd-03fe25bc3bc7	pkce.code.challenge.method	S256
b47e2542-cc0b-453d-993f-e73422e7a44e	client.use.lightweight.access.token.enabled	true
3b9bf017-eac3-4f6f-a5ff-355ca092fa85	client.use.lightweight.access.token.enabled	true
d4c63c03-da48-4170-b5dd-03fe25bc3bc7	client.use.lightweight.access.token.enabled	true
ba6a831d-ceef-4ba6-9157-1ebcf85c411c	client.use.lightweight.access.token.enabled	true
50c8e8fd-de3b-4877-ac29-f8644a9d0bb0	client.secret.creation.time	1749044741
50c8e8fd-de3b-4877-ac29-f8644a9d0bb0	standard.token.exchange.enabled	false
50c8e8fd-de3b-4877-ac29-f8644a9d0bb0	oauth2.device.authorization.grant.enabled	false
50c8e8fd-de3b-4877-ac29-f8644a9d0bb0	oidc.ciba.grant.enabled	false
50c8e8fd-de3b-4877-ac29-f8644a9d0bb0	backchannel.logout.session.required	true
50c8e8fd-de3b-4877-ac29-f8644a9d0bb0	backchannel.logout.revoke.offline.tokens	false
50c8e8fd-de3b-4877-ac29-f8644a9d0bb0	realm_client	false
50c8e8fd-de3b-4877-ac29-f8644a9d0bb0	display.on.consent.screen	false
50c8e8fd-de3b-4877-ac29-f8644a9d0bb0	frontchannel.logout.session.required	true
db7fb3a7-14a1-4b7e-9379-8905016349db	standard.token.exchange.enabled	false
db7fb3a7-14a1-4b7e-9379-8905016349db	oauth2.device.authorization.grant.enabled	false
db7fb3a7-14a1-4b7e-9379-8905016349db	oidc.ciba.grant.enabled	false
db7fb3a7-14a1-4b7e-9379-8905016349db	backchannel.logout.session.required	true
db7fb3a7-14a1-4b7e-9379-8905016349db	backchannel.logout.revoke.offline.tokens	false
db7fb3a7-14a1-4b7e-9379-8905016349db	realm_client	false
db7fb3a7-14a1-4b7e-9379-8905016349db	display.on.consent.screen	false
db7fb3a7-14a1-4b7e-9379-8905016349db	frontchannel.logout.session.required	true
db7fb3a7-14a1-4b7e-9379-8905016349db	access.token.header.type.rfc9068	false
db7fb3a7-14a1-4b7e-9379-8905016349db	request.object.signature.alg	any
db7fb3a7-14a1-4b7e-9379-8905016349db	request.object.encryption.alg	any
db7fb3a7-14a1-4b7e-9379-8905016349db	request.object.encryption.enc	any
db7fb3a7-14a1-4b7e-9379-8905016349db	request.object.required	not required
db7fb3a7-14a1-4b7e-9379-8905016349db	use.refresh.tokens	true
db7fb3a7-14a1-4b7e-9379-8905016349db	client_credentials.use_refresh_token	false
db7fb3a7-14a1-4b7e-9379-8905016349db	token.response.type.bearer.lower-case	false
db7fb3a7-14a1-4b7e-9379-8905016349db	tls.client.certificate.bound.access.tokens	false
db7fb3a7-14a1-4b7e-9379-8905016349db	pkce.code.challenge.method	S256
db7fb3a7-14a1-4b7e-9379-8905016349db	require.pushed.authorization.requests	false
db7fb3a7-14a1-4b7e-9379-8905016349db	client.use.lightweight.access.token.enabled	false
db7fb3a7-14a1-4b7e-9379-8905016349db	client.introspection.response.allow.jwt.claim.enabled	false
db7fb3a7-14a1-4b7e-9379-8905016349db	acr.loa.map	{}
\.


--
-- Data for Name: client_auth_flow_bindings; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_auth_flow_bindings (client_id, flow_id, binding_name) FROM stdin;
\.


--
-- Data for Name: client_initial_access; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_initial_access (id, realm_id, "timestamp", expiration, count, remaining_count) FROM stdin;
\.


--
-- Data for Name: client_node_registrations; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_node_registrations (client_id, value, name) FROM stdin;
\.


--
-- Data for Name: client_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope (id, name, realm_id, description, protocol) FROM stdin;
ec3648e1-1066-447d-96f5-2d8eb0bc46ff	offline_access	98b2ec68-490d-4a88-b1bd-05b5707e88da	OpenID Connect built-in scope: offline_access	openid-connect
8e7645f4-2451-45ad-9b23-2f134644b247	role_list	98b2ec68-490d-4a88-b1bd-05b5707e88da	SAML role list	saml
07c92273-56d0-4146-9527-06062df4ecd9	profile	98b2ec68-490d-4a88-b1bd-05b5707e88da	OpenID Connect built-in scope: profile	openid-connect
b5d7f679-2dd9-4ce7-8afe-cc3c11e64c33	email	98b2ec68-490d-4a88-b1bd-05b5707e88da	OpenID Connect built-in scope: email	openid-connect
74e0b3a0-0717-4f2e-84b6-84b3f670f740	address	98b2ec68-490d-4a88-b1bd-05b5707e88da	OpenID Connect built-in scope: address	openid-connect
692aa94c-6422-440f-9dec-db751b7f8a57	phone	98b2ec68-490d-4a88-b1bd-05b5707e88da	OpenID Connect built-in scope: phone	openid-connect
d42fac06-27aa-481e-9120-aa41eb07ed8b	roles	98b2ec68-490d-4a88-b1bd-05b5707e88da	OpenID Connect scope for add user roles to the access token	openid-connect
1dcefe0f-2d1c-4b9c-8339-7726fda71005	web-origins	98b2ec68-490d-4a88-b1bd-05b5707e88da	OpenID Connect scope for add allowed web origins to the access token	openid-connect
5fe5a21a-329d-4f02-bf01-bc0e865b3d86	microprofile-jwt	98b2ec68-490d-4a88-b1bd-05b5707e88da	Microprofile - JWT built-in scope	openid-connect
f82ae212-bd5e-4214-b06f-300ff86113d4	acr	98b2ec68-490d-4a88-b1bd-05b5707e88da	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
29e5c5c9-0e32-4c8f-a52d-952b88a08b3e	offline_access	545899ec-2a73-4c95-b368-425da707cea1	OpenID Connect built-in scope: offline_access	openid-connect
8584251b-aac3-4cbb-88b5-c8f296ba05a1	role_list	545899ec-2a73-4c95-b368-425da707cea1	SAML role list	saml
fa8768c8-e248-4760-934c-539eaa982a8d	profile	545899ec-2a73-4c95-b368-425da707cea1	OpenID Connect built-in scope: profile	openid-connect
c7cdc97f-181a-4536-960a-e895810f0f23	email	545899ec-2a73-4c95-b368-425da707cea1	OpenID Connect built-in scope: email	openid-connect
9dec93f8-97b6-433c-8335-7cec3f030f56	address	545899ec-2a73-4c95-b368-425da707cea1	OpenID Connect built-in scope: address	openid-connect
627847cc-3caf-4b2f-976f-03da61fa4cdc	phone	545899ec-2a73-4c95-b368-425da707cea1	OpenID Connect built-in scope: phone	openid-connect
bd452d3d-137b-4f49-bdce-c477b2bbc742	roles	545899ec-2a73-4c95-b368-425da707cea1	OpenID Connect scope for add user roles to the access token	openid-connect
825e1390-66c9-47fd-b238-80702e480d73	web-origins	545899ec-2a73-4c95-b368-425da707cea1	OpenID Connect scope for add allowed web origins to the access token	openid-connect
d9a604e1-9343-404b-9357-79506e6a3324	microprofile-jwt	545899ec-2a73-4c95-b368-425da707cea1	Microprofile - JWT built-in scope	openid-connect
dcda8ff0-d811-443f-9d49-7e6f8922de1b	acr	545899ec-2a73-4c95-b368-425da707cea1	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
2ae9433c-7e7a-408c-9a6d-7c1f5d28b126	basic	98b2ec68-490d-4a88-b1bd-05b5707e88da	OpenID Connect scope for add all basic claims to the token	openid-connect
f893822a-ff36-4193-812f-628b2d9e1737	basic	545899ec-2a73-4c95-b368-425da707cea1	OpenID Connect scope for add all basic claims to the token	openid-connect
f1705fc0-918a-4bff-9dbe-ca60a0204918	service_account	98b2ec68-490d-4a88-b1bd-05b5707e88da	Specific scope for a client enabled for service accounts	openid-connect
244661a6-24a7-400a-b4fd-c0d9ed73f85a	service_account	545899ec-2a73-4c95-b368-425da707cea1	Specific scope for a client enabled for service accounts	openid-connect
\.


--
-- Data for Name: client_scope_attributes; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope_attributes (scope_id, value, name) FROM stdin;
ec3648e1-1066-447d-96f5-2d8eb0bc46ff	true	display.on.consent.screen
ec3648e1-1066-447d-96f5-2d8eb0bc46ff	${offlineAccessScopeConsentText}	consent.screen.text
8e7645f4-2451-45ad-9b23-2f134644b247	true	display.on.consent.screen
8e7645f4-2451-45ad-9b23-2f134644b247	${samlRoleListScopeConsentText}	consent.screen.text
07c92273-56d0-4146-9527-06062df4ecd9	true	display.on.consent.screen
07c92273-56d0-4146-9527-06062df4ecd9	${profileScopeConsentText}	consent.screen.text
07c92273-56d0-4146-9527-06062df4ecd9	true	include.in.token.scope
b5d7f679-2dd9-4ce7-8afe-cc3c11e64c33	true	display.on.consent.screen
b5d7f679-2dd9-4ce7-8afe-cc3c11e64c33	${emailScopeConsentText}	consent.screen.text
b5d7f679-2dd9-4ce7-8afe-cc3c11e64c33	true	include.in.token.scope
74e0b3a0-0717-4f2e-84b6-84b3f670f740	true	display.on.consent.screen
74e0b3a0-0717-4f2e-84b6-84b3f670f740	${addressScopeConsentText}	consent.screen.text
74e0b3a0-0717-4f2e-84b6-84b3f670f740	true	include.in.token.scope
692aa94c-6422-440f-9dec-db751b7f8a57	true	display.on.consent.screen
692aa94c-6422-440f-9dec-db751b7f8a57	${phoneScopeConsentText}	consent.screen.text
692aa94c-6422-440f-9dec-db751b7f8a57	true	include.in.token.scope
d42fac06-27aa-481e-9120-aa41eb07ed8b	true	display.on.consent.screen
d42fac06-27aa-481e-9120-aa41eb07ed8b	${rolesScopeConsentText}	consent.screen.text
d42fac06-27aa-481e-9120-aa41eb07ed8b	false	include.in.token.scope
1dcefe0f-2d1c-4b9c-8339-7726fda71005	false	display.on.consent.screen
1dcefe0f-2d1c-4b9c-8339-7726fda71005		consent.screen.text
1dcefe0f-2d1c-4b9c-8339-7726fda71005	false	include.in.token.scope
5fe5a21a-329d-4f02-bf01-bc0e865b3d86	false	display.on.consent.screen
5fe5a21a-329d-4f02-bf01-bc0e865b3d86	true	include.in.token.scope
f82ae212-bd5e-4214-b06f-300ff86113d4	false	display.on.consent.screen
f82ae212-bd5e-4214-b06f-300ff86113d4	false	include.in.token.scope
29e5c5c9-0e32-4c8f-a52d-952b88a08b3e	true	display.on.consent.screen
29e5c5c9-0e32-4c8f-a52d-952b88a08b3e	${offlineAccessScopeConsentText}	consent.screen.text
8584251b-aac3-4cbb-88b5-c8f296ba05a1	true	display.on.consent.screen
8584251b-aac3-4cbb-88b5-c8f296ba05a1	${samlRoleListScopeConsentText}	consent.screen.text
fa8768c8-e248-4760-934c-539eaa982a8d	true	display.on.consent.screen
fa8768c8-e248-4760-934c-539eaa982a8d	${profileScopeConsentText}	consent.screen.text
fa8768c8-e248-4760-934c-539eaa982a8d	true	include.in.token.scope
c7cdc97f-181a-4536-960a-e895810f0f23	true	display.on.consent.screen
c7cdc97f-181a-4536-960a-e895810f0f23	${emailScopeConsentText}	consent.screen.text
c7cdc97f-181a-4536-960a-e895810f0f23	true	include.in.token.scope
9dec93f8-97b6-433c-8335-7cec3f030f56	true	display.on.consent.screen
9dec93f8-97b6-433c-8335-7cec3f030f56	${addressScopeConsentText}	consent.screen.text
9dec93f8-97b6-433c-8335-7cec3f030f56	true	include.in.token.scope
627847cc-3caf-4b2f-976f-03da61fa4cdc	true	display.on.consent.screen
627847cc-3caf-4b2f-976f-03da61fa4cdc	${phoneScopeConsentText}	consent.screen.text
627847cc-3caf-4b2f-976f-03da61fa4cdc	true	include.in.token.scope
bd452d3d-137b-4f49-bdce-c477b2bbc742	true	display.on.consent.screen
bd452d3d-137b-4f49-bdce-c477b2bbc742	${rolesScopeConsentText}	consent.screen.text
bd452d3d-137b-4f49-bdce-c477b2bbc742	false	include.in.token.scope
825e1390-66c9-47fd-b238-80702e480d73	false	display.on.consent.screen
825e1390-66c9-47fd-b238-80702e480d73		consent.screen.text
825e1390-66c9-47fd-b238-80702e480d73	false	include.in.token.scope
d9a604e1-9343-404b-9357-79506e6a3324	false	display.on.consent.screen
d9a604e1-9343-404b-9357-79506e6a3324	true	include.in.token.scope
dcda8ff0-d811-443f-9d49-7e6f8922de1b	false	display.on.consent.screen
dcda8ff0-d811-443f-9d49-7e6f8922de1b	false	include.in.token.scope
2ae9433c-7e7a-408c-9a6d-7c1f5d28b126	false	display.on.consent.screen
2ae9433c-7e7a-408c-9a6d-7c1f5d28b126	false	include.in.token.scope
f893822a-ff36-4193-812f-628b2d9e1737	false	display.on.consent.screen
f893822a-ff36-4193-812f-628b2d9e1737	false	include.in.token.scope
f1705fc0-918a-4bff-9dbe-ca60a0204918	false	display.on.consent.screen
f1705fc0-918a-4bff-9dbe-ca60a0204918	false	include.in.token.scope
244661a6-24a7-400a-b4fd-c0d9ed73f85a	false	display.on.consent.screen
244661a6-24a7-400a-b4fd-c0d9ed73f85a	false	include.in.token.scope
\.


--
-- Data for Name: client_scope_client; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope_client (client_id, scope_id, default_scope) FROM stdin;
55bd8a5b-3f67-4667-9e35-9010417f108a	1dcefe0f-2d1c-4b9c-8339-7726fda71005	t
55bd8a5b-3f67-4667-9e35-9010417f108a	07c92273-56d0-4146-9527-06062df4ecd9	t
55bd8a5b-3f67-4667-9e35-9010417f108a	b5d7f679-2dd9-4ce7-8afe-cc3c11e64c33	t
55bd8a5b-3f67-4667-9e35-9010417f108a	f82ae212-bd5e-4214-b06f-300ff86113d4	t
55bd8a5b-3f67-4667-9e35-9010417f108a	d42fac06-27aa-481e-9120-aa41eb07ed8b	t
55bd8a5b-3f67-4667-9e35-9010417f108a	ec3648e1-1066-447d-96f5-2d8eb0bc46ff	f
55bd8a5b-3f67-4667-9e35-9010417f108a	692aa94c-6422-440f-9dec-db751b7f8a57	f
55bd8a5b-3f67-4667-9e35-9010417f108a	5fe5a21a-329d-4f02-bf01-bc0e865b3d86	f
55bd8a5b-3f67-4667-9e35-9010417f108a	74e0b3a0-0717-4f2e-84b6-84b3f670f740	f
d2c379b9-8493-47e1-82d8-9f5b2791c11a	1dcefe0f-2d1c-4b9c-8339-7726fda71005	t
d2c379b9-8493-47e1-82d8-9f5b2791c11a	07c92273-56d0-4146-9527-06062df4ecd9	t
d2c379b9-8493-47e1-82d8-9f5b2791c11a	b5d7f679-2dd9-4ce7-8afe-cc3c11e64c33	t
d2c379b9-8493-47e1-82d8-9f5b2791c11a	f82ae212-bd5e-4214-b06f-300ff86113d4	t
d2c379b9-8493-47e1-82d8-9f5b2791c11a	d42fac06-27aa-481e-9120-aa41eb07ed8b	t
d2c379b9-8493-47e1-82d8-9f5b2791c11a	ec3648e1-1066-447d-96f5-2d8eb0bc46ff	f
d2c379b9-8493-47e1-82d8-9f5b2791c11a	692aa94c-6422-440f-9dec-db751b7f8a57	f
d2c379b9-8493-47e1-82d8-9f5b2791c11a	5fe5a21a-329d-4f02-bf01-bc0e865b3d86	f
d2c379b9-8493-47e1-82d8-9f5b2791c11a	74e0b3a0-0717-4f2e-84b6-84b3f670f740	f
3b9bf017-eac3-4f6f-a5ff-355ca092fa85	1dcefe0f-2d1c-4b9c-8339-7726fda71005	t
3b9bf017-eac3-4f6f-a5ff-355ca092fa85	07c92273-56d0-4146-9527-06062df4ecd9	t
3b9bf017-eac3-4f6f-a5ff-355ca092fa85	b5d7f679-2dd9-4ce7-8afe-cc3c11e64c33	t
3b9bf017-eac3-4f6f-a5ff-355ca092fa85	f82ae212-bd5e-4214-b06f-300ff86113d4	t
3b9bf017-eac3-4f6f-a5ff-355ca092fa85	d42fac06-27aa-481e-9120-aa41eb07ed8b	t
3b9bf017-eac3-4f6f-a5ff-355ca092fa85	ec3648e1-1066-447d-96f5-2d8eb0bc46ff	f
3b9bf017-eac3-4f6f-a5ff-355ca092fa85	692aa94c-6422-440f-9dec-db751b7f8a57	f
3b9bf017-eac3-4f6f-a5ff-355ca092fa85	5fe5a21a-329d-4f02-bf01-bc0e865b3d86	f
3b9bf017-eac3-4f6f-a5ff-355ca092fa85	74e0b3a0-0717-4f2e-84b6-84b3f670f740	f
51a1b14f-346a-4213-a434-792f9f437336	1dcefe0f-2d1c-4b9c-8339-7726fda71005	t
51a1b14f-346a-4213-a434-792f9f437336	07c92273-56d0-4146-9527-06062df4ecd9	t
51a1b14f-346a-4213-a434-792f9f437336	b5d7f679-2dd9-4ce7-8afe-cc3c11e64c33	t
51a1b14f-346a-4213-a434-792f9f437336	f82ae212-bd5e-4214-b06f-300ff86113d4	t
51a1b14f-346a-4213-a434-792f9f437336	d42fac06-27aa-481e-9120-aa41eb07ed8b	t
51a1b14f-346a-4213-a434-792f9f437336	ec3648e1-1066-447d-96f5-2d8eb0bc46ff	f
51a1b14f-346a-4213-a434-792f9f437336	692aa94c-6422-440f-9dec-db751b7f8a57	f
51a1b14f-346a-4213-a434-792f9f437336	5fe5a21a-329d-4f02-bf01-bc0e865b3d86	f
51a1b14f-346a-4213-a434-792f9f437336	74e0b3a0-0717-4f2e-84b6-84b3f670f740	f
fe642ed6-7328-4dc5-82c1-a7c74140cef4	1dcefe0f-2d1c-4b9c-8339-7726fda71005	t
fe642ed6-7328-4dc5-82c1-a7c74140cef4	07c92273-56d0-4146-9527-06062df4ecd9	t
fe642ed6-7328-4dc5-82c1-a7c74140cef4	b5d7f679-2dd9-4ce7-8afe-cc3c11e64c33	t
fe642ed6-7328-4dc5-82c1-a7c74140cef4	f82ae212-bd5e-4214-b06f-300ff86113d4	t
fe642ed6-7328-4dc5-82c1-a7c74140cef4	d42fac06-27aa-481e-9120-aa41eb07ed8b	t
fe642ed6-7328-4dc5-82c1-a7c74140cef4	ec3648e1-1066-447d-96f5-2d8eb0bc46ff	f
fe642ed6-7328-4dc5-82c1-a7c74140cef4	692aa94c-6422-440f-9dec-db751b7f8a57	f
fe642ed6-7328-4dc5-82c1-a7c74140cef4	5fe5a21a-329d-4f02-bf01-bc0e865b3d86	f
fe642ed6-7328-4dc5-82c1-a7c74140cef4	74e0b3a0-0717-4f2e-84b6-84b3f670f740	f
b47e2542-cc0b-453d-993f-e73422e7a44e	1dcefe0f-2d1c-4b9c-8339-7726fda71005	t
b47e2542-cc0b-453d-993f-e73422e7a44e	07c92273-56d0-4146-9527-06062df4ecd9	t
b47e2542-cc0b-453d-993f-e73422e7a44e	b5d7f679-2dd9-4ce7-8afe-cc3c11e64c33	t
b47e2542-cc0b-453d-993f-e73422e7a44e	f82ae212-bd5e-4214-b06f-300ff86113d4	t
b47e2542-cc0b-453d-993f-e73422e7a44e	d42fac06-27aa-481e-9120-aa41eb07ed8b	t
b47e2542-cc0b-453d-993f-e73422e7a44e	ec3648e1-1066-447d-96f5-2d8eb0bc46ff	f
b47e2542-cc0b-453d-993f-e73422e7a44e	692aa94c-6422-440f-9dec-db751b7f8a57	f
b47e2542-cc0b-453d-993f-e73422e7a44e	5fe5a21a-329d-4f02-bf01-bc0e865b3d86	f
b47e2542-cc0b-453d-993f-e73422e7a44e	74e0b3a0-0717-4f2e-84b6-84b3f670f740	f
8ed73690-8dd1-4434-b5ca-2665456bae8e	c7cdc97f-181a-4536-960a-e895810f0f23	t
8ed73690-8dd1-4434-b5ca-2665456bae8e	dcda8ff0-d811-443f-9d49-7e6f8922de1b	t
8ed73690-8dd1-4434-b5ca-2665456bae8e	fa8768c8-e248-4760-934c-539eaa982a8d	t
8ed73690-8dd1-4434-b5ca-2665456bae8e	825e1390-66c9-47fd-b238-80702e480d73	t
8ed73690-8dd1-4434-b5ca-2665456bae8e	bd452d3d-137b-4f49-bdce-c477b2bbc742	t
8ed73690-8dd1-4434-b5ca-2665456bae8e	d9a604e1-9343-404b-9357-79506e6a3324	f
8ed73690-8dd1-4434-b5ca-2665456bae8e	9dec93f8-97b6-433c-8335-7cec3f030f56	f
8ed73690-8dd1-4434-b5ca-2665456bae8e	627847cc-3caf-4b2f-976f-03da61fa4cdc	f
8ed73690-8dd1-4434-b5ca-2665456bae8e	29e5c5c9-0e32-4c8f-a52d-952b88a08b3e	f
191b61d7-ca16-4c99-b7f7-828b3391d614	c7cdc97f-181a-4536-960a-e895810f0f23	t
191b61d7-ca16-4c99-b7f7-828b3391d614	dcda8ff0-d811-443f-9d49-7e6f8922de1b	t
191b61d7-ca16-4c99-b7f7-828b3391d614	fa8768c8-e248-4760-934c-539eaa982a8d	t
191b61d7-ca16-4c99-b7f7-828b3391d614	825e1390-66c9-47fd-b238-80702e480d73	t
191b61d7-ca16-4c99-b7f7-828b3391d614	bd452d3d-137b-4f49-bdce-c477b2bbc742	t
191b61d7-ca16-4c99-b7f7-828b3391d614	d9a604e1-9343-404b-9357-79506e6a3324	f
191b61d7-ca16-4c99-b7f7-828b3391d614	9dec93f8-97b6-433c-8335-7cec3f030f56	f
191b61d7-ca16-4c99-b7f7-828b3391d614	627847cc-3caf-4b2f-976f-03da61fa4cdc	f
191b61d7-ca16-4c99-b7f7-828b3391d614	29e5c5c9-0e32-4c8f-a52d-952b88a08b3e	f
ba6a831d-ceef-4ba6-9157-1ebcf85c411c	c7cdc97f-181a-4536-960a-e895810f0f23	t
ba6a831d-ceef-4ba6-9157-1ebcf85c411c	dcda8ff0-d811-443f-9d49-7e6f8922de1b	t
ba6a831d-ceef-4ba6-9157-1ebcf85c411c	fa8768c8-e248-4760-934c-539eaa982a8d	t
ba6a831d-ceef-4ba6-9157-1ebcf85c411c	825e1390-66c9-47fd-b238-80702e480d73	t
ba6a831d-ceef-4ba6-9157-1ebcf85c411c	bd452d3d-137b-4f49-bdce-c477b2bbc742	t
ba6a831d-ceef-4ba6-9157-1ebcf85c411c	d9a604e1-9343-404b-9357-79506e6a3324	f
ba6a831d-ceef-4ba6-9157-1ebcf85c411c	9dec93f8-97b6-433c-8335-7cec3f030f56	f
ba6a831d-ceef-4ba6-9157-1ebcf85c411c	627847cc-3caf-4b2f-976f-03da61fa4cdc	f
ba6a831d-ceef-4ba6-9157-1ebcf85c411c	29e5c5c9-0e32-4c8f-a52d-952b88a08b3e	f
7e6b42db-252d-4396-ac22-11917ef97257	c7cdc97f-181a-4536-960a-e895810f0f23	t
7e6b42db-252d-4396-ac22-11917ef97257	dcda8ff0-d811-443f-9d49-7e6f8922de1b	t
7e6b42db-252d-4396-ac22-11917ef97257	fa8768c8-e248-4760-934c-539eaa982a8d	t
7e6b42db-252d-4396-ac22-11917ef97257	825e1390-66c9-47fd-b238-80702e480d73	t
7e6b42db-252d-4396-ac22-11917ef97257	bd452d3d-137b-4f49-bdce-c477b2bbc742	t
7e6b42db-252d-4396-ac22-11917ef97257	d9a604e1-9343-404b-9357-79506e6a3324	f
7e6b42db-252d-4396-ac22-11917ef97257	9dec93f8-97b6-433c-8335-7cec3f030f56	f
7e6b42db-252d-4396-ac22-11917ef97257	627847cc-3caf-4b2f-976f-03da61fa4cdc	f
7e6b42db-252d-4396-ac22-11917ef97257	29e5c5c9-0e32-4c8f-a52d-952b88a08b3e	f
93e6a496-3882-4eb1-b9de-54706ffadf03	c7cdc97f-181a-4536-960a-e895810f0f23	t
93e6a496-3882-4eb1-b9de-54706ffadf03	dcda8ff0-d811-443f-9d49-7e6f8922de1b	t
93e6a496-3882-4eb1-b9de-54706ffadf03	fa8768c8-e248-4760-934c-539eaa982a8d	t
93e6a496-3882-4eb1-b9de-54706ffadf03	825e1390-66c9-47fd-b238-80702e480d73	t
93e6a496-3882-4eb1-b9de-54706ffadf03	bd452d3d-137b-4f49-bdce-c477b2bbc742	t
93e6a496-3882-4eb1-b9de-54706ffadf03	d9a604e1-9343-404b-9357-79506e6a3324	f
93e6a496-3882-4eb1-b9de-54706ffadf03	9dec93f8-97b6-433c-8335-7cec3f030f56	f
93e6a496-3882-4eb1-b9de-54706ffadf03	627847cc-3caf-4b2f-976f-03da61fa4cdc	f
93e6a496-3882-4eb1-b9de-54706ffadf03	29e5c5c9-0e32-4c8f-a52d-952b88a08b3e	f
d4c63c03-da48-4170-b5dd-03fe25bc3bc7	c7cdc97f-181a-4536-960a-e895810f0f23	t
d4c63c03-da48-4170-b5dd-03fe25bc3bc7	dcda8ff0-d811-443f-9d49-7e6f8922de1b	t
d4c63c03-da48-4170-b5dd-03fe25bc3bc7	fa8768c8-e248-4760-934c-539eaa982a8d	t
d4c63c03-da48-4170-b5dd-03fe25bc3bc7	825e1390-66c9-47fd-b238-80702e480d73	t
d4c63c03-da48-4170-b5dd-03fe25bc3bc7	bd452d3d-137b-4f49-bdce-c477b2bbc742	t
d4c63c03-da48-4170-b5dd-03fe25bc3bc7	d9a604e1-9343-404b-9357-79506e6a3324	f
d4c63c03-da48-4170-b5dd-03fe25bc3bc7	9dec93f8-97b6-433c-8335-7cec3f030f56	f
d4c63c03-da48-4170-b5dd-03fe25bc3bc7	627847cc-3caf-4b2f-976f-03da61fa4cdc	f
d4c63c03-da48-4170-b5dd-03fe25bc3bc7	29e5c5c9-0e32-4c8f-a52d-952b88a08b3e	f
55bd8a5b-3f67-4667-9e35-9010417f108a	2ae9433c-7e7a-408c-9a6d-7c1f5d28b126	t
d2c379b9-8493-47e1-82d8-9f5b2791c11a	2ae9433c-7e7a-408c-9a6d-7c1f5d28b126	t
3b9bf017-eac3-4f6f-a5ff-355ca092fa85	2ae9433c-7e7a-408c-9a6d-7c1f5d28b126	t
b47e2542-cc0b-453d-993f-e73422e7a44e	2ae9433c-7e7a-408c-9a6d-7c1f5d28b126	t
8ed73690-8dd1-4434-b5ca-2665456bae8e	f893822a-ff36-4193-812f-628b2d9e1737	t
191b61d7-ca16-4c99-b7f7-828b3391d614	f893822a-ff36-4193-812f-628b2d9e1737	t
ba6a831d-ceef-4ba6-9157-1ebcf85c411c	f893822a-ff36-4193-812f-628b2d9e1737	t
d4c63c03-da48-4170-b5dd-03fe25bc3bc7	f893822a-ff36-4193-812f-628b2d9e1737	t
50c8e8fd-de3b-4877-ac29-f8644a9d0bb0	c7cdc97f-181a-4536-960a-e895810f0f23	t
50c8e8fd-de3b-4877-ac29-f8644a9d0bb0	f893822a-ff36-4193-812f-628b2d9e1737	t
50c8e8fd-de3b-4877-ac29-f8644a9d0bb0	dcda8ff0-d811-443f-9d49-7e6f8922de1b	t
50c8e8fd-de3b-4877-ac29-f8644a9d0bb0	fa8768c8-e248-4760-934c-539eaa982a8d	t
50c8e8fd-de3b-4877-ac29-f8644a9d0bb0	825e1390-66c9-47fd-b238-80702e480d73	t
50c8e8fd-de3b-4877-ac29-f8644a9d0bb0	bd452d3d-137b-4f49-bdce-c477b2bbc742	t
50c8e8fd-de3b-4877-ac29-f8644a9d0bb0	d9a604e1-9343-404b-9357-79506e6a3324	f
50c8e8fd-de3b-4877-ac29-f8644a9d0bb0	9dec93f8-97b6-433c-8335-7cec3f030f56	f
50c8e8fd-de3b-4877-ac29-f8644a9d0bb0	627847cc-3caf-4b2f-976f-03da61fa4cdc	f
50c8e8fd-de3b-4877-ac29-f8644a9d0bb0	29e5c5c9-0e32-4c8f-a52d-952b88a08b3e	f
db7fb3a7-14a1-4b7e-9379-8905016349db	c7cdc97f-181a-4536-960a-e895810f0f23	t
db7fb3a7-14a1-4b7e-9379-8905016349db	f893822a-ff36-4193-812f-628b2d9e1737	t
db7fb3a7-14a1-4b7e-9379-8905016349db	dcda8ff0-d811-443f-9d49-7e6f8922de1b	t
db7fb3a7-14a1-4b7e-9379-8905016349db	fa8768c8-e248-4760-934c-539eaa982a8d	t
db7fb3a7-14a1-4b7e-9379-8905016349db	825e1390-66c9-47fd-b238-80702e480d73	t
db7fb3a7-14a1-4b7e-9379-8905016349db	bd452d3d-137b-4f49-bdce-c477b2bbc742	t
db7fb3a7-14a1-4b7e-9379-8905016349db	d9a604e1-9343-404b-9357-79506e6a3324	f
db7fb3a7-14a1-4b7e-9379-8905016349db	9dec93f8-97b6-433c-8335-7cec3f030f56	f
db7fb3a7-14a1-4b7e-9379-8905016349db	627847cc-3caf-4b2f-976f-03da61fa4cdc	f
db7fb3a7-14a1-4b7e-9379-8905016349db	29e5c5c9-0e32-4c8f-a52d-952b88a08b3e	f
\.


--
-- Data for Name: client_scope_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope_role_mapping (scope_id, role_id) FROM stdin;
ec3648e1-1066-447d-96f5-2d8eb0bc46ff	283324a3-aa37-4488-823b-86f70f5f8535
29e5c5c9-0e32-4c8f-a52d-952b88a08b3e	b775294b-f8db-46a8-a945-bd9bc2214b98
\.


--
-- Data for Name: component; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.component (id, name, parent_id, provider_id, provider_type, realm_id, sub_type) FROM stdin;
b7669723-38da-4ec4-a0d8-1c498c1ac8eb	Trusted Hosts	98b2ec68-490d-4a88-b1bd-05b5707e88da	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	98b2ec68-490d-4a88-b1bd-05b5707e88da	anonymous
f6d83b63-4c3c-491a-abb1-0fc9151c8ab4	Consent Required	98b2ec68-490d-4a88-b1bd-05b5707e88da	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	98b2ec68-490d-4a88-b1bd-05b5707e88da	anonymous
da0f4c19-8915-48bc-be80-e933cab588a6	Full Scope Disabled	98b2ec68-490d-4a88-b1bd-05b5707e88da	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	98b2ec68-490d-4a88-b1bd-05b5707e88da	anonymous
a3ea52bc-58fb-4d63-b367-d6bd3599ef04	Max Clients Limit	98b2ec68-490d-4a88-b1bd-05b5707e88da	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	98b2ec68-490d-4a88-b1bd-05b5707e88da	anonymous
d2be61aa-190b-4d8c-ad37-23be10a039b9	Allowed Protocol Mapper Types	98b2ec68-490d-4a88-b1bd-05b5707e88da	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	98b2ec68-490d-4a88-b1bd-05b5707e88da	anonymous
035b9cff-9300-4863-9b05-8d228931e968	Allowed Client Scopes	98b2ec68-490d-4a88-b1bd-05b5707e88da	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	98b2ec68-490d-4a88-b1bd-05b5707e88da	anonymous
38258a26-8f39-41a9-be0c-5718a9b9d4f8	Allowed Protocol Mapper Types	98b2ec68-490d-4a88-b1bd-05b5707e88da	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	98b2ec68-490d-4a88-b1bd-05b5707e88da	authenticated
79cd0824-a570-420a-af32-d7a17d4ea78d	Allowed Client Scopes	98b2ec68-490d-4a88-b1bd-05b5707e88da	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	98b2ec68-490d-4a88-b1bd-05b5707e88da	authenticated
a7010bfe-edd8-46e8-b03b-d1f0b7a9e094	rsa-generated	98b2ec68-490d-4a88-b1bd-05b5707e88da	rsa-generated	org.keycloak.keys.KeyProvider	98b2ec68-490d-4a88-b1bd-05b5707e88da	\N
08f29228-32a4-4832-a99e-f52443d33d12	rsa-enc-generated	98b2ec68-490d-4a88-b1bd-05b5707e88da	rsa-enc-generated	org.keycloak.keys.KeyProvider	98b2ec68-490d-4a88-b1bd-05b5707e88da	\N
77a5d1e4-49db-4328-af21-217b041ad5b0	hmac-generated-hs512	98b2ec68-490d-4a88-b1bd-05b5707e88da	hmac-generated	org.keycloak.keys.KeyProvider	98b2ec68-490d-4a88-b1bd-05b5707e88da	\N
8bc23598-535a-4668-aed4-11f9e8289131	aes-generated	98b2ec68-490d-4a88-b1bd-05b5707e88da	aes-generated	org.keycloak.keys.KeyProvider	98b2ec68-490d-4a88-b1bd-05b5707e88da	\N
842a0b95-00d9-4907-8827-e9d7fa441ec1	\N	98b2ec68-490d-4a88-b1bd-05b5707e88da	declarative-user-profile	org.keycloak.userprofile.UserProfileProvider	98b2ec68-490d-4a88-b1bd-05b5707e88da	\N
2d0bb7cd-1808-4f8a-8797-4c9ea00dfb08	rsa-generated	545899ec-2a73-4c95-b368-425da707cea1	rsa-generated	org.keycloak.keys.KeyProvider	545899ec-2a73-4c95-b368-425da707cea1	\N
035a9e7c-9b28-4123-b468-8ecaabf80764	rsa-enc-generated	545899ec-2a73-4c95-b368-425da707cea1	rsa-enc-generated	org.keycloak.keys.KeyProvider	545899ec-2a73-4c95-b368-425da707cea1	\N
a2c1aee9-2d65-4cdc-a4f1-6103c3cf60a2	hmac-generated-hs512	545899ec-2a73-4c95-b368-425da707cea1	hmac-generated	org.keycloak.keys.KeyProvider	545899ec-2a73-4c95-b368-425da707cea1	\N
0781a3cb-8c9a-4e19-9cc6-4397adb46b28	aes-generated	545899ec-2a73-4c95-b368-425da707cea1	aes-generated	org.keycloak.keys.KeyProvider	545899ec-2a73-4c95-b368-425da707cea1	\N
3b610697-18ee-4966-985f-933dab7fd342	Trusted Hosts	545899ec-2a73-4c95-b368-425da707cea1	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	545899ec-2a73-4c95-b368-425da707cea1	anonymous
83ce60a3-32e1-47f9-a21a-8c77b2126413	Consent Required	545899ec-2a73-4c95-b368-425da707cea1	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	545899ec-2a73-4c95-b368-425da707cea1	anonymous
c7787e4f-22bc-471f-8376-d064fc8d69ce	Full Scope Disabled	545899ec-2a73-4c95-b368-425da707cea1	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	545899ec-2a73-4c95-b368-425da707cea1	anonymous
8af7506a-8f28-4460-aa44-e0aa4e4af5e7	Max Clients Limit	545899ec-2a73-4c95-b368-425da707cea1	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	545899ec-2a73-4c95-b368-425da707cea1	anonymous
2b1418d7-c49f-447a-b7ff-4396b369dd9a	Allowed Protocol Mapper Types	545899ec-2a73-4c95-b368-425da707cea1	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	545899ec-2a73-4c95-b368-425da707cea1	anonymous
e71d06fd-e607-4874-8437-09aceb0bf3eb	Allowed Client Scopes	545899ec-2a73-4c95-b368-425da707cea1	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	545899ec-2a73-4c95-b368-425da707cea1	anonymous
15649ebb-b2ec-456c-ab00-0dbff7195f95	Allowed Protocol Mapper Types	545899ec-2a73-4c95-b368-425da707cea1	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	545899ec-2a73-4c95-b368-425da707cea1	authenticated
8ac4c233-d3ba-4c81-b572-f6a0083edd04	Allowed Client Scopes	545899ec-2a73-4c95-b368-425da707cea1	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	545899ec-2a73-4c95-b368-425da707cea1	authenticated
\.


--
-- Data for Name: component_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.component_config (id, component_id, name, value) FROM stdin;
c704079b-0fc1-49a8-a1b3-5d241733c24b	b7669723-38da-4ec4-a0d8-1c498c1ac8eb	client-uris-must-match	true
9a8e2e92-daae-4190-bb24-a22b025572f4	b7669723-38da-4ec4-a0d8-1c498c1ac8eb	host-sending-registration-request-must-match	true
e99536d6-09ae-4a13-a511-ac9cfb1ca324	a3ea52bc-58fb-4d63-b367-d6bd3599ef04	max-clients	200
078601b7-9ef5-45b0-9614-cc38e613850b	d2be61aa-190b-4d8c-ad37-23be10a039b9	allowed-protocol-mapper-types	oidc-address-mapper
e9568ce5-e932-411e-a5ee-dd6b24351982	d2be61aa-190b-4d8c-ad37-23be10a039b9	allowed-protocol-mapper-types	saml-role-list-mapper
2ebf69a8-359d-4051-9d8a-90e6344f874d	d2be61aa-190b-4d8c-ad37-23be10a039b9	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
f2319e0f-9fbf-438f-98a4-115754753aa7	d2be61aa-190b-4d8c-ad37-23be10a039b9	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
d40275fb-2302-4c6c-9ee2-9a7eb75a04c4	d2be61aa-190b-4d8c-ad37-23be10a039b9	allowed-protocol-mapper-types	saml-user-property-mapper
ddd97437-56c9-45e4-86a5-799b2c279a41	d2be61aa-190b-4d8c-ad37-23be10a039b9	allowed-protocol-mapper-types	oidc-full-name-mapper
88505a16-9cf5-4dec-a720-b92b56fbbd77	d2be61aa-190b-4d8c-ad37-23be10a039b9	allowed-protocol-mapper-types	saml-user-attribute-mapper
963f1a5e-176f-474c-b577-a60de8758e7e	d2be61aa-190b-4d8c-ad37-23be10a039b9	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
a7f9786d-bf2b-47de-86af-339c79e35239	79cd0824-a570-420a-af32-d7a17d4ea78d	allow-default-scopes	true
dd20d20f-7c04-4127-902d-948cf816dc17	035b9cff-9300-4863-9b05-8d228931e968	allow-default-scopes	true
fd40d5cb-d5cc-466b-aeab-48685c3029d3	38258a26-8f39-41a9-be0c-5718a9b9d4f8	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
ac7acf3b-dec1-42a4-8ea2-53cfc1c6263d	38258a26-8f39-41a9-be0c-5718a9b9d4f8	allowed-protocol-mapper-types	saml-user-attribute-mapper
39f7a4a2-1cea-49ba-9145-42ff77341f6c	38258a26-8f39-41a9-be0c-5718a9b9d4f8	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
421d9d26-dcc7-48b9-b33a-be3616e24476	38258a26-8f39-41a9-be0c-5718a9b9d4f8	allowed-protocol-mapper-types	saml-user-property-mapper
1d265c5f-ddad-4764-9cd5-73475320f91f	38258a26-8f39-41a9-be0c-5718a9b9d4f8	allowed-protocol-mapper-types	oidc-address-mapper
5530309e-af05-4f77-952e-62b03778ca10	38258a26-8f39-41a9-be0c-5718a9b9d4f8	allowed-protocol-mapper-types	oidc-full-name-mapper
36f0a08c-a662-4666-bc6e-e0a3803d005e	38258a26-8f39-41a9-be0c-5718a9b9d4f8	allowed-protocol-mapper-types	saml-role-list-mapper
3b4190c7-3abf-4363-a5b8-2452fd0ee950	38258a26-8f39-41a9-be0c-5718a9b9d4f8	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
11da94b4-629a-45c1-9c1d-91ef6f07b464	8bc23598-535a-4668-aed4-11f9e8289131	secret	xIyxFocJnT5W_v9IeyGKuA
e937e249-7cad-40ca-b019-746c8400104f	8bc23598-535a-4668-aed4-11f9e8289131	priority	100
41c10b96-1c16-4775-811d-f8a2e9c98bfc	8bc23598-535a-4668-aed4-11f9e8289131	kid	f57d996c-fb53-4f73-a414-2a437807c92a
74d38fe4-92d5-4930-a08b-751b42bcb14d	77a5d1e4-49db-4328-af21-217b041ad5b0	kid	9a9d5d9d-1d0d-4a4c-ba2c-8a3a9642cf41
565cd1de-c083-4058-bc09-5188b61ad5ef	77a5d1e4-49db-4328-af21-217b041ad5b0	secret	N7dxaq2oC5ZBCKGn4ysU9iAItlemV6ANRxiGxg9jXu8V0PT-yqXG0yzBRHW2UrhtmNQuO034uX1u_zG8SHjCU5ffiOhTKVHnzAP4Bj436-1GARiHp7GfMvasK_L8CE-OOzBW4H9VKK_NwWtAlZmZ_aNWdom7GtZ6pMS3fr1ip6o
df06deee-e020-4bf9-bcd7-2a03aecd9f00	77a5d1e4-49db-4328-af21-217b041ad5b0	priority	100
8234610d-b005-4d81-97fe-16d3c71f9ae2	77a5d1e4-49db-4328-af21-217b041ad5b0	algorithm	HS512
18229b2a-270d-405f-8dd0-f171a6c7d648	842a0b95-00d9-4907-8827-e9d7fa441ec1	kc.user.profile.config	{"attributes":[{"name":"username","displayName":"${username}","validations":{"length":{"min":3,"max":255},"username-prohibited-characters":{},"up-username-not-idn-homograph":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"email","displayName":"${email}","validations":{"email":{},"length":{"max":255}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"firstName","displayName":"${firstName}","validations":{"length":{"max":255},"person-name-prohibited-characters":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"lastName","displayName":"${lastName}","validations":{"length":{"max":255},"person-name-prohibited-characters":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false}],"groups":[{"name":"user-metadata","displayHeader":"User metadata","displayDescription":"Attributes, which refer to user metadata"}]}
bc2fdd99-684c-4c78-9a6a-ef33c0e32f36	a7010bfe-edd8-46e8-b03b-d1f0b7a9e094	certificate	MIICmzCCAYMCBgGXOwnA1TANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjUwNjA0MTMwMTI0WhcNMzUwNjA0MTMwMzA0WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCb0oj5DM43DhozUKZ9Kg9843ldi1+qOslPLYDGSl8ZlVv9r44e8bx37EtuwSpJpicNDQSZirS9zQBOQf+yE4pSDp5sOwHWsTGdCZt0lhFX6bfY6PGPXL5wvEIHY/9rQeO6rUOYiW7cObYkaXMHcXI3HnsCZVMXyIfmRdrZmTmUi3pSm1QPD3sm4LNpFDKOxx0SkaKQVMFXY2TBbjrC5V03Kg9TMudoTq0iGchqc+4iuMx6Ytrl/W66AfaJuCvjmOyiMaKFxFNtZQ5KaEGAnsNlF2xQ38MUzeuq+vY8HuJeWpDfo8EkdRTTuSh4PQfx25+GVj0JIlXoVbnPhREwUha7AgMBAAEwDQYJKoZIhvcNAQELBQADggEBAAf7IvmI5IaBVNuGrIK/jfwwJdd7ETdUII0VSxXIzur/8sX62AHIUvYrbZH50Q1a91bLUBVTj171WEZ76ms4mwc5vEOppdovbaH97EuKWKs4J7FfArMl9GqTBLsb6kCnAPBfpmVh6WJ174oEundkSO2CJMOA8g7vR1uipZMpEnCSVe3Aa5D+y81fZi4fdnDzsNM3t9kPpKZCXX8sT21HdZHI2htYKtcC3wcJOobYg/X3Mml+ZJirqRJOPX9Dq3A65gjJd6yU2iZbnqEb+LSZqC9SAU7mOEHtL6Nz7WcozksCpV4bYJquocMVDGTS+4u0oeCccMl8l62QcDjYXR+Fne4=
1a04ed0e-63d0-4a9b-a019-ebdcade79987	2d0bb7cd-1808-4f8a-8797-4c9ea00dfb08	priority	100
ed29e213-3574-4b1a-971b-949fb80d97eb	2d0bb7cd-1808-4f8a-8797-4c9ea00dfb08	certificate	MIICszCCAZsCBgGXOwvtTDANBgkqhkiG9w0BAQsFADAdMRswGQYDVQQDDBJwdXJjaGFzZS1hcHAtcmVhbG0wHhcNMjUwNjA0MTMwMzQ2WhcNMzUwNjA0MTMwNTI2WjAdMRswGQYDVQQDDBJwdXJjaGFzZS1hcHAtcmVhbG0wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQD6e3QYW8UDwE9+c96u7KVtpn5Ihzk1f6pSTrH5N/AnmHdn5BrgYJHMeg9a3CepZyRMVE6fAfQ0UXH59H/RnQ52A0bM3RSOc9sPdn/RH1PdGW0Ran9awbIr8M6JBrOwDenuECwCXBqZcSkmk7x44K4RdpMSzZQzIRK2M10pQLD6dq8V475JT/OJu+mAjz5ewMUq6q82NaaP7GZpNvaC7UfaZ3tzw31vAj+3hR/+DYL1mscanZbkHmIMKvFm6/UpIfN8vT5fgDsyba0jmv91DkGFBzRgXKc7YVnp65pEcPFnCLnIGtxgDQZpaYKhLfWRjald66t/9Llcp6TPDb3zasMlAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAOuH6Tr10chVb/WovH1tYHs+oxvdJRzuQWBd7h/mKBVehMfzcKzZinJdUbXHDZPY3j+enpvtfyso5+NgIcOVjdjq9TpeOF/+q+UjKQ8DhsYC2jwNffIZPNCW5akWAm/EUHlhUzKuxxCqNcX+hS3+RDoKpq8iKnKFB7z/2JYxDM9+iFLGdMSH2XdvFEV2MfPE5Vmh4rT7OD6hH6lkcp5e0TesMTfh185xMrl8X137qF6og9o6FBoG2++auXgwsY0XYn6qsFO7nMVqaoOCPRkuH2Sg/kkz+4txdOWW5l5TePwCKczpR9AOTNKnxrd/ag9XSuaCPAkZOFREy28uhPyKCjs=
552da013-569a-4482-9f38-8742c98cfc4f	2d0bb7cd-1808-4f8a-8797-4c9ea00dfb08	keyUse	SIG
6a1c2e23-d457-4f69-9288-1c78914b90e7	a7010bfe-edd8-46e8-b03b-d1f0b7a9e094	privateKey	MIIEpAIBAAKCAQEAm9KI+QzONw4aM1CmfSoPfON5XYtfqjrJTy2AxkpfGZVb/a+OHvG8d+xLbsEqSaYnDQ0EmYq0vc0ATkH/shOKUg6ebDsB1rExnQmbdJYRV+m32Ojxj1y+cLxCB2P/a0Hjuq1DmIlu3Dm2JGlzB3FyNx57AmVTF8iH5kXa2Zk5lIt6UptUDw97JuCzaRQyjscdEpGikFTBV2NkwW46wuVdNyoPUzLnaE6tIhnIanPuIrjMemLa5f1uugH2ibgr45jsojGihcRTbWUOSmhBgJ7DZRdsUN/DFM3rqvr2PB7iXlqQ36PBJHUU07koeD0H8dufhlY9CSJV6FW5z4URMFIWuwIDAQABAoIBAEdKHbePx8LBdXQ3uEv4U8ioC80j6DsqFRLf9xQBT5wVTNZ2HJgEsdzN4z8DKhUy6pfadlnG72UMptCm+lRfA0AChzFuF6vBOrklfZVr2Ph3KdEX1fhojopmXvEhq2hHZ2hvP8dITUt9Ldtf0Sw9F2unStDwSYFOkfpkyDkYlJLkPFpR1CnV5icczo4Qj/5hcVwdDxLb5m+JFw4Sb/g7WDjfawZP/BG+sfvPJcisTihkk8u2cXlzPRzoxuvc4rbtlR2+1Ai1EgLSwayOcYMA7YLNlT1QDkoNH2hY/mKvCM7BV4rA70oYS5EowNbetMngcifnUNSJVbHLK8y+1yPjQqkCgYEAzUr5sPcE+9zmiSeTACDO4HFuDm/4+isW0zlaX9Vpslgr5fhR66z2urYjXGCKwOKsICOO58M0+/+ihpbRelrkH+PNd5aatOTwj4+jsxXAyySP82ZbBnreLtyfeDcSKbSOPi08ZuJhrgDGcl28NSROrMVgqM9HERsB7zzxbcFS1BkCgYEAwk90vXDckSaCtUO+sieaovqFINaNPq4t66Lh/QxntuhnoOB8cdytkqnWKQimlfnZCsjMz3O8CIffDWodcnyMwYws4sdvKfbXSMmzJqWNwTw871otI9M+linIkEfzOhNzYT2YWzFZXGL8djd31OCAxLsUwx0lX2NtUJ/mLBh5O/MCgYEAuyvoi5gsSxYUemhCdpNzCt9gYHlmn3A510srQsTpIVmSbJIC3sVMDt+RTeAXodUI6iSBXn10CW4BWISZaN0FsK2Z37bIRrWVPs7PibADnzMuq9RemYHcoQ01t/096hhcuAO2VneAZ4z9YbhkqG757Dvo7QBO4yGkmeMOm+rvAcECgYEAhi9sxO5Nw4c+uILiDBHBfk9W5EiGHgUW/STsv11zuiJgff7IsbDdxOy4UnoA4I07z3C/z3tzHMkHxjHDyC4u3fI5hRqIsAggv8laiJPHguxggEJb7eOR0w1jzg+B7ldEVKC+uCsqNNy+z7yaak3nXvR68AsOpgL5mLXzs/vqrPUCgYAB1+ICAmVShIy8yVuiZetTI5G0BaXq8ssZmJf2wAWOkdFGeQCyNwPzyQbF+9R/GvmO69ZKr71Sf3KaegXuH2uGU7qsHxnX+6d5Pxxr4M9Hk5lcsCUlMWR3eu2zIuQewu6TmhXI2mm6nIzN4vx2falePxutoCCsdefTYZtneZOsmg==
ba1b50d9-dec2-4410-b9c0-fd75fdf13676	a7010bfe-edd8-46e8-b03b-d1f0b7a9e094	keyUse	SIG
91c82d29-7b00-492c-b3b2-bfe1f816fc51	a7010bfe-edd8-46e8-b03b-d1f0b7a9e094	priority	100
97139a86-67ea-4919-a2fb-9590d8da3ec9	08f29228-32a4-4832-a99e-f52443d33d12	keyUse	ENC
51da57d5-bbea-45bb-bec7-5dba613e72ba	08f29228-32a4-4832-a99e-f52443d33d12	algorithm	RSA-OAEP
dd446548-9fd7-4c6d-b98c-634f5abad43f	08f29228-32a4-4832-a99e-f52443d33d12	certificate	MIICmzCCAYMCBgGXOwnB7DANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjUwNjA0MTMwMTI0WhcNMzUwNjA0MTMwMzA0WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC6HP06hxdSQdU/nCjZAiiisccLNXvbQmy6S9pm0ealsiyMAFj93NkDqrNXIzjXKkmugVu4RPbNALf8bkbu/cGtaxNNHy4wAZQhlBskfKt6FiFa+UvdfwZqKbcNJNijdZfVXH/YUuu2Evvy4W6pR/ibCuzGPdN+QTO7g5ORl17aJRNjZe4UwofMiQ+8FKPjs8/PD9zYpgbciM1soLT72FaI5lDHVDTY2nBM+GCWY3ybZsHm7M88nVmn6cE96ojitHIMvjsjrbAe5+keUE6xHW2af5HtThj39W1QI19v3h3IaRH4xv6Sr1mfDkQzdhDwJyVskhFyC8s9IK8uKV4/0wmZAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAElSbEc/Alie7C81uCOPgXeZrSrFgK06UoDSeKJGxIHvkOAy3whQma6efKKvTG9n7y/5L0/EtIgEifP2q8BScKeNXcD1FnNB9R1HXdmV0SPckP9T5DySadFi5IaZeopFfX1AVcEjPN3iwl/qhmx4E22KLmPgrnMu99u2AkcK58lsecuambAFcgNBYy047OTqbRO9V/FArbW1hqmGBkE5TRSVHzGoTjm0XMYvlPazUt5oQi5SmmxNzLwKYJiCmDHTmYrJMhppEyv56oCibNVkx4+Sq6gtVBh5Ddn2oQd236Y5pNqq7JCIl91QpsyM+ZZTte7Fy+k9i41hlUTY2RNsFFo=
f4e254ad-1b5a-4080-9b74-5eb92fbc91c9	08f29228-32a4-4832-a99e-f52443d33d12	priority	100
716772fe-5cf3-4b75-95a5-465c4487be39	08f29228-32a4-4832-a99e-f52443d33d12	privateKey	MIIEogIBAAKCAQEAuhz9OocXUkHVP5wo2QIoorHHCzV720JsukvaZtHmpbIsjABY/dzZA6qzVyM41ypJroFbuET2zQC3/G5G7v3BrWsTTR8uMAGUIZQbJHyrehYhWvlL3X8Gaim3DSTYo3WX1Vx/2FLrthL78uFuqUf4mwrsxj3TfkEzu4OTkZde2iUTY2XuFMKHzIkPvBSj47PPzw/c2KYG3IjNbKC0+9hWiOZQx1Q02NpwTPhglmN8m2bB5uzPPJ1Zp+nBPeqI4rRyDL47I62wHufpHlBOsR1tmn+R7U4Y9/VtUCNfb94dyGkR+Mb+kq9Znw5EM3YQ8CclbJIRcgvLPSCvLileP9MJmQIDAQABAoIBABYLG3IccIZxXjLZydvEHfCBKnBZLhmO4UZieBSADXe4Jf8SBnhQ+VIuHG44cYHIlDALScQGRQ4MZP5MyHGDlDY4TbGvfP66HSOqAVn9uyiraNl32AS8yBN4a+IuaEtaAPkIKutCDQGEd5txmHQL3nXsohUr2voj+l7eC3Mt0NH46L5L1xCy8oNSgCLj3z41f5xpv4sHq7benl1jGnix27hPpaXapAkX+LBoQt+lA8HItRRtmeua6B9a+KdL+SQ6O2/txHeWCz3wpgcDH7raCl9nOdAt10nz24q4arSD9Tffv5UBrkMI3L6SOogsx/Aauj+QXSw/DGSpz8D2h1CAW6UCgYEA8WA0ni0LzrxhChic6jE8lsqHZu4cJ9bbIf7kvuiu05tIO30uoZpxUN0azhncRdG2DhYTEJyUbrTfRJbpWCCGBWAWdVfNo2yE5iGm7J2NUxdF2d6/zStm7NMDU6XG8xT7v9Q9MyGyYE8H/NkPj3IRkpsJl5Og0YRlOcqOTVyiO+UCgYEAxWOmBFJWjdmqGvKDNNFJMleXA7i3C8AJwkif15MsARaM3FMduKbqi0Lh283rJ8Fr8X4QgUAkf4ZC26BUiqGJAdrQAwdhFO8jyBZfd3b/UDsYPKxPqvpvd8E0rXXSJe68EhQjctEQPdbZIj7TswYyMEn7KBllQc8m6Rlbr3znw6UCgYBr3Jfmzy5lldyvTExigtoWcC6Nmn3Od764tFS30va87LkcjFYYNRHKFuPxkbDTKmF2bfrbA3148y6KUf24OeBp6oRer3vfOZEx3XvgZI9QwCegsl93aZu23Jyx9nSvD4NoN4mZncc+LlLddIn1if28S7e/mmLU/ZrWdmOcwnZk2QKBgHanHu2sHRFpzUIjk1FVmP1k/4ciKw4qIvOhukvY0PPafVQXtl8AHy8VRjVdw8SDFYL196/qQcZSi6//4bHvxi7SPIYFkosF8WleYYarhm/RBhG6tq0dm5HOFv9KOsfIiU8IwgJLv8qccquOPq13xQWYAxyon2B+yHIIZz/HAn5tAoGAZICyMI82FY9cIYqtvLtWQg4zxcxr0ps6vHDr5CIeL9NDD8DGlbgcmxKtTmt+83eU3RTGAKMv9JoZWsDB4r5jzmLgz/BSw5zObxRPxgwR4m8KlXi3MWi7mH+1owJHw+7goUbJgHj9uzEBVOz8cNA6ItqbSJ7RMBKsvYIFoM8IJ9U=
8749e816-e478-42a9-a1fe-67aca3785c69	035a9e7c-9b28-4123-b468-8ecaabf80764	certificate	MIICszCCAZsCBgGXOwvt7TANBgkqhkiG9w0BAQsFADAdMRswGQYDVQQDDBJwdXJjaGFzZS1hcHAtcmVhbG0wHhcNMjUwNjA0MTMwMzQ3WhcNMzUwNjA0MTMwNTI3WjAdMRswGQYDVQQDDBJwdXJjaGFzZS1hcHAtcmVhbG0wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC3Rv3S0wKXN6YOztDvVAFDeSR2IXMERjwXrj33lDrLsKyU0GHmLRIJ0wGfkSzKHtj8Uch0rT6WVmBgNw737j7kcIf0NuopgHwZyEYmpp6J1nGOAODhS3FPyBgQltq0XKDSEFxqxZRRYEs+wPe2G2gpf3ENgHsFJQdWWrtY6UbkamIbtWvsLd/hVvrGqn41BZDEYr6mNHIqn3sYV5nFFkJEP6OmKW9Tld1wOb4GlexpYWkaAdbZ2pYW21eZMXQiWWljmdX48QEzf+v0qruryY+oEsS8ynxD7MIKEKx3eVSWMMhUrqpzr1O78S2jHJm1yLm1FqSS4//iT4o0GI27NbR3AgMBAAEwDQYJKoZIhvcNAQELBQADggEBAG+Ci0taNbMnyNuWtfPWkztmeFJSYSJ5AfR129EM0p1c63Un0VRB1aeK0IEzjVCYUbz6L69xltYbWuAsi3Vlq/O9OuCc5sW97ersYdlTecwAChKGOpvBjWR4utvwckQEg1yiE7HLWptJJ65hNEeHpGI8qqU6uy9menXXP0LxGKJaa2YMcNx02YOwvH0WkDKfm9btfTfdYsT4JkPDXpULFraQ9VgDfMInOPwAy0gaKhibQE6VAroQxi71ugtZu13BjprycrzaCwbVQxdQD2GJUuCncE7ALTSqxSNE9HTfzFKHOZZhcHU/sUdLtRdrNeIxFzQrgwsqtn1KjEYA2zMf61M=
ac1263bc-cf34-452b-93ad-20e6189237d5	035a9e7c-9b28-4123-b468-8ecaabf80764	keyUse	ENC
540d212b-0721-460e-84f1-d883323ef38c	035a9e7c-9b28-4123-b468-8ecaabf80764	privateKey	MIIEowIBAAKCAQEAt0b90tMClzemDs7Q71QBQ3kkdiFzBEY8F64995Q6y7CslNBh5i0SCdMBn5Esyh7Y/FHIdK0+llZgYDcO9+4+5HCH9DbqKYB8GchGJqaeidZxjgDg4UtxT8gYEJbatFyg0hBcasWUUWBLPsD3thtoKX9xDYB7BSUHVlq7WOlG5GpiG7Vr7C3f4Vb6xqp+NQWQxGK+pjRyKp97GFeZxRZCRD+jpilvU5XdcDm+BpXsaWFpGgHW2dqWFttXmTF0IllpY5nV+PEBM3/r9Kq7q8mPqBLEvMp8Q+zCChCsd3lUljDIVK6qc69Tu/EtoxyZtci5tRakkuP/4k+KNBiNuzW0dwIDAQABAoIBADfcyA3j6hS8Tf2SdSWVdcMioAXvoRaK79MJ9XJKeHdQVPIQ594YG7jp20NPJRdAOsQBi3dgvMRm9H4vGf1g3UOUtyOtP0dCFdFn9VXfkFAUEE2HoAObkqCOLSOVT3kNCKmuefTDXzdEgfrRJ0+W3/NSGFvUrup9BFUCV7s8czK4ZDOX9w8XbPvx6Wvh5dz3/ZF2aY+Mt1pLMG+Tx3Nncu//mzJym3QJ9Nx9CtxsrNlPuvvQRgLZd2VWCEv0OitR4wVieLhX+OLFOLgEjii8CwFEP8bWLzhS/EAmUpH9/YyCwzt3ymvSSS10/YiRWjGQSr5fR9p4SYzwAJOGeNK2WvkCgYEA3idzC/Kr6+NmhgFrUd266B1vC9t3KBAHyoRMB7NC4H7vk8VMeIVWKnNQwhNHK1CsBIYicQHNqZxtkpa17Zd9V1f6GDnKmFWeCztnqqSP4ztjguINK2zwUbzRr0LUOxAJF/itypORfcR1LftChdEp8zMX2ro6XfduHlGiNEsaTbkCgYEA0zNAsa/S7z0t/7Oj67GjRcEGlqSLikjmyq4zBFaltXOXxrM1sD2UeErwkQx24hWUnOo1bo6an7Bo0ImfrvgMdvCfFHDbQWQp8nHZcZP29vnVXTpJltu2YxmPNMU+YaAJ69wW8c9BPTuG9MmGzen72HKace8QCuAM9MgUoAzQq68CgYA66fNUo9J8CB5UQ2QWndrHW6brWhRLh5TJXDRdhmih6IfYhGY3QAUN1O8ByOMC1a4ItRnFJllINbfJPDaa/6W52Bb2/byAkZQMHoDrfCC8fi9xskkTzxwcURq6g9qMn0AKH2TXaDMZS1RYEV4e5s1dNZuJ4gFAkjGd0MBXZeNf4QKBgHsdBlpN7vzswfKriiNrkoyn36pS0tDSfE6ryyt9Qu2KK3B1qRdKXlDdBmzXQjm6cL4jvO/sivAJip/9iasaB1ISI/lrbDQrKlSczy9pHG6N5jWJM7qP6zrLfHI7hIiuHPpzeqCMuy/xklMBYuaHvfpHnAZMYCKmxoauV2+Q6NcbAoGBAJ+tnQKLvGsjBxraNT/Gc9z26En8kXm+X1N/SxAvS/bumCr6R3XWV3ldcUrk9pI/RvLz7ZSpoNhv/IE9IQ6890PizUHis4WJSwBjn+kdzilNl13C73zNvHHku9v5ie7to+GJc6y2LCNwxmRCop41NVAJMZ2foJqeG2mB3hrT/3YT
34539047-1db4-4338-9cee-e2c6fa3b8985	035a9e7c-9b28-4123-b468-8ecaabf80764	priority	100
19de0be0-9c99-4c8e-a991-ad6fdeda0791	035a9e7c-9b28-4123-b468-8ecaabf80764	algorithm	RSA-OAEP
6011bf55-f522-4891-a9af-f3204b5fecd9	2d0bb7cd-1808-4f8a-8797-4c9ea00dfb08	privateKey	MIIEpAIBAAKCAQEA+nt0GFvFA8BPfnPeruylbaZ+SIc5NX+qUk6x+TfwJ5h3Z+Qa4GCRzHoPWtwnqWckTFROnwH0NFFx+fR/0Z0OdgNGzN0UjnPbD3Z/0R9T3RltEWp/WsGyK/DOiQazsA3p7hAsAlwamXEpJpO8eOCuEXaTEs2UMyEStjNdKUCw+navFeO+SU/zibvpgI8+XsDFKuqvNjWmj+xmaTb2gu1H2md7c8N9bwI/t4Uf/g2C9ZrHGp2W5B5iDCrxZuv1KSHzfL0+X4A7Mm2tI5r/dQ5BhQc0YFynO2FZ6euaRHDxZwi5yBrcYA0GaWmCoS31kY2pXeurf/S5XKekzw2982rDJQIDAQABAoIBABy6n6Zykh57xnJZvlsAU/oHXFkbv11KOwINOh78Qjx8YYemM0n0cYyLHGs+sILezFw/2DOnIPgGNmUlnKpxUdkJx6tUGRk8ow27OO5GolML6UVT2m8Ro8qj6EBxpxbkhaXzL2UG5NsgDkj5LWcM2BIzMCu6LgsOOkvxCLikTZgwXg5rZuI3eHZM3C7aEcpSf3IB2Su+0Cat3F+LFF1NKEZjBA8uJxdKD24QGLLFit0kuxbGmGS7pw5lzP3MP+ux5Of3Rpo8RfHyOGeYhj2E4RbnygJNPzpMMt5yIHo8nwt/79LwxNNM7lISBw8RmrJliOJNp19zoPSTmuBnPk8up0kCgYEA/a3FimsMPB/h1tUh/xF47ES9SZDJpyPCvc5vygRPu8X25WVOMcmWvdgXZRGKkvOlxaZl0H34iy6ZqZW0vcWKmAsaQkRLJ/TXkvzq8lzoLWu5A63VTVKIyE/SRjLr4Dhvq/4nrmk4iWLoECmkdvM7Q2hSE+X//vqhVjpERnhrMakCgYEA/MYxsKiWMnQD9sT+wrlcL/dkTMFxapet0xgk+qxAXSfrTgtRVI3bDfAH2PMpVjUKLEFWqu3dTfQcGgynic88TTiit/C1RON7cL1O83BwKpnb1lt8lGA4HojXLuqmCJHmpp3Vhg0LLiPky9sBGmwC6oQLEKVW7UZGQEbge3Ew6x0CgYEArZC/n70uWdTWiE67O/GQctd1S2gtEJZ/H66m/emFRExmaP2vSpFK+glnuFcQIQtjWKBI+SW3cEMqD8XGLDGEahLunHhtk6EJ/h/eAIVgtfMGW2YMkyLtQ2CZ1j3w9TCn912leMe1TwrFDInxZRF2cuBliAfN539D8+NZ431wmkECgYEAv7zXFFnNFJhMKXNki/BurTPLMS3LCj/j6qv14O+oIwGUy65qEulHsFrSmQ5Z3Lp+7PLi+uVTaT4x0tCmhTJdW3YKd9xuo8Kqb+opaR9w9d+fkgnzhdk2uHK0RzJWn0mM2/X9caGTSXyQoNGPFKu5yoo+mnHQbktQHpGk1f4WTUECgYAMIcfCMEnlQXxqvTfMCGn00nlbcuBTfh7y5weC49mlqClkQX41zRr+E3AIX/yD+Ve9jnqM9tq1LImCWsyAum5O9wQDzTUbkyaRqy3jJhCuob0vMz5FhBb6SlJ4vY3OrIWFf6OxJxRRrvThDLfXQUlQTx81tBF8vPxfjPPp83/0Cg==
220bd636-0b09-4db2-b243-cb8fdb7d1829	a2c1aee9-2d65-4cdc-a4f1-6103c3cf60a2	priority	100
ef5efabc-7583-4c1a-a38e-1771d85c0b00	a2c1aee9-2d65-4cdc-a4f1-6103c3cf60a2	algorithm	HS512
5b92587c-bc07-42ec-b7e4-77b49a80a094	a2c1aee9-2d65-4cdc-a4f1-6103c3cf60a2	secret	eWwFq_9iqn55vsisfJKlizqkdhj75JwZY3syRYNShpUnTwU2q726IZTTc57vgZKv3TkqbQixsj7Trql25HgDKu1L1rj77b1-jXD5l63oHac56af_Ro5e9IRs5oyiGrzbM-F0Vyxoop7KURVYBx7gjr7CB0RBTmSqJ9hcHDRTIJQ
cc7239b2-3caf-4c10-ab32-29efa3269f35	a2c1aee9-2d65-4cdc-a4f1-6103c3cf60a2	kid	3252434f-1285-45ed-ac8b-c7242ed82bcd
90a79a7d-000e-4b89-9716-01e5707caf92	0781a3cb-8c9a-4e19-9cc6-4397adb46b28	kid	a8a7f501-c699-4440-82ae-69e6a07d21f4
beb2ffc8-f973-4424-b790-fcb3c7a54f4a	0781a3cb-8c9a-4e19-9cc6-4397adb46b28	secret	lH-o2UWCJkd5k-DQUe8MEA
5799048c-1c4c-4873-8c64-c054a880ecc9	0781a3cb-8c9a-4e19-9cc6-4397adb46b28	priority	100
f7cf0493-4f70-444d-a7be-f436875f0e2b	3b610697-18ee-4966-985f-933dab7fd342	host-sending-registration-request-must-match	true
456bc3dd-f427-4385-b938-7fa7e84108f1	3b610697-18ee-4966-985f-933dab7fd342	client-uris-must-match	true
bc100e69-bbf9-4f17-9bcd-26f09f948235	2b1418d7-c49f-447a-b7ff-4396b369dd9a	allowed-protocol-mapper-types	saml-user-attribute-mapper
8c4581cb-547d-422d-9b5f-36cd347be866	2b1418d7-c49f-447a-b7ff-4396b369dd9a	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
8ce39032-8d98-496e-b39d-04f17793343c	2b1418d7-c49f-447a-b7ff-4396b369dd9a	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
496eea1f-e1cb-425a-ade4-d938a53d3d65	2b1418d7-c49f-447a-b7ff-4396b369dd9a	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
07636e5f-c11a-491d-96b3-1163f64aeca4	2b1418d7-c49f-447a-b7ff-4396b369dd9a	allowed-protocol-mapper-types	oidc-full-name-mapper
7a54d51f-14ca-49a8-9f9e-3203cf0eaa14	2b1418d7-c49f-447a-b7ff-4396b369dd9a	allowed-protocol-mapper-types	saml-role-list-mapper
6006d80e-4a49-4276-b304-2d983daaf2d8	2b1418d7-c49f-447a-b7ff-4396b369dd9a	allowed-protocol-mapper-types	saml-user-property-mapper
434ce280-3a5f-4629-a596-ef84bb6a6d21	2b1418d7-c49f-447a-b7ff-4396b369dd9a	allowed-protocol-mapper-types	oidc-address-mapper
a5d5ce7e-a8f5-4a62-95fa-18319539fc58	8af7506a-8f28-4460-aa44-e0aa4e4af5e7	max-clients	200
3b3daa5b-d633-4f3a-b093-fd9e616a9b34	e71d06fd-e607-4874-8437-09aceb0bf3eb	allow-default-scopes	true
4eff0f34-d95e-446d-8b53-fdb5275938ea	8ac4c233-d3ba-4c81-b572-f6a0083edd04	allow-default-scopes	true
2528d51f-7a9e-4cb8-9e82-6a7627c82929	15649ebb-b2ec-456c-ab00-0dbff7195f95	allowed-protocol-mapper-types	saml-user-attribute-mapper
4bfb8f2e-f23e-4ce6-a9ae-14d58cfbdb65	15649ebb-b2ec-456c-ab00-0dbff7195f95	allowed-protocol-mapper-types	oidc-address-mapper
df3c23e2-bf61-4dfa-8dec-2918811b42e0	15649ebb-b2ec-456c-ab00-0dbff7195f95	allowed-protocol-mapper-types	oidc-full-name-mapper
189ca970-9b85-4283-af97-c8b3be3ff6f0	15649ebb-b2ec-456c-ab00-0dbff7195f95	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
45ca143d-a77b-4465-99ba-71fd75f4b12d	15649ebb-b2ec-456c-ab00-0dbff7195f95	allowed-protocol-mapper-types	saml-role-list-mapper
684bac5d-8447-44fc-a640-dd28ba0ecd90	15649ebb-b2ec-456c-ab00-0dbff7195f95	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
12b02c94-8708-4891-86e7-f23b3f9f435e	15649ebb-b2ec-456c-ab00-0dbff7195f95	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
185c73e9-4bc5-4272-ba05-0f3d80678c43	15649ebb-b2ec-456c-ab00-0dbff7195f95	allowed-protocol-mapper-types	saml-user-property-mapper
\.


--
-- Data for Name: composite_role; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.composite_role (composite, child_role) FROM stdin;
7ca25e09-89e0-4c12-8850-2138924f1159	878bddf9-8d97-4e97-8302-2ec3ef66dac3
7ca25e09-89e0-4c12-8850-2138924f1159	0aeb47e7-d5ff-42e2-81eb-0c1aeffbe877
7ca25e09-89e0-4c12-8850-2138924f1159	ae3484f8-6e2e-409f-917f-42ba8c71fc10
7ca25e09-89e0-4c12-8850-2138924f1159	180c115a-e750-4bd8-9030-a6111522e32a
7ca25e09-89e0-4c12-8850-2138924f1159	1ba729b1-bebd-4eae-8dd1-77bbc97ed207
7ca25e09-89e0-4c12-8850-2138924f1159	18501d54-ecc0-4fc5-ac6c-c656d16352e5
7ca25e09-89e0-4c12-8850-2138924f1159	f402175d-8834-4bd9-8297-ff63a15e4b56
7ca25e09-89e0-4c12-8850-2138924f1159	bf6ea91c-b9d9-4f86-909a-ed92a30b6a42
7ca25e09-89e0-4c12-8850-2138924f1159	14f8a1da-841e-4b9b-b725-4b59d6ae935b
7ca25e09-89e0-4c12-8850-2138924f1159	84cac2c5-214c-4bda-a6b3-7e4b9297fa49
7ca25e09-89e0-4c12-8850-2138924f1159	38091b78-823c-4fc8-971c-27adcc2cc9b3
7ca25e09-89e0-4c12-8850-2138924f1159	46ad9b37-8dbb-4465-acdc-ee0c1e553b3c
7ca25e09-89e0-4c12-8850-2138924f1159	97c53fe4-442d-494d-b33c-da560c0e3834
7ca25e09-89e0-4c12-8850-2138924f1159	03f09909-e513-43c4-a17c-69024e6c4c91
7ca25e09-89e0-4c12-8850-2138924f1159	0ac766ed-6121-4220-a3e9-110831df48a1
7ca25e09-89e0-4c12-8850-2138924f1159	ecb658fe-70d4-4a99-98ab-6753effa4feb
7ca25e09-89e0-4c12-8850-2138924f1159	731fad47-4cb9-4d76-b9c0-c42e0428fe93
7ca25e09-89e0-4c12-8850-2138924f1159	57ffe883-7c31-4017-885e-55fe3df4c310
180c115a-e750-4bd8-9030-a6111522e32a	0ac766ed-6121-4220-a3e9-110831df48a1
180c115a-e750-4bd8-9030-a6111522e32a	57ffe883-7c31-4017-885e-55fe3df4c310
1ba729b1-bebd-4eae-8dd1-77bbc97ed207	ecb658fe-70d4-4a99-98ab-6753effa4feb
76ab0737-f4fe-42af-aec1-3b71892f8ccc	c59f2546-8d3f-4c38-becb-061371e4db2d
76ab0737-f4fe-42af-aec1-3b71892f8ccc	4726bd4a-01c2-46de-8632-82627aa46ea2
4726bd4a-01c2-46de-8632-82627aa46ea2	afbe5e5f-2fc1-4759-aaff-0fe7239f573b
59daf1d2-e8ac-4395-b5c6-f682dcbca252	ae6e7738-fd45-496e-bf62-a0ba21d1210f
7ca25e09-89e0-4c12-8850-2138924f1159	fd6d9dae-08e8-433e-a8b4-f7f3ad5ca944
76ab0737-f4fe-42af-aec1-3b71892f8ccc	283324a3-aa37-4488-823b-86f70f5f8535
76ab0737-f4fe-42af-aec1-3b71892f8ccc	53331b34-d3fb-4217-ba3b-a9e55f004324
7ca25e09-89e0-4c12-8850-2138924f1159	e7c10524-6b80-4870-931f-707a10b330f5
7ca25e09-89e0-4c12-8850-2138924f1159	ed05b454-19df-4baa-8a02-8e209a6d0987
7ca25e09-89e0-4c12-8850-2138924f1159	9f05ea53-4629-4db1-9ed6-89fe784170b5
7ca25e09-89e0-4c12-8850-2138924f1159	22582409-311c-48ab-b854-304d221c304d
7ca25e09-89e0-4c12-8850-2138924f1159	a105a5f8-9a9d-489f-9f7a-6487feff7f11
7ca25e09-89e0-4c12-8850-2138924f1159	2ca8f3a5-9ed2-4748-9217-195beeaa0c58
7ca25e09-89e0-4c12-8850-2138924f1159	8e563722-fba0-47c8-894d-fe83fecb2489
7ca25e09-89e0-4c12-8850-2138924f1159	b70c3df3-ef51-461f-b94c-ca147aed8e34
7ca25e09-89e0-4c12-8850-2138924f1159	0a6d272e-4e7e-46c7-a6c9-01338a5421b7
7ca25e09-89e0-4c12-8850-2138924f1159	df467638-22c0-4cb9-85a7-5b0764411e2c
7ca25e09-89e0-4c12-8850-2138924f1159	fe938b22-12a1-4bed-a192-b1d3596df6b7
7ca25e09-89e0-4c12-8850-2138924f1159	de0fbdbb-e992-4db9-987f-1b45c3827c1c
7ca25e09-89e0-4c12-8850-2138924f1159	ef73a8fa-1246-4ddb-b186-acaf8946e643
7ca25e09-89e0-4c12-8850-2138924f1159	e5c8b81f-27b3-442a-9b5a-3a6d326c04df
7ca25e09-89e0-4c12-8850-2138924f1159	0ac7e126-33cb-403a-92a3-4a5dfc623d3b
7ca25e09-89e0-4c12-8850-2138924f1159	3c60ded0-299d-4f6a-b978-66046ad0cea8
7ca25e09-89e0-4c12-8850-2138924f1159	a313efc0-5b47-4961-8dce-d9650d4d93c9
22582409-311c-48ab-b854-304d221c304d	0ac7e126-33cb-403a-92a3-4a5dfc623d3b
9f05ea53-4629-4db1-9ed6-89fe784170b5	a313efc0-5b47-4961-8dce-d9650d4d93c9
9f05ea53-4629-4db1-9ed6-89fe784170b5	e5c8b81f-27b3-442a-9b5a-3a6d326c04df
eeb2191a-c5d1-4016-a587-9e0762726302	3a5bb10f-33ad-43ce-91b6-768ad4d6ce0b
eeb2191a-c5d1-4016-a587-9e0762726302	90dc2f93-e3e6-4987-b50d-62cc35afd81e
eeb2191a-c5d1-4016-a587-9e0762726302	33a350a3-4d8f-4823-8152-d53b9a32ed7f
eeb2191a-c5d1-4016-a587-9e0762726302	e61125d9-594e-49d7-b4ec-f2b7ddd0f1a5
eeb2191a-c5d1-4016-a587-9e0762726302	7161923a-ffe1-4d32-9311-da8fc4219d00
eeb2191a-c5d1-4016-a587-9e0762726302	3f67ac2f-e012-47c8-abb3-33763d0c3520
eeb2191a-c5d1-4016-a587-9e0762726302	add5b4cd-77b4-476e-8d1c-41df27e611c1
eeb2191a-c5d1-4016-a587-9e0762726302	1ffa6825-7714-4f6e-8511-05d12758d3a5
eeb2191a-c5d1-4016-a587-9e0762726302	284638e1-e9e5-400f-9186-9246e55acbb3
eeb2191a-c5d1-4016-a587-9e0762726302	dacf0eb7-d35e-401f-a55b-9eb15d88ab05
eeb2191a-c5d1-4016-a587-9e0762726302	304b50b7-5c67-402c-ad6c-43d90dfacc3a
eeb2191a-c5d1-4016-a587-9e0762726302	7cb760ff-e50d-4d59-87c2-66102f26cf1f
eeb2191a-c5d1-4016-a587-9e0762726302	c6a86be4-b5e1-4cab-942d-4e0eaa688744
eeb2191a-c5d1-4016-a587-9e0762726302	d8c73c9d-4dcc-4783-be94-5ef06b6c99ff
eeb2191a-c5d1-4016-a587-9e0762726302	7b84fd5f-1913-4404-ae0b-1f6cf55b4c3e
eeb2191a-c5d1-4016-a587-9e0762726302	c985a6c5-7eb1-40cd-b871-5a8085c34471
eeb2191a-c5d1-4016-a587-9e0762726302	18e6fd44-db60-46b1-9731-694a9aaca8eb
33a350a3-4d8f-4823-8152-d53b9a32ed7f	18e6fd44-db60-46b1-9731-694a9aaca8eb
33a350a3-4d8f-4823-8152-d53b9a32ed7f	d8c73c9d-4dcc-4783-be94-5ef06b6c99ff
e61125d9-594e-49d7-b4ec-f2b7ddd0f1a5	7b84fd5f-1913-4404-ae0b-1f6cf55b4c3e
ef4e1149-2675-45d2-82e4-b539d823ceb2	bf410f8e-dc5a-40bd-96aa-afa1b5584b2d
ef4e1149-2675-45d2-82e4-b539d823ceb2	c476aec6-d6c4-40ca-b747-6c7b2139db46
c476aec6-d6c4-40ca-b747-6c7b2139db46	e5a29f7a-420a-4a57-8705-a2268c714ed0
766d0268-bf2e-4e32-a794-5a8a3b4de4fe	a6d488c3-bd55-4d28-9949-6dd460217199
7ca25e09-89e0-4c12-8850-2138924f1159	9b2defaa-9d38-43e2-b3ee-bf2dd6388057
eeb2191a-c5d1-4016-a587-9e0762726302	4bf1f616-1f7a-4c62-965f-5b0f5d053844
ef4e1149-2675-45d2-82e4-b539d823ceb2	b775294b-f8db-46a8-a945-bd9bc2214b98
ef4e1149-2675-45d2-82e4-b539d823ceb2	f789f503-48d0-4c88-9680-04675e3a9dc4
\.


--
-- Data for Name: credential; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.credential (id, salt, type, user_id, created_date, user_label, secret_data, credential_data, priority, version) FROM stdin;
6c5412c6-6aa4-4b63-92da-e37bf2c14966	\N	password	65c5dbfe-fb0b-4849-98ad-519a254de1c1	1749042186723	\N	{"value":"G9kwDu1rsGPO49I2kW772VaEH/OvbFBvBF8yzQHpqls=","salt":"/2z7xp9QBm5giWdzLcichw==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10	1
d2624492-4907-49a8-a34a-ab619b7bf4aa	\N	password	9b84fcdf-6f83-4402-b631-6a97b0de6f86	1749043537913	My password	{"value":"eWc27wgDL2A+CVvumaLe67u3lY7NX0PjNAJWufH+x9s=","salt":"OxdiNV0MwhC5hdV3s5/TCQ==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10	3
142901bb-30ed-49ce-98e6-7517ca148084	\N	password	cf2fedf1-1bb5-40af-8241-bd20b90d2762	1752075905179	My password	{"value":"j1EDzYBV1T10EJfxr7U8Sle2GBbWGRTsiNdcjZTi4ZA=","salt":"Fkh4Tl+hQmk0biaN0/xwZA==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10	1
\.


--
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM stdin;
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/jpa-changelog-1.0.0.Final.xml	2025-06-04 13:02:32.283683	1	EXECUTED	9:6f1016664e21e16d26517a4418f5e3df	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.25.1	\N	\N	9042148891
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/db2-jpa-changelog-1.0.0.Final.xml	2025-06-04 13:02:32.330143	2	MARK_RAN	9:828775b1596a07d1200ba1d49e5e3941	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.25.1	\N	\N	9042148891
1.1.0.Beta1	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Beta1.xml	2025-06-04 13:02:32.737035	3	EXECUTED	9:5f090e44a7d595883c1fb61f4b41fd38	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=CLIENT_ATTRIBUTES; createTable tableName=CLIENT_SESSION_NOTE; createTable tableName=APP_NODE_REGISTRATIONS; addColumn table...		\N	4.25.1	\N	\N	9042148891
1.1.0.Final	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Final.xml	2025-06-04 13:02:32.810173	4	EXECUTED	9:c07e577387a3d2c04d1adc9aaad8730e	renameColumn newColumnName=EVENT_TIME, oldColumnName=TIME, tableName=EVENT_ENTITY		\N	4.25.1	\N	\N	9042148891
1.2.0.Beta1	psilva@redhat.com	META-INF/jpa-changelog-1.2.0.Beta1.xml	2025-06-04 13:02:33.94321	5	EXECUTED	9:b68ce996c655922dbcd2fe6b6ae72686	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.25.1	\N	\N	9042148891
1.2.0.Beta1	psilva@redhat.com	META-INF/db2-jpa-changelog-1.2.0.Beta1.xml	2025-06-04 13:02:33.97908	6	MARK_RAN	9:543b5c9989f024fe35c6f6c5a97de88e	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.25.1	\N	\N	9042148891
1.2.0.RC1	bburke@redhat.com	META-INF/jpa-changelog-1.2.0.CR1.xml	2025-06-04 13:02:34.756161	7	EXECUTED	9:765afebbe21cf5bbca048e632df38336	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.25.1	\N	\N	9042148891
1.2.0.RC1	bburke@redhat.com	META-INF/db2-jpa-changelog-1.2.0.CR1.xml	2025-06-04 13:02:34.802662	8	MARK_RAN	9:db4a145ba11a6fdaefb397f6dbf829a1	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.25.1	\N	\N	9042148891
1.2.0.Final	keycloak	META-INF/jpa-changelog-1.2.0.Final.xml	2025-06-04 13:02:34.842207	9	EXECUTED	9:9d05c7be10cdb873f8bcb41bc3a8ab23	update tableName=CLIENT; update tableName=CLIENT; update tableName=CLIENT		\N	4.25.1	\N	\N	9042148891
1.3.0	bburke@redhat.com	META-INF/jpa-changelog-1.3.0.xml	2025-06-04 13:02:36.769042	10	EXECUTED	9:18593702353128d53111f9b1ff0b82b8	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=ADMI...		\N	4.25.1	\N	\N	9042148891
1.4.0	bburke@redhat.com	META-INF/jpa-changelog-1.4.0.xml	2025-06-04 13:02:37.357263	11	EXECUTED	9:6122efe5f090e41a85c0f1c9e52cbb62	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.25.1	\N	\N	9042148891
1.4.0	bburke@redhat.com	META-INF/db2-jpa-changelog-1.4.0.xml	2025-06-04 13:02:37.388971	12	MARK_RAN	9:e1ff28bf7568451453f844c5d54bb0b5	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.25.1	\N	\N	9042148891
1.5.0	bburke@redhat.com	META-INF/jpa-changelog-1.5.0.xml	2025-06-04 13:02:37.482225	13	EXECUTED	9:7af32cd8957fbc069f796b61217483fd	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.25.1	\N	\N	9042148891
1.6.1_from15	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2025-06-04 13:02:37.818437	14	EXECUTED	9:6005e15e84714cd83226bf7879f54190	addColumn tableName=REALM; addColumn tableName=KEYCLOAK_ROLE; addColumn tableName=CLIENT; createTable tableName=OFFLINE_USER_SESSION; createTable tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_US_SES_PK2, tableName=...		\N	4.25.1	\N	\N	9042148891
1.6.1_from16-pre	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2025-06-04 13:02:37.856641	15	MARK_RAN	9:bf656f5a2b055d07f314431cae76f06c	delete tableName=OFFLINE_CLIENT_SESSION; delete tableName=OFFLINE_USER_SESSION		\N	4.25.1	\N	\N	9042148891
1.6.1_from16	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2025-06-04 13:02:37.893273	16	MARK_RAN	9:f8dadc9284440469dcf71e25ca6ab99b	dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_US_SES_PK, tableName=OFFLINE_USER_SESSION; dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_CL_SES_PK, tableName=OFFLINE_CLIENT_SESSION; addColumn tableName=OFFLINE_USER_SESSION; update tableName=OF...		\N	4.25.1	\N	\N	9042148891
1.6.1	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2025-06-04 13:02:37.931462	17	EXECUTED	9:d41d8cd98f00b204e9800998ecf8427e	empty		\N	4.25.1	\N	\N	9042148891
1.7.0	bburke@redhat.com	META-INF/jpa-changelog-1.7.0.xml	2025-06-04 13:02:38.341949	18	EXECUTED	9:3368ff0be4c2855ee2dd9ca813b38d8e	createTable tableName=KEYCLOAK_GROUP; createTable tableName=GROUP_ROLE_MAPPING; createTable tableName=GROUP_ATTRIBUTE; createTable tableName=USER_GROUP_MEMBERSHIP; createTable tableName=REALM_DEFAULT_GROUPS; addColumn tableName=IDENTITY_PROVIDER; ...		\N	4.25.1	\N	\N	9042148891
1.8.0	mposolda@redhat.com	META-INF/jpa-changelog-1.8.0.xml	2025-06-04 13:02:40.297734	19	EXECUTED	9:8ac2fb5dd030b24c0570a763ed75ed20	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.25.1	\N	\N	9042148891
1.8.0-2	keycloak	META-INF/jpa-changelog-1.8.0.xml	2025-06-04 13:02:40.384006	20	EXECUTED	9:f91ddca9b19743db60e3057679810e6c	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.25.1	\N	\N	9042148891
24.0.0-9758-2	keycloak	META-INF/jpa-changelog-24.0.0.xml	2025-06-04 13:03:00.962082	119	EXECUTED	9:bf0fdee10afdf597a987adbf291db7b2	customChange		\N	4.25.1	\N	\N	9042148891
1.8.0	mposolda@redhat.com	META-INF/db2-jpa-changelog-1.8.0.xml	2025-06-04 13:02:40.422225	21	MARK_RAN	9:831e82914316dc8a57dc09d755f23c51	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.25.1	\N	\N	9042148891
1.8.0-2	keycloak	META-INF/db2-jpa-changelog-1.8.0.xml	2025-06-04 13:02:40.490673	22	MARK_RAN	9:f91ddca9b19743db60e3057679810e6c	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.25.1	\N	\N	9042148891
1.9.0	mposolda@redhat.com	META-INF/jpa-changelog-1.9.0.xml	2025-06-04 13:02:40.697297	23	EXECUTED	9:bc3d0f9e823a69dc21e23e94c7a94bb1	update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=REALM; update tableName=REALM; customChange; dr...		\N	4.25.1	\N	\N	9042148891
1.9.1	keycloak	META-INF/jpa-changelog-1.9.1.xml	2025-06-04 13:02:41.063586	24	EXECUTED	9:c9999da42f543575ab790e76439a2679	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=PUBLIC_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.25.1	\N	\N	9042148891
1.9.1	keycloak	META-INF/db2-jpa-changelog-1.9.1.xml	2025-06-04 13:02:41.090749	25	MARK_RAN	9:0d6c65c6f58732d81569e77b10ba301d	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.25.1	\N	\N	9042148891
1.9.2	keycloak	META-INF/jpa-changelog-1.9.2.xml	2025-06-04 13:02:41.887042	26	EXECUTED	9:fc576660fc016ae53d2d4778d84d86d0	createIndex indexName=IDX_USER_EMAIL, tableName=USER_ENTITY; createIndex indexName=IDX_USER_ROLE_MAPPING, tableName=USER_ROLE_MAPPING; createIndex indexName=IDX_USER_GROUP_MAPPING, tableName=USER_GROUP_MEMBERSHIP; createIndex indexName=IDX_USER_CO...		\N	4.25.1	\N	\N	9042148891
authz-2.0.0	psilva@redhat.com	META-INF/jpa-changelog-authz-2.0.0.xml	2025-06-04 13:02:43.010974	27	EXECUTED	9:43ed6b0da89ff77206289e87eaa9c024	createTable tableName=RESOURCE_SERVER; addPrimaryKey constraintName=CONSTRAINT_FARS, tableName=RESOURCE_SERVER; addUniqueConstraint constraintName=UK_AU8TT6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER; createTable tableName=RESOURCE_SERVER_RESOU...		\N	4.25.1	\N	\N	9042148891
authz-2.5.1	psilva@redhat.com	META-INF/jpa-changelog-authz-2.5.1.xml	2025-06-04 13:02:43.070348	28	EXECUTED	9:44bae577f551b3738740281eceb4ea70	update tableName=RESOURCE_SERVER_POLICY		\N	4.25.1	\N	\N	9042148891
2.1.0-KEYCLOAK-5461	bburke@redhat.com	META-INF/jpa-changelog-2.1.0.xml	2025-06-04 13:02:44.140627	29	EXECUTED	9:bd88e1f833df0420b01e114533aee5e8	createTable tableName=BROKER_LINK; createTable tableName=FED_USER_ATTRIBUTE; createTable tableName=FED_USER_CONSENT; createTable tableName=FED_USER_CONSENT_ROLE; createTable tableName=FED_USER_CONSENT_PROT_MAPPER; createTable tableName=FED_USER_CR...		\N	4.25.1	\N	\N	9042148891
2.2.0	bburke@redhat.com	META-INF/jpa-changelog-2.2.0.xml	2025-06-04 13:02:44.421084	30	EXECUTED	9:a7022af5267f019d020edfe316ef4371	addColumn tableName=ADMIN_EVENT_ENTITY; createTable tableName=CREDENTIAL_ATTRIBUTE; createTable tableName=FED_CREDENTIAL_ATTRIBUTE; modifyDataType columnName=VALUE, tableName=CREDENTIAL; addForeignKeyConstraint baseTableName=FED_CREDENTIAL_ATTRIBU...		\N	4.25.1	\N	\N	9042148891
2.3.0	bburke@redhat.com	META-INF/jpa-changelog-2.3.0.xml	2025-06-04 13:02:44.625959	31	EXECUTED	9:fc155c394040654d6a79227e56f5e25a	createTable tableName=FEDERATED_USER; addPrimaryKey constraintName=CONSTR_FEDERATED_USER, tableName=FEDERATED_USER; dropDefaultValue columnName=TOTP, tableName=USER_ENTITY; dropColumn columnName=TOTP, tableName=USER_ENTITY; addColumn tableName=IDE...		\N	4.25.1	\N	\N	9042148891
2.4.0	bburke@redhat.com	META-INF/jpa-changelog-2.4.0.xml	2025-06-04 13:02:44.675573	32	EXECUTED	9:eac4ffb2a14795e5dc7b426063e54d88	customChange		\N	4.25.1	\N	\N	9042148891
2.5.0	bburke@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2025-06-04 13:02:44.787936	33	EXECUTED	9:54937c05672568c4c64fc9524c1e9462	customChange; modifyDataType columnName=USER_ID, tableName=OFFLINE_USER_SESSION		\N	4.25.1	\N	\N	9042148891
2.5.0-unicode-oracle	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2025-06-04 13:02:44.824256	34	MARK_RAN	9:3a32bace77c84d7678d035a7f5a8084e	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.25.1	\N	\N	9042148891
2.5.0-unicode-other-dbs	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2025-06-04 13:02:45.177971	35	EXECUTED	9:33d72168746f81f98ae3a1e8e0ca3554	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.25.1	\N	\N	9042148891
2.5.0-duplicate-email-support	slawomir@dabek.name	META-INF/jpa-changelog-2.5.0.xml	2025-06-04 13:02:45.25347	36	EXECUTED	9:61b6d3d7a4c0e0024b0c839da283da0c	addColumn tableName=REALM		\N	4.25.1	\N	\N	9042148891
2.5.0-unique-group-names	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2025-06-04 13:02:45.399267	37	EXECUTED	9:8dcac7bdf7378e7d823cdfddebf72fda	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.25.1	\N	\N	9042148891
2.5.1	bburke@redhat.com	META-INF/jpa-changelog-2.5.1.xml	2025-06-04 13:02:45.486957	38	EXECUTED	9:a2b870802540cb3faa72098db5388af3	addColumn tableName=FED_USER_CONSENT		\N	4.25.1	\N	\N	9042148891
3.0.0	bburke@redhat.com	META-INF/jpa-changelog-3.0.0.xml	2025-06-04 13:02:45.948465	39	EXECUTED	9:132a67499ba24bcc54fb5cbdcfe7e4c0	addColumn tableName=IDENTITY_PROVIDER		\N	4.25.1	\N	\N	9042148891
3.2.0-fix	keycloak	META-INF/jpa-changelog-3.2.0.xml	2025-06-04 13:02:45.99223	40	MARK_RAN	9:938f894c032f5430f2b0fafb1a243462	addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS		\N	4.25.1	\N	\N	9042148891
3.2.0-fix-with-keycloak-5416	keycloak	META-INF/jpa-changelog-3.2.0.xml	2025-06-04 13:02:46.036281	41	MARK_RAN	9:845c332ff1874dc5d35974b0babf3006	dropIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS; addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS; createIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS		\N	4.25.1	\N	\N	9042148891
3.2.0-fix-offline-sessions	hmlnarik	META-INF/jpa-changelog-3.2.0.xml	2025-06-04 13:02:46.089084	42	EXECUTED	9:fc86359c079781adc577c5a217e4d04c	customChange		\N	4.25.1	\N	\N	9042148891
3.2.0-fixed	keycloak	META-INF/jpa-changelog-3.2.0.xml	2025-06-04 13:02:48.730962	43	EXECUTED	9:59a64800e3c0d09b825f8a3b444fa8f4	addColumn tableName=REALM; dropPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_PK2, tableName=OFFLINE_CLIENT_SESSION; dropColumn columnName=CLIENT_SESSION_ID, tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_P...		\N	4.25.1	\N	\N	9042148891
3.3.0	keycloak	META-INF/jpa-changelog-3.3.0.xml	2025-06-04 13:02:48.811141	44	EXECUTED	9:d48d6da5c6ccf667807f633fe489ce88	addColumn tableName=USER_ENTITY		\N	4.25.1	\N	\N	9042148891
authz-3.4.0.CR1-resource-server-pk-change-part1	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-06-04 13:02:48.907752	45	EXECUTED	9:dde36f7973e80d71fceee683bc5d2951	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_RESOURCE; addColumn tableName=RESOURCE_SERVER_SCOPE		\N	4.25.1	\N	\N	9042148891
authz-3.4.0.CR1-resource-server-pk-change-part2-KEYCLOAK-6095	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-06-04 13:02:48.957391	46	EXECUTED	9:b855e9b0a406b34fa323235a0cf4f640	customChange		\N	4.25.1	\N	\N	9042148891
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-06-04 13:02:49.004934	47	MARK_RAN	9:51abbacd7b416c50c4421a8cabf7927e	dropIndex indexName=IDX_RES_SERV_POL_RES_SERV, tableName=RESOURCE_SERVER_POLICY; dropIndex indexName=IDX_RES_SRV_RES_RES_SRV, tableName=RESOURCE_SERVER_RESOURCE; dropIndex indexName=IDX_RES_SRV_SCOPE_RES_SRV, tableName=RESOURCE_SERVER_SCOPE		\N	4.25.1	\N	\N	9042148891
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed-nodropindex	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-06-04 13:02:49.534376	48	EXECUTED	9:bdc99e567b3398bac83263d375aad143	addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_POLICY; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_RESOURCE; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, ...		\N	4.25.1	\N	\N	9042148891
authn-3.4.0.CR1-refresh-token-max-reuse	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-06-04 13:02:49.618931	49	EXECUTED	9:d198654156881c46bfba39abd7769e69	addColumn tableName=REALM		\N	4.25.1	\N	\N	9042148891
3.4.0	keycloak	META-INF/jpa-changelog-3.4.0.xml	2025-06-04 13:02:50.491361	50	EXECUTED	9:cfdd8736332ccdd72c5256ccb42335db	addPrimaryKey constraintName=CONSTRAINT_REALM_DEFAULT_ROLES, tableName=REALM_DEFAULT_ROLES; addPrimaryKey constraintName=CONSTRAINT_COMPOSITE_ROLE, tableName=COMPOSITE_ROLE; addPrimaryKey constraintName=CONSTR_REALM_DEFAULT_GROUPS, tableName=REALM...		\N	4.25.1	\N	\N	9042148891
3.4.0-KEYCLOAK-5230	hmlnarik@redhat.com	META-INF/jpa-changelog-3.4.0.xml	2025-06-04 13:02:51.936951	51	EXECUTED	9:7c84de3d9bd84d7f077607c1a4dcb714	createIndex indexName=IDX_FU_ATTRIBUTE, tableName=FED_USER_ATTRIBUTE; createIndex indexName=IDX_FU_CONSENT, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CONSENT_RU, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CREDENTIAL, t...		\N	4.25.1	\N	\N	9042148891
3.4.1	psilva@redhat.com	META-INF/jpa-changelog-3.4.1.xml	2025-06-04 13:02:52.045638	52	EXECUTED	9:5a6bb36cbefb6a9d6928452c0852af2d	modifyDataType columnName=VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	9042148891
3.4.2	keycloak	META-INF/jpa-changelog-3.4.2.xml	2025-06-04 13:02:52.127076	53	EXECUTED	9:8f23e334dbc59f82e0a328373ca6ced0	update tableName=REALM		\N	4.25.1	\N	\N	9042148891
3.4.2-KEYCLOAK-5172	mkanis@redhat.com	META-INF/jpa-changelog-3.4.2.xml	2025-06-04 13:02:52.211865	54	EXECUTED	9:9156214268f09d970cdf0e1564d866af	update tableName=CLIENT		\N	4.25.1	\N	\N	9042148891
4.0.0-KEYCLOAK-6335	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2025-06-04 13:02:52.430862	55	EXECUTED	9:db806613b1ed154826c02610b7dbdf74	createTable tableName=CLIENT_AUTH_FLOW_BINDINGS; addPrimaryKey constraintName=C_CLI_FLOW_BIND, tableName=CLIENT_AUTH_FLOW_BINDINGS		\N	4.25.1	\N	\N	9042148891
4.0.0-CLEANUP-UNUSED-TABLE	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2025-06-04 13:02:52.534764	56	EXECUTED	9:229a041fb72d5beac76bb94a5fa709de	dropTable tableName=CLIENT_IDENTITY_PROV_MAPPING		\N	4.25.1	\N	\N	9042148891
4.0.0-KEYCLOAK-6228	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2025-06-04 13:02:52.823893	57	EXECUTED	9:079899dade9c1e683f26b2aa9ca6ff04	dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; dropNotNullConstraint columnName=CLIENT_ID, tableName=USER_CONSENT; addColumn tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHO...		\N	4.25.1	\N	\N	9042148891
4.0.0-KEYCLOAK-5579-fixed	mposolda@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2025-06-04 13:02:54.191226	58	EXECUTED	9:139b79bcbbfe903bb1c2d2a4dbf001d9	dropForeignKeyConstraint baseTableName=CLIENT_TEMPLATE_ATTRIBUTES, constraintName=FK_CL_TEMPL_ATTR_TEMPL; renameTable newTableName=CLIENT_SCOPE_ATTRIBUTES, oldTableName=CLIENT_TEMPLATE_ATTRIBUTES; renameColumn newColumnName=SCOPE_ID, oldColumnName...		\N	4.25.1	\N	\N	9042148891
authz-4.0.0.CR1	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.CR1.xml	2025-06-04 13:02:54.470193	59	EXECUTED	9:b55738ad889860c625ba2bf483495a04	createTable tableName=RESOURCE_SERVER_PERM_TICKET; addPrimaryKey constraintName=CONSTRAINT_FAPMT, tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRHO213XCX4WNKOG82SSPMT...		\N	4.25.1	\N	\N	9042148891
authz-4.0.0.Beta3	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.Beta3.xml	2025-06-04 13:02:54.544542	60	EXECUTED	9:e0057eac39aa8fc8e09ac6cfa4ae15fe	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRPO2128CX4WNKOG82SSRFY, referencedTableName=RESOURCE_SERVER_POLICY		\N	4.25.1	\N	\N	9042148891
authz-4.2.0.Final	mhajas@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2025-06-04 13:02:54.629619	61	EXECUTED	9:42a33806f3a0443fe0e7feeec821326c	createTable tableName=RESOURCE_URIS; addForeignKeyConstraint baseTableName=RESOURCE_URIS, constraintName=FK_RESOURCE_SERVER_URIS, referencedTableName=RESOURCE_SERVER_RESOURCE; customChange; dropColumn columnName=URI, tableName=RESOURCE_SERVER_RESO...		\N	4.25.1	\N	\N	9042148891
authz-4.2.0.Final-KEYCLOAK-9944	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2025-06-04 13:02:54.721427	62	EXECUTED	9:9968206fca46eecc1f51db9c024bfe56	addPrimaryKey constraintName=CONSTRAINT_RESOUR_URIS_PK, tableName=RESOURCE_URIS		\N	4.25.1	\N	\N	9042148891
4.2.0-KEYCLOAK-6313	wadahiro@gmail.com	META-INF/jpa-changelog-4.2.0.xml	2025-06-04 13:02:54.795939	63	EXECUTED	9:92143a6daea0a3f3b8f598c97ce55c3d	addColumn tableName=REQUIRED_ACTION_PROVIDER		\N	4.25.1	\N	\N	9042148891
4.3.0-KEYCLOAK-7984	wadahiro@gmail.com	META-INF/jpa-changelog-4.3.0.xml	2025-06-04 13:02:54.839151	64	EXECUTED	9:82bab26a27195d889fb0429003b18f40	update tableName=REQUIRED_ACTION_PROVIDER		\N	4.25.1	\N	\N	9042148891
4.6.0-KEYCLOAK-7950	psilva@redhat.com	META-INF/jpa-changelog-4.6.0.xml	2025-06-04 13:02:54.872965	65	EXECUTED	9:e590c88ddc0b38b0ae4249bbfcb5abc3	update tableName=RESOURCE_SERVER_RESOURCE		\N	4.25.1	\N	\N	9042148891
4.6.0-KEYCLOAK-8377	keycloak	META-INF/jpa-changelog-4.6.0.xml	2025-06-04 13:02:55.096307	66	EXECUTED	9:5c1f475536118dbdc38d5d7977950cc0	createTable tableName=ROLE_ATTRIBUTE; addPrimaryKey constraintName=CONSTRAINT_ROLE_ATTRIBUTE_PK, tableName=ROLE_ATTRIBUTE; addForeignKeyConstraint baseTableName=ROLE_ATTRIBUTE, constraintName=FK_ROLE_ATTRIBUTE_ID, referencedTableName=KEYCLOAK_ROLE...		\N	4.25.1	\N	\N	9042148891
4.6.0-KEYCLOAK-8555	gideonray@gmail.com	META-INF/jpa-changelog-4.6.0.xml	2025-06-04 13:02:55.312597	67	EXECUTED	9:e7c9f5f9c4d67ccbbcc215440c718a17	createIndex indexName=IDX_COMPONENT_PROVIDER_TYPE, tableName=COMPONENT		\N	4.25.1	\N	\N	9042148891
4.7.0-KEYCLOAK-1267	sguilhen@redhat.com	META-INF/jpa-changelog-4.7.0.xml	2025-06-04 13:02:55.407426	68	EXECUTED	9:88e0bfdda924690d6f4e430c53447dd5	addColumn tableName=REALM		\N	4.25.1	\N	\N	9042148891
4.7.0-KEYCLOAK-7275	keycloak	META-INF/jpa-changelog-4.7.0.xml	2025-06-04 13:02:55.550234	69	EXECUTED	9:f53177f137e1c46b6a88c59ec1cb5218	renameColumn newColumnName=CREATED_ON, oldColumnName=LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION; addNotNullConstraint columnName=CREATED_ON, tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_USER_SESSION; customChange; createIn...		\N	4.25.1	\N	\N	9042148891
4.8.0-KEYCLOAK-8835	sguilhen@redhat.com	META-INF/jpa-changelog-4.8.0.xml	2025-06-04 13:02:55.625279	70	EXECUTED	9:a74d33da4dc42a37ec27121580d1459f	addNotNullConstraint columnName=SSO_MAX_LIFESPAN_REMEMBER_ME, tableName=REALM; addNotNullConstraint columnName=SSO_IDLE_TIMEOUT_REMEMBER_ME, tableName=REALM		\N	4.25.1	\N	\N	9042148891
authz-7.0.0-KEYCLOAK-10443	psilva@redhat.com	META-INF/jpa-changelog-authz-7.0.0.xml	2025-06-04 13:02:55.69983	71	EXECUTED	9:fd4ade7b90c3b67fae0bfcfcb42dfb5f	addColumn tableName=RESOURCE_SERVER		\N	4.25.1	\N	\N	9042148891
8.0.0-adding-credential-columns	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-06-04 13:02:55.784404	72	EXECUTED	9:aa072ad090bbba210d8f18781b8cebf4	addColumn tableName=CREDENTIAL; addColumn tableName=FED_USER_CREDENTIAL		\N	4.25.1	\N	\N	9042148891
8.0.0-updating-credential-data-not-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-06-04 13:02:55.824042	73	EXECUTED	9:1ae6be29bab7c2aa376f6983b932be37	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.25.1	\N	\N	9042148891
8.0.0-updating-credential-data-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-06-04 13:02:55.85924	74	MARK_RAN	9:14706f286953fc9a25286dbd8fb30d97	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.25.1	\N	\N	9042148891
8.0.0-credential-cleanup-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-06-04 13:02:55.969556	75	EXECUTED	9:2b9cc12779be32c5b40e2e67711a218b	dropDefaultValue columnName=COUNTER, tableName=CREDENTIAL; dropDefaultValue columnName=DIGITS, tableName=CREDENTIAL; dropDefaultValue columnName=PERIOD, tableName=CREDENTIAL; dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; dropColumn ...		\N	4.25.1	\N	\N	9042148891
8.0.0-resource-tag-support	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-06-04 13:02:56.078876	76	EXECUTED	9:91fa186ce7a5af127a2d7a91ee083cc5	addColumn tableName=MIGRATION_MODEL; createIndex indexName=IDX_UPDATE_TIME, tableName=MIGRATION_MODEL		\N	4.25.1	\N	\N	9042148891
9.0.0-always-display-client	keycloak	META-INF/jpa-changelog-9.0.0.xml	2025-06-04 13:02:56.164338	77	EXECUTED	9:6335e5c94e83a2639ccd68dd24e2e5ad	addColumn tableName=CLIENT		\N	4.25.1	\N	\N	9042148891
9.0.0-drop-constraints-for-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2025-06-04 13:02:56.199815	78	MARK_RAN	9:6bdb5658951e028bfe16fa0a8228b530	dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5PMT, tableName=RESOURCE_SERVER_PERM_TICKET; dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER_RESOURCE; dropPrimaryKey constraintName=CONSTRAINT_O...		\N	4.25.1	\N	\N	9042148891
9.0.0-increase-column-size-federated-fk	keycloak	META-INF/jpa-changelog-9.0.0.xml	2025-06-04 13:02:56.74349	79	EXECUTED	9:d5bc15a64117ccad481ce8792d4c608f	modifyDataType columnName=CLIENT_ID, tableName=FED_USER_CONSENT; modifyDataType columnName=CLIENT_REALM_CONSTRAINT, tableName=KEYCLOAK_ROLE; modifyDataType columnName=OWNER, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=CLIENT_ID, ta...		\N	4.25.1	\N	\N	9042148891
9.0.0-recreate-constraints-after-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2025-06-04 13:02:56.781852	80	MARK_RAN	9:077cba51999515f4d3e7ad5619ab592c	addNotNullConstraint columnName=CLIENT_ID, tableName=OFFLINE_CLIENT_SESSION; addNotNullConstraint columnName=OWNER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNullConstraint columnName=REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNull...		\N	4.25.1	\N	\N	9042148891
9.0.1-add-index-to-client.client_id	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-06-04 13:02:56.913779	81	EXECUTED	9:be969f08a163bf47c6b9e9ead8ac2afb	createIndex indexName=IDX_CLIENT_ID, tableName=CLIENT		\N	4.25.1	\N	\N	9042148891
9.0.1-KEYCLOAK-12579-drop-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-06-04 13:02:56.942898	82	MARK_RAN	9:6d3bb4408ba5a72f39bd8a0b301ec6e3	dropUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.25.1	\N	\N	9042148891
9.0.1-KEYCLOAK-12579-add-not-null-constraint	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-06-04 13:02:57.025552	83	EXECUTED	9:966bda61e46bebf3cc39518fbed52fa7	addNotNullConstraint columnName=PARENT_GROUP, tableName=KEYCLOAK_GROUP		\N	4.25.1	\N	\N	9042148891
9.0.1-KEYCLOAK-12579-recreate-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-06-04 13:02:57.062711	84	MARK_RAN	9:8dcac7bdf7378e7d823cdfddebf72fda	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.25.1	\N	\N	9042148891
9.0.1-add-index-to-events	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-06-04 13:02:57.175149	85	EXECUTED	9:7d93d602352a30c0c317e6a609b56599	createIndex indexName=IDX_EVENT_TIME, tableName=EVENT_ENTITY		\N	4.25.1	\N	\N	9042148891
map-remove-ri	keycloak	META-INF/jpa-changelog-11.0.0.xml	2025-06-04 13:02:57.354613	86	EXECUTED	9:71c5969e6cdd8d7b6f47cebc86d37627	dropForeignKeyConstraint baseTableName=REALM, constraintName=FK_TRAF444KK6QRKMS7N56AIWQ5Y; dropForeignKeyConstraint baseTableName=KEYCLOAK_ROLE, constraintName=FK_KJHO5LE2C0RAL09FL8CM9WFW9		\N	4.25.1	\N	\N	9042148891
map-remove-ri	keycloak	META-INF/jpa-changelog-12.0.0.xml	2025-06-04 13:02:57.439642	87	EXECUTED	9:a9ba7d47f065f041b7da856a81762021	dropForeignKeyConstraint baseTableName=REALM_DEFAULT_GROUPS, constraintName=FK_DEF_GROUPS_GROUP; dropForeignKeyConstraint baseTableName=REALM_DEFAULT_ROLES, constraintName=FK_H4WPD7W4HSOOLNI3H0SW7BTJE; dropForeignKeyConstraint baseTableName=CLIENT...		\N	4.25.1	\N	\N	9042148891
12.1.0-add-realm-localization-table	keycloak	META-INF/jpa-changelog-12.0.0.xml	2025-06-04 13:02:57.609843	88	EXECUTED	9:fffabce2bc01e1a8f5110d5278500065	createTable tableName=REALM_LOCALIZATIONS; addPrimaryKey tableName=REALM_LOCALIZATIONS		\N	4.25.1	\N	\N	9042148891
default-roles	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-06-04 13:02:57.684544	89	EXECUTED	9:fa8a5b5445e3857f4b010bafb5009957	addColumn tableName=REALM; customChange		\N	4.25.1	\N	\N	9042148891
default-roles-cleanup	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-06-04 13:02:57.773977	90	EXECUTED	9:67ac3241df9a8582d591c5ed87125f39	dropTable tableName=REALM_DEFAULT_ROLES; dropTable tableName=CLIENT_DEFAULT_ROLES		\N	4.25.1	\N	\N	9042148891
13.0.0-KEYCLOAK-16844	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-06-04 13:02:57.892562	91	EXECUTED	9:ad1194d66c937e3ffc82386c050ba089	createIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION		\N	4.25.1	\N	\N	9042148891
map-remove-ri-13.0.0	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-06-04 13:02:57.967498	92	EXECUTED	9:d9be619d94af5a2f5d07b9f003543b91	dropForeignKeyConstraint baseTableName=DEFAULT_CLIENT_SCOPE, constraintName=FK_R_DEF_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SCOPE_CLIENT, constraintName=FK_C_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SC...		\N	4.25.1	\N	\N	9042148891
13.0.0-KEYCLOAK-17992-drop-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-06-04 13:02:58.004032	93	MARK_RAN	9:544d201116a0fcc5a5da0925fbbc3bde	dropPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CLSCOPE_CL, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CL_CLSCOPE, tableName=CLIENT_SCOPE_CLIENT		\N	4.25.1	\N	\N	9042148891
13.0.0-increase-column-size-federated	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-06-04 13:02:58.163909	94	EXECUTED	9:43c0c1055b6761b4b3e89de76d612ccf	modifyDataType columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; modifyDataType columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT		\N	4.25.1	\N	\N	9042148891
13.0.0-KEYCLOAK-17992-recreate-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-06-04 13:02:58.202159	95	MARK_RAN	9:8bd711fd0330f4fe980494ca43ab1139	addNotNullConstraint columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; addNotNullConstraint columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT; addPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; createIndex indexName=...		\N	4.25.1	\N	\N	9042148891
json-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-06-04 13:02:58.380879	96	EXECUTED	9:e07d2bc0970c348bb06fb63b1f82ddbf	addColumn tableName=REALM_ATTRIBUTE; update tableName=REALM_ATTRIBUTE; dropColumn columnName=VALUE, tableName=REALM_ATTRIBUTE; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=REALM_ATTRIBUTE		\N	4.25.1	\N	\N	9042148891
14.0.0-KEYCLOAK-11019	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-06-04 13:02:58.64827	97	EXECUTED	9:24fb8611e97f29989bea412aa38d12b7	createIndex indexName=IDX_OFFLINE_CSS_PRELOAD, tableName=OFFLINE_CLIENT_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USER, tableName=OFFLINE_USER_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION		\N	4.25.1	\N	\N	9042148891
14.0.0-KEYCLOAK-18286	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-06-04 13:02:58.685422	98	MARK_RAN	9:259f89014ce2506ee84740cbf7163aa7	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	9042148891
14.0.0-KEYCLOAK-18286-revert	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-06-04 13:02:58.749388	99	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	9042148891
14.0.0-KEYCLOAK-18286-supported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-06-04 13:02:58.876914	100	EXECUTED	9:60ca84a0f8c94ec8c3504a5a3bc88ee8	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	9042148891
14.0.0-KEYCLOAK-18286-unsupported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-06-04 13:02:58.914347	101	MARK_RAN	9:d3d977031d431db16e2c181ce49d73e9	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	9042148891
KEYCLOAK-17267-add-index-to-user-attributes	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-06-04 13:02:59.026415	102	EXECUTED	9:0b305d8d1277f3a89a0a53a659ad274c	createIndex indexName=IDX_USER_ATTRIBUTE_NAME, tableName=USER_ATTRIBUTE		\N	4.25.1	\N	\N	9042148891
KEYCLOAK-18146-add-saml-art-binding-identifier	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-06-04 13:02:59.070085	103	EXECUTED	9:2c374ad2cdfe20e2905a84c8fac48460	customChange		\N	4.25.1	\N	\N	9042148891
15.0.0-KEYCLOAK-18467	keycloak	META-INF/jpa-changelog-15.0.0.xml	2025-06-04 13:02:59.149003	104	EXECUTED	9:47a760639ac597360a8219f5b768b4de	addColumn tableName=REALM_LOCALIZATIONS; update tableName=REALM_LOCALIZATIONS; dropColumn columnName=TEXTS, tableName=REALM_LOCALIZATIONS; renameColumn newColumnName=TEXTS, oldColumnName=TEXTS_NEW, tableName=REALM_LOCALIZATIONS; addNotNullConstrai...		\N	4.25.1	\N	\N	9042148891
17.0.0-9562	keycloak	META-INF/jpa-changelog-17.0.0.xml	2025-06-04 13:02:59.284515	105	EXECUTED	9:a6272f0576727dd8cad2522335f5d99e	createIndex indexName=IDX_USER_SERVICE_ACCOUNT, tableName=USER_ENTITY		\N	4.25.1	\N	\N	9042148891
18.0.0-10625-IDX_ADMIN_EVENT_TIME	keycloak	META-INF/jpa-changelog-18.0.0.xml	2025-06-04 13:02:59.418173	106	EXECUTED	9:015479dbd691d9cc8669282f4828c41d	createIndex indexName=IDX_ADMIN_EVENT_TIME, tableName=ADMIN_EVENT_ENTITY		\N	4.25.1	\N	\N	9042148891
19.0.0-10135	keycloak	META-INF/jpa-changelog-19.0.0.xml	2025-06-04 13:02:59.464264	107	EXECUTED	9:9518e495fdd22f78ad6425cc30630221	customChange		\N	4.25.1	\N	\N	9042148891
20.0.0-12964-supported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2025-06-04 13:02:59.587549	108	EXECUTED	9:e5f243877199fd96bcc842f27a1656ac	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.25.1	\N	\N	9042148891
20.0.0-12964-unsupported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2025-06-04 13:02:59.626188	109	MARK_RAN	9:1a6fcaa85e20bdeae0a9ce49b41946a5	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.25.1	\N	\N	9042148891
client-attributes-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-20.0.0.xml	2025-06-04 13:02:59.702826	110	EXECUTED	9:3f332e13e90739ed0c35b0b25b7822ca	addColumn tableName=CLIENT_ATTRIBUTES; update tableName=CLIENT_ATTRIBUTES; dropColumn columnName=VALUE, tableName=CLIENT_ATTRIBUTES; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	9042148891
21.0.2-17277	keycloak	META-INF/jpa-changelog-21.0.2.xml	2025-06-04 13:02:59.732612	111	EXECUTED	9:7ee1f7a3fb8f5588f171fb9a6ab623c0	customChange		\N	4.25.1	\N	\N	9042148891
21.1.0-19404	keycloak	META-INF/jpa-changelog-21.1.0.xml	2025-06-04 13:03:00.326419	112	EXECUTED	9:3d7e830b52f33676b9d64f7f2b2ea634	modifyDataType columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=LOGIC, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=POLICY_ENFORCE_MODE, tableName=RESOURCE_SERVER		\N	4.25.1	\N	\N	9042148891
21.1.0-19404-2	keycloak	META-INF/jpa-changelog-21.1.0.xml	2025-06-04 13:03:00.365626	113	MARK_RAN	9:627d032e3ef2c06c0e1f73d2ae25c26c	addColumn tableName=RESOURCE_SERVER_POLICY; update tableName=RESOURCE_SERVER_POLICY; dropColumn columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; renameColumn newColumnName=DECISION_STRATEGY, oldColumnName=DECISION_STRATEGY_NEW, tabl...		\N	4.25.1	\N	\N	9042148891
22.0.0-17484-updated	keycloak	META-INF/jpa-changelog-22.0.0.xml	2025-06-04 13:03:00.406705	114	EXECUTED	9:90af0bfd30cafc17b9f4d6eccd92b8b3	customChange		\N	4.25.1	\N	\N	9042148891
22.0.5-24031	keycloak	META-INF/jpa-changelog-22.0.0.xml	2025-06-04 13:03:00.450447	115	MARK_RAN	9:a60d2d7b315ec2d3eba9e2f145f9df28	customChange		\N	4.25.1	\N	\N	9042148891
23.0.0-12062	keycloak	META-INF/jpa-changelog-23.0.0.xml	2025-06-04 13:03:00.524777	116	EXECUTED	9:2168fbe728fec46ae9baf15bf80927b8	addColumn tableName=COMPONENT_CONFIG; update tableName=COMPONENT_CONFIG; dropColumn columnName=VALUE, tableName=COMPONENT_CONFIG; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=COMPONENT_CONFIG		\N	4.25.1	\N	\N	9042148891
23.0.0-17258	keycloak	META-INF/jpa-changelog-23.0.0.xml	2025-06-04 13:03:00.625912	117	EXECUTED	9:36506d679a83bbfda85a27ea1864dca8	addColumn tableName=EVENT_ENTITY		\N	4.25.1	\N	\N	9042148891
24.0.0-9758	keycloak	META-INF/jpa-changelog-24.0.0.xml	2025-06-04 13:03:00.918979	118	EXECUTED	9:502c557a5189f600f0f445a9b49ebbce	addColumn tableName=USER_ATTRIBUTE; addColumn tableName=FED_USER_ATTRIBUTE; createIndex indexName=USER_ATTR_LONG_VALUES, tableName=USER_ATTRIBUTE; createIndex indexName=FED_USER_ATTR_LONG_VALUES, tableName=FED_USER_ATTRIBUTE; createIndex indexName...		\N	4.25.1	\N	\N	9042148891
24.0.0-26618-drop-index-if-present	keycloak	META-INF/jpa-changelog-24.0.0.xml	2025-06-04 13:03:00.9984	120	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	9042148891
24.0.0-26618-reindex	keycloak	META-INF/jpa-changelog-24.0.0.xml	2025-06-04 13:03:01.127022	121	EXECUTED	9:08707c0f0db1cef6b352db03a60edc7f	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	9042148891
24.0.2-27228	keycloak	META-INF/jpa-changelog-24.0.2.xml	2025-06-04 13:03:01.158221	122	EXECUTED	9:eaee11f6b8aa25d2cc6a84fb86fc6238	customChange		\N	4.25.1	\N	\N	9042148891
24.0.2-27967-drop-index-if-present	keycloak	META-INF/jpa-changelog-24.0.2.xml	2025-06-04 13:03:01.191143	123	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	9042148891
24.0.2-27967-reindex	keycloak	META-INF/jpa-changelog-24.0.2.xml	2025-06-04 13:03:01.22818	124	MARK_RAN	9:d3d977031d431db16e2c181ce49d73e9	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	9042148891
18.0.15-30992-index-consent	keycloak	META-INF/jpa-changelog-18.0.15.xml	2025-06-04 13:16:47.74287	125	EXECUTED	9:80071ede7a05604b1f4906f3bf3b00f0	createIndex indexName=IDX_USCONSENT_SCOPE_ID, tableName=USER_CONSENT_CLIENT_SCOPE		\N	4.29.1	\N	\N	9043007284
25.0.0-28265-tables	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-06-04 13:16:47.837777	126	EXECUTED	9:deda2df035df23388af95bbd36c17cef	addColumn tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_CLIENT_SESSION		\N	4.29.1	\N	\N	9043007284
25.0.0-28265-index-creation	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-06-04 13:16:48.066165	127	EXECUTED	9:3e96709818458ae49f3c679ae58d263a	createIndex indexName=IDX_OFFLINE_USS_BY_LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	9043007284
25.0.0-28265-index-cleanup-uss-createdon	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-06-04 13:16:48.376371	128	EXECUTED	9:78ab4fc129ed5e8265dbcc3485fba92f	dropIndex indexName=IDX_OFFLINE_USS_CREATEDON, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	9043007284
25.0.0-28265-index-cleanup-uss-preload	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-06-04 13:16:48.68291	129	EXECUTED	9:de5f7c1f7e10994ed8b62e621d20eaab	dropIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	9043007284
25.0.0-28265-index-cleanup-uss-by-usersess	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-06-04 13:16:48.962954	130	EXECUTED	9:6eee220d024e38e89c799417ec33667f	dropIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	9043007284
25.0.0-28265-index-cleanup-css-preload	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-06-04 13:16:49.237876	131	EXECUTED	9:5411d2fb2891d3e8d63ddb55dfa3c0c9	dropIndex indexName=IDX_OFFLINE_CSS_PRELOAD, tableName=OFFLINE_CLIENT_SESSION		\N	4.29.1	\N	\N	9043007284
25.0.0-28265-index-2-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-06-04 13:16:49.276813	132	MARK_RAN	9:b7ef76036d3126bb83c2423bf4d449d6	createIndex indexName=IDX_OFFLINE_USS_BY_BROKER_SESSION_ID, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	9043007284
25.0.0-28265-index-2-not-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-06-04 13:16:49.451349	133	EXECUTED	9:23396cf51ab8bc1ae6f0cac7f9f6fcf7	createIndex indexName=IDX_OFFLINE_USS_BY_BROKER_SESSION_ID, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	9043007284
25.0.0-org	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-06-04 13:16:50.425348	134	EXECUTED	9:5c859965c2c9b9c72136c360649af157	createTable tableName=ORG; addUniqueConstraint constraintName=UK_ORG_NAME, tableName=ORG; addUniqueConstraint constraintName=UK_ORG_GROUP, tableName=ORG; createTable tableName=ORG_DOMAIN		\N	4.29.1	\N	\N	9043007284
unique-consentuser	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-06-04 13:16:50.643659	135	EXECUTED	9:5857626a2ea8767e9a6c66bf3a2cb32f	customChange; dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_LOCAL_CONSENT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_EXTERNAL_CONSENT, tableName=...		\N	4.29.1	\N	\N	9043007284
unique-consentuser-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-06-04 13:16:50.675585	136	MARK_RAN	9:b79478aad5adaa1bc428e31563f55e8e	customChange; dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_LOCAL_CONSENT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_EXTERNAL_CONSENT, tableName=...		\N	4.29.1	\N	\N	9043007284
25.0.0-28861-index-creation	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-06-04 13:16:52.51707	137	EXECUTED	9:b9acb58ac958d9ada0fe12a5d4794ab1	createIndex indexName=IDX_PERM_TICKET_REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; createIndex indexName=IDX_PERM_TICKET_OWNER, tableName=RESOURCE_SERVER_PERM_TICKET		\N	4.29.1	\N	\N	9043007284
26.0.0-org-alias	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-06-04 13:16:52.640427	138	EXECUTED	9:6ef7d63e4412b3c2d66ed179159886a4	addColumn tableName=ORG; update tableName=ORG; addNotNullConstraint columnName=ALIAS, tableName=ORG; addUniqueConstraint constraintName=UK_ORG_ALIAS, tableName=ORG		\N	4.29.1	\N	\N	9043007284
26.0.0-org-group	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-06-04 13:16:52.715173	139	EXECUTED	9:da8e8087d80ef2ace4f89d8c5b9ca223	addColumn tableName=KEYCLOAK_GROUP; update tableName=KEYCLOAK_GROUP; addNotNullConstraint columnName=TYPE, tableName=KEYCLOAK_GROUP; customChange		\N	4.29.1	\N	\N	9043007284
26.0.0-org-indexes	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-06-04 13:16:52.880182	140	EXECUTED	9:79b05dcd610a8c7f25ec05135eec0857	createIndex indexName=IDX_ORG_DOMAIN_ORG_ID, tableName=ORG_DOMAIN		\N	4.29.1	\N	\N	9043007284
26.0.0-org-group-membership	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-06-04 13:16:52.955432	141	EXECUTED	9:a6ace2ce583a421d89b01ba2a28dc2d4	addColumn tableName=USER_GROUP_MEMBERSHIP; update tableName=USER_GROUP_MEMBERSHIP; addNotNullConstraint columnName=MEMBERSHIP_TYPE, tableName=USER_GROUP_MEMBERSHIP		\N	4.29.1	\N	\N	9043007284
31296-persist-revoked-access-tokens	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-06-04 13:16:53.068465	142	EXECUTED	9:64ef94489d42a358e8304b0e245f0ed4	createTable tableName=REVOKED_TOKEN; addPrimaryKey constraintName=CONSTRAINT_RT, tableName=REVOKED_TOKEN		\N	4.29.1	\N	\N	9043007284
31725-index-persist-revoked-access-tokens	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-06-04 13:16:53.36578	143	EXECUTED	9:b994246ec2bf7c94da881e1d28782c7b	createIndex indexName=IDX_REV_TOKEN_ON_EXPIRE, tableName=REVOKED_TOKEN		\N	4.29.1	\N	\N	9043007284
26.0.0-idps-for-login	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-06-04 13:16:53.690733	144	EXECUTED	9:51f5fffadf986983d4bd59582c6c1604	addColumn tableName=IDENTITY_PROVIDER; createIndex indexName=IDX_IDP_REALM_ORG, tableName=IDENTITY_PROVIDER; createIndex indexName=IDX_IDP_FOR_LOGIN, tableName=IDENTITY_PROVIDER; customChange		\N	4.29.1	\N	\N	9043007284
26.0.0-32583-drop-redundant-index-on-client-session	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-06-04 13:16:54.012426	145	EXECUTED	9:24972d83bf27317a055d234187bb4af9	dropIndex indexName=IDX_US_SESS_ID_ON_CL_SESS, tableName=OFFLINE_CLIENT_SESSION		\N	4.29.1	\N	\N	9043007284
26.0.0.32582-remove-tables-user-session-user-session-note-and-client-session	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-06-04 13:16:54.169621	146	EXECUTED	9:febdc0f47f2ed241c59e60f58c3ceea5	dropTable tableName=CLIENT_SESSION_ROLE; dropTable tableName=CLIENT_SESSION_NOTE; dropTable tableName=CLIENT_SESSION_PROT_MAPPER; dropTable tableName=CLIENT_SESSION_AUTH_STATUS; dropTable tableName=CLIENT_USER_SESSION_NOTE; dropTable tableName=CLI...		\N	4.29.1	\N	\N	9043007284
26.0.0-33201-org-redirect-url	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-06-04 13:16:54.23152	147	EXECUTED	9:4d0e22b0ac68ebe9794fa9cb752ea660	addColumn tableName=ORG		\N	4.29.1	\N	\N	9043007284
29399-jdbc-ping-default	keycloak	META-INF/jpa-changelog-26.1.0.xml	2025-06-04 13:16:54.42489	148	EXECUTED	9:007dbe99d7203fca403b89d4edfdf21e	createTable tableName=JGROUPS_PING; addPrimaryKey constraintName=CONSTRAINT_JGROUPS_PING, tableName=JGROUPS_PING		\N	4.29.1	\N	\N	9043007284
26.1.0-34013	keycloak	META-INF/jpa-changelog-26.1.0.xml	2025-06-04 13:16:54.498942	149	EXECUTED	9:e6b686a15759aef99a6d758a5c4c6a26	addColumn tableName=ADMIN_EVENT_ENTITY		\N	4.29.1	\N	\N	9043007284
26.1.0-34380	keycloak	META-INF/jpa-changelog-26.1.0.xml	2025-06-04 13:16:54.60641	150	EXECUTED	9:ac8b9edb7c2b6c17a1c7a11fcf5ccf01	dropTable tableName=USERNAME_LOGIN_FAILURE		\N	4.29.1	\N	\N	9043007284
26.2.0-36750	keycloak	META-INF/jpa-changelog-26.2.0.xml	2025-06-04 13:16:54.786436	151	EXECUTED	9:b49ce951c22f7eb16480ff085640a33a	createTable tableName=SERVER_CONFIG		\N	4.29.1	\N	\N	9043007284
26.2.0-26106	keycloak	META-INF/jpa-changelog-26.2.0.xml	2025-06-04 13:16:54.871238	152	EXECUTED	9:b5877d5dab7d10ff3a9d209d7beb6680	addColumn tableName=CREDENTIAL		\N	4.29.1	\N	\N	9043007284
\.


--
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
1	f	\N	\N
1000	f	\N	\N
1001	f	\N	\N
\.


--
-- Data for Name: default_client_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.default_client_scope (realm_id, scope_id, default_scope) FROM stdin;
98b2ec68-490d-4a88-b1bd-05b5707e88da	ec3648e1-1066-447d-96f5-2d8eb0bc46ff	f
98b2ec68-490d-4a88-b1bd-05b5707e88da	8e7645f4-2451-45ad-9b23-2f134644b247	t
98b2ec68-490d-4a88-b1bd-05b5707e88da	07c92273-56d0-4146-9527-06062df4ecd9	t
98b2ec68-490d-4a88-b1bd-05b5707e88da	b5d7f679-2dd9-4ce7-8afe-cc3c11e64c33	t
98b2ec68-490d-4a88-b1bd-05b5707e88da	74e0b3a0-0717-4f2e-84b6-84b3f670f740	f
98b2ec68-490d-4a88-b1bd-05b5707e88da	692aa94c-6422-440f-9dec-db751b7f8a57	f
98b2ec68-490d-4a88-b1bd-05b5707e88da	d42fac06-27aa-481e-9120-aa41eb07ed8b	t
98b2ec68-490d-4a88-b1bd-05b5707e88da	1dcefe0f-2d1c-4b9c-8339-7726fda71005	t
98b2ec68-490d-4a88-b1bd-05b5707e88da	5fe5a21a-329d-4f02-bf01-bc0e865b3d86	f
98b2ec68-490d-4a88-b1bd-05b5707e88da	f82ae212-bd5e-4214-b06f-300ff86113d4	t
545899ec-2a73-4c95-b368-425da707cea1	29e5c5c9-0e32-4c8f-a52d-952b88a08b3e	f
545899ec-2a73-4c95-b368-425da707cea1	8584251b-aac3-4cbb-88b5-c8f296ba05a1	t
545899ec-2a73-4c95-b368-425da707cea1	fa8768c8-e248-4760-934c-539eaa982a8d	t
545899ec-2a73-4c95-b368-425da707cea1	c7cdc97f-181a-4536-960a-e895810f0f23	t
545899ec-2a73-4c95-b368-425da707cea1	9dec93f8-97b6-433c-8335-7cec3f030f56	f
545899ec-2a73-4c95-b368-425da707cea1	627847cc-3caf-4b2f-976f-03da61fa4cdc	f
545899ec-2a73-4c95-b368-425da707cea1	bd452d3d-137b-4f49-bdce-c477b2bbc742	t
545899ec-2a73-4c95-b368-425da707cea1	825e1390-66c9-47fd-b238-80702e480d73	t
545899ec-2a73-4c95-b368-425da707cea1	d9a604e1-9343-404b-9357-79506e6a3324	f
545899ec-2a73-4c95-b368-425da707cea1	dcda8ff0-d811-443f-9d49-7e6f8922de1b	t
98b2ec68-490d-4a88-b1bd-05b5707e88da	2ae9433c-7e7a-408c-9a6d-7c1f5d28b126	t
545899ec-2a73-4c95-b368-425da707cea1	f893822a-ff36-4193-812f-628b2d9e1737	t
\.


--
-- Data for Name: event_entity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.event_entity (id, client_id, details_json, error, ip_address, realm_id, session_id, event_time, type, user_id, details_json_long_value) FROM stdin;
\.


--
-- Data for Name: fed_user_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_attribute (id, name, user_id, realm_id, storage_provider_id, value, long_value_hash, long_value_hash_lower_case, long_value) FROM stdin;
\.


--
-- Data for Name: fed_user_consent; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_consent (id, client_id, user_id, realm_id, storage_provider_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: fed_user_consent_cl_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_consent_cl_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: fed_user_credential; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_credential (id, salt, type, created_date, user_id, realm_id, storage_provider_id, user_label, secret_data, credential_data, priority) FROM stdin;
\.


--
-- Data for Name: fed_user_group_membership; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_group_membership (group_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_required_action; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_required_action (required_action, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_role_mapping (role_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: federated_identity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.federated_identity (identity_provider, realm_id, federated_user_id, federated_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: federated_user; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.federated_user (id, storage_provider_id, realm_id) FROM stdin;
\.


--
-- Data for Name: group_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.group_attribute (id, name, value, group_id) FROM stdin;
\.


--
-- Data for Name: group_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.group_role_mapping (role_id, group_id) FROM stdin;
\.


--
-- Data for Name: identity_provider; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.identity_provider (internal_id, enabled, provider_alias, provider_id, store_token, authenticate_by_default, realm_id, add_token_role, trust_email, first_broker_login_flow_id, post_broker_login_flow_id, provider_display_name, link_only, organization_id, hide_on_login) FROM stdin;
\.


--
-- Data for Name: identity_provider_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.identity_provider_config (identity_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: identity_provider_mapper; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.identity_provider_mapper (id, name, idp_alias, idp_mapper_name, realm_id) FROM stdin;
\.


--
-- Data for Name: idp_mapper_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.idp_mapper_config (idp_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: jgroups_ping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.jgroups_ping (address, name, cluster_name, ip, coord) FROM stdin;
\.


--
-- Data for Name: keycloak_group; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.keycloak_group (id, name, parent_group, realm_id, type) FROM stdin;
\.


--
-- Data for Name: keycloak_role; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.keycloak_role (id, client_realm_constraint, client_role, description, name, realm_id, client, realm) FROM stdin;
76ab0737-f4fe-42af-aec1-3b71892f8ccc	98b2ec68-490d-4a88-b1bd-05b5707e88da	f	${role_default-roles}	default-roles-master	98b2ec68-490d-4a88-b1bd-05b5707e88da	\N	\N
7ca25e09-89e0-4c12-8850-2138924f1159	98b2ec68-490d-4a88-b1bd-05b5707e88da	f	${role_admin}	admin	98b2ec68-490d-4a88-b1bd-05b5707e88da	\N	\N
878bddf9-8d97-4e97-8302-2ec3ef66dac3	98b2ec68-490d-4a88-b1bd-05b5707e88da	f	${role_create-realm}	create-realm	98b2ec68-490d-4a88-b1bd-05b5707e88da	\N	\N
0aeb47e7-d5ff-42e2-81eb-0c1aeffbe877	fe642ed6-7328-4dc5-82c1-a7c74140cef4	t	${role_create-client}	create-client	98b2ec68-490d-4a88-b1bd-05b5707e88da	fe642ed6-7328-4dc5-82c1-a7c74140cef4	\N
ae3484f8-6e2e-409f-917f-42ba8c71fc10	fe642ed6-7328-4dc5-82c1-a7c74140cef4	t	${role_view-realm}	view-realm	98b2ec68-490d-4a88-b1bd-05b5707e88da	fe642ed6-7328-4dc5-82c1-a7c74140cef4	\N
180c115a-e750-4bd8-9030-a6111522e32a	fe642ed6-7328-4dc5-82c1-a7c74140cef4	t	${role_view-users}	view-users	98b2ec68-490d-4a88-b1bd-05b5707e88da	fe642ed6-7328-4dc5-82c1-a7c74140cef4	\N
1ba729b1-bebd-4eae-8dd1-77bbc97ed207	fe642ed6-7328-4dc5-82c1-a7c74140cef4	t	${role_view-clients}	view-clients	98b2ec68-490d-4a88-b1bd-05b5707e88da	fe642ed6-7328-4dc5-82c1-a7c74140cef4	\N
18501d54-ecc0-4fc5-ac6c-c656d16352e5	fe642ed6-7328-4dc5-82c1-a7c74140cef4	t	${role_view-events}	view-events	98b2ec68-490d-4a88-b1bd-05b5707e88da	fe642ed6-7328-4dc5-82c1-a7c74140cef4	\N
f402175d-8834-4bd9-8297-ff63a15e4b56	fe642ed6-7328-4dc5-82c1-a7c74140cef4	t	${role_view-identity-providers}	view-identity-providers	98b2ec68-490d-4a88-b1bd-05b5707e88da	fe642ed6-7328-4dc5-82c1-a7c74140cef4	\N
bf6ea91c-b9d9-4f86-909a-ed92a30b6a42	fe642ed6-7328-4dc5-82c1-a7c74140cef4	t	${role_view-authorization}	view-authorization	98b2ec68-490d-4a88-b1bd-05b5707e88da	fe642ed6-7328-4dc5-82c1-a7c74140cef4	\N
14f8a1da-841e-4b9b-b725-4b59d6ae935b	fe642ed6-7328-4dc5-82c1-a7c74140cef4	t	${role_manage-realm}	manage-realm	98b2ec68-490d-4a88-b1bd-05b5707e88da	fe642ed6-7328-4dc5-82c1-a7c74140cef4	\N
84cac2c5-214c-4bda-a6b3-7e4b9297fa49	fe642ed6-7328-4dc5-82c1-a7c74140cef4	t	${role_manage-users}	manage-users	98b2ec68-490d-4a88-b1bd-05b5707e88da	fe642ed6-7328-4dc5-82c1-a7c74140cef4	\N
38091b78-823c-4fc8-971c-27adcc2cc9b3	fe642ed6-7328-4dc5-82c1-a7c74140cef4	t	${role_manage-clients}	manage-clients	98b2ec68-490d-4a88-b1bd-05b5707e88da	fe642ed6-7328-4dc5-82c1-a7c74140cef4	\N
46ad9b37-8dbb-4465-acdc-ee0c1e553b3c	fe642ed6-7328-4dc5-82c1-a7c74140cef4	t	${role_manage-events}	manage-events	98b2ec68-490d-4a88-b1bd-05b5707e88da	fe642ed6-7328-4dc5-82c1-a7c74140cef4	\N
97c53fe4-442d-494d-b33c-da560c0e3834	fe642ed6-7328-4dc5-82c1-a7c74140cef4	t	${role_manage-identity-providers}	manage-identity-providers	98b2ec68-490d-4a88-b1bd-05b5707e88da	fe642ed6-7328-4dc5-82c1-a7c74140cef4	\N
03f09909-e513-43c4-a17c-69024e6c4c91	fe642ed6-7328-4dc5-82c1-a7c74140cef4	t	${role_manage-authorization}	manage-authorization	98b2ec68-490d-4a88-b1bd-05b5707e88da	fe642ed6-7328-4dc5-82c1-a7c74140cef4	\N
0ac766ed-6121-4220-a3e9-110831df48a1	fe642ed6-7328-4dc5-82c1-a7c74140cef4	t	${role_query-users}	query-users	98b2ec68-490d-4a88-b1bd-05b5707e88da	fe642ed6-7328-4dc5-82c1-a7c74140cef4	\N
ecb658fe-70d4-4a99-98ab-6753effa4feb	fe642ed6-7328-4dc5-82c1-a7c74140cef4	t	${role_query-clients}	query-clients	98b2ec68-490d-4a88-b1bd-05b5707e88da	fe642ed6-7328-4dc5-82c1-a7c74140cef4	\N
731fad47-4cb9-4d76-b9c0-c42e0428fe93	fe642ed6-7328-4dc5-82c1-a7c74140cef4	t	${role_query-realms}	query-realms	98b2ec68-490d-4a88-b1bd-05b5707e88da	fe642ed6-7328-4dc5-82c1-a7c74140cef4	\N
57ffe883-7c31-4017-885e-55fe3df4c310	fe642ed6-7328-4dc5-82c1-a7c74140cef4	t	${role_query-groups}	query-groups	98b2ec68-490d-4a88-b1bd-05b5707e88da	fe642ed6-7328-4dc5-82c1-a7c74140cef4	\N
c59f2546-8d3f-4c38-becb-061371e4db2d	55bd8a5b-3f67-4667-9e35-9010417f108a	t	${role_view-profile}	view-profile	98b2ec68-490d-4a88-b1bd-05b5707e88da	55bd8a5b-3f67-4667-9e35-9010417f108a	\N
4726bd4a-01c2-46de-8632-82627aa46ea2	55bd8a5b-3f67-4667-9e35-9010417f108a	t	${role_manage-account}	manage-account	98b2ec68-490d-4a88-b1bd-05b5707e88da	55bd8a5b-3f67-4667-9e35-9010417f108a	\N
afbe5e5f-2fc1-4759-aaff-0fe7239f573b	55bd8a5b-3f67-4667-9e35-9010417f108a	t	${role_manage-account-links}	manage-account-links	98b2ec68-490d-4a88-b1bd-05b5707e88da	55bd8a5b-3f67-4667-9e35-9010417f108a	\N
c699666f-0da7-40d1-9f78-9b73eb4c0398	55bd8a5b-3f67-4667-9e35-9010417f108a	t	${role_view-applications}	view-applications	98b2ec68-490d-4a88-b1bd-05b5707e88da	55bd8a5b-3f67-4667-9e35-9010417f108a	\N
ae6e7738-fd45-496e-bf62-a0ba21d1210f	55bd8a5b-3f67-4667-9e35-9010417f108a	t	${role_view-consent}	view-consent	98b2ec68-490d-4a88-b1bd-05b5707e88da	55bd8a5b-3f67-4667-9e35-9010417f108a	\N
59daf1d2-e8ac-4395-b5c6-f682dcbca252	55bd8a5b-3f67-4667-9e35-9010417f108a	t	${role_manage-consent}	manage-consent	98b2ec68-490d-4a88-b1bd-05b5707e88da	55bd8a5b-3f67-4667-9e35-9010417f108a	\N
25c8ea4b-02a3-4bbb-a679-2e860e94c435	55bd8a5b-3f67-4667-9e35-9010417f108a	t	${role_view-groups}	view-groups	98b2ec68-490d-4a88-b1bd-05b5707e88da	55bd8a5b-3f67-4667-9e35-9010417f108a	\N
c2b8f278-0dd2-49b2-8301-9b88adbde43b	55bd8a5b-3f67-4667-9e35-9010417f108a	t	${role_delete-account}	delete-account	98b2ec68-490d-4a88-b1bd-05b5707e88da	55bd8a5b-3f67-4667-9e35-9010417f108a	\N
58c8a24e-b817-4275-b133-f8a2b733bd55	51a1b14f-346a-4213-a434-792f9f437336	t	${role_read-token}	read-token	98b2ec68-490d-4a88-b1bd-05b5707e88da	51a1b14f-346a-4213-a434-792f9f437336	\N
fd6d9dae-08e8-433e-a8b4-f7f3ad5ca944	fe642ed6-7328-4dc5-82c1-a7c74140cef4	t	${role_impersonation}	impersonation	98b2ec68-490d-4a88-b1bd-05b5707e88da	fe642ed6-7328-4dc5-82c1-a7c74140cef4	\N
283324a3-aa37-4488-823b-86f70f5f8535	98b2ec68-490d-4a88-b1bd-05b5707e88da	f	${role_offline-access}	offline_access	98b2ec68-490d-4a88-b1bd-05b5707e88da	\N	\N
53331b34-d3fb-4217-ba3b-a9e55f004324	98b2ec68-490d-4a88-b1bd-05b5707e88da	f	${role_uma_authorization}	uma_authorization	98b2ec68-490d-4a88-b1bd-05b5707e88da	\N	\N
ef4e1149-2675-45d2-82e4-b539d823ceb2	545899ec-2a73-4c95-b368-425da707cea1	f	${role_default-roles}	default-roles-purchase-app-realm	545899ec-2a73-4c95-b368-425da707cea1	\N	\N
e7c10524-6b80-4870-931f-707a10b330f5	9969ca14-fb6b-4b25-9ee4-8fca05889e15	t	${role_create-client}	create-client	98b2ec68-490d-4a88-b1bd-05b5707e88da	9969ca14-fb6b-4b25-9ee4-8fca05889e15	\N
ed05b454-19df-4baa-8a02-8e209a6d0987	9969ca14-fb6b-4b25-9ee4-8fca05889e15	t	${role_view-realm}	view-realm	98b2ec68-490d-4a88-b1bd-05b5707e88da	9969ca14-fb6b-4b25-9ee4-8fca05889e15	\N
9f05ea53-4629-4db1-9ed6-89fe784170b5	9969ca14-fb6b-4b25-9ee4-8fca05889e15	t	${role_view-users}	view-users	98b2ec68-490d-4a88-b1bd-05b5707e88da	9969ca14-fb6b-4b25-9ee4-8fca05889e15	\N
22582409-311c-48ab-b854-304d221c304d	9969ca14-fb6b-4b25-9ee4-8fca05889e15	t	${role_view-clients}	view-clients	98b2ec68-490d-4a88-b1bd-05b5707e88da	9969ca14-fb6b-4b25-9ee4-8fca05889e15	\N
a105a5f8-9a9d-489f-9f7a-6487feff7f11	9969ca14-fb6b-4b25-9ee4-8fca05889e15	t	${role_view-events}	view-events	98b2ec68-490d-4a88-b1bd-05b5707e88da	9969ca14-fb6b-4b25-9ee4-8fca05889e15	\N
2ca8f3a5-9ed2-4748-9217-195beeaa0c58	9969ca14-fb6b-4b25-9ee4-8fca05889e15	t	${role_view-identity-providers}	view-identity-providers	98b2ec68-490d-4a88-b1bd-05b5707e88da	9969ca14-fb6b-4b25-9ee4-8fca05889e15	\N
8e563722-fba0-47c8-894d-fe83fecb2489	9969ca14-fb6b-4b25-9ee4-8fca05889e15	t	${role_view-authorization}	view-authorization	98b2ec68-490d-4a88-b1bd-05b5707e88da	9969ca14-fb6b-4b25-9ee4-8fca05889e15	\N
b70c3df3-ef51-461f-b94c-ca147aed8e34	9969ca14-fb6b-4b25-9ee4-8fca05889e15	t	${role_manage-realm}	manage-realm	98b2ec68-490d-4a88-b1bd-05b5707e88da	9969ca14-fb6b-4b25-9ee4-8fca05889e15	\N
0a6d272e-4e7e-46c7-a6c9-01338a5421b7	9969ca14-fb6b-4b25-9ee4-8fca05889e15	t	${role_manage-users}	manage-users	98b2ec68-490d-4a88-b1bd-05b5707e88da	9969ca14-fb6b-4b25-9ee4-8fca05889e15	\N
df467638-22c0-4cb9-85a7-5b0764411e2c	9969ca14-fb6b-4b25-9ee4-8fca05889e15	t	${role_manage-clients}	manage-clients	98b2ec68-490d-4a88-b1bd-05b5707e88da	9969ca14-fb6b-4b25-9ee4-8fca05889e15	\N
fe938b22-12a1-4bed-a192-b1d3596df6b7	9969ca14-fb6b-4b25-9ee4-8fca05889e15	t	${role_manage-events}	manage-events	98b2ec68-490d-4a88-b1bd-05b5707e88da	9969ca14-fb6b-4b25-9ee4-8fca05889e15	\N
de0fbdbb-e992-4db9-987f-1b45c3827c1c	9969ca14-fb6b-4b25-9ee4-8fca05889e15	t	${role_manage-identity-providers}	manage-identity-providers	98b2ec68-490d-4a88-b1bd-05b5707e88da	9969ca14-fb6b-4b25-9ee4-8fca05889e15	\N
ef73a8fa-1246-4ddb-b186-acaf8946e643	9969ca14-fb6b-4b25-9ee4-8fca05889e15	t	${role_manage-authorization}	manage-authorization	98b2ec68-490d-4a88-b1bd-05b5707e88da	9969ca14-fb6b-4b25-9ee4-8fca05889e15	\N
e5c8b81f-27b3-442a-9b5a-3a6d326c04df	9969ca14-fb6b-4b25-9ee4-8fca05889e15	t	${role_query-users}	query-users	98b2ec68-490d-4a88-b1bd-05b5707e88da	9969ca14-fb6b-4b25-9ee4-8fca05889e15	\N
0ac7e126-33cb-403a-92a3-4a5dfc623d3b	9969ca14-fb6b-4b25-9ee4-8fca05889e15	t	${role_query-clients}	query-clients	98b2ec68-490d-4a88-b1bd-05b5707e88da	9969ca14-fb6b-4b25-9ee4-8fca05889e15	\N
3c60ded0-299d-4f6a-b978-66046ad0cea8	9969ca14-fb6b-4b25-9ee4-8fca05889e15	t	${role_query-realms}	query-realms	98b2ec68-490d-4a88-b1bd-05b5707e88da	9969ca14-fb6b-4b25-9ee4-8fca05889e15	\N
a313efc0-5b47-4961-8dce-d9650d4d93c9	9969ca14-fb6b-4b25-9ee4-8fca05889e15	t	${role_query-groups}	query-groups	98b2ec68-490d-4a88-b1bd-05b5707e88da	9969ca14-fb6b-4b25-9ee4-8fca05889e15	\N
eeb2191a-c5d1-4016-a587-9e0762726302	93e6a496-3882-4eb1-b9de-54706ffadf03	t	${role_realm-admin}	realm-admin	545899ec-2a73-4c95-b368-425da707cea1	93e6a496-3882-4eb1-b9de-54706ffadf03	\N
3a5bb10f-33ad-43ce-91b6-768ad4d6ce0b	93e6a496-3882-4eb1-b9de-54706ffadf03	t	${role_create-client}	create-client	545899ec-2a73-4c95-b368-425da707cea1	93e6a496-3882-4eb1-b9de-54706ffadf03	\N
90dc2f93-e3e6-4987-b50d-62cc35afd81e	93e6a496-3882-4eb1-b9de-54706ffadf03	t	${role_view-realm}	view-realm	545899ec-2a73-4c95-b368-425da707cea1	93e6a496-3882-4eb1-b9de-54706ffadf03	\N
33a350a3-4d8f-4823-8152-d53b9a32ed7f	93e6a496-3882-4eb1-b9de-54706ffadf03	t	${role_view-users}	view-users	545899ec-2a73-4c95-b368-425da707cea1	93e6a496-3882-4eb1-b9de-54706ffadf03	\N
e61125d9-594e-49d7-b4ec-f2b7ddd0f1a5	93e6a496-3882-4eb1-b9de-54706ffadf03	t	${role_view-clients}	view-clients	545899ec-2a73-4c95-b368-425da707cea1	93e6a496-3882-4eb1-b9de-54706ffadf03	\N
7161923a-ffe1-4d32-9311-da8fc4219d00	93e6a496-3882-4eb1-b9de-54706ffadf03	t	${role_view-events}	view-events	545899ec-2a73-4c95-b368-425da707cea1	93e6a496-3882-4eb1-b9de-54706ffadf03	\N
3f67ac2f-e012-47c8-abb3-33763d0c3520	93e6a496-3882-4eb1-b9de-54706ffadf03	t	${role_view-identity-providers}	view-identity-providers	545899ec-2a73-4c95-b368-425da707cea1	93e6a496-3882-4eb1-b9de-54706ffadf03	\N
add5b4cd-77b4-476e-8d1c-41df27e611c1	93e6a496-3882-4eb1-b9de-54706ffadf03	t	${role_view-authorization}	view-authorization	545899ec-2a73-4c95-b368-425da707cea1	93e6a496-3882-4eb1-b9de-54706ffadf03	\N
1ffa6825-7714-4f6e-8511-05d12758d3a5	93e6a496-3882-4eb1-b9de-54706ffadf03	t	${role_manage-realm}	manage-realm	545899ec-2a73-4c95-b368-425da707cea1	93e6a496-3882-4eb1-b9de-54706ffadf03	\N
284638e1-e9e5-400f-9186-9246e55acbb3	93e6a496-3882-4eb1-b9de-54706ffadf03	t	${role_manage-users}	manage-users	545899ec-2a73-4c95-b368-425da707cea1	93e6a496-3882-4eb1-b9de-54706ffadf03	\N
dacf0eb7-d35e-401f-a55b-9eb15d88ab05	93e6a496-3882-4eb1-b9de-54706ffadf03	t	${role_manage-clients}	manage-clients	545899ec-2a73-4c95-b368-425da707cea1	93e6a496-3882-4eb1-b9de-54706ffadf03	\N
304b50b7-5c67-402c-ad6c-43d90dfacc3a	93e6a496-3882-4eb1-b9de-54706ffadf03	t	${role_manage-events}	manage-events	545899ec-2a73-4c95-b368-425da707cea1	93e6a496-3882-4eb1-b9de-54706ffadf03	\N
7cb760ff-e50d-4d59-87c2-66102f26cf1f	93e6a496-3882-4eb1-b9de-54706ffadf03	t	${role_manage-identity-providers}	manage-identity-providers	545899ec-2a73-4c95-b368-425da707cea1	93e6a496-3882-4eb1-b9de-54706ffadf03	\N
c6a86be4-b5e1-4cab-942d-4e0eaa688744	93e6a496-3882-4eb1-b9de-54706ffadf03	t	${role_manage-authorization}	manage-authorization	545899ec-2a73-4c95-b368-425da707cea1	93e6a496-3882-4eb1-b9de-54706ffadf03	\N
d8c73c9d-4dcc-4783-be94-5ef06b6c99ff	93e6a496-3882-4eb1-b9de-54706ffadf03	t	${role_query-users}	query-users	545899ec-2a73-4c95-b368-425da707cea1	93e6a496-3882-4eb1-b9de-54706ffadf03	\N
7b84fd5f-1913-4404-ae0b-1f6cf55b4c3e	93e6a496-3882-4eb1-b9de-54706ffadf03	t	${role_query-clients}	query-clients	545899ec-2a73-4c95-b368-425da707cea1	93e6a496-3882-4eb1-b9de-54706ffadf03	\N
c985a6c5-7eb1-40cd-b871-5a8085c34471	93e6a496-3882-4eb1-b9de-54706ffadf03	t	${role_query-realms}	query-realms	545899ec-2a73-4c95-b368-425da707cea1	93e6a496-3882-4eb1-b9de-54706ffadf03	\N
18e6fd44-db60-46b1-9731-694a9aaca8eb	93e6a496-3882-4eb1-b9de-54706ffadf03	t	${role_query-groups}	query-groups	545899ec-2a73-4c95-b368-425da707cea1	93e6a496-3882-4eb1-b9de-54706ffadf03	\N
bf410f8e-dc5a-40bd-96aa-afa1b5584b2d	8ed73690-8dd1-4434-b5ca-2665456bae8e	t	${role_view-profile}	view-profile	545899ec-2a73-4c95-b368-425da707cea1	8ed73690-8dd1-4434-b5ca-2665456bae8e	\N
c476aec6-d6c4-40ca-b747-6c7b2139db46	8ed73690-8dd1-4434-b5ca-2665456bae8e	t	${role_manage-account}	manage-account	545899ec-2a73-4c95-b368-425da707cea1	8ed73690-8dd1-4434-b5ca-2665456bae8e	\N
e5a29f7a-420a-4a57-8705-a2268c714ed0	8ed73690-8dd1-4434-b5ca-2665456bae8e	t	${role_manage-account-links}	manage-account-links	545899ec-2a73-4c95-b368-425da707cea1	8ed73690-8dd1-4434-b5ca-2665456bae8e	\N
bcc2be06-f6b1-4983-b302-65f83020ce58	8ed73690-8dd1-4434-b5ca-2665456bae8e	t	${role_view-applications}	view-applications	545899ec-2a73-4c95-b368-425da707cea1	8ed73690-8dd1-4434-b5ca-2665456bae8e	\N
a6d488c3-bd55-4d28-9949-6dd460217199	8ed73690-8dd1-4434-b5ca-2665456bae8e	t	${role_view-consent}	view-consent	545899ec-2a73-4c95-b368-425da707cea1	8ed73690-8dd1-4434-b5ca-2665456bae8e	\N
766d0268-bf2e-4e32-a794-5a8a3b4de4fe	8ed73690-8dd1-4434-b5ca-2665456bae8e	t	${role_manage-consent}	manage-consent	545899ec-2a73-4c95-b368-425da707cea1	8ed73690-8dd1-4434-b5ca-2665456bae8e	\N
f8801922-ee75-4c9f-baae-20c89a30b61c	8ed73690-8dd1-4434-b5ca-2665456bae8e	t	${role_view-groups}	view-groups	545899ec-2a73-4c95-b368-425da707cea1	8ed73690-8dd1-4434-b5ca-2665456bae8e	\N
766b24bc-0ab0-4ddb-9350-80c7117dbf28	8ed73690-8dd1-4434-b5ca-2665456bae8e	t	${role_delete-account}	delete-account	545899ec-2a73-4c95-b368-425da707cea1	8ed73690-8dd1-4434-b5ca-2665456bae8e	\N
9b2defaa-9d38-43e2-b3ee-bf2dd6388057	9969ca14-fb6b-4b25-9ee4-8fca05889e15	t	${role_impersonation}	impersonation	98b2ec68-490d-4a88-b1bd-05b5707e88da	9969ca14-fb6b-4b25-9ee4-8fca05889e15	\N
4bf1f616-1f7a-4c62-965f-5b0f5d053844	93e6a496-3882-4eb1-b9de-54706ffadf03	t	${role_impersonation}	impersonation	545899ec-2a73-4c95-b368-425da707cea1	93e6a496-3882-4eb1-b9de-54706ffadf03	\N
9df160fd-6718-465f-a532-f92f616bd76a	7e6b42db-252d-4396-ac22-11917ef97257	t	${role_read-token}	read-token	545899ec-2a73-4c95-b368-425da707cea1	7e6b42db-252d-4396-ac22-11917ef97257	\N
b775294b-f8db-46a8-a945-bd9bc2214b98	545899ec-2a73-4c95-b368-425da707cea1	f	${role_offline-access}	offline_access	545899ec-2a73-4c95-b368-425da707cea1	\N	\N
f789f503-48d0-4c88-9680-04675e3a9dc4	545899ec-2a73-4c95-b368-425da707cea1	f	${role_uma_authorization}	uma_authorization	545899ec-2a73-4c95-b368-425da707cea1	\N	\N
f2199a9f-8855-4919-b7aa-127630b81455	db7fb3a7-14a1-4b7e-9379-8905016349db	t		User	545899ec-2a73-4c95-b368-425da707cea1	db7fb3a7-14a1-4b7e-9379-8905016349db	\N
80cde56c-c0e8-4052-a579-54f814df866b	db7fb3a7-14a1-4b7e-9379-8905016349db	t		Admin	545899ec-2a73-4c95-b368-425da707cea1	db7fb3a7-14a1-4b7e-9379-8905016349db	\N
\.


--
-- Data for Name: migration_model; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.migration_model (id, version, update_time) FROM stdin;
t8090	24.0.5	1749042181
bw70e	26.2.5	1749043017
\.


--
-- Data for Name: offline_client_session; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.offline_client_session (user_session_id, client_id, offline_flag, "timestamp", data, client_storage_provider, external_client_id, version) FROM stdin;
ea984803-fdf8-4b0a-9855-dc9ca60ab344	db7fb3a7-14a1-4b7e-9379-8905016349db	1	1750927668	{"authMethod":"openid-connect","redirectUri":"http://localhost:4200/","notes":{"clientId":"db7fb3a7-14a1-4b7e-9379-8905016349db","iss":"http://localhost:8180/realms/purchase-service-realm","startedAt":"1750916563","response_type":"code","level-of-authentication":"-1","code_challenge_method":"S256","nonce":"d7797d5c-f860-48f4-984e-9aef25035378","response_mode":"fragment","scope":"openid profile email offline_access","userSessionStartedAt":"1750916563","redirect_uri":"http://localhost:4200/","state":"91ec0b6e-52f6-4d77-84de-0d642512bca2","code_challenge":"Hy29Uq6bguC1zOyugUGscKtkT5guTGi04slaU1Mk_74"}}	local	local	37
831bcae2-1887-4613-b5fe-294580543438	db7fb3a7-14a1-4b7e-9379-8905016349db	1	1752110903	{"authMethod":"openid-connect","redirectUri":"http://localhost:4200/","notes":{"clientId":"db7fb3a7-14a1-4b7e-9379-8905016349db","iss":"http://localhost:8180/realms/purchase-service-realm","startedAt":"1752110902","response_type":"code","level-of-authentication":"-1","code_challenge_method":"S256","nonce":"d581e5ad-05be-4648-bbc9-defe6910076f","response_mode":"fragment","scope":"openid profile email offline_access","userSessionStartedAt":"1752110902","redirect_uri":"http://localhost:4200/","state":"737dc732-685f-4318-b8ae-3b028bcde411","code_challenge":"L-lUur13ardxTSyOJj4XW7FeqUZUWeyu1nKa9wtEUKU"}}	local	local	0
9824838b-270a-434d-acf0-d55d0bb48eab	db7fb3a7-14a1-4b7e-9379-8905016349db	1	1752112575	{"authMethod":"openid-connect","redirectUri":"http://localhost:4200/","notes":{"clientId":"db7fb3a7-14a1-4b7e-9379-8905016349db","iss":"http://localhost:8180/realms/purchase-service-realm","startedAt":"1752111073","response_type":"code","level-of-authentication":"-1","code_challenge_method":"S256","nonce":"53b7ee82-6aea-4c84-aabd-5161db364c3b","response_mode":"fragment","scope":"openid profile email offline_access","userSessionStartedAt":"1752111073","redirect_uri":"http://localhost:4200/","state":"0135bd2d-a6f7-4da5-ac07-746428ef95b7","code_challenge":"Kxok2QF922_0QHB_UyvSmlo8WS4zfabiFfTQCl7Kj7s"}}	local	local	5
\.


--
-- Data for Name: offline_user_session; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.offline_user_session (user_session_id, user_id, realm_id, created_on, offline_flag, data, last_session_refresh, broker_session_id, version) FROM stdin;
ea984803-fdf8-4b0a-9855-dc9ca60ab344	9b84fcdf-6f83-4402-b631-6a97b0de6f86	545899ec-2a73-4c95-b368-425da707cea1	1750916564	1	{"ipAddress":"172.18.0.1","authMethod":"openid-connect","rememberMe":false,"started":0,"notes":{"KC_DEVICE_NOTE":"eyJpcEFkZHJlc3MiOiIxNzIuMTguMC4xIiwib3MiOiJXaW5kb3dzIiwib3NWZXJzaW9uIjoiMTAiLCJicm93c2VyIjoiRmlyZWZveC8xMzkuMCIsImRldmljZSI6Ik90aGVyIiwibGFzdEFjY2VzcyI6MCwibW9iaWxlIjpmYWxzZX0=","AUTH_TIME":"1750916563","authenticators-completed":"{\\"daf02634-591b-40c0-aead-85cf2f753dab\\":1750916563}"},"state":"LOGGED_IN"}	1750927668	\N	37
831bcae2-1887-4613-b5fe-294580543438	9b84fcdf-6f83-4402-b631-6a97b0de6f86	545899ec-2a73-4c95-b368-425da707cea1	1752110903	1	{"ipAddress":"172.18.0.1","authMethod":"openid-connect","rememberMe":false,"started":0,"notes":{"KC_DEVICE_NOTE":"eyJpcEFkZHJlc3MiOiIxNzIuMTguMC4xIiwib3MiOiJMaW51eCIsIm9zVmVyc2lvbiI6IlVua25vd24iLCJicm93c2VyIjoiRmlyZWZveC8xNDAuMCIsImRldmljZSI6Ik90aGVyIiwibGFzdEFjY2VzcyI6MCwibW9iaWxlIjpmYWxzZX0=","AUTH_TIME":"1752110902","authenticators-completed":"{\\"daf02634-591b-40c0-aead-85cf2f753dab\\":1752110902}"},"state":"LOGGED_IN"}	1752110903	\N	0
9824838b-270a-434d-acf0-d55d0bb48eab	9b84fcdf-6f83-4402-b631-6a97b0de6f86	545899ec-2a73-4c95-b368-425da707cea1	1752111074	1	{"ipAddress":"172.18.0.1","authMethod":"openid-connect","rememberMe":false,"started":0,"notes":{"KC_DEVICE_NOTE":"eyJpcEFkZHJlc3MiOiIxNzIuMTguMC4xIiwib3MiOiJMaW51eCIsIm9zVmVyc2lvbiI6IlVua25vd24iLCJicm93c2VyIjoiRmlyZWZveC8xNDAuMCIsImRldmljZSI6Ik90aGVyIiwibGFzdEFjY2VzcyI6MCwibW9iaWxlIjpmYWxzZX0=","AUTH_TIME":"1752111073","authenticators-completed":"{\\"daf02634-591b-40c0-aead-85cf2f753dab\\":1752111073}"},"state":"LOGGED_IN"}	1752112575	\N	5
\.


--
-- Data for Name: org; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.org (id, enabled, realm_id, group_id, name, description, alias, redirect_url) FROM stdin;
\.


--
-- Data for Name: org_domain; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.org_domain (id, name, verified, org_id) FROM stdin;
\.


--
-- Data for Name: policy_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.policy_config (policy_id, name, value) FROM stdin;
\.


--
-- Data for Name: protocol_mapper; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.protocol_mapper (id, name, protocol, protocol_mapper_name, client_id, client_scope_id) FROM stdin;
e37bd4be-83a1-4e7a-85e7-8b80ecb8b456	audience resolve	openid-connect	oidc-audience-resolve-mapper	d2c379b9-8493-47e1-82d8-9f5b2791c11a	\N
ab80bdd3-9fb6-4dbb-b610-5eda4e627674	locale	openid-connect	oidc-usermodel-attribute-mapper	b47e2542-cc0b-453d-993f-e73422e7a44e	\N
8b32f90e-086a-4042-be4c-88feba5a5d2d	role list	saml	saml-role-list-mapper	\N	8e7645f4-2451-45ad-9b23-2f134644b247
a16802fd-29a9-43ad-8642-346a42f305a7	full name	openid-connect	oidc-full-name-mapper	\N	07c92273-56d0-4146-9527-06062df4ecd9
c2ec685a-3544-4458-9186-c3f7e5770879	family name	openid-connect	oidc-usermodel-attribute-mapper	\N	07c92273-56d0-4146-9527-06062df4ecd9
179b4108-6d5a-44b3-a4ed-8acf0dcba903	given name	openid-connect	oidc-usermodel-attribute-mapper	\N	07c92273-56d0-4146-9527-06062df4ecd9
952eef82-ca61-4092-b28e-6dbe6693d758	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	07c92273-56d0-4146-9527-06062df4ecd9
5aa6d094-c2b4-41ce-b4a5-e0165bd6e0bd	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	07c92273-56d0-4146-9527-06062df4ecd9
5d2c8298-d9d5-4982-a1cc-7a3fb7b7db3e	username	openid-connect	oidc-usermodel-attribute-mapper	\N	07c92273-56d0-4146-9527-06062df4ecd9
ee34fdcf-79d5-494a-8201-f29c05aa75af	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	07c92273-56d0-4146-9527-06062df4ecd9
e065a43d-26ea-4316-ab9a-db1fdad5d775	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	07c92273-56d0-4146-9527-06062df4ecd9
3bd4b67d-a049-4335-91ba-8ad6dae122ac	website	openid-connect	oidc-usermodel-attribute-mapper	\N	07c92273-56d0-4146-9527-06062df4ecd9
f02ca50f-ac23-4b07-8782-7817bf2b89f7	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	07c92273-56d0-4146-9527-06062df4ecd9
4087e5e8-b63a-4533-9c2c-3608299c2899	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	07c92273-56d0-4146-9527-06062df4ecd9
740d057d-9ad9-4322-b088-9794197f50f7	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	07c92273-56d0-4146-9527-06062df4ecd9
03e34797-d3d6-46fb-ae7b-ec8cd2b26d6f	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	07c92273-56d0-4146-9527-06062df4ecd9
e217227e-9ab9-47c5-a6c3-885bd6d11cd3	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	07c92273-56d0-4146-9527-06062df4ecd9
e2f593ac-3d40-4fbf-9d74-f0368961ea18	email	openid-connect	oidc-usermodel-attribute-mapper	\N	b5d7f679-2dd9-4ce7-8afe-cc3c11e64c33
74541ed8-77b0-47a2-9092-cc0a04accd1a	email verified	openid-connect	oidc-usermodel-property-mapper	\N	b5d7f679-2dd9-4ce7-8afe-cc3c11e64c33
8dc9b90b-96da-4ee3-b9a4-de2bfb812147	address	openid-connect	oidc-address-mapper	\N	74e0b3a0-0717-4f2e-84b6-84b3f670f740
72c01a01-c228-40d7-82fd-a7baa3654a0f	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	692aa94c-6422-440f-9dec-db751b7f8a57
ac8db68b-2115-4ed4-9444-396c66270fd5	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	692aa94c-6422-440f-9dec-db751b7f8a57
40570d9c-fd7d-4f80-8e2d-39193a58d75b	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	d42fac06-27aa-481e-9120-aa41eb07ed8b
b806ba9c-2b83-49ce-91d0-86008d989939	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	d42fac06-27aa-481e-9120-aa41eb07ed8b
39600394-a7e3-4916-a965-d85af85a9f91	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	d42fac06-27aa-481e-9120-aa41eb07ed8b
55cd493f-77b6-4424-8a28-9ec2a5d91d04	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	1dcefe0f-2d1c-4b9c-8339-7726fda71005
91291879-fd68-4acf-bbd2-8edb56ca6ef3	upn	openid-connect	oidc-usermodel-attribute-mapper	\N	5fe5a21a-329d-4f02-bf01-bc0e865b3d86
cf9a9fdf-4ccb-497a-8c5e-3e61aa3ac126	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	5fe5a21a-329d-4f02-bf01-bc0e865b3d86
589a586f-c333-4122-8bab-6b86f9cbf77d	acr loa level	openid-connect	oidc-acr-mapper	\N	f82ae212-bd5e-4214-b06f-300ff86113d4
52506b5a-b431-48b7-b979-b91eb0d0dbee	audience resolve	openid-connect	oidc-audience-resolve-mapper	191b61d7-ca16-4c99-b7f7-828b3391d614	\N
77cb2767-6465-482f-b7c1-ba0ccd4a3f6f	role list	saml	saml-role-list-mapper	\N	8584251b-aac3-4cbb-88b5-c8f296ba05a1
1dd49865-2943-47a0-9b40-b04e54001f45	full name	openid-connect	oidc-full-name-mapper	\N	fa8768c8-e248-4760-934c-539eaa982a8d
b6729b43-097a-4783-9bfb-6e37b0628d23	family name	openid-connect	oidc-usermodel-attribute-mapper	\N	fa8768c8-e248-4760-934c-539eaa982a8d
8e81576f-63f0-4c29-8314-90559b8e0fc0	given name	openid-connect	oidc-usermodel-attribute-mapper	\N	fa8768c8-e248-4760-934c-539eaa982a8d
f9ac6aa7-1d6f-4b35-9315-42cafa2b3649	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	fa8768c8-e248-4760-934c-539eaa982a8d
f0af52a7-36b2-4dd2-a25d-98acbc625f18	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	fa8768c8-e248-4760-934c-539eaa982a8d
ff661a02-4d58-44b8-a4cc-0984009610df	username	openid-connect	oidc-usermodel-attribute-mapper	\N	fa8768c8-e248-4760-934c-539eaa982a8d
d4074f23-3e39-47eb-9f0a-204520771aff	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	fa8768c8-e248-4760-934c-539eaa982a8d
c4be2b7b-9d0e-438a-be6e-f19e84e1f883	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	fa8768c8-e248-4760-934c-539eaa982a8d
367081d6-855e-423c-8437-83320d313711	website	openid-connect	oidc-usermodel-attribute-mapper	\N	fa8768c8-e248-4760-934c-539eaa982a8d
38ed3ab6-3ef9-4cc5-8e5d-71ff554187ec	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	fa8768c8-e248-4760-934c-539eaa982a8d
f3e572a2-f6f7-45ce-84f1-8c598333e251	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	fa8768c8-e248-4760-934c-539eaa982a8d
8fe4bcde-8490-477d-a93b-f8d1fff67498	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	fa8768c8-e248-4760-934c-539eaa982a8d
446e2beb-9913-4f84-9c3a-b2c6a4ff76b9	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	fa8768c8-e248-4760-934c-539eaa982a8d
271868b3-fbb5-45b0-8f9b-1292a9ac3840	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	fa8768c8-e248-4760-934c-539eaa982a8d
2f5c4950-cd72-40ea-9137-62c24fcf1ad7	email	openid-connect	oidc-usermodel-attribute-mapper	\N	c7cdc97f-181a-4536-960a-e895810f0f23
8fccef21-2fe9-4708-b8c9-7a5d096399cb	email verified	openid-connect	oidc-usermodel-property-mapper	\N	c7cdc97f-181a-4536-960a-e895810f0f23
03f4c214-1336-4363-9e99-a35a10792f13	address	openid-connect	oidc-address-mapper	\N	9dec93f8-97b6-433c-8335-7cec3f030f56
b1ae1d96-bfc4-4deb-b6bc-c9d4f27b8be2	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	627847cc-3caf-4b2f-976f-03da61fa4cdc
0860ff8d-d877-47c9-b192-e3196146d48f	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	627847cc-3caf-4b2f-976f-03da61fa4cdc
0474d04a-8085-4a45-9e01-88f67d7b6d02	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	bd452d3d-137b-4f49-bdce-c477b2bbc742
80a92efe-578d-45a2-8bd9-4d9eb9d01e9a	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	bd452d3d-137b-4f49-bdce-c477b2bbc742
4c9b4eb2-0724-4e5f-af8f-6114f7ab5380	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	bd452d3d-137b-4f49-bdce-c477b2bbc742
97caaeb7-a1df-4245-82c3-afe2f9120924	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	825e1390-66c9-47fd-b238-80702e480d73
9550161b-f00e-4112-b7f7-67bb3d05e230	upn	openid-connect	oidc-usermodel-attribute-mapper	\N	d9a604e1-9343-404b-9357-79506e6a3324
a4cc8f4b-f2df-405b-aa3c-c59dbe4718f6	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	d9a604e1-9343-404b-9357-79506e6a3324
cb1a1803-2cfb-48eb-8380-d986b5fe9732	acr loa level	openid-connect	oidc-acr-mapper	\N	dcda8ff0-d811-443f-9d49-7e6f8922de1b
d845db60-3dee-4f9a-aefb-296bfbf85e91	locale	openid-connect	oidc-usermodel-attribute-mapper	d4c63c03-da48-4170-b5dd-03fe25bc3bc7	\N
343d2bbf-5f4d-4ab2-bd6a-a90f7368e4be	auth_time	openid-connect	oidc-usersessionmodel-note-mapper	\N	2ae9433c-7e7a-408c-9a6d-7c1f5d28b126
c07d69ee-65b6-4d69-8ccf-9ab5d24556b2	sub	openid-connect	oidc-sub-mapper	\N	2ae9433c-7e7a-408c-9a6d-7c1f5d28b126
0fa8606d-b97b-4a82-a529-96b7fc53c030	auth_time	openid-connect	oidc-usersessionmodel-note-mapper	\N	f893822a-ff36-4193-812f-628b2d9e1737
653135c3-4cc9-4efa-9539-63bc6a32dbf4	sub	openid-connect	oidc-sub-mapper	\N	f893822a-ff36-4193-812f-628b2d9e1737
2eda4093-c7e7-490f-bb67-042269c74374	Client ID	openid-connect	oidc-usersessionmodel-note-mapper	\N	f1705fc0-918a-4bff-9dbe-ca60a0204918
81cfb4d1-b273-4261-bac4-95d6f0473b7a	Client Host	openid-connect	oidc-usersessionmodel-note-mapper	\N	f1705fc0-918a-4bff-9dbe-ca60a0204918
720b901e-2a25-4f7d-add8-19b023fb8fcd	Client IP Address	openid-connect	oidc-usersessionmodel-note-mapper	\N	f1705fc0-918a-4bff-9dbe-ca60a0204918
9262f2d6-3f70-4872-9eb7-37421f7c4270	Client ID	openid-connect	oidc-usersessionmodel-note-mapper	\N	244661a6-24a7-400a-b4fd-c0d9ed73f85a
2e8772b6-9997-40ef-b6c5-c3692fa48adc	Client Host	openid-connect	oidc-usersessionmodel-note-mapper	\N	244661a6-24a7-400a-b4fd-c0d9ed73f85a
e887a496-7438-44bd-9b45-cf0102a581a2	Client IP Address	openid-connect	oidc-usersessionmodel-note-mapper	\N	244661a6-24a7-400a-b4fd-c0d9ed73f85a
\.


--
-- Data for Name: protocol_mapper_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.protocol_mapper_config (protocol_mapper_id, value, name) FROM stdin;
ab80bdd3-9fb6-4dbb-b610-5eda4e627674	true	introspection.token.claim
ab80bdd3-9fb6-4dbb-b610-5eda4e627674	true	userinfo.token.claim
ab80bdd3-9fb6-4dbb-b610-5eda4e627674	locale	user.attribute
ab80bdd3-9fb6-4dbb-b610-5eda4e627674	true	id.token.claim
ab80bdd3-9fb6-4dbb-b610-5eda4e627674	true	access.token.claim
ab80bdd3-9fb6-4dbb-b610-5eda4e627674	locale	claim.name
ab80bdd3-9fb6-4dbb-b610-5eda4e627674	String	jsonType.label
8b32f90e-086a-4042-be4c-88feba5a5d2d	false	single
8b32f90e-086a-4042-be4c-88feba5a5d2d	Basic	attribute.nameformat
8b32f90e-086a-4042-be4c-88feba5a5d2d	Role	attribute.name
03e34797-d3d6-46fb-ae7b-ec8cd2b26d6f	true	introspection.token.claim
03e34797-d3d6-46fb-ae7b-ec8cd2b26d6f	true	userinfo.token.claim
03e34797-d3d6-46fb-ae7b-ec8cd2b26d6f	locale	user.attribute
03e34797-d3d6-46fb-ae7b-ec8cd2b26d6f	true	id.token.claim
03e34797-d3d6-46fb-ae7b-ec8cd2b26d6f	true	access.token.claim
03e34797-d3d6-46fb-ae7b-ec8cd2b26d6f	locale	claim.name
03e34797-d3d6-46fb-ae7b-ec8cd2b26d6f	String	jsonType.label
179b4108-6d5a-44b3-a4ed-8acf0dcba903	true	introspection.token.claim
179b4108-6d5a-44b3-a4ed-8acf0dcba903	true	userinfo.token.claim
179b4108-6d5a-44b3-a4ed-8acf0dcba903	firstName	user.attribute
179b4108-6d5a-44b3-a4ed-8acf0dcba903	true	id.token.claim
179b4108-6d5a-44b3-a4ed-8acf0dcba903	true	access.token.claim
179b4108-6d5a-44b3-a4ed-8acf0dcba903	given_name	claim.name
179b4108-6d5a-44b3-a4ed-8acf0dcba903	String	jsonType.label
3bd4b67d-a049-4335-91ba-8ad6dae122ac	true	introspection.token.claim
3bd4b67d-a049-4335-91ba-8ad6dae122ac	true	userinfo.token.claim
3bd4b67d-a049-4335-91ba-8ad6dae122ac	website	user.attribute
3bd4b67d-a049-4335-91ba-8ad6dae122ac	true	id.token.claim
3bd4b67d-a049-4335-91ba-8ad6dae122ac	true	access.token.claim
3bd4b67d-a049-4335-91ba-8ad6dae122ac	website	claim.name
3bd4b67d-a049-4335-91ba-8ad6dae122ac	String	jsonType.label
4087e5e8-b63a-4533-9c2c-3608299c2899	true	introspection.token.claim
4087e5e8-b63a-4533-9c2c-3608299c2899	true	userinfo.token.claim
4087e5e8-b63a-4533-9c2c-3608299c2899	birthdate	user.attribute
4087e5e8-b63a-4533-9c2c-3608299c2899	true	id.token.claim
4087e5e8-b63a-4533-9c2c-3608299c2899	true	access.token.claim
4087e5e8-b63a-4533-9c2c-3608299c2899	birthdate	claim.name
4087e5e8-b63a-4533-9c2c-3608299c2899	String	jsonType.label
5aa6d094-c2b4-41ce-b4a5-e0165bd6e0bd	true	introspection.token.claim
5aa6d094-c2b4-41ce-b4a5-e0165bd6e0bd	true	userinfo.token.claim
5aa6d094-c2b4-41ce-b4a5-e0165bd6e0bd	nickname	user.attribute
5aa6d094-c2b4-41ce-b4a5-e0165bd6e0bd	true	id.token.claim
5aa6d094-c2b4-41ce-b4a5-e0165bd6e0bd	true	access.token.claim
5aa6d094-c2b4-41ce-b4a5-e0165bd6e0bd	nickname	claim.name
5aa6d094-c2b4-41ce-b4a5-e0165bd6e0bd	String	jsonType.label
5d2c8298-d9d5-4982-a1cc-7a3fb7b7db3e	true	introspection.token.claim
5d2c8298-d9d5-4982-a1cc-7a3fb7b7db3e	true	userinfo.token.claim
5d2c8298-d9d5-4982-a1cc-7a3fb7b7db3e	username	user.attribute
5d2c8298-d9d5-4982-a1cc-7a3fb7b7db3e	true	id.token.claim
5d2c8298-d9d5-4982-a1cc-7a3fb7b7db3e	true	access.token.claim
5d2c8298-d9d5-4982-a1cc-7a3fb7b7db3e	preferred_username	claim.name
5d2c8298-d9d5-4982-a1cc-7a3fb7b7db3e	String	jsonType.label
740d057d-9ad9-4322-b088-9794197f50f7	true	introspection.token.claim
740d057d-9ad9-4322-b088-9794197f50f7	true	userinfo.token.claim
740d057d-9ad9-4322-b088-9794197f50f7	zoneinfo	user.attribute
740d057d-9ad9-4322-b088-9794197f50f7	true	id.token.claim
740d057d-9ad9-4322-b088-9794197f50f7	true	access.token.claim
740d057d-9ad9-4322-b088-9794197f50f7	zoneinfo	claim.name
740d057d-9ad9-4322-b088-9794197f50f7	String	jsonType.label
952eef82-ca61-4092-b28e-6dbe6693d758	true	introspection.token.claim
952eef82-ca61-4092-b28e-6dbe6693d758	true	userinfo.token.claim
952eef82-ca61-4092-b28e-6dbe6693d758	middleName	user.attribute
952eef82-ca61-4092-b28e-6dbe6693d758	true	id.token.claim
952eef82-ca61-4092-b28e-6dbe6693d758	true	access.token.claim
952eef82-ca61-4092-b28e-6dbe6693d758	middle_name	claim.name
952eef82-ca61-4092-b28e-6dbe6693d758	String	jsonType.label
a16802fd-29a9-43ad-8642-346a42f305a7	true	introspection.token.claim
a16802fd-29a9-43ad-8642-346a42f305a7	true	userinfo.token.claim
a16802fd-29a9-43ad-8642-346a42f305a7	true	id.token.claim
a16802fd-29a9-43ad-8642-346a42f305a7	true	access.token.claim
c2ec685a-3544-4458-9186-c3f7e5770879	true	introspection.token.claim
c2ec685a-3544-4458-9186-c3f7e5770879	true	userinfo.token.claim
c2ec685a-3544-4458-9186-c3f7e5770879	lastName	user.attribute
c2ec685a-3544-4458-9186-c3f7e5770879	true	id.token.claim
c2ec685a-3544-4458-9186-c3f7e5770879	true	access.token.claim
c2ec685a-3544-4458-9186-c3f7e5770879	family_name	claim.name
c2ec685a-3544-4458-9186-c3f7e5770879	String	jsonType.label
e065a43d-26ea-4316-ab9a-db1fdad5d775	true	introspection.token.claim
e065a43d-26ea-4316-ab9a-db1fdad5d775	true	userinfo.token.claim
e065a43d-26ea-4316-ab9a-db1fdad5d775	picture	user.attribute
e065a43d-26ea-4316-ab9a-db1fdad5d775	true	id.token.claim
e065a43d-26ea-4316-ab9a-db1fdad5d775	true	access.token.claim
e065a43d-26ea-4316-ab9a-db1fdad5d775	picture	claim.name
e065a43d-26ea-4316-ab9a-db1fdad5d775	String	jsonType.label
e217227e-9ab9-47c5-a6c3-885bd6d11cd3	true	introspection.token.claim
e217227e-9ab9-47c5-a6c3-885bd6d11cd3	true	userinfo.token.claim
e217227e-9ab9-47c5-a6c3-885bd6d11cd3	updatedAt	user.attribute
e217227e-9ab9-47c5-a6c3-885bd6d11cd3	true	id.token.claim
e217227e-9ab9-47c5-a6c3-885bd6d11cd3	true	access.token.claim
e217227e-9ab9-47c5-a6c3-885bd6d11cd3	updated_at	claim.name
e217227e-9ab9-47c5-a6c3-885bd6d11cd3	long	jsonType.label
ee34fdcf-79d5-494a-8201-f29c05aa75af	true	introspection.token.claim
ee34fdcf-79d5-494a-8201-f29c05aa75af	true	userinfo.token.claim
ee34fdcf-79d5-494a-8201-f29c05aa75af	profile	user.attribute
ee34fdcf-79d5-494a-8201-f29c05aa75af	true	id.token.claim
ee34fdcf-79d5-494a-8201-f29c05aa75af	true	access.token.claim
ee34fdcf-79d5-494a-8201-f29c05aa75af	profile	claim.name
ee34fdcf-79d5-494a-8201-f29c05aa75af	String	jsonType.label
f02ca50f-ac23-4b07-8782-7817bf2b89f7	true	introspection.token.claim
f02ca50f-ac23-4b07-8782-7817bf2b89f7	true	userinfo.token.claim
f02ca50f-ac23-4b07-8782-7817bf2b89f7	gender	user.attribute
f02ca50f-ac23-4b07-8782-7817bf2b89f7	true	id.token.claim
f02ca50f-ac23-4b07-8782-7817bf2b89f7	true	access.token.claim
f02ca50f-ac23-4b07-8782-7817bf2b89f7	gender	claim.name
f02ca50f-ac23-4b07-8782-7817bf2b89f7	String	jsonType.label
74541ed8-77b0-47a2-9092-cc0a04accd1a	true	introspection.token.claim
74541ed8-77b0-47a2-9092-cc0a04accd1a	true	userinfo.token.claim
74541ed8-77b0-47a2-9092-cc0a04accd1a	emailVerified	user.attribute
74541ed8-77b0-47a2-9092-cc0a04accd1a	true	id.token.claim
74541ed8-77b0-47a2-9092-cc0a04accd1a	true	access.token.claim
74541ed8-77b0-47a2-9092-cc0a04accd1a	email_verified	claim.name
74541ed8-77b0-47a2-9092-cc0a04accd1a	boolean	jsonType.label
e2f593ac-3d40-4fbf-9d74-f0368961ea18	true	introspection.token.claim
e2f593ac-3d40-4fbf-9d74-f0368961ea18	true	userinfo.token.claim
e2f593ac-3d40-4fbf-9d74-f0368961ea18	email	user.attribute
e2f593ac-3d40-4fbf-9d74-f0368961ea18	true	id.token.claim
e2f593ac-3d40-4fbf-9d74-f0368961ea18	true	access.token.claim
e2f593ac-3d40-4fbf-9d74-f0368961ea18	email	claim.name
e2f593ac-3d40-4fbf-9d74-f0368961ea18	String	jsonType.label
8dc9b90b-96da-4ee3-b9a4-de2bfb812147	formatted	user.attribute.formatted
8dc9b90b-96da-4ee3-b9a4-de2bfb812147	country	user.attribute.country
8dc9b90b-96da-4ee3-b9a4-de2bfb812147	true	introspection.token.claim
8dc9b90b-96da-4ee3-b9a4-de2bfb812147	postal_code	user.attribute.postal_code
8dc9b90b-96da-4ee3-b9a4-de2bfb812147	true	userinfo.token.claim
8dc9b90b-96da-4ee3-b9a4-de2bfb812147	street	user.attribute.street
8dc9b90b-96da-4ee3-b9a4-de2bfb812147	true	id.token.claim
8dc9b90b-96da-4ee3-b9a4-de2bfb812147	region	user.attribute.region
8dc9b90b-96da-4ee3-b9a4-de2bfb812147	true	access.token.claim
8dc9b90b-96da-4ee3-b9a4-de2bfb812147	locality	user.attribute.locality
72c01a01-c228-40d7-82fd-a7baa3654a0f	true	introspection.token.claim
72c01a01-c228-40d7-82fd-a7baa3654a0f	true	userinfo.token.claim
72c01a01-c228-40d7-82fd-a7baa3654a0f	phoneNumber	user.attribute
72c01a01-c228-40d7-82fd-a7baa3654a0f	true	id.token.claim
72c01a01-c228-40d7-82fd-a7baa3654a0f	true	access.token.claim
72c01a01-c228-40d7-82fd-a7baa3654a0f	phone_number	claim.name
72c01a01-c228-40d7-82fd-a7baa3654a0f	String	jsonType.label
ac8db68b-2115-4ed4-9444-396c66270fd5	true	introspection.token.claim
ac8db68b-2115-4ed4-9444-396c66270fd5	true	userinfo.token.claim
ac8db68b-2115-4ed4-9444-396c66270fd5	phoneNumberVerified	user.attribute
ac8db68b-2115-4ed4-9444-396c66270fd5	true	id.token.claim
ac8db68b-2115-4ed4-9444-396c66270fd5	true	access.token.claim
ac8db68b-2115-4ed4-9444-396c66270fd5	phone_number_verified	claim.name
ac8db68b-2115-4ed4-9444-396c66270fd5	boolean	jsonType.label
39600394-a7e3-4916-a965-d85af85a9f91	true	introspection.token.claim
39600394-a7e3-4916-a965-d85af85a9f91	true	access.token.claim
40570d9c-fd7d-4f80-8e2d-39193a58d75b	true	introspection.token.claim
40570d9c-fd7d-4f80-8e2d-39193a58d75b	true	multivalued
40570d9c-fd7d-4f80-8e2d-39193a58d75b	foo	user.attribute
40570d9c-fd7d-4f80-8e2d-39193a58d75b	true	access.token.claim
40570d9c-fd7d-4f80-8e2d-39193a58d75b	realm_access.roles	claim.name
40570d9c-fd7d-4f80-8e2d-39193a58d75b	String	jsonType.label
b806ba9c-2b83-49ce-91d0-86008d989939	true	introspection.token.claim
b806ba9c-2b83-49ce-91d0-86008d989939	true	multivalued
b806ba9c-2b83-49ce-91d0-86008d989939	foo	user.attribute
b806ba9c-2b83-49ce-91d0-86008d989939	true	access.token.claim
b806ba9c-2b83-49ce-91d0-86008d989939	resource_access.${client_id}.roles	claim.name
b806ba9c-2b83-49ce-91d0-86008d989939	String	jsonType.label
55cd493f-77b6-4424-8a28-9ec2a5d91d04	true	introspection.token.claim
55cd493f-77b6-4424-8a28-9ec2a5d91d04	true	access.token.claim
91291879-fd68-4acf-bbd2-8edb56ca6ef3	true	introspection.token.claim
91291879-fd68-4acf-bbd2-8edb56ca6ef3	true	userinfo.token.claim
91291879-fd68-4acf-bbd2-8edb56ca6ef3	username	user.attribute
91291879-fd68-4acf-bbd2-8edb56ca6ef3	true	id.token.claim
91291879-fd68-4acf-bbd2-8edb56ca6ef3	true	access.token.claim
91291879-fd68-4acf-bbd2-8edb56ca6ef3	upn	claim.name
91291879-fd68-4acf-bbd2-8edb56ca6ef3	String	jsonType.label
cf9a9fdf-4ccb-497a-8c5e-3e61aa3ac126	true	introspection.token.claim
cf9a9fdf-4ccb-497a-8c5e-3e61aa3ac126	true	multivalued
cf9a9fdf-4ccb-497a-8c5e-3e61aa3ac126	foo	user.attribute
cf9a9fdf-4ccb-497a-8c5e-3e61aa3ac126	true	id.token.claim
cf9a9fdf-4ccb-497a-8c5e-3e61aa3ac126	true	access.token.claim
cf9a9fdf-4ccb-497a-8c5e-3e61aa3ac126	groups	claim.name
cf9a9fdf-4ccb-497a-8c5e-3e61aa3ac126	String	jsonType.label
589a586f-c333-4122-8bab-6b86f9cbf77d	true	introspection.token.claim
589a586f-c333-4122-8bab-6b86f9cbf77d	true	id.token.claim
589a586f-c333-4122-8bab-6b86f9cbf77d	true	access.token.claim
77cb2767-6465-482f-b7c1-ba0ccd4a3f6f	false	single
77cb2767-6465-482f-b7c1-ba0ccd4a3f6f	Basic	attribute.nameformat
77cb2767-6465-482f-b7c1-ba0ccd4a3f6f	Role	attribute.name
1dd49865-2943-47a0-9b40-b04e54001f45	true	introspection.token.claim
1dd49865-2943-47a0-9b40-b04e54001f45	true	userinfo.token.claim
1dd49865-2943-47a0-9b40-b04e54001f45	true	id.token.claim
1dd49865-2943-47a0-9b40-b04e54001f45	true	access.token.claim
271868b3-fbb5-45b0-8f9b-1292a9ac3840	true	introspection.token.claim
271868b3-fbb5-45b0-8f9b-1292a9ac3840	true	userinfo.token.claim
271868b3-fbb5-45b0-8f9b-1292a9ac3840	updatedAt	user.attribute
271868b3-fbb5-45b0-8f9b-1292a9ac3840	true	id.token.claim
271868b3-fbb5-45b0-8f9b-1292a9ac3840	true	access.token.claim
271868b3-fbb5-45b0-8f9b-1292a9ac3840	updated_at	claim.name
271868b3-fbb5-45b0-8f9b-1292a9ac3840	long	jsonType.label
367081d6-855e-423c-8437-83320d313711	true	introspection.token.claim
367081d6-855e-423c-8437-83320d313711	true	userinfo.token.claim
367081d6-855e-423c-8437-83320d313711	website	user.attribute
367081d6-855e-423c-8437-83320d313711	true	id.token.claim
367081d6-855e-423c-8437-83320d313711	true	access.token.claim
367081d6-855e-423c-8437-83320d313711	website	claim.name
367081d6-855e-423c-8437-83320d313711	String	jsonType.label
38ed3ab6-3ef9-4cc5-8e5d-71ff554187ec	true	introspection.token.claim
38ed3ab6-3ef9-4cc5-8e5d-71ff554187ec	true	userinfo.token.claim
38ed3ab6-3ef9-4cc5-8e5d-71ff554187ec	gender	user.attribute
38ed3ab6-3ef9-4cc5-8e5d-71ff554187ec	true	id.token.claim
38ed3ab6-3ef9-4cc5-8e5d-71ff554187ec	true	access.token.claim
38ed3ab6-3ef9-4cc5-8e5d-71ff554187ec	gender	claim.name
38ed3ab6-3ef9-4cc5-8e5d-71ff554187ec	String	jsonType.label
446e2beb-9913-4f84-9c3a-b2c6a4ff76b9	true	introspection.token.claim
446e2beb-9913-4f84-9c3a-b2c6a4ff76b9	true	userinfo.token.claim
446e2beb-9913-4f84-9c3a-b2c6a4ff76b9	locale	user.attribute
446e2beb-9913-4f84-9c3a-b2c6a4ff76b9	true	id.token.claim
446e2beb-9913-4f84-9c3a-b2c6a4ff76b9	true	access.token.claim
446e2beb-9913-4f84-9c3a-b2c6a4ff76b9	locale	claim.name
446e2beb-9913-4f84-9c3a-b2c6a4ff76b9	String	jsonType.label
8e81576f-63f0-4c29-8314-90559b8e0fc0	true	introspection.token.claim
8e81576f-63f0-4c29-8314-90559b8e0fc0	true	userinfo.token.claim
8e81576f-63f0-4c29-8314-90559b8e0fc0	firstName	user.attribute
8e81576f-63f0-4c29-8314-90559b8e0fc0	true	id.token.claim
8e81576f-63f0-4c29-8314-90559b8e0fc0	true	access.token.claim
8e81576f-63f0-4c29-8314-90559b8e0fc0	given_name	claim.name
8e81576f-63f0-4c29-8314-90559b8e0fc0	String	jsonType.label
8fe4bcde-8490-477d-a93b-f8d1fff67498	true	introspection.token.claim
8fe4bcde-8490-477d-a93b-f8d1fff67498	true	userinfo.token.claim
8fe4bcde-8490-477d-a93b-f8d1fff67498	zoneinfo	user.attribute
8fe4bcde-8490-477d-a93b-f8d1fff67498	true	id.token.claim
8fe4bcde-8490-477d-a93b-f8d1fff67498	true	access.token.claim
8fe4bcde-8490-477d-a93b-f8d1fff67498	zoneinfo	claim.name
8fe4bcde-8490-477d-a93b-f8d1fff67498	String	jsonType.label
b6729b43-097a-4783-9bfb-6e37b0628d23	true	introspection.token.claim
b6729b43-097a-4783-9bfb-6e37b0628d23	true	userinfo.token.claim
b6729b43-097a-4783-9bfb-6e37b0628d23	lastName	user.attribute
b6729b43-097a-4783-9bfb-6e37b0628d23	true	id.token.claim
b6729b43-097a-4783-9bfb-6e37b0628d23	true	access.token.claim
b6729b43-097a-4783-9bfb-6e37b0628d23	family_name	claim.name
b6729b43-097a-4783-9bfb-6e37b0628d23	String	jsonType.label
c4be2b7b-9d0e-438a-be6e-f19e84e1f883	true	introspection.token.claim
c4be2b7b-9d0e-438a-be6e-f19e84e1f883	true	userinfo.token.claim
c4be2b7b-9d0e-438a-be6e-f19e84e1f883	picture	user.attribute
c4be2b7b-9d0e-438a-be6e-f19e84e1f883	true	id.token.claim
c4be2b7b-9d0e-438a-be6e-f19e84e1f883	true	access.token.claim
c4be2b7b-9d0e-438a-be6e-f19e84e1f883	picture	claim.name
c4be2b7b-9d0e-438a-be6e-f19e84e1f883	String	jsonType.label
d4074f23-3e39-47eb-9f0a-204520771aff	true	introspection.token.claim
d4074f23-3e39-47eb-9f0a-204520771aff	true	userinfo.token.claim
d4074f23-3e39-47eb-9f0a-204520771aff	profile	user.attribute
d4074f23-3e39-47eb-9f0a-204520771aff	true	id.token.claim
d4074f23-3e39-47eb-9f0a-204520771aff	true	access.token.claim
d4074f23-3e39-47eb-9f0a-204520771aff	profile	claim.name
d4074f23-3e39-47eb-9f0a-204520771aff	String	jsonType.label
f0af52a7-36b2-4dd2-a25d-98acbc625f18	true	introspection.token.claim
f0af52a7-36b2-4dd2-a25d-98acbc625f18	true	userinfo.token.claim
f0af52a7-36b2-4dd2-a25d-98acbc625f18	nickname	user.attribute
f0af52a7-36b2-4dd2-a25d-98acbc625f18	true	id.token.claim
f0af52a7-36b2-4dd2-a25d-98acbc625f18	true	access.token.claim
f0af52a7-36b2-4dd2-a25d-98acbc625f18	nickname	claim.name
f0af52a7-36b2-4dd2-a25d-98acbc625f18	String	jsonType.label
f3e572a2-f6f7-45ce-84f1-8c598333e251	true	introspection.token.claim
f3e572a2-f6f7-45ce-84f1-8c598333e251	true	userinfo.token.claim
f3e572a2-f6f7-45ce-84f1-8c598333e251	birthdate	user.attribute
f3e572a2-f6f7-45ce-84f1-8c598333e251	true	id.token.claim
f3e572a2-f6f7-45ce-84f1-8c598333e251	true	access.token.claim
f3e572a2-f6f7-45ce-84f1-8c598333e251	birthdate	claim.name
f3e572a2-f6f7-45ce-84f1-8c598333e251	String	jsonType.label
f9ac6aa7-1d6f-4b35-9315-42cafa2b3649	true	introspection.token.claim
f9ac6aa7-1d6f-4b35-9315-42cafa2b3649	true	userinfo.token.claim
f9ac6aa7-1d6f-4b35-9315-42cafa2b3649	middleName	user.attribute
f9ac6aa7-1d6f-4b35-9315-42cafa2b3649	true	id.token.claim
f9ac6aa7-1d6f-4b35-9315-42cafa2b3649	true	access.token.claim
f9ac6aa7-1d6f-4b35-9315-42cafa2b3649	middle_name	claim.name
f9ac6aa7-1d6f-4b35-9315-42cafa2b3649	String	jsonType.label
ff661a02-4d58-44b8-a4cc-0984009610df	true	introspection.token.claim
ff661a02-4d58-44b8-a4cc-0984009610df	true	userinfo.token.claim
ff661a02-4d58-44b8-a4cc-0984009610df	username	user.attribute
ff661a02-4d58-44b8-a4cc-0984009610df	true	id.token.claim
ff661a02-4d58-44b8-a4cc-0984009610df	true	access.token.claim
ff661a02-4d58-44b8-a4cc-0984009610df	preferred_username	claim.name
ff661a02-4d58-44b8-a4cc-0984009610df	String	jsonType.label
2f5c4950-cd72-40ea-9137-62c24fcf1ad7	true	introspection.token.claim
2f5c4950-cd72-40ea-9137-62c24fcf1ad7	true	userinfo.token.claim
2f5c4950-cd72-40ea-9137-62c24fcf1ad7	email	user.attribute
2f5c4950-cd72-40ea-9137-62c24fcf1ad7	true	id.token.claim
2f5c4950-cd72-40ea-9137-62c24fcf1ad7	true	access.token.claim
2f5c4950-cd72-40ea-9137-62c24fcf1ad7	email	claim.name
2f5c4950-cd72-40ea-9137-62c24fcf1ad7	String	jsonType.label
8fccef21-2fe9-4708-b8c9-7a5d096399cb	true	introspection.token.claim
8fccef21-2fe9-4708-b8c9-7a5d096399cb	true	userinfo.token.claim
8fccef21-2fe9-4708-b8c9-7a5d096399cb	emailVerified	user.attribute
8fccef21-2fe9-4708-b8c9-7a5d096399cb	true	id.token.claim
8fccef21-2fe9-4708-b8c9-7a5d096399cb	true	access.token.claim
8fccef21-2fe9-4708-b8c9-7a5d096399cb	email_verified	claim.name
8fccef21-2fe9-4708-b8c9-7a5d096399cb	boolean	jsonType.label
03f4c214-1336-4363-9e99-a35a10792f13	formatted	user.attribute.formatted
03f4c214-1336-4363-9e99-a35a10792f13	country	user.attribute.country
03f4c214-1336-4363-9e99-a35a10792f13	true	introspection.token.claim
03f4c214-1336-4363-9e99-a35a10792f13	postal_code	user.attribute.postal_code
03f4c214-1336-4363-9e99-a35a10792f13	true	userinfo.token.claim
03f4c214-1336-4363-9e99-a35a10792f13	street	user.attribute.street
03f4c214-1336-4363-9e99-a35a10792f13	true	id.token.claim
03f4c214-1336-4363-9e99-a35a10792f13	region	user.attribute.region
03f4c214-1336-4363-9e99-a35a10792f13	true	access.token.claim
03f4c214-1336-4363-9e99-a35a10792f13	locality	user.attribute.locality
0860ff8d-d877-47c9-b192-e3196146d48f	true	introspection.token.claim
0860ff8d-d877-47c9-b192-e3196146d48f	true	userinfo.token.claim
0860ff8d-d877-47c9-b192-e3196146d48f	phoneNumberVerified	user.attribute
0860ff8d-d877-47c9-b192-e3196146d48f	true	id.token.claim
0860ff8d-d877-47c9-b192-e3196146d48f	true	access.token.claim
0860ff8d-d877-47c9-b192-e3196146d48f	phone_number_verified	claim.name
0860ff8d-d877-47c9-b192-e3196146d48f	boolean	jsonType.label
b1ae1d96-bfc4-4deb-b6bc-c9d4f27b8be2	true	introspection.token.claim
b1ae1d96-bfc4-4deb-b6bc-c9d4f27b8be2	true	userinfo.token.claim
b1ae1d96-bfc4-4deb-b6bc-c9d4f27b8be2	phoneNumber	user.attribute
b1ae1d96-bfc4-4deb-b6bc-c9d4f27b8be2	true	id.token.claim
b1ae1d96-bfc4-4deb-b6bc-c9d4f27b8be2	true	access.token.claim
b1ae1d96-bfc4-4deb-b6bc-c9d4f27b8be2	phone_number	claim.name
b1ae1d96-bfc4-4deb-b6bc-c9d4f27b8be2	String	jsonType.label
0474d04a-8085-4a45-9e01-88f67d7b6d02	true	introspection.token.claim
0474d04a-8085-4a45-9e01-88f67d7b6d02	true	multivalued
0474d04a-8085-4a45-9e01-88f67d7b6d02	foo	user.attribute
0474d04a-8085-4a45-9e01-88f67d7b6d02	true	access.token.claim
0474d04a-8085-4a45-9e01-88f67d7b6d02	realm_access.roles	claim.name
0474d04a-8085-4a45-9e01-88f67d7b6d02	String	jsonType.label
4c9b4eb2-0724-4e5f-af8f-6114f7ab5380	true	introspection.token.claim
4c9b4eb2-0724-4e5f-af8f-6114f7ab5380	true	access.token.claim
80a92efe-578d-45a2-8bd9-4d9eb9d01e9a	true	introspection.token.claim
80a92efe-578d-45a2-8bd9-4d9eb9d01e9a	true	multivalued
80a92efe-578d-45a2-8bd9-4d9eb9d01e9a	foo	user.attribute
80a92efe-578d-45a2-8bd9-4d9eb9d01e9a	true	access.token.claim
80a92efe-578d-45a2-8bd9-4d9eb9d01e9a	resource_access.${client_id}.roles	claim.name
80a92efe-578d-45a2-8bd9-4d9eb9d01e9a	String	jsonType.label
97caaeb7-a1df-4245-82c3-afe2f9120924	true	introspection.token.claim
97caaeb7-a1df-4245-82c3-afe2f9120924	true	access.token.claim
9550161b-f00e-4112-b7f7-67bb3d05e230	true	introspection.token.claim
9550161b-f00e-4112-b7f7-67bb3d05e230	true	userinfo.token.claim
9550161b-f00e-4112-b7f7-67bb3d05e230	username	user.attribute
9550161b-f00e-4112-b7f7-67bb3d05e230	true	id.token.claim
9550161b-f00e-4112-b7f7-67bb3d05e230	true	access.token.claim
9550161b-f00e-4112-b7f7-67bb3d05e230	upn	claim.name
9550161b-f00e-4112-b7f7-67bb3d05e230	String	jsonType.label
a4cc8f4b-f2df-405b-aa3c-c59dbe4718f6	true	introspection.token.claim
a4cc8f4b-f2df-405b-aa3c-c59dbe4718f6	true	multivalued
a4cc8f4b-f2df-405b-aa3c-c59dbe4718f6	foo	user.attribute
a4cc8f4b-f2df-405b-aa3c-c59dbe4718f6	true	id.token.claim
a4cc8f4b-f2df-405b-aa3c-c59dbe4718f6	true	access.token.claim
a4cc8f4b-f2df-405b-aa3c-c59dbe4718f6	groups	claim.name
a4cc8f4b-f2df-405b-aa3c-c59dbe4718f6	String	jsonType.label
cb1a1803-2cfb-48eb-8380-d986b5fe9732	true	introspection.token.claim
cb1a1803-2cfb-48eb-8380-d986b5fe9732	true	id.token.claim
cb1a1803-2cfb-48eb-8380-d986b5fe9732	true	access.token.claim
d845db60-3dee-4f9a-aefb-296bfbf85e91	true	introspection.token.claim
d845db60-3dee-4f9a-aefb-296bfbf85e91	true	userinfo.token.claim
d845db60-3dee-4f9a-aefb-296bfbf85e91	locale	user.attribute
d845db60-3dee-4f9a-aefb-296bfbf85e91	true	id.token.claim
d845db60-3dee-4f9a-aefb-296bfbf85e91	true	access.token.claim
d845db60-3dee-4f9a-aefb-296bfbf85e91	locale	claim.name
d845db60-3dee-4f9a-aefb-296bfbf85e91	String	jsonType.label
343d2bbf-5f4d-4ab2-bd6a-a90f7368e4be	AUTH_TIME	user.session.note
343d2bbf-5f4d-4ab2-bd6a-a90f7368e4be	true	introspection.token.claim
343d2bbf-5f4d-4ab2-bd6a-a90f7368e4be	true	id.token.claim
343d2bbf-5f4d-4ab2-bd6a-a90f7368e4be	true	access.token.claim
343d2bbf-5f4d-4ab2-bd6a-a90f7368e4be	auth_time	claim.name
343d2bbf-5f4d-4ab2-bd6a-a90f7368e4be	long	jsonType.label
c07d69ee-65b6-4d69-8ccf-9ab5d24556b2	true	introspection.token.claim
c07d69ee-65b6-4d69-8ccf-9ab5d24556b2	true	access.token.claim
0fa8606d-b97b-4a82-a529-96b7fc53c030	AUTH_TIME	user.session.note
0fa8606d-b97b-4a82-a529-96b7fc53c030	true	introspection.token.claim
0fa8606d-b97b-4a82-a529-96b7fc53c030	true	id.token.claim
0fa8606d-b97b-4a82-a529-96b7fc53c030	true	access.token.claim
0fa8606d-b97b-4a82-a529-96b7fc53c030	auth_time	claim.name
0fa8606d-b97b-4a82-a529-96b7fc53c030	long	jsonType.label
653135c3-4cc9-4efa-9539-63bc6a32dbf4	true	introspection.token.claim
653135c3-4cc9-4efa-9539-63bc6a32dbf4	true	access.token.claim
2eda4093-c7e7-490f-bb67-042269c74374	client_id	user.session.note
2eda4093-c7e7-490f-bb67-042269c74374	true	introspection.token.claim
2eda4093-c7e7-490f-bb67-042269c74374	true	id.token.claim
2eda4093-c7e7-490f-bb67-042269c74374	true	access.token.claim
2eda4093-c7e7-490f-bb67-042269c74374	client_id	claim.name
2eda4093-c7e7-490f-bb67-042269c74374	String	jsonType.label
720b901e-2a25-4f7d-add8-19b023fb8fcd	clientAddress	user.session.note
720b901e-2a25-4f7d-add8-19b023fb8fcd	true	introspection.token.claim
720b901e-2a25-4f7d-add8-19b023fb8fcd	true	id.token.claim
720b901e-2a25-4f7d-add8-19b023fb8fcd	true	access.token.claim
720b901e-2a25-4f7d-add8-19b023fb8fcd	clientAddress	claim.name
720b901e-2a25-4f7d-add8-19b023fb8fcd	String	jsonType.label
81cfb4d1-b273-4261-bac4-95d6f0473b7a	clientHost	user.session.note
81cfb4d1-b273-4261-bac4-95d6f0473b7a	true	introspection.token.claim
81cfb4d1-b273-4261-bac4-95d6f0473b7a	true	id.token.claim
81cfb4d1-b273-4261-bac4-95d6f0473b7a	true	access.token.claim
81cfb4d1-b273-4261-bac4-95d6f0473b7a	clientHost	claim.name
81cfb4d1-b273-4261-bac4-95d6f0473b7a	String	jsonType.label
2e8772b6-9997-40ef-b6c5-c3692fa48adc	clientHost	user.session.note
2e8772b6-9997-40ef-b6c5-c3692fa48adc	true	introspection.token.claim
2e8772b6-9997-40ef-b6c5-c3692fa48adc	true	id.token.claim
2e8772b6-9997-40ef-b6c5-c3692fa48adc	true	access.token.claim
2e8772b6-9997-40ef-b6c5-c3692fa48adc	clientHost	claim.name
2e8772b6-9997-40ef-b6c5-c3692fa48adc	String	jsonType.label
9262f2d6-3f70-4872-9eb7-37421f7c4270	client_id	user.session.note
9262f2d6-3f70-4872-9eb7-37421f7c4270	true	introspection.token.claim
9262f2d6-3f70-4872-9eb7-37421f7c4270	true	id.token.claim
9262f2d6-3f70-4872-9eb7-37421f7c4270	true	access.token.claim
9262f2d6-3f70-4872-9eb7-37421f7c4270	client_id	claim.name
9262f2d6-3f70-4872-9eb7-37421f7c4270	String	jsonType.label
e887a496-7438-44bd-9b45-cf0102a581a2	clientAddress	user.session.note
e887a496-7438-44bd-9b45-cf0102a581a2	true	introspection.token.claim
e887a496-7438-44bd-9b45-cf0102a581a2	true	id.token.claim
e887a496-7438-44bd-9b45-cf0102a581a2	true	access.token.claim
e887a496-7438-44bd-9b45-cf0102a581a2	clientAddress	claim.name
e887a496-7438-44bd-9b45-cf0102a581a2	String	jsonType.label
\.


--
-- Data for Name: realm; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm (id, access_code_lifespan, user_action_lifespan, access_token_lifespan, account_theme, admin_theme, email_theme, enabled, events_enabled, events_expiration, login_theme, name, not_before, password_policy, registration_allowed, remember_me, reset_password_allowed, social, ssl_required, sso_idle_timeout, sso_max_lifespan, update_profile_on_soc_login, verify_email, master_admin_client, login_lifespan, internationalization_enabled, default_locale, reg_email_as_username, admin_events_enabled, admin_events_details_enabled, edit_username_allowed, otp_policy_counter, otp_policy_window, otp_policy_period, otp_policy_digits, otp_policy_alg, otp_policy_type, browser_flow, registration_flow, direct_grant_flow, reset_credentials_flow, client_auth_flow, offline_session_idle_timeout, revoke_refresh_token, access_token_life_implicit, login_with_email_allowed, duplicate_emails_allowed, docker_auth_flow, refresh_token_max_reuse, allow_user_managed_access, sso_max_lifespan_remember_me, sso_idle_timeout_remember_me, default_role) FROM stdin;
545899ec-2a73-4c95-b368-425da707cea1	60	300	300	\N	\N	\N	t	f	0	\N	purchase-service-realm	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	9969ca14-fb6b-4b25-9ee4-8fca05889e15	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	9c3bb2d9-d2b6-43c2-8e15-e3b8ab94fab5	42754e79-22e2-4cb9-9931-53214609601c	84cae261-4275-4b1a-814d-fcd9cca08788	d601a09a-058c-4610-a3fe-f1ef4f61ee51	f6740fd6-b59e-49b7-8445-29b85c7ce410	2592000	f	900	t	f	09b36483-2b72-4b71-b7a1-61a63e41220b	0	f	0	0	ef4e1149-2675-45d2-82e4-b539d823ceb2
98b2ec68-490d-4a88-b1bd-05b5707e88da	60	300	60	\N	\N	\N	t	f	0	\N	master	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	fe642ed6-7328-4dc5-82c1-a7c74140cef4	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	1ecdfd6c-7efb-4193-a807-843f0d4de9c0	8d4fbdd4-9d6e-4a36-a1a8-7eec490d1c3f	db4d3e83-56c2-4ea2-ae34-5b3e14a54989	d572418c-ee37-441e-a5bb-6d487cea0d3c	f2a59aa2-f9b7-4785-98bc-f79de29cd083	2592000	f	900	t	f	35ebbc3b-5a52-4317-bf58-587e19cfce16	0	f	0	0	76ab0737-f4fe-42af-aec1-3b71892f8ccc
\.


--
-- Data for Name: realm_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_attribute (name, realm_id, value) FROM stdin;
_browser_header.contentSecurityPolicyReportOnly	98b2ec68-490d-4a88-b1bd-05b5707e88da	
_browser_header.xContentTypeOptions	98b2ec68-490d-4a88-b1bd-05b5707e88da	nosniff
_browser_header.referrerPolicy	98b2ec68-490d-4a88-b1bd-05b5707e88da	no-referrer
_browser_header.xRobotsTag	98b2ec68-490d-4a88-b1bd-05b5707e88da	none
_browser_header.xFrameOptions	98b2ec68-490d-4a88-b1bd-05b5707e88da	SAMEORIGIN
_browser_header.contentSecurityPolicy	98b2ec68-490d-4a88-b1bd-05b5707e88da	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.xXSSProtection	98b2ec68-490d-4a88-b1bd-05b5707e88da	1; mode=block
_browser_header.strictTransportSecurity	98b2ec68-490d-4a88-b1bd-05b5707e88da	max-age=31536000; includeSubDomains
bruteForceProtected	98b2ec68-490d-4a88-b1bd-05b5707e88da	false
permanentLockout	98b2ec68-490d-4a88-b1bd-05b5707e88da	false
maxTemporaryLockouts	98b2ec68-490d-4a88-b1bd-05b5707e88da	0
maxFailureWaitSeconds	98b2ec68-490d-4a88-b1bd-05b5707e88da	900
minimumQuickLoginWaitSeconds	98b2ec68-490d-4a88-b1bd-05b5707e88da	60
waitIncrementSeconds	98b2ec68-490d-4a88-b1bd-05b5707e88da	60
quickLoginCheckMilliSeconds	98b2ec68-490d-4a88-b1bd-05b5707e88da	1000
maxDeltaTimeSeconds	98b2ec68-490d-4a88-b1bd-05b5707e88da	43200
failureFactor	98b2ec68-490d-4a88-b1bd-05b5707e88da	30
realmReusableOtpCode	98b2ec68-490d-4a88-b1bd-05b5707e88da	false
firstBrokerLoginFlowId	98b2ec68-490d-4a88-b1bd-05b5707e88da	c9553ad0-c2f2-420e-b9e1-fb8f6a810481
displayName	98b2ec68-490d-4a88-b1bd-05b5707e88da	Keycloak
displayNameHtml	98b2ec68-490d-4a88-b1bd-05b5707e88da	<div class="kc-logo-text"><span>Keycloak</span></div>
defaultSignatureAlgorithm	98b2ec68-490d-4a88-b1bd-05b5707e88da	RS256
offlineSessionMaxLifespanEnabled	98b2ec68-490d-4a88-b1bd-05b5707e88da	false
offlineSessionMaxLifespan	98b2ec68-490d-4a88-b1bd-05b5707e88da	5184000
_browser_header.contentSecurityPolicyReportOnly	545899ec-2a73-4c95-b368-425da707cea1	
_browser_header.xContentTypeOptions	545899ec-2a73-4c95-b368-425da707cea1	nosniff
_browser_header.referrerPolicy	545899ec-2a73-4c95-b368-425da707cea1	no-referrer
_browser_header.xRobotsTag	545899ec-2a73-4c95-b368-425da707cea1	none
_browser_header.xFrameOptions	545899ec-2a73-4c95-b368-425da707cea1	SAMEORIGIN
_browser_header.contentSecurityPolicy	545899ec-2a73-4c95-b368-425da707cea1	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.xXSSProtection	545899ec-2a73-4c95-b368-425da707cea1	1; mode=block
_browser_header.strictTransportSecurity	545899ec-2a73-4c95-b368-425da707cea1	max-age=31536000; includeSubDomains
bruteForceProtected	545899ec-2a73-4c95-b368-425da707cea1	false
permanentLockout	545899ec-2a73-4c95-b368-425da707cea1	false
maxTemporaryLockouts	545899ec-2a73-4c95-b368-425da707cea1	0
maxFailureWaitSeconds	545899ec-2a73-4c95-b368-425da707cea1	900
minimumQuickLoginWaitSeconds	545899ec-2a73-4c95-b368-425da707cea1	60
waitIncrementSeconds	545899ec-2a73-4c95-b368-425da707cea1	60
quickLoginCheckMilliSeconds	545899ec-2a73-4c95-b368-425da707cea1	1000
maxDeltaTimeSeconds	545899ec-2a73-4c95-b368-425da707cea1	43200
failureFactor	545899ec-2a73-4c95-b368-425da707cea1	30
realmReusableOtpCode	545899ec-2a73-4c95-b368-425da707cea1	false
defaultSignatureAlgorithm	545899ec-2a73-4c95-b368-425da707cea1	RS256
offlineSessionMaxLifespanEnabled	545899ec-2a73-4c95-b368-425da707cea1	false
offlineSessionMaxLifespan	545899ec-2a73-4c95-b368-425da707cea1	5184000
actionTokenGeneratedByAdminLifespan	545899ec-2a73-4c95-b368-425da707cea1	43200
actionTokenGeneratedByUserLifespan	545899ec-2a73-4c95-b368-425da707cea1	300
oauth2DeviceCodeLifespan	545899ec-2a73-4c95-b368-425da707cea1	600
oauth2DevicePollingInterval	545899ec-2a73-4c95-b368-425da707cea1	5
webAuthnPolicyRpEntityName	545899ec-2a73-4c95-b368-425da707cea1	keycloak
webAuthnPolicySignatureAlgorithms	545899ec-2a73-4c95-b368-425da707cea1	ES256
webAuthnPolicyRpId	545899ec-2a73-4c95-b368-425da707cea1	
webAuthnPolicyAttestationConveyancePreference	545899ec-2a73-4c95-b368-425da707cea1	not specified
webAuthnPolicyAuthenticatorAttachment	545899ec-2a73-4c95-b368-425da707cea1	not specified
webAuthnPolicyRequireResidentKey	545899ec-2a73-4c95-b368-425da707cea1	not specified
webAuthnPolicyUserVerificationRequirement	545899ec-2a73-4c95-b368-425da707cea1	not specified
webAuthnPolicyCreateTimeout	545899ec-2a73-4c95-b368-425da707cea1	0
webAuthnPolicyAvoidSameAuthenticatorRegister	545899ec-2a73-4c95-b368-425da707cea1	false
webAuthnPolicyRpEntityNamePasswordless	545899ec-2a73-4c95-b368-425da707cea1	keycloak
webAuthnPolicySignatureAlgorithmsPasswordless	545899ec-2a73-4c95-b368-425da707cea1	ES256
webAuthnPolicyRpIdPasswordless	545899ec-2a73-4c95-b368-425da707cea1	
webAuthnPolicyAttestationConveyancePreferencePasswordless	545899ec-2a73-4c95-b368-425da707cea1	not specified
webAuthnPolicyAuthenticatorAttachmentPasswordless	545899ec-2a73-4c95-b368-425da707cea1	not specified
webAuthnPolicyRequireResidentKeyPasswordless	545899ec-2a73-4c95-b368-425da707cea1	not specified
webAuthnPolicyUserVerificationRequirementPasswordless	545899ec-2a73-4c95-b368-425da707cea1	not specified
webAuthnPolicyCreateTimeoutPasswordless	545899ec-2a73-4c95-b368-425da707cea1	0
webAuthnPolicyAvoidSameAuthenticatorRegisterPasswordless	545899ec-2a73-4c95-b368-425da707cea1	false
cibaBackchannelTokenDeliveryMode	545899ec-2a73-4c95-b368-425da707cea1	poll
cibaExpiresIn	545899ec-2a73-4c95-b368-425da707cea1	120
cibaInterval	545899ec-2a73-4c95-b368-425da707cea1	5
cibaAuthRequestedUserHint	545899ec-2a73-4c95-b368-425da707cea1	login_hint
parRequestUriLifespan	545899ec-2a73-4c95-b368-425da707cea1	60
firstBrokerLoginFlowId	545899ec-2a73-4c95-b368-425da707cea1	4eafe314-6dd8-4dc5-ba9b-63ffcf24d400
frontendUrl	545899ec-2a73-4c95-b368-425da707cea1	
saml.signature.algorithm	545899ec-2a73-4c95-b368-425da707cea1	
acr.loa.map	545899ec-2a73-4c95-b368-425da707cea1	{}
displayName	545899ec-2a73-4c95-b368-425da707cea1	
displayNameHtml	545899ec-2a73-4c95-b368-425da707cea1	
bruteForceStrategy	545899ec-2a73-4c95-b368-425da707cea1	MULTIPLE
organizationsEnabled	545899ec-2a73-4c95-b368-425da707cea1	false
adminPermissionsEnabled	545899ec-2a73-4c95-b368-425da707cea1	false
verifiableCredentialsEnabled	545899ec-2a73-4c95-b368-425da707cea1	false
clientSessionIdleTimeout	545899ec-2a73-4c95-b368-425da707cea1	0
clientSessionMaxLifespan	545899ec-2a73-4c95-b368-425da707cea1	0
clientOfflineSessionIdleTimeout	545899ec-2a73-4c95-b368-425da707cea1	0
clientOfflineSessionMaxLifespan	545899ec-2a73-4c95-b368-425da707cea1	0
client-policies.profiles	545899ec-2a73-4c95-b368-425da707cea1	{"profiles":[]}
client-policies.policies	545899ec-2a73-4c95-b368-425da707cea1	{"policies":[]}
\.


--
-- Data for Name: realm_default_groups; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_default_groups (realm_id, group_id) FROM stdin;
\.


--
-- Data for Name: realm_enabled_event_types; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_enabled_event_types (realm_id, value) FROM stdin;
\.


--
-- Data for Name: realm_events_listeners; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_events_listeners (realm_id, value) FROM stdin;
98b2ec68-490d-4a88-b1bd-05b5707e88da	jboss-logging
545899ec-2a73-4c95-b368-425da707cea1	jboss-logging
\.


--
-- Data for Name: realm_localizations; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_localizations (realm_id, locale, texts) FROM stdin;
\.


--
-- Data for Name: realm_required_credential; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_required_credential (type, form_label, input, secret, realm_id) FROM stdin;
password	password	t	t	98b2ec68-490d-4a88-b1bd-05b5707e88da
password	password	t	t	545899ec-2a73-4c95-b368-425da707cea1
\.


--
-- Data for Name: realm_smtp_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_smtp_config (realm_id, value, name) FROM stdin;
\.


--
-- Data for Name: realm_supported_locales; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_supported_locales (realm_id, value) FROM stdin;
\.


--
-- Data for Name: redirect_uris; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.redirect_uris (client_id, value) FROM stdin;
55bd8a5b-3f67-4667-9e35-9010417f108a	/realms/master/account/*
d2c379b9-8493-47e1-82d8-9f5b2791c11a	/realms/master/account/*
b47e2542-cc0b-453d-993f-e73422e7a44e	/admin/master/console/*
191b61d7-ca16-4c99-b7f7-828b3391d614	/realms/purchase-service-realm/account/*
8ed73690-8dd1-4434-b5ca-2665456bae8e	/realms/purchase-service-realm/account/*
d4c63c03-da48-4170-b5dd-03fe25bc3bc7	/admin/purchase-service-realm/console/*
50c8e8fd-de3b-4877-ac29-f8644a9d0bb0	http://localhost:8080/login/oauth2/code/purchase-service-client
db7fb3a7-14a1-4b7e-9379-8905016349db	http://localhost:4200/*
db7fb3a7-14a1-4b7e-9379-8905016349db	http://localhost:4200
\.


--
-- Data for Name: required_action_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.required_action_config (required_action_id, value, name) FROM stdin;
\.


--
-- Data for Name: required_action_provider; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.required_action_provider (id, alias, name, realm_id, enabled, default_action, provider_id, priority) FROM stdin;
0c327bb4-e284-4e9e-a156-f8ae807e7d8e	VERIFY_EMAIL	Verify Email	98b2ec68-490d-4a88-b1bd-05b5707e88da	t	f	VERIFY_EMAIL	50
30671e49-c698-4c71-ad86-afb53ce172af	UPDATE_PROFILE	Update Profile	98b2ec68-490d-4a88-b1bd-05b5707e88da	t	f	UPDATE_PROFILE	40
76c796df-a775-4e57-9ef4-b3079f3bddde	CONFIGURE_TOTP	Configure OTP	98b2ec68-490d-4a88-b1bd-05b5707e88da	t	f	CONFIGURE_TOTP	10
6d5ccaf8-e303-4fab-a16d-c4afcb4dafff	UPDATE_PASSWORD	Update Password	98b2ec68-490d-4a88-b1bd-05b5707e88da	t	f	UPDATE_PASSWORD	30
e83acb34-9395-4f6b-925b-674ae4962b00	TERMS_AND_CONDITIONS	Terms and Conditions	98b2ec68-490d-4a88-b1bd-05b5707e88da	f	f	TERMS_AND_CONDITIONS	20
b623e34c-3ce4-42b9-94df-45838c3d4834	delete_account	Delete Account	98b2ec68-490d-4a88-b1bd-05b5707e88da	f	f	delete_account	60
2203ab44-466a-4878-91f9-dd9548bd77aa	delete_credential	Delete Credential	98b2ec68-490d-4a88-b1bd-05b5707e88da	t	f	delete_credential	100
2e331adc-afeb-48f6-a4be-87c1d3e45a5b	update_user_locale	Update User Locale	98b2ec68-490d-4a88-b1bd-05b5707e88da	t	f	update_user_locale	1000
2a6f5bf2-4de5-40e7-aab5-b833249063c1	webauthn-register	Webauthn Register	98b2ec68-490d-4a88-b1bd-05b5707e88da	t	f	webauthn-register	70
7236ee31-c7b3-43d3-98c8-a5172b3e0193	webauthn-register-passwordless	Webauthn Register Passwordless	98b2ec68-490d-4a88-b1bd-05b5707e88da	t	f	webauthn-register-passwordless	80
0d602d8f-7c01-4dea-b6ee-c5d275f8f15e	VERIFY_PROFILE	Verify Profile	98b2ec68-490d-4a88-b1bd-05b5707e88da	t	f	VERIFY_PROFILE	90
6bcd1e1d-8781-46cd-a62d-4840adbae6fc	VERIFY_EMAIL	Verify Email	545899ec-2a73-4c95-b368-425da707cea1	t	f	VERIFY_EMAIL	50
c5953fff-41db-4f07-936f-f37892137df7	UPDATE_PROFILE	Update Profile	545899ec-2a73-4c95-b368-425da707cea1	t	f	UPDATE_PROFILE	40
1b9eec14-13f2-4920-ba25-3a1d9b6df25a	CONFIGURE_TOTP	Configure OTP	545899ec-2a73-4c95-b368-425da707cea1	t	f	CONFIGURE_TOTP	10
f9cdbb18-e8a6-4f40-ada6-0817872c3776	UPDATE_PASSWORD	Update Password	545899ec-2a73-4c95-b368-425da707cea1	t	f	UPDATE_PASSWORD	30
59462c37-0ffa-417f-944f-e4036b659654	TERMS_AND_CONDITIONS	Terms and Conditions	545899ec-2a73-4c95-b368-425da707cea1	f	f	TERMS_AND_CONDITIONS	20
7896a1fa-5df6-4223-a371-7d557145c9ec	delete_account	Delete Account	545899ec-2a73-4c95-b368-425da707cea1	f	f	delete_account	60
276a9cea-2102-45bf-ab88-809598b7c169	delete_credential	Delete Credential	545899ec-2a73-4c95-b368-425da707cea1	t	f	delete_credential	100
06ff2cdf-3dc3-47eb-bedc-68844aec5ee1	update_user_locale	Update User Locale	545899ec-2a73-4c95-b368-425da707cea1	t	f	update_user_locale	1000
b73173e5-5381-48b6-8d8f-bee22b0e6c09	webauthn-register	Webauthn Register	545899ec-2a73-4c95-b368-425da707cea1	t	f	webauthn-register	70
b9fde59e-db88-4197-a08f-6c0e4975968b	webauthn-register-passwordless	Webauthn Register Passwordless	545899ec-2a73-4c95-b368-425da707cea1	t	f	webauthn-register-passwordless	80
83525c6c-e5c0-4f04-a1da-c9e595c4ca40	VERIFY_PROFILE	Verify Profile	545899ec-2a73-4c95-b368-425da707cea1	t	f	VERIFY_PROFILE	90
\.


--
-- Data for Name: resource_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_attribute (id, name, value, resource_id) FROM stdin;
\.


--
-- Data for Name: resource_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_policy (resource_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_scope (resource_id, scope_id) FROM stdin;
\.


--
-- Data for Name: resource_server; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server (id, allow_rs_remote_mgmt, policy_enforce_mode, decision_strategy) FROM stdin;
\.


--
-- Data for Name: resource_server_perm_ticket; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_perm_ticket (id, owner, requester, created_timestamp, granted_timestamp, resource_id, scope_id, resource_server_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_server_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_policy (id, name, description, type, decision_strategy, logic, resource_server_id, owner) FROM stdin;
\.


--
-- Data for Name: resource_server_resource; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_resource (id, name, type, icon_uri, owner, resource_server_id, owner_managed_access, display_name) FROM stdin;
\.


--
-- Data for Name: resource_server_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_scope (id, name, icon_uri, resource_server_id, display_name) FROM stdin;
\.


--
-- Data for Name: resource_uris; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_uris (resource_id, value) FROM stdin;
\.


--
-- Data for Name: revoked_token; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.revoked_token (id, expire) FROM stdin;
\.


--
-- Data for Name: role_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.role_attribute (id, role_id, name, value) FROM stdin;
\.


--
-- Data for Name: scope_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.scope_mapping (client_id, role_id) FROM stdin;
d2c379b9-8493-47e1-82d8-9f5b2791c11a	4726bd4a-01c2-46de-8632-82627aa46ea2
d2c379b9-8493-47e1-82d8-9f5b2791c11a	25c8ea4b-02a3-4bbb-a679-2e860e94c435
191b61d7-ca16-4c99-b7f7-828b3391d614	f8801922-ee75-4c9f-baae-20c89a30b61c
191b61d7-ca16-4c99-b7f7-828b3391d614	c476aec6-d6c4-40ca-b747-6c7b2139db46
\.


--
-- Data for Name: scope_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.scope_policy (scope_id, policy_id) FROM stdin;
\.


--
-- Data for Name: server_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.server_config (server_config_key, value, version) FROM stdin;
\.


--
-- Data for Name: user_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_attribute (name, value, user_id, id, long_value_hash, long_value_hash_lower_case, long_value) FROM stdin;
\.


--
-- Data for Name: user_consent; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_consent (id, client_id, user_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: user_consent_client_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_consent_client_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: user_entity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_entity (id, email, email_constraint, email_verified, enabled, federation_link, first_name, last_name, realm_id, username, created_timestamp, service_account_client_link, not_before) FROM stdin;
65c5dbfe-fb0b-4849-98ad-519a254de1c1	\N	8f33247e-205e-47b9-9152-e5a2f6a0a54a	f	t	\N	\N	\N	98b2ec68-490d-4a88-b1bd-05b5707e88da	admin	1749042186207	\N	0
cf2fedf1-1bb5-40af-8241-bd20b90d2762	demo002@gmail.com	demo002@gmail.com	f	t	\N	Mohammad	Mahamid	545899ec-2a73-4c95-b368-425da707cea1	demo002	1752075888038	\N	0
9b84fcdf-6f83-4402-b631-6a97b0de6f86	demo001@gmail.com	demo001@gmail.com	f	t	\N	foo	bar	545899ec-2a73-4c95-b368-425da707cea1	demo001	1749043426271	\N	0
\.


--
-- Data for Name: user_federation_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_config (user_federation_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_mapper (id, name, federation_provider_id, federation_mapper_type, realm_id) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_mapper_config (user_federation_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_provider; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_provider (id, changed_sync_period, display_name, full_sync_period, last_sync, priority, provider_name, realm_id) FROM stdin;
\.


--
-- Data for Name: user_group_membership; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_group_membership (group_id, user_id, membership_type) FROM stdin;
\.


--
-- Data for Name: user_required_action; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_required_action (user_id, required_action) FROM stdin;
\.


--
-- Data for Name: user_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_role_mapping (role_id, user_id) FROM stdin;
76ab0737-f4fe-42af-aec1-3b71892f8ccc	65c5dbfe-fb0b-4849-98ad-519a254de1c1
7ca25e09-89e0-4c12-8850-2138924f1159	65c5dbfe-fb0b-4849-98ad-519a254de1c1
e7c10524-6b80-4870-931f-707a10b330f5	65c5dbfe-fb0b-4849-98ad-519a254de1c1
ed05b454-19df-4baa-8a02-8e209a6d0987	65c5dbfe-fb0b-4849-98ad-519a254de1c1
9f05ea53-4629-4db1-9ed6-89fe784170b5	65c5dbfe-fb0b-4849-98ad-519a254de1c1
22582409-311c-48ab-b854-304d221c304d	65c5dbfe-fb0b-4849-98ad-519a254de1c1
a105a5f8-9a9d-489f-9f7a-6487feff7f11	65c5dbfe-fb0b-4849-98ad-519a254de1c1
2ca8f3a5-9ed2-4748-9217-195beeaa0c58	65c5dbfe-fb0b-4849-98ad-519a254de1c1
8e563722-fba0-47c8-894d-fe83fecb2489	65c5dbfe-fb0b-4849-98ad-519a254de1c1
b70c3df3-ef51-461f-b94c-ca147aed8e34	65c5dbfe-fb0b-4849-98ad-519a254de1c1
0a6d272e-4e7e-46c7-a6c9-01338a5421b7	65c5dbfe-fb0b-4849-98ad-519a254de1c1
df467638-22c0-4cb9-85a7-5b0764411e2c	65c5dbfe-fb0b-4849-98ad-519a254de1c1
fe938b22-12a1-4bed-a192-b1d3596df6b7	65c5dbfe-fb0b-4849-98ad-519a254de1c1
de0fbdbb-e992-4db9-987f-1b45c3827c1c	65c5dbfe-fb0b-4849-98ad-519a254de1c1
ef73a8fa-1246-4ddb-b186-acaf8946e643	65c5dbfe-fb0b-4849-98ad-519a254de1c1
e5c8b81f-27b3-442a-9b5a-3a6d326c04df	65c5dbfe-fb0b-4849-98ad-519a254de1c1
0ac7e126-33cb-403a-92a3-4a5dfc623d3b	65c5dbfe-fb0b-4849-98ad-519a254de1c1
3c60ded0-299d-4f6a-b978-66046ad0cea8	65c5dbfe-fb0b-4849-98ad-519a254de1c1
a313efc0-5b47-4961-8dce-d9650d4d93c9	65c5dbfe-fb0b-4849-98ad-519a254de1c1
ef4e1149-2675-45d2-82e4-b539d823ceb2	9b84fcdf-6f83-4402-b631-6a97b0de6f86
ef4e1149-2675-45d2-82e4-b539d823ceb2	cf2fedf1-1bb5-40af-8241-bd20b90d2762
\.


--
-- Data for Name: web_origins; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.web_origins (client_id, value) FROM stdin;
b47e2542-cc0b-453d-993f-e73422e7a44e	+
d4c63c03-da48-4170-b5dd-03fe25bc3bc7	+
50c8e8fd-de3b-4877-ac29-f8644a9d0bb0	
db7fb3a7-14a1-4b7e-9379-8905016349db	*
db7fb3a7-14a1-4b7e-9379-8905016349db	+
\.


--
-- Name: org_domain ORG_DOMAIN_pkey; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.org_domain
    ADD CONSTRAINT "ORG_DOMAIN_pkey" PRIMARY KEY (id, name);


--
-- Name: org ORG_pkey; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT "ORG_pkey" PRIMARY KEY (id);


--
-- Name: server_config SERVER_CONFIG_pkey; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.server_config
    ADD CONSTRAINT "SERVER_CONFIG_pkey" PRIMARY KEY (server_config_key);


--
-- Name: keycloak_role UK_J3RWUVD56ONTGSUHOGM184WW2-2; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT "UK_J3RWUVD56ONTGSUHOGM184WW2-2" UNIQUE (name, client_realm_constraint);


--
-- Name: client_auth_flow_bindings c_cli_flow_bind; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_auth_flow_bindings
    ADD CONSTRAINT c_cli_flow_bind PRIMARY KEY (client_id, binding_name);


--
-- Name: client_scope_client c_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_client
    ADD CONSTRAINT c_cli_scope_bind PRIMARY KEY (client_id, scope_id);


--
-- Name: client_initial_access cnstr_client_init_acc_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT cnstr_client_init_acc_pk PRIMARY KEY (id);


--
-- Name: realm_default_groups con_group_id_def_groups; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT con_group_id_def_groups UNIQUE (group_id);


--
-- Name: broker_link constr_broker_link_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.broker_link
    ADD CONSTRAINT constr_broker_link_pk PRIMARY KEY (identity_provider, user_id);


--
-- Name: component_config constr_component_config_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT constr_component_config_pk PRIMARY KEY (id);


--
-- Name: component constr_component_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT constr_component_pk PRIMARY KEY (id);


--
-- Name: fed_user_required_action constr_fed_required_action; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_required_action
    ADD CONSTRAINT constr_fed_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: fed_user_attribute constr_fed_user_attr_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_attribute
    ADD CONSTRAINT constr_fed_user_attr_pk PRIMARY KEY (id);


--
-- Name: fed_user_consent constr_fed_user_consent_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_consent
    ADD CONSTRAINT constr_fed_user_consent_pk PRIMARY KEY (id);


--
-- Name: fed_user_credential constr_fed_user_cred_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_credential
    ADD CONSTRAINT constr_fed_user_cred_pk PRIMARY KEY (id);


--
-- Name: fed_user_group_membership constr_fed_user_group; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_group_membership
    ADD CONSTRAINT constr_fed_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: fed_user_role_mapping constr_fed_user_role; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_role_mapping
    ADD CONSTRAINT constr_fed_user_role PRIMARY KEY (role_id, user_id);


--
-- Name: federated_user constr_federated_user; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.federated_user
    ADD CONSTRAINT constr_federated_user PRIMARY KEY (id);


--
-- Name: realm_default_groups constr_realm_default_groups; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT constr_realm_default_groups PRIMARY KEY (realm_id, group_id);


--
-- Name: realm_enabled_event_types constr_realm_enabl_event_types; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT constr_realm_enabl_event_types PRIMARY KEY (realm_id, value);


--
-- Name: realm_events_listeners constr_realm_events_listeners; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT constr_realm_events_listeners PRIMARY KEY (realm_id, value);


--
-- Name: realm_supported_locales constr_realm_supported_locales; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT constr_realm_supported_locales PRIMARY KEY (realm_id, value);


--
-- Name: identity_provider constraint_2b; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT constraint_2b PRIMARY KEY (internal_id);


--
-- Name: client_attributes constraint_3c; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT constraint_3c PRIMARY KEY (client_id, name);


--
-- Name: event_entity constraint_4; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.event_entity
    ADD CONSTRAINT constraint_4 PRIMARY KEY (id);


--
-- Name: federated_identity constraint_40; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT constraint_40 PRIMARY KEY (identity_provider, user_id);


--
-- Name: realm constraint_4a; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT constraint_4a PRIMARY KEY (id);


--
-- Name: user_federation_provider constraint_5c; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT constraint_5c PRIMARY KEY (id);


--
-- Name: client constraint_7; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT constraint_7 PRIMARY KEY (id);


--
-- Name: scope_mapping constraint_81; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT constraint_81 PRIMARY KEY (client_id, role_id);


--
-- Name: client_node_registrations constraint_84; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT constraint_84 PRIMARY KEY (client_id, name);


--
-- Name: realm_attribute constraint_9; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT constraint_9 PRIMARY KEY (name, realm_id);


--
-- Name: realm_required_credential constraint_92; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT constraint_92 PRIMARY KEY (realm_id, type);


--
-- Name: keycloak_role constraint_a; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT constraint_a PRIMARY KEY (id);


--
-- Name: admin_event_entity constraint_admin_event_entity; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.admin_event_entity
    ADD CONSTRAINT constraint_admin_event_entity PRIMARY KEY (id);


--
-- Name: authenticator_config_entry constraint_auth_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authenticator_config_entry
    ADD CONSTRAINT constraint_auth_cfg_pk PRIMARY KEY (authenticator_id, name);


--
-- Name: authentication_execution constraint_auth_exec_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT constraint_auth_exec_pk PRIMARY KEY (id);


--
-- Name: authentication_flow constraint_auth_flow_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT constraint_auth_flow_pk PRIMARY KEY (id);


--
-- Name: authenticator_config constraint_auth_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT constraint_auth_pk PRIMARY KEY (id);


--
-- Name: user_role_mapping constraint_c; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT constraint_c PRIMARY KEY (role_id, user_id);


--
-- Name: composite_role constraint_composite_role; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT constraint_composite_role PRIMARY KEY (composite, child_role);


--
-- Name: identity_provider_config constraint_d; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT constraint_d PRIMARY KEY (identity_provider_id, name);


--
-- Name: policy_config constraint_dpc; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT constraint_dpc PRIMARY KEY (policy_id, name);


--
-- Name: realm_smtp_config constraint_e; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT constraint_e PRIMARY KEY (realm_id, name);


--
-- Name: credential constraint_f; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT constraint_f PRIMARY KEY (id);


--
-- Name: user_federation_config constraint_f9; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT constraint_f9 PRIMARY KEY (user_federation_provider_id, name);


--
-- Name: resource_server_perm_ticket constraint_fapmt; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT constraint_fapmt PRIMARY KEY (id);


--
-- Name: resource_server_resource constraint_farsr; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT constraint_farsr PRIMARY KEY (id);


--
-- Name: resource_server_policy constraint_farsrp; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT constraint_farsrp PRIMARY KEY (id);


--
-- Name: associated_policy constraint_farsrpap; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT constraint_farsrpap PRIMARY KEY (policy_id, associated_policy_id);


--
-- Name: resource_policy constraint_farsrpp; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT constraint_farsrpp PRIMARY KEY (resource_id, policy_id);


--
-- Name: resource_server_scope constraint_farsrs; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT constraint_farsrs PRIMARY KEY (id);


--
-- Name: resource_scope constraint_farsrsp; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT constraint_farsrsp PRIMARY KEY (resource_id, scope_id);


--
-- Name: scope_policy constraint_farsrsps; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT constraint_farsrsps PRIMARY KEY (scope_id, policy_id);


--
-- Name: user_entity constraint_fb; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT constraint_fb PRIMARY KEY (id);


--
-- Name: user_federation_mapper_config constraint_fedmapper_cfg_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT constraint_fedmapper_cfg_pm PRIMARY KEY (user_federation_mapper_id, name);


--
-- Name: user_federation_mapper constraint_fedmapperpm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT constraint_fedmapperpm PRIMARY KEY (id);


--
-- Name: fed_user_consent_cl_scope constraint_fgrntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_consent_cl_scope
    ADD CONSTRAINT constraint_fgrntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent_client_scope constraint_grntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT constraint_grntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent constraint_grntcsnt_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT constraint_grntcsnt_pm PRIMARY KEY (id);


--
-- Name: keycloak_group constraint_group; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT constraint_group PRIMARY KEY (id);


--
-- Name: group_attribute constraint_group_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT constraint_group_attribute_pk PRIMARY KEY (id);


--
-- Name: group_role_mapping constraint_group_role; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT constraint_group_role PRIMARY KEY (role_id, group_id);


--
-- Name: identity_provider_mapper constraint_idpm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT constraint_idpm PRIMARY KEY (id);


--
-- Name: idp_mapper_config constraint_idpmconfig; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT constraint_idpmconfig PRIMARY KEY (idp_mapper_id, name);


--
-- Name: jgroups_ping constraint_jgroups_ping; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.jgroups_ping
    ADD CONSTRAINT constraint_jgroups_ping PRIMARY KEY (address);


--
-- Name: migration_model constraint_migmod; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT constraint_migmod PRIMARY KEY (id);


--
-- Name: offline_client_session constraint_offl_cl_ses_pk3; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.offline_client_session
    ADD CONSTRAINT constraint_offl_cl_ses_pk3 PRIMARY KEY (user_session_id, client_id, client_storage_provider, external_client_id, offline_flag);


--
-- Name: offline_user_session constraint_offl_us_ses_pk2; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.offline_user_session
    ADD CONSTRAINT constraint_offl_us_ses_pk2 PRIMARY KEY (user_session_id, offline_flag);


--
-- Name: protocol_mapper constraint_pcm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT constraint_pcm PRIMARY KEY (id);


--
-- Name: protocol_mapper_config constraint_pmconfig; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT constraint_pmconfig PRIMARY KEY (protocol_mapper_id, name);


--
-- Name: redirect_uris constraint_redirect_uris; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT constraint_redirect_uris PRIMARY KEY (client_id, value);


--
-- Name: required_action_config constraint_req_act_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.required_action_config
    ADD CONSTRAINT constraint_req_act_cfg_pk PRIMARY KEY (required_action_id, name);


--
-- Name: required_action_provider constraint_req_act_prv_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT constraint_req_act_prv_pk PRIMARY KEY (id);


--
-- Name: user_required_action constraint_required_action; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT constraint_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: resource_uris constraint_resour_uris_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT constraint_resour_uris_pk PRIMARY KEY (resource_id, value);


--
-- Name: role_attribute constraint_role_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT constraint_role_attribute_pk PRIMARY KEY (id);


--
-- Name: revoked_token constraint_rt; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.revoked_token
    ADD CONSTRAINT constraint_rt PRIMARY KEY (id);


--
-- Name: user_attribute constraint_user_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT constraint_user_attribute_pk PRIMARY KEY (id);


--
-- Name: user_group_membership constraint_user_group; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT constraint_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: web_origins constraint_web_origins; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT constraint_web_origins PRIMARY KEY (client_id, value);


--
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- Name: client_scope_attributes pk_cl_tmpl_attr; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT pk_cl_tmpl_attr PRIMARY KEY (scope_id, name);


--
-- Name: client_scope pk_cli_template; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT pk_cli_template PRIMARY KEY (id);


--
-- Name: resource_server pk_resource_server; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server
    ADD CONSTRAINT pk_resource_server PRIMARY KEY (id);


--
-- Name: client_scope_role_mapping pk_template_scope; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT pk_template_scope PRIMARY KEY (scope_id, role_id);


--
-- Name: default_client_scope r_def_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT r_def_cli_scope_bind PRIMARY KEY (realm_id, scope_id);


--
-- Name: realm_localizations realm_localizations_pkey; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_localizations
    ADD CONSTRAINT realm_localizations_pkey PRIMARY KEY (realm_id, locale);


--
-- Name: resource_attribute res_attr_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT res_attr_pk PRIMARY KEY (id);


--
-- Name: keycloak_group sibling_names; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT sibling_names UNIQUE (realm_id, parent_group, name);


--
-- Name: identity_provider uk_2daelwnibji49avxsrtuf6xj33; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT uk_2daelwnibji49avxsrtuf6xj33 UNIQUE (provider_alias, realm_id);


--
-- Name: client uk_b71cjlbenv945rb6gcon438at; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT uk_b71cjlbenv945rb6gcon438at UNIQUE (realm_id, client_id);


--
-- Name: client_scope uk_cli_scope; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT uk_cli_scope UNIQUE (realm_id, name);


--
-- Name: user_entity uk_dykn684sl8up1crfei6eckhd7; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_dykn684sl8up1crfei6eckhd7 UNIQUE (realm_id, email_constraint);


--
-- Name: user_consent uk_external_consent; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_external_consent UNIQUE (client_storage_provider, external_client_id, user_id);


--
-- Name: resource_server_resource uk_frsr6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5ha6 UNIQUE (name, owner, resource_server_id);


--
-- Name: resource_server_perm_ticket uk_frsr6t700s9v50bu18ws5pmt; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5pmt UNIQUE (owner, requester, resource_server_id, resource_id, scope_id);


--
-- Name: resource_server_policy uk_frsrpt700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT uk_frsrpt700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: resource_server_scope uk_frsrst700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT uk_frsrst700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: user_consent uk_local_consent; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_local_consent UNIQUE (client_id, user_id);


--
-- Name: org uk_org_alias; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT uk_org_alias UNIQUE (realm_id, alias);


--
-- Name: org uk_org_group; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT uk_org_group UNIQUE (group_id);


--
-- Name: org uk_org_name; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT uk_org_name UNIQUE (realm_id, name);


--
-- Name: realm uk_orvsdmla56612eaefiq6wl5oi; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT uk_orvsdmla56612eaefiq6wl5oi UNIQUE (name);


--
-- Name: user_entity uk_ru8tt6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_ru8tt6t700s9v50bu18ws5ha6 UNIQUE (realm_id, username);


--
-- Name: fed_user_attr_long_values; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX fed_user_attr_long_values ON public.fed_user_attribute USING btree (long_value_hash, name);


--
-- Name: fed_user_attr_long_values_lower_case; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX fed_user_attr_long_values_lower_case ON public.fed_user_attribute USING btree (long_value_hash_lower_case, name);


--
-- Name: idx_admin_event_time; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_admin_event_time ON public.admin_event_entity USING btree (realm_id, admin_event_time);


--
-- Name: idx_assoc_pol_assoc_pol_id; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_assoc_pol_assoc_pol_id ON public.associated_policy USING btree (associated_policy_id);


--
-- Name: idx_auth_config_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_config_realm ON public.authenticator_config USING btree (realm_id);


--
-- Name: idx_auth_exec_flow; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_exec_flow ON public.authentication_execution USING btree (flow_id);


--
-- Name: idx_auth_exec_realm_flow; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_exec_realm_flow ON public.authentication_execution USING btree (realm_id, flow_id);


--
-- Name: idx_auth_flow_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_flow_realm ON public.authentication_flow USING btree (realm_id);


--
-- Name: idx_cl_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_cl_clscope ON public.client_scope_client USING btree (scope_id);


--
-- Name: idx_client_att_by_name_value; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_client_att_by_name_value ON public.client_attributes USING btree (name, substr(value, 1, 255));


--
-- Name: idx_client_id; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_client_id ON public.client USING btree (client_id);


--
-- Name: idx_client_init_acc_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_client_init_acc_realm ON public.client_initial_access USING btree (realm_id);


--
-- Name: idx_clscope_attrs; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_attrs ON public.client_scope_attributes USING btree (scope_id);


--
-- Name: idx_clscope_cl; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_cl ON public.client_scope_client USING btree (client_id);


--
-- Name: idx_clscope_protmap; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_protmap ON public.protocol_mapper USING btree (client_scope_id);


--
-- Name: idx_clscope_role; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_role ON public.client_scope_role_mapping USING btree (scope_id);


--
-- Name: idx_compo_config_compo; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_compo_config_compo ON public.component_config USING btree (component_id);


--
-- Name: idx_component_provider_type; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_component_provider_type ON public.component USING btree (provider_type);


--
-- Name: idx_component_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_component_realm ON public.component USING btree (realm_id);


--
-- Name: idx_composite; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_composite ON public.composite_role USING btree (composite);


--
-- Name: idx_composite_child; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_composite_child ON public.composite_role USING btree (child_role);


--
-- Name: idx_defcls_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_defcls_realm ON public.default_client_scope USING btree (realm_id);


--
-- Name: idx_defcls_scope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_defcls_scope ON public.default_client_scope USING btree (scope_id);


--
-- Name: idx_event_time; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_event_time ON public.event_entity USING btree (realm_id, event_time);


--
-- Name: idx_fedidentity_feduser; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fedidentity_feduser ON public.federated_identity USING btree (federated_user_id);


--
-- Name: idx_fedidentity_user; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fedidentity_user ON public.federated_identity USING btree (user_id);


--
-- Name: idx_fu_attribute; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_attribute ON public.fed_user_attribute USING btree (user_id, realm_id, name);


--
-- Name: idx_fu_cnsnt_ext; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_cnsnt_ext ON public.fed_user_consent USING btree (user_id, client_storage_provider, external_client_id);


--
-- Name: idx_fu_consent; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_consent ON public.fed_user_consent USING btree (user_id, client_id);


--
-- Name: idx_fu_consent_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_consent_ru ON public.fed_user_consent USING btree (realm_id, user_id);


--
-- Name: idx_fu_credential; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_credential ON public.fed_user_credential USING btree (user_id, type);


--
-- Name: idx_fu_credential_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_credential_ru ON public.fed_user_credential USING btree (realm_id, user_id);


--
-- Name: idx_fu_group_membership; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_group_membership ON public.fed_user_group_membership USING btree (user_id, group_id);


--
-- Name: idx_fu_group_membership_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_group_membership_ru ON public.fed_user_group_membership USING btree (realm_id, user_id);


--
-- Name: idx_fu_required_action; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_required_action ON public.fed_user_required_action USING btree (user_id, required_action);


--
-- Name: idx_fu_required_action_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_required_action_ru ON public.fed_user_required_action USING btree (realm_id, user_id);


--
-- Name: idx_fu_role_mapping; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_role_mapping ON public.fed_user_role_mapping USING btree (user_id, role_id);


--
-- Name: idx_fu_role_mapping_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_role_mapping_ru ON public.fed_user_role_mapping USING btree (realm_id, user_id);


--
-- Name: idx_group_att_by_name_value; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_group_att_by_name_value ON public.group_attribute USING btree (name, ((value)::character varying(250)));


--
-- Name: idx_group_attr_group; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_group_attr_group ON public.group_attribute USING btree (group_id);


--
-- Name: idx_group_role_mapp_group; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_group_role_mapp_group ON public.group_role_mapping USING btree (group_id);


--
-- Name: idx_id_prov_mapp_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_id_prov_mapp_realm ON public.identity_provider_mapper USING btree (realm_id);


--
-- Name: idx_ident_prov_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_ident_prov_realm ON public.identity_provider USING btree (realm_id);


--
-- Name: idx_idp_for_login; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_idp_for_login ON public.identity_provider USING btree (realm_id, enabled, link_only, hide_on_login, organization_id);


--
-- Name: idx_idp_realm_org; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_idp_realm_org ON public.identity_provider USING btree (realm_id, organization_id);


--
-- Name: idx_keycloak_role_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_keycloak_role_client ON public.keycloak_role USING btree (client);


--
-- Name: idx_keycloak_role_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_keycloak_role_realm ON public.keycloak_role USING btree (realm);


--
-- Name: idx_offline_uss_by_broker_session_id; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_uss_by_broker_session_id ON public.offline_user_session USING btree (broker_session_id, realm_id);


--
-- Name: idx_offline_uss_by_last_session_refresh; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_uss_by_last_session_refresh ON public.offline_user_session USING btree (realm_id, offline_flag, last_session_refresh);


--
-- Name: idx_offline_uss_by_user; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_uss_by_user ON public.offline_user_session USING btree (user_id, realm_id, offline_flag);


--
-- Name: idx_org_domain_org_id; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_org_domain_org_id ON public.org_domain USING btree (org_id);


--
-- Name: idx_perm_ticket_owner; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_perm_ticket_owner ON public.resource_server_perm_ticket USING btree (owner);


--
-- Name: idx_perm_ticket_requester; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_perm_ticket_requester ON public.resource_server_perm_ticket USING btree (requester);


--
-- Name: idx_protocol_mapper_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_protocol_mapper_client ON public.protocol_mapper USING btree (client_id);


--
-- Name: idx_realm_attr_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_attr_realm ON public.realm_attribute USING btree (realm_id);


--
-- Name: idx_realm_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_clscope ON public.client_scope USING btree (realm_id);


--
-- Name: idx_realm_def_grp_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_def_grp_realm ON public.realm_default_groups USING btree (realm_id);


--
-- Name: idx_realm_evt_list_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_evt_list_realm ON public.realm_events_listeners USING btree (realm_id);


--
-- Name: idx_realm_evt_types_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_evt_types_realm ON public.realm_enabled_event_types USING btree (realm_id);


--
-- Name: idx_realm_master_adm_cli; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_master_adm_cli ON public.realm USING btree (master_admin_client);


--
-- Name: idx_realm_supp_local_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_supp_local_realm ON public.realm_supported_locales USING btree (realm_id);


--
-- Name: idx_redir_uri_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_redir_uri_client ON public.redirect_uris USING btree (client_id);


--
-- Name: idx_req_act_prov_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_req_act_prov_realm ON public.required_action_provider USING btree (realm_id);


--
-- Name: idx_res_policy_policy; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_policy_policy ON public.resource_policy USING btree (policy_id);


--
-- Name: idx_res_scope_scope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_scope_scope ON public.resource_scope USING btree (scope_id);


--
-- Name: idx_res_serv_pol_res_serv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_serv_pol_res_serv ON public.resource_server_policy USING btree (resource_server_id);


--
-- Name: idx_res_srv_res_res_srv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_srv_res_res_srv ON public.resource_server_resource USING btree (resource_server_id);


--
-- Name: idx_res_srv_scope_res_srv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_srv_scope_res_srv ON public.resource_server_scope USING btree (resource_server_id);


--
-- Name: idx_rev_token_on_expire; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_rev_token_on_expire ON public.revoked_token USING btree (expire);


--
-- Name: idx_role_attribute; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_role_attribute ON public.role_attribute USING btree (role_id);


--
-- Name: idx_role_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_role_clscope ON public.client_scope_role_mapping USING btree (role_id);


--
-- Name: idx_scope_mapping_role; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_scope_mapping_role ON public.scope_mapping USING btree (role_id);


--
-- Name: idx_scope_policy_policy; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_scope_policy_policy ON public.scope_policy USING btree (policy_id);


--
-- Name: idx_update_time; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_update_time ON public.migration_model USING btree (update_time);


--
-- Name: idx_usconsent_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usconsent_clscope ON public.user_consent_client_scope USING btree (user_consent_id);


--
-- Name: idx_usconsent_scope_id; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usconsent_scope_id ON public.user_consent_client_scope USING btree (scope_id);


--
-- Name: idx_user_attribute; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_attribute ON public.user_attribute USING btree (user_id);


--
-- Name: idx_user_attribute_name; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_attribute_name ON public.user_attribute USING btree (name, value);


--
-- Name: idx_user_consent; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_consent ON public.user_consent USING btree (user_id);


--
-- Name: idx_user_credential; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_credential ON public.credential USING btree (user_id);


--
-- Name: idx_user_email; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_email ON public.user_entity USING btree (email);


--
-- Name: idx_user_group_mapping; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_group_mapping ON public.user_group_membership USING btree (user_id);


--
-- Name: idx_user_reqactions; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_reqactions ON public.user_required_action USING btree (user_id);


--
-- Name: idx_user_role_mapping; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_role_mapping ON public.user_role_mapping USING btree (user_id);


--
-- Name: idx_user_service_account; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_service_account ON public.user_entity USING btree (realm_id, service_account_client_link);


--
-- Name: idx_usr_fed_map_fed_prv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usr_fed_map_fed_prv ON public.user_federation_mapper USING btree (federation_provider_id);


--
-- Name: idx_usr_fed_map_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usr_fed_map_realm ON public.user_federation_mapper USING btree (realm_id);


--
-- Name: idx_usr_fed_prv_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usr_fed_prv_realm ON public.user_federation_provider USING btree (realm_id);


--
-- Name: idx_web_orig_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_web_orig_client ON public.web_origins USING btree (client_id);


--
-- Name: user_attr_long_values; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX user_attr_long_values ON public.user_attribute USING btree (long_value_hash, name);


--
-- Name: user_attr_long_values_lower_case; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX user_attr_long_values_lower_case ON public.user_attribute USING btree (long_value_hash_lower_case, name);


--
-- Name: identity_provider fk2b4ebc52ae5c3b34; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT fk2b4ebc52ae5c3b34 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_attributes fk3c47c64beacca966; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT fk3c47c64beacca966 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: federated_identity fk404288b92ef007a6; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT fk404288b92ef007a6 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_node_registrations fk4129723ba992f594; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT fk4129723ba992f594 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: redirect_uris fk_1burs8pb4ouj97h5wuppahv9f; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT fk_1burs8pb4ouj97h5wuppahv9f FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: user_federation_provider fk_1fj32f6ptolw2qy60cd8n01e8; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT fk_1fj32f6ptolw2qy60cd8n01e8 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_required_credential fk_5hg65lybevavkqfki3kponh9v; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT fk_5hg65lybevavkqfki3kponh9v FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_attribute fk_5hrm2vlf9ql5fu022kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu022kqepovbr FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: user_attribute fk_5hrm2vlf9ql5fu043kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu043kqepovbr FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: user_required_action fk_6qj3w1jw9cvafhe19bwsiuvmd; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT fk_6qj3w1jw9cvafhe19bwsiuvmd FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: keycloak_role fk_6vyqfe4cn4wlq8r6kt5vdsj5c; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT fk_6vyqfe4cn4wlq8r6kt5vdsj5c FOREIGN KEY (realm) REFERENCES public.realm(id);


--
-- Name: realm_smtp_config fk_70ej8xdxgxd0b9hh6180irr0o; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT fk_70ej8xdxgxd0b9hh6180irr0o FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_attribute fk_8shxd6l3e9atqukacxgpffptw; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT fk_8shxd6l3e9atqukacxgpffptw FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: composite_role fk_a63wvekftu8jo1pnj81e7mce2; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_a63wvekftu8jo1pnj81e7mce2 FOREIGN KEY (composite) REFERENCES public.keycloak_role(id);


--
-- Name: authentication_execution fk_auth_exec_flow; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_flow FOREIGN KEY (flow_id) REFERENCES public.authentication_flow(id);


--
-- Name: authentication_execution fk_auth_exec_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authentication_flow fk_auth_flow_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT fk_auth_flow_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authenticator_config fk_auth_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT fk_auth_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_role_mapping fk_c4fqv34p1mbylloxang7b1q3l; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT fk_c4fqv34p1mbylloxang7b1q3l FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_scope_attributes fk_cl_scope_attr_scope; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT fk_cl_scope_attr_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_scope_role_mapping fk_cl_scope_rm_scope; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT fk_cl_scope_rm_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: protocol_mapper fk_cli_scope_mapper; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_cli_scope_mapper FOREIGN KEY (client_scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_initial_access fk_client_init_acc_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT fk_client_init_acc_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: component_config fk_component_config; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT fk_component_config FOREIGN KEY (component_id) REFERENCES public.component(id);


--
-- Name: component fk_component_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT fk_component_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_default_groups fk_def_groups_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT fk_def_groups_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_mapper_config fk_fedmapper_cfg; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT fk_fedmapper_cfg FOREIGN KEY (user_federation_mapper_id) REFERENCES public.user_federation_mapper(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_fedprv; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_fedprv FOREIGN KEY (federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: associated_policy fk_frsr5s213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsr5s213xcx4wnkog82ssrfy FOREIGN KEY (associated_policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrasp13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrasp13xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog82sspmt; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82sspmt FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_resource fk_frsrho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog83sspmt; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog83sspmt FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog84sspmt; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog84sspmt FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: associated_policy fk_frsrpas14xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsrpas14xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrpass3xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrpass3xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_perm_ticket fk_frsrpo2128cx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrpo2128cx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_policy fk_frsrpo213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT fk_frsrpo213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_scope fk_frsrpos13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrpos13xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpos53xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpos53xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpp213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpp213xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_scope fk_frsrps213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrps213xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_scope fk_frsrso213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT fk_frsrso213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: composite_role fk_gr7thllb9lu8q4vqa4524jjy8; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_gr7thllb9lu8q4vqa4524jjy8 FOREIGN KEY (child_role) REFERENCES public.keycloak_role(id);


--
-- Name: user_consent_client_scope fk_grntcsnt_clsc_usc; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT fk_grntcsnt_clsc_usc FOREIGN KEY (user_consent_id) REFERENCES public.user_consent(id);


--
-- Name: user_consent fk_grntcsnt_user; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT fk_grntcsnt_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: group_attribute fk_group_attribute_group; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT fk_group_attribute_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: group_role_mapping fk_group_role_group; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT fk_group_role_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: realm_enabled_event_types fk_h846o4h0w8epx5nwedrf5y69j; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT fk_h846o4h0w8epx5nwedrf5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_events_listeners fk_h846o4h0w8epx5nxev9f5y69j; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT fk_h846o4h0w8epx5nxev9f5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: identity_provider_mapper fk_idpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT fk_idpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: idp_mapper_config fk_idpmconfig; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT fk_idpmconfig FOREIGN KEY (idp_mapper_id) REFERENCES public.identity_provider_mapper(id);


--
-- Name: web_origins fk_lojpho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT fk_lojpho213xcx4wnkog82ssrfy FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: scope_mapping fk_ouse064plmlr732lxjcn1q5f1; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT fk_ouse064plmlr732lxjcn1q5f1 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: protocol_mapper fk_pcm_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_pcm_realm FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: credential fk_pfyr0glasqyl0dei3kl69r6v0; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT fk_pfyr0glasqyl0dei3kl69r6v0 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: protocol_mapper_config fk_pmconfig; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT fk_pmconfig FOREIGN KEY (protocol_mapper_id) REFERENCES public.protocol_mapper(id);


--
-- Name: default_client_scope fk_r_def_cli_scope_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT fk_r_def_cli_scope_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: required_action_provider fk_req_act_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT fk_req_act_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_uris fk_resource_server_uris; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT fk_resource_server_uris FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: role_attribute fk_role_attribute_id; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT fk_role_attribute_id FOREIGN KEY (role_id) REFERENCES public.keycloak_role(id);


--
-- Name: realm_supported_locales fk_supported_locales_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT fk_supported_locales_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_config fk_t13hpu1j94r2ebpekr39x5eu5; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT fk_t13hpu1j94r2ebpekr39x5eu5 FOREIGN KEY (user_federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_group_membership fk_user_group_user; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT fk_user_group_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: policy_config fkdc34197cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT fkdc34197cf864c4e43 FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: identity_provider_config fkdc4897cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT fkdc4897cf864c4e43 FOREIGN KEY (identity_provider_id) REFERENCES public.identity_provider(internal_id);


--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.13 (Debian 15.13-1.pgdg120+1)
-- Dumped by pg_dump version 15.13 (Debian 15.13-1.pgdg120+1)

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
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

