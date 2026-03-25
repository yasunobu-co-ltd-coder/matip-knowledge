-- 顧客マスタ
CREATE TABLE IF NOT EXISTS clients (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name        text NOT NULL,
  notes       text,
  created_by  uuid REFERENCES users(id),
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_clients_name ON clients (name);

-- 名寄せ用別名
CREATE TABLE IF NOT EXISTS client_aliases (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  client_id   uuid NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
  alias       text NOT NULL,
  created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_client_aliases_alias ON client_aliases (alias);
CREATE INDEX IF NOT EXISTS idx_client_aliases_client ON client_aliases (client_id);

-- 名寄せ解決関数
CREATE OR REPLACE FUNCTION resolve_client_name(input_name text)
RETURNS uuid
LANGUAGE sql STABLE AS $$
  SELECT COALESCE(
    (SELECT id FROM clients WHERE name = input_name),
    (SELECT client_id FROM client_aliases WHERE alias = input_name)
  );
$$;

-- updated_at 自動更新
CREATE TRIGGER trg_clients_updated_at
  BEFORE UPDATE ON clients FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- RLS
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow all for authenticated" ON clients
  FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);

ALTER TABLE client_aliases ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow all for authenticated" ON client_aliases
  FOR ALL TO anon, authenticated USING (true) WITH CHECK (true);
