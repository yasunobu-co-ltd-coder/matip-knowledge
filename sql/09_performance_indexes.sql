-- matip-memo
CREATE INDEX IF NOT EXISTS idx_memo_client_name ON "matip-memo"(client_name);
CREATE INDEX IF NOT EXISTS idx_memo_due_date ON "matip-memo"(due_date) WHERE due_date IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_memo_created_at ON "matip-memo"(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_memo_status ON "matip-memo"(status);

-- pocket-matip
CREATE INDEX IF NOT EXISTS idx_pocket_client_name ON "pocket-matip"(client_name);
CREATE INDEX IF NOT EXISTS idx_pocket_next_schedule ON "pocket-matip"(next_schedule) WHERE next_schedule IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_pocket_created_at ON "pocket-matip"(created_at DESC);

-- todos
CREATE INDEX IF NOT EXISTS idx_todos_client_status ON todos(client_name, status);
CREATE INDEX IF NOT EXISTS idx_todos_due_date ON todos(due_date) WHERE due_date IS NOT NULL;

-- decisions
CREATE INDEX IF NOT EXISTS idx_decisions_client_status ON decisions(client_name, status);

-- change_logs
CREATE INDEX IF NOT EXISTS idx_changelogs_client ON change_logs(client_name, created_at DESC);

-- chat
CREATE INDEX IF NOT EXISTS idx_threads_client ON chat_threads(client_name, updated_at DESC);
CREATE INDEX IF NOT EXISTS idx_chatmsg_thread ON chat_messages(thread_id, created_at DESC);

-- team chat
CREATE INDEX IF NOT EXISTS idx_teammsg_channel_created ON team_messages(channel_id, created_at);
CREATE INDEX IF NOT EXISTS idx_teammsg_channel_user ON team_messages(channel_id, user_id, created_at);
CREATE INDEX IF NOT EXISTS idx_readstatus_user ON team_read_status(user_id);
