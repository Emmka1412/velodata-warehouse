DROP SCHEMA IF EXISTS bronze, silver, gold, ops CASCADE;
CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;
CREATE SCHEMA ops;

CREATE TABLE ops.etl_log (
  run_id      BIGSERIAL PRIMARY KEY,
  layer       TEXT NOT NULL,
  table_name  TEXT NOT NULL,
  rows_loaded BIGINT,
  started_at  TIMESTAMPTZ NOT NULL,
  ended_at    TIMESTAMPTZ NOT NULL,
  duration_ms NUMERIC GENERATED ALWAYS AS
    (EXTRACT(EPOCH FROM ended_at - started_at) * 1000) STORED
);