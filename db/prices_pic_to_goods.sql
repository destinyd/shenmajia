INSERT INTO uploads (id,uploadable_id) SELECT uploads.id,prices.good_id FROM uploads INNER JOIN prices ON uploadable_id = prices.id AND uploadable_type = 'Price' ON DUPLICATE KEY UPDATE uploadable_id = prices.good_id,uploadable_type = 'Good';
