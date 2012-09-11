INSERT INTO costs (`money`,`user_id`,`updated_at`,`created_at`) SELECT price,user_id,updated_at,created_at FROM prices WHERE id <= 295630 and type_id between 0 and 1 and user_id between 2 and 3
