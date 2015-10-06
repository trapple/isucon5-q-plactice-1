ALTER TABLE entries ADD COLUMN comments_count INT not null default 0;
UPDATE entries SET comments_count = (SELECT COUNT(*) FROM comments WHERE entry_id = id);
