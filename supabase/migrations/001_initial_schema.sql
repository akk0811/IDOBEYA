-- IDOBEYA（イドベヤ）初期スキーマ
-- Supabase ダッシュボードの SQL Editor で実行するか、supabase db push で適用

-- 列挙型
CREATE TYPE room_visibility AS ENUM ('public', 'invite_only', 'private');
CREATE TYPE room_status AS ENUM ('active', 'suspended', 'deleted');
CREATE TYPE account_status AS ENUM ('active', 'suspended', 'deleted');
CREATE TYPE report_target_type AS ENUM ('user', 'post', 'thread', 'message', 'room');
CREATE TYPE report_status AS ENUM ('pending', 'reviewing', 'resolved', 'dismissed');

-- プロフィール（auth.users と 1:1）
CREATE TABLE profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT,
    display_name TEXT NOT NULL DEFAULT 'ユーザー',
    account_status account_status NOT NULL DEFAULT 'active',
    is_admin BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 部屋
CREATE TABLE rooms (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT NOT NULL DEFAULT '',
    visibility room_visibility NOT NULL,
    creator_id UUID NOT NULL REFERENCES profiles(id),
    status room_status NOT NULL DEFAULT 'active',
    invite_code TEXT UNIQUE,
    category TEXT,
    member_count INT NOT NULL DEFAULT 0,
    report_count INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_rooms_visibility ON rooms(visibility) WHERE status = 'active';
CREATE INDEX idx_rooms_created_at ON rooms(created_at DESC);

-- 部屋メンバー（部屋ごとの表示名を含む）
CREATE TABLE room_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    room_id UUID NOT NULL REFERENCES rooms(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    room_display_name TEXT NOT NULL,
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(room_id, user_id)
);

CREATE INDEX idx_room_members_user ON room_members(user_id);

-- 公開部屋：スレッド
CREATE TABLE threads (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    room_id UUID NOT NULL REFERENCES rooms(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES profiles(id),
    room_display_name TEXT NOT NULL,
    title TEXT NOT NULL,
    body TEXT NOT NULL DEFAULT '',
    reply_count INT NOT NULL DEFAULT 0,
    report_count INT NOT NULL DEFAULT 0,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_threads_room ON threads(room_id, created_at DESC) WHERE is_deleted = FALSE;

-- スレッド返信
CREATE TABLE thread_replies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    thread_id UUID NOT NULL REFERENCES threads(id) ON DELETE CASCADE,
    room_id UUID NOT NULL REFERENCES rooms(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES profiles(id),
    room_display_name TEXT NOT NULL,
    body TEXT NOT NULL,
    report_count INT NOT NULL DEFAULT 0,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_thread_replies_thread ON thread_replies(thread_id, created_at);

-- 招待制・非公開部屋：チャット
CREATE TABLE chat_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    room_id UUID NOT NULL REFERENCES rooms(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES profiles(id),
    room_display_name TEXT NOT NULL,
    body TEXT NOT NULL,
    report_count INT NOT NULL DEFAULT 0,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_chat_messages_room ON chat_messages(room_id, created_at);

-- ブロック
CREATE TABLE blocks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    blocker_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    blocked_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(blocker_id, blocked_id)
);

-- ミュート
CREATE TABLE mutes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    muter_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    muted_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(muter_id, muted_id)
);

-- 通報
CREATE TABLE reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reporter_id UUID NOT NULL REFERENCES profiles(id),
    target_type report_target_type NOT NULL,
    target_user_id UUID REFERENCES profiles(id),
    target_room_id UUID REFERENCES rooms(id),
    target_thread_id UUID REFERENCES threads(id),
    target_reply_id UUID REFERENCES thread_replies(id),
    target_message_id UUID REFERENCES chat_messages(id),
    reason TEXT NOT NULL,
    status report_status NOT NULL DEFAULT 'pending',
    admin_note TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    resolved_at TIMESTAMPTZ
);

CREATE INDEX idx_reports_status ON reports(status, created_at DESC);

-- 新規ユーザー登録時にプロフィール自動作成
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO profiles (id, email, display_name)
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'display_name', 'ユーザー')
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- メンバー数更新
CREATE OR REPLACE FUNCTION update_room_member_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE rooms SET member_count = member_count + 1 WHERE id = NEW.room_id;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE rooms SET member_count = member_count - 1 WHERE id = OLD.room_id;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_room_member_change
    AFTER INSERT OR DELETE ON room_members
    FOR EACH ROW EXECUTE FUNCTION update_room_member_count();

-- 返信数更新
CREATE OR REPLACE FUNCTION update_thread_reply_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE threads SET reply_count = reply_count + 1 WHERE id = NEW.thread_id;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE threads SET reply_count = reply_count - 1 WHERE id = OLD.thread_id;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_thread_reply_change
    AFTER INSERT OR DELETE ON thread_replies
    FOR EACH ROW EXECUTE FUNCTION update_thread_reply_count();

-- RLS 有効化
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE rooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE room_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE threads ENABLE ROW LEVEL SECURITY;
ALTER TABLE thread_replies ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE blocks ENABLE ROW LEVEL SECURITY;
ALTER TABLE mutes ENABLE ROW LEVEL SECURITY;
ALTER TABLE reports ENABLE ROW LEVEL SECURITY;

-- プロフィール: 自分は読み書き、他人は読み取りのみ
CREATE POLICY "profiles_select" ON profiles FOR SELECT USING (true);
CREATE POLICY "profiles_update_own" ON profiles FOR UPDATE USING (auth.uid() = id);

-- 部屋: 公開は誰でも閲覧、招待制・非公開はメンバーのみ
CREATE POLICY "rooms_select_public" ON rooms FOR SELECT
    USING (visibility = 'public' AND status = 'active');
CREATE POLICY "rooms_select_member" ON rooms FOR SELECT
    USING (
        status = 'active' AND EXISTS (
            SELECT 1 FROM room_members WHERE room_id = rooms.id AND user_id = auth.uid()
        )
    );
CREATE POLICY "rooms_insert" ON rooms FOR INSERT
    WITH CHECK (auth.uid() = creator_id);
CREATE POLICY "rooms_update_creator" ON rooms FOR UPDATE
    USING (auth.uid() = creator_id);

-- メンバー
CREATE POLICY "room_members_select" ON room_members FOR SELECT
    USING (
        user_id = auth.uid() OR EXISTS (
            SELECT 1 FROM room_members rm WHERE rm.room_id = room_members.room_id AND rm.user_id = auth.uid()
        )
    );
CREATE POLICY "room_members_insert" ON room_members FOR INSERT
    WITH CHECK (auth.uid() = user_id);
CREATE POLICY "room_members_update_own" ON room_members FOR UPDATE
    USING (auth.uid() = user_id);
CREATE POLICY "room_members_delete_own" ON room_members FOR DELETE
    USING (auth.uid() = user_id);

-- スレッド（公開部屋のメンバーのみ）
CREATE POLICY "threads_select" ON threads FOR SELECT
    USING (EXISTS (SELECT 1 FROM room_members WHERE room_id = threads.room_id AND user_id = auth.uid()));
CREATE POLICY "threads_insert" ON threads FOR INSERT
    WITH CHECK (auth.uid() = user_id);
CREATE POLICY "threads_update_own" ON threads FOR UPDATE
    USING (auth.uid() = user_id);

-- 返信
CREATE POLICY "thread_replies_select" ON thread_replies FOR SELECT
    USING (EXISTS (SELECT 1 FROM room_members WHERE room_id = thread_replies.room_id AND user_id = auth.uid()));
CREATE POLICY "thread_replies_insert" ON thread_replies FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- チャット
CREATE POLICY "chat_messages_select" ON chat_messages FOR SELECT
    USING (EXISTS (SELECT 1 FROM room_members WHERE room_id = chat_messages.room_id AND user_id = auth.uid()));
CREATE POLICY "chat_messages_insert" ON chat_messages FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- ブロック・ミュート
CREATE POLICY "blocks_all" ON blocks FOR ALL USING (auth.uid() = blocker_id);
CREATE POLICY "mutes_all" ON mutes FOR ALL USING (auth.uid() = muter_id);

-- 通報
CREATE POLICY "reports_insert" ON reports FOR INSERT WITH CHECK (auth.uid() = reporter_id);
CREATE POLICY "reports_select_own" ON reports FOR SELECT USING (auth.uid() = reporter_id);

-- Realtime（チャット用）
ALTER PUBLICATION supabase_realtime ADD TABLE chat_messages;
ALTER PUBLICATION supabase_realtime ADD TABLE thread_replies;
