-- 決定事項追跡テーブル
CREATE TABLE IF NOT EXISTS decisions (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  source_type text NOT NULL CHECK (source_type IN ('memo', 'minutes')),
  source_id   text NOT NULL,
  content     text NOT NULL,
  status      text NOT NULL DEFAULT 'active'
              CHECK (status IN ('active', 'revised', 'cancelled')),
  revised_by  uuid REFERENCES decisions(id),
  sort_order  integer DEFAULT 0,
  client_name text,
  created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_decisions_source ON decisions (source_type, source_id);
CREATE INDEX IF NOT EXISTS idx_decisions_active ON decisions (client_name, status) WHERE status = 'active';

ALTER TABLE decisions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow all for authenticated" ON decisions
  FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);
