-- 変更履歴テーブル
CREATE TABLE IF NOT EXISTS change_logs (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  client_name   text,
  source_type   text NOT NULL,
  source_id     text NOT NULL,
  change_type   text NOT NULL,
  before_value  text,
  after_value   text,
  note          text,
  thread_id     uuid REFERENCES chat_threads(id),
  created_by    text,
  created_at    timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_change_logs_client ON change_logs (client_name, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_change_logs_source ON change_logs (source_type, source_id);

ALTER TABLE change_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow all for authenticated" ON change_logs
  FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);
