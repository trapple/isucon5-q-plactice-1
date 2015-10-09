ALTER TABLE comments ADD INDEX index_user_id(user_id);

ALTER TABLE comments ADD COLUMN entry_user_id INT NOT NULL;
ALTER TABLE comments ADD INDEX index_entry_user_id(entry_user_id);
UPDATE comments SET entry_user_id = (SELECT user_id FROM entries WHERE id = entry_id);

ALTER TABLE comments ADD COLUMN entry_private INT NOT NULL;
UPDATE comments SET entry_private = (SELECT private FROM entries WHERE id = entry_id);
