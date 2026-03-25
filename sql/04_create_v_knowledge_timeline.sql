-- 名寄せ解決関数
CREATE OR REPLACE FUNCTION resolve_client_display_name(input_name text)
RETURNS text
LANGUAGE sql STABLE AS $$
  SELECT COALESCE(
    (SELECT c.name FROM client_aliases a JOIN clients c ON c.id = a.client_id WHERE a.alias = input_name),
    (SELECT name FROM clients WHERE name = input_name),
    input_name
  );
$$;

-- 横断View: matip-memo + pocket-matip
CREATE OR REPLACE VIEW v_knowledge_timeline AS

SELECT
  m.id::text                        AS id,
  'memo'::text                      AS source_type,
  resolve_client_display_name(m.client_name) AS client_name,
  m.memo                            AS body,
  NULL::text                        AS summary,
  NULL::text                        AS transcript,
  m.status,
  m.importance,
  m.profit,
  m.urgency,
  m.due_date::text                  AS due_date,
  m.assignment_type,
  m.assignee::text                  AS assignee,
  m.created_by::text                AS user_id,
  NULL::jsonb                       AS decisions_json,
  NULL::jsonb                       AS todos_json,
  NULL::jsonb                       AS keywords,
  NULL::text                        AS next_schedule,
  m.created_at
FROM "matip-memo" m

UNION ALL

SELECT
  p.id::text                        AS id,
  'minutes'::text                   AS source_type,
  resolve_client_display_name(p.client_name) AS client_name,
  NULL::text                        AS body,
  p.summary,
  p.transcript,
  'done'::text                      AS status,
  NULL::text                        AS importance,
  NULL::text                        AS profit,
  NULL::text                        AS urgency,
  NULL::text                        AS due_date,
  NULL::text                        AS assignment_type,
  NULL::text                        AS assignee,
  p.user_id::text                   AS user_id,
  p.decisions                       AS decisions_json,
  p.todos                           AS todos_json,
  p.keywords::jsonb                 AS keywords,
  p.next_schedule::text             AS next_schedule,
  p.created_at
FROM "pocket-matip" p;

-- インデックス
CREATE INDEX IF NOT EXISTS idx_memo_client_name ON "matip-memo" (client_name);
CREATE INDEX IF NOT EXISTS idx_memo_created_at ON "matip-memo" (created_at DESC);
CREATE INDEX IF NOT EXISTS idx_pocket_client_name ON "pocket-matip" (client_name);
CREATE INDEX IF NOT EXISTS idx_pocket_created_at ON "pocket-matip" (created_at DESC);
