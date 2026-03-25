-- client_name を clients テーブルに自動追加するトリガー
CREATE OR REPLACE FUNCTION sync_client_name()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.client_name IS NOT NULL AND NEW.client_name != '' THEN
    IF NOT EXISTS (SELECT 1 FROM clients WHERE name = NEW.client_name)
       AND NOT EXISTS (SELECT 1 FROM client_aliases WHERE alias = NEW.client_name)
    THEN
      INSERT INTO clients (name)
      VALUES (NEW.client_name)
      ON CONFLICT (name) DO NOTHING;
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- matip-memo INSERT
CREATE TRIGGER trg_memo_sync_client
  AFTER INSERT ON "matip-memo"
  FOR EACH ROW EXECUTE FUNCTION sync_client_name();

-- pocket-matip INSERT
CREATE TRIGGER trg_pocket_sync_client
  AFTER INSERT ON "pocket-matip"
  FOR EACH ROW EXECUTE FUNCTION sync_client_name();

-- matip-memo UPDATE
CREATE TRIGGER trg_memo_sync_client_update
  AFTER UPDATE OF client_name ON "matip-memo"
  FOR EACH ROW
  WHEN (NEW.client_name IS DISTINCT FROM OLD.client_name)
  EXECUTE FUNCTION sync_client_name();

-- pocket-matip UPDATE
CREATE TRIGGER trg_pocket_sync_client_update
  AFTER UPDATE OF client_name ON "pocket-matip"
  FOR EACH ROW
  WHEN (NEW.client_name IS DISTINCT FROM OLD.client_name)
  EXECUTE FUNCTION sync_client_name();
