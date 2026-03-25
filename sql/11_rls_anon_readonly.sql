-- RLSポリシー: anon = SELECT のみ（service_roleはRLSバイパス）

-- todos
DROP POLICY IF EXISTS "Allow all for authenticated" ON todos;
CREATE POLICY "todos_select_anon" ON todos FOR SELECT USING (true);

-- decisions
DROP POLICY IF EXISTS "Allow all for authenticated" ON decisions;
CREATE POLICY "decisions_select_anon" ON decisions FOR SELECT USING (true);

-- clients
DROP POLICY IF EXISTS "Allow all for authenticated" ON clients;
CREATE POLICY "clients_select_anon" ON clients FOR SELECT USING (true);

-- client_aliases
DROP POLICY IF EXISTS "Allow all for authenticated" ON client_aliases;
CREATE POLICY "client_aliases_select_anon" ON client_aliases FOR SELECT USING (true);

-- change_logs
DROP POLICY IF EXISTS "Allow all for authenticated" ON change_logs;
CREATE POLICY "change_logs_select_anon" ON change_logs FOR SELECT USING (true);

-- chat_threads
DROP POLICY IF EXISTS "Allow all for authenticated" ON chat_threads;
CREATE POLICY "chat_threads_select_anon" ON chat_threads FOR SELECT USING (true);

-- chat_messages
DROP POLICY IF EXISTS "Allow all for authenticated" ON chat_messages;
CREATE POLICY "chat_messages_select_anon" ON chat_messages FOR SELECT USING (true);

-- team_channels
DROP POLICY IF EXISTS "team_channels_all" ON team_channels;
CREATE POLICY "team_channels_select_anon" ON team_channels FOR SELECT USING (true);

-- team_messages
DROP POLICY IF EXISTS "team_messages_all" ON team_messages;
CREATE POLICY "team_messages_select_anon" ON team_messages FOR SELECT USING (true);

-- team_read_status
DROP POLICY IF EXISTS "team_read_status_all" ON team_read_status;
CREATE POLICY "team_read_status_select_anon" ON team_read_status FOR SELECT USING (true);

-- team_channel_members
DROP POLICY IF EXISTS "team_channel_members_all" ON team_channel_members;
CREATE POLICY "team_channel_members_select_anon" ON team_channel_members FOR SELECT USING (true);

-- push_subscriptions
DROP POLICY IF EXISTS "push_subscriptions_all" ON push_subscriptions;
CREATE POLICY "push_subscriptions_select_anon" ON push_subscriptions FOR SELECT USING (true);
