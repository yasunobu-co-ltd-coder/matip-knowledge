-- TODO追跡テーブル
CREATE TABLE IF NOT EXISTS todos (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  source_type text NOT NULL CHECK (source_type IN ('memo', 'minutes')),
  source_id   text NOT NULL,
  content     text NOT NULL,
  assignee    uuid REFERENCES users(id),
  due_date    date,
  status      text NOT NULL DEFAULT 'open'
              CHECK (status IN ('open', 'in_progress', 'done', 'cancelled')),
  sort_order  integer DEFAULT 0,
  client_name text,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_todos_source ON todos (source_type, source_id);
CREATE INDEX IF NOT EXISTS idx_todos_open ON todos (status, due_date) WHERE status NOT IN ('done', 'cancelled');
CREATE INDEX IF NOT EXISTS idx_todos_assignee ON todos (assignee) WHERE status NOT IN ('done', 'cancelled');
CREATE INDEX IF NOT EXISTS idx_todos_client ON todos (client_name) WHERE status NOT IN ('done', 'cancelled');

CREATE TRIGGER trg_todos_updated_at
  BEFORE UPDATE ON todos FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

ALTER TABLE todos ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow all for authenticated" ON todos
  FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);
