-- チームチャット: チャンネル
CREATE TABLE IF NOT EXISTS team_channels (
  id          uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  name        text NOT NULL,
  client_name text,
  created_at  timestamptz DEFAULT now()
);

-- チームチャット: メッセージ
CREATE TABLE IF NOT EXISTS team_messages (
  id              uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  channel_id      uuid NOT NULL REFERENCES team_channels(id) ON DELETE CASCADE,
  user_id         uuid NOT NULL REFERENCES users(id),
  user_name       text NOT NULL,
  content         text NOT NULL,
  reply_to_id     uuid REFERENCES team_messages(id) ON DELETE SET NULL,
  attachment_type text,
  attachment_id   uuid,
  created_at      timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_team_messages_channel ON team_messages(channel_id, created_at);
CREATE INDEX IF NOT EXISTS idx_team_messages_reply ON team_messages(reply_to_id);

-- 未読管理
CREATE TABLE IF NOT EXISTS team_read_status (
  user_id      uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  channel_id   uuid NOT NULL REFERENCES team_channels(id) ON DELETE CASCADE,
  last_read_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, channel_id)
);

-- チャンネルメンバー
CREATE TABLE IF NOT EXISTS team_channel_members (
  channel_id  uuid NOT NULL REFERENCES team_channels(id) ON DELETE CASCADE,
  user_id     uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  joined_at   timestamptz DEFAULT now(),
  PRIMARY KEY (channel_id, user_id)
);

-- Push通知サブスクリプション
CREATE TABLE IF NOT EXISTS push_subscriptions (
  id          uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id     uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  endpoint    text NOT NULL UNIQUE,
  p256dh      text NOT NULL,
  auth        text NOT NULL,
  enabled     boolean DEFAULT true,
  user_agent  text,
  created_at  timestamptz DEFAULT now(),
  updated_at  timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_push_subs_user ON push_subscriptions(user_id, enabled);

-- デフォルト全体チャンネル
INSERT INTO team_channels (name, client_name) VALUES ('全体', NULL) ON CONFLICT DO NOTHING;

-- Realtime有効化
ALTER PUBLICATION supabase_realtime ADD TABLE team_messages;

-- RLS
ALTER TABLE team_channels ENABLE ROW LEVEL SECURITY;
CREATE POLICY "team_channels_all" ON team_channels FOR ALL USING (true) WITH CHECK (true);

ALTER TABLE team_messages ENABLE ROW LEVEL SECURITY;
CREATE POLICY "team_messages_all" ON team_messages FOR ALL USING (true) WITH CHECK (true);

ALTER TABLE team_read_status ENABLE ROW LEVEL SECURITY;
CREATE POLICY "team_read_status_all" ON team_read_status FOR ALL USING (true) WITH CHECK (true);

ALTER TABLE team_channel_members ENABLE ROW LEVEL SECURITY;
CREATE POLICY "team_channel_members_all" ON team_channel_members FOR ALL USING (true) WITH CHECK (true);

ALTER TABLE push_subscriptions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "push_subscriptions_all" ON push_subscriptions FOR ALL USING (true) WITH CHECK (true);
