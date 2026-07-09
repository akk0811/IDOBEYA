-- IDOBEYA: 管理者権限・コンテンツ削除・ミュート対応の拡張
-- 何度実行しても大丈夫なよう、既存ポリシーは削除してから再作成する

-- 管理者判定ヘルパー
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT COALESCE((SELECT is_admin FROM profiles WHERE id = auth.uid()), false);
$$;

-- 通報: 管理者は全件閲覧・更新可能
DROP POLICY IF EXISTS "reports_select_admin" ON reports;
CREATE POLICY "reports_select_admin" ON reports
    FOR SELECT USING (is_admin());
DROP POLICY IF EXISTS "reports_update_admin" ON reports;
CREATE POLICY "reports_update_admin" ON reports
    FOR UPDATE USING (is_admin());

-- 部屋: 管理者は停止・削除可能
DROP POLICY IF EXISTS "rooms_update_admin" ON rooms;
CREATE POLICY "rooms_update_admin" ON rooms
    FOR UPDATE USING (is_admin());

-- プロフィール: 管理者はアカウント停止可能
DROP POLICY IF EXISTS "profiles_update_admin" ON profiles;
CREATE POLICY "profiles_update_admin" ON profiles
    FOR UPDATE USING (is_admin());

-- スレッド・返信・チャット: 自分の削除 + 管理者の削除
DROP POLICY IF EXISTS "threads_update_admin" ON threads;
CREATE POLICY "threads_update_admin" ON threads
    FOR UPDATE USING (is_admin());

DROP POLICY IF EXISTS "thread_replies_update_own" ON thread_replies;
CREATE POLICY "thread_replies_update_own" ON thread_replies
    FOR UPDATE USING (auth.uid() = user_id);
DROP POLICY IF EXISTS "thread_replies_update_admin" ON thread_replies;
CREATE POLICY "thread_replies_update_admin" ON thread_replies
    FOR UPDATE USING (is_admin());

DROP POLICY IF EXISTS "chat_messages_update_own" ON chat_messages;
CREATE POLICY "chat_messages_update_own" ON chat_messages
    FOR UPDATE USING (auth.uid() = user_id);
DROP POLICY IF EXISTS "chat_messages_update_admin" ON chat_messages;
CREATE POLICY "chat_messages_update_admin" ON chat_messages
    FOR UPDATE USING (is_admin());
