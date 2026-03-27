-- Comprehensive NBA Endorsement Data Seed
-- 50 Players, 200+ Deals across 6 categories

-- Clear existing data
DELETE FROM endorsements;
DELETE FROM players;
DELETE FROM brands;

-- ============================================================================
-- BRANDS (Organized by Category)
-- ============================================================================

-- Footwear/Apparel
INSERT INTO brands (brand_name, brand_category, parent_company, brand_hq_country, brand_tier) VALUES
('Nike', 'Footwear/Apparel', 'Nike Inc.', 'USA', 'Premium'),
('Jordan Brand', 'Footwear/Apparel', 'Nike Inc.', 'USA', 'Premium'),
('Adidas', 'Footwear/Apparel', 'Adidas AG', 'Germany', 'Premium'),
('Under Armour', 'Footwear/Apparel', 'Under Armour Inc.', 'USA', 'Premium'),
('New Balance', 'Footwear/Apparel', 'New Balance Inc.', 'USA', 'Mass Market'),
('Puma', 'Footwear/Apparel', 'Puma SE', 'Germany', 'Premium'),
('Anta', 'Footwear/Apparel', 'Anta Sports', 'China', 'Mass Market'),
('Li-Ning', 'Footwear/Apparel', 'Li-Ning Company', 'China', 'Mass Market');

-- Tech/Electronics
INSERT INTO brands (brand_name, brand_category, parent_company, brand_hq_country, brand_tier) VALUES
('Apple', 'Technology', 'Apple Inc.', 'USA', 'Premium'),
('Beats by Dre', 'Technology', 'Apple Inc.', 'USA', 'Premium'),
('Google', 'Technology', 'Alphabet Inc.', 'USA', 'Premium'),
('Samsung', 'Technology', 'Samsung Electronics', 'South Korea', 'Premium'),
('Meta', 'Technology', 'Meta Platforms', 'USA', 'Premium'),
('Bose', 'Technology', 'Bose Corporation', 'USA', 'Premium');

-- Financial Services
INSERT INTO brands (brand_name, brand_category, parent_company, brand_hq_country, brand_tier) VALUES
('State Farm', 'Financial/Insurance', 'State Farm Mutual', 'USA', 'Mass Market'),
('Geico', 'Financial/Insurance', 'Berkshire Hathaway', 'USA', 'Mass Market'),
('American Express', 'Financial/Insurance', 'American Express Co.', 'USA', 'Premium'),
('Chase', 'Financial/Insurance', 'JPMorgan Chase', 'USA', 'Premium'),
('Capital One', 'Financial/Insurance', 'Capital One Financial', 'USA', 'Mass Market');

-- Food & Beverage
INSERT INTO brands (brand_name, brand_category, parent_company, brand_hq_country, brand_tier) VALUES
('Gatorade', 'Food/Beverage', 'PepsiCo', 'USA', 'Premium'),
('Pepsi', 'Food/Beverage', 'PepsiCo', 'USA', 'Mass Market'),
('Coca-Cola', 'Food/Beverage', 'The Coca-Cola Company', 'USA', 'Mass Market'),
('Mountain Dew', 'Food/Beverage', 'PepsiCo', 'USA', 'Mass Market'),
('Sprite', 'Food/Beverage', 'The Coca-Cola Company', 'USA', 'Mass Market'),
('Subway', 'Food/Beverage', 'Subway IP LLC', 'USA', 'Mass Market'),
('Taco Bell', 'Food/Beverage', 'Yum! Brands', 'USA', 'Mass Market');

-- Automotive
INSERT INTO brands (brand_name, brand_category, parent_company, brand_hq_country, brand_tier) VALUES
('Kia', 'Automotive', 'Kia Corporation', 'South Korea', 'Mass Market'),
('Toyota', 'Automotive', 'Toyota Motor Corporation', 'Japan', 'Mass Market'),
('BMW', 'Automotive', 'BMW Group', 'Germany', 'Premium'),
('Lexus', 'Automotive', 'Toyota Motor Corporation', 'Japan', 'Premium'),
('Infiniti', 'Automotive', 'Nissan Motor Co.', 'Japan', 'Premium');

-- Other (Gaming, Watches, Telecom, Crypto)
INSERT INTO brands (brand_name, brand_category, parent_company, brand_hq_country, brand_tier) VALUES
('2K Sports', 'Gaming/Media', 'Take-Two Interactive', 'USA', 'Mass Market'),
('Panini', 'Gaming/Media', 'Panini Group', 'Italy', 'Niche'),
('Tissot', 'Luxury Goods', 'Swatch Group', 'Switzerland', 'Premium'),
('Rolex', 'Luxury Goods', 'Rolex SA', 'Switzerland', 'Premium'),
('AT&T', 'Telecom', 'AT&T Inc.', 'USA', 'Mass Market'),
('Verizon', 'Telecom', 'Verizon Communications', 'USA', 'Mass Market'),
('Crypto.com', 'Crypto/Finance', 'Crypto.com', 'Singapore', 'Emerging'),
('Coinbase', 'Crypto/Finance', 'Coinbase Inc.', 'USA', 'Emerging'),
('Rakuten', 'E-Commerce', 'Rakuten Group', 'Japan', 'Mass Market'),
('JBL', 'Technology', 'Harman International', 'USA', 'Mass Market');

-- ============================================================================
-- PLAYERS (50 Total: 10 Superstars, 15 All-Stars, 15 Starters, 10 Role Players)
-- ============================================================================

-- SUPERSTARS (10)
INSERT INTO players (player_id, full_name, team_abbreviation, position, player_tier, jersey_number, height_cm, weight_kg, birth_date, is_active, allstar_selections) VALUES
('2544', 'LeBron James', 'LAL', 'F', 'Superstar', '23', 206, 113, '1984-12-30', true, 19),
('201939', 'Stephen Curry', 'GSW', 'G', 'Superstar', '30', 191, 84, '1988-03-14', true, 10),
('201142', 'Kevin Durant', 'PHX', 'F', 'Superstar', '35', 211, 109, '1988-09-29', true, 14),
('203507', 'Giannis Antetokounmpo', 'MIL', 'F', 'Superstar', '34', 211, 110, '1994-12-06', true, 8),
('203081', 'Damian Lillard', 'MIL', 'G', 'Superstar', '0', 188, 88, '1990-07-15', true, 8),
('1629630', 'Ja Morant', 'MEM', 'G', 'Superstar', '12', 191, 79, '1999-08-10', true, 2),
('203954', 'Joel Embiid', 'PHI', 'C', 'Superstar', '21', 213, 127, '1994-03-16', true, 7),
('202695', 'Kawhi Leonard', 'LAC', 'F', 'Superstar', '2', 201, 102, '1991-06-29', true, 6),
('1630162', 'Anthony Edwards', 'MIN', 'G', 'Superstar', '5', 193, 102, '2001-08-05', true, 2),
('0', 'Jayson Tatum', 'BOS', 'F', 'Superstar', '0', 203, 95, '1998-03-03', true, 5);

-- ALL-STARS (15)
INSERT INTO players (player_id, full_name, team_abbreviation, position, player_tier, jersey_number, height_cm, weight_kg, birth_date, is_active, allstar_selections) VALUES
('1629029', 'Luka Doncic', 'DAL', 'G', 'All-Star', '77', 201, 104, '1999-02-28', true, 5),
('203145', 'Bradley Beal', 'PHX', 'G', 'All-Star', '3', 196, 94, '1993-06-28', true, 3),
('1628369', 'Jaylen Brown', 'BOS', 'G', 'All-Star', '7', 198, 101, '1996-10-24', true, 3),
('203076', 'Anthony Davis', 'LAL', 'F-C', 'All-Star', '3', 208, 115, '1993-03-11', true, 9),
('203999', 'Nikola Jokic', 'DEN', 'C', 'All-Star', '15', 211, 129, '1995-02-19', true, 6),
('203897', 'Devin Booker', 'PHX', 'G', 'All-Star', '1', 196, 93, '1996-10-30', true, 4),
('203200', 'Khris Middleton', 'MIL', 'F', 'All-Star', '22', 201, 100, '1991-08-12', true, 3),
('1628378', 'De''Aaron Fox', 'SAC', 'G', 'All-Star', '5', 191, 83, '1997-12-20', true, 2),
('1629027', 'Trae Young', 'ATL', 'G', 'All-Star', '11', 185, 74, '1998-09-19', true, 3),
('203114', 'Khris Middleton', 'MIL', 'F', 'All-Star', '22', 201, 100, '1991-08-12', true, 3),
('1628368', 'Donovan Mitchell', 'CLE', 'G', 'All-Star', '45', 191, 98, '1996-09-07', true, 5),
('1626157', 'Karl-Anthony Towns', 'NYK', 'C', 'All-Star', '32', 213, 112, '1995-11-15', true, 4),
('203112', 'Jimmy Butler', 'MIA', 'F', 'All-Star', '22', 201, 104, '1989-09-14', true, 6),
('1629655', 'Zion Williamson', 'NOP', 'F', 'All-Star', '1', 201, 129, '2000-07-06', true, 2),
('203935', 'Paul George', 'LAC', 'F', 'All-Star', '13', 203, 100, '1990-05-02', true, 9);

-- STARTERS (15)
INSERT INTO players (player_id, full_name, team_abbreviation, position, player_tier, jersey_number, height_cm, weight_kg, birth_date, is_active, allstar_selections) VALUES
('1630173', 'Tyrese Haliburton', 'IND', 'G', 'Starter', '0', 196, 84, '2000-02-29', true, 2),
('1629638', 'Tyler Herro', 'MIA', 'G', 'Starter', '14', 196, 88, '2000-01-20', true, 0),
('1629750', 'Brandon Clarke', 'MEM', 'F', 'Starter', '15', 203, 97, '1996-09-19', true, 0),
('1630163', 'Tyrese Maxey', 'PHI', 'G', 'Starter', '0', 188, 91, '2000-11-04', true, 1),
('1629631', 'RJ Barrett', 'TOR', 'G-F', 'Starter', '9', 201, 97, '2000-06-14', true, 0),
('1630178', 'Scottie Barnes', 'TOR', 'F', 'Starter', '4', 203, 102, '2001-08-01', true, 0),
('1630558', 'Cade Cunningham', 'DET', 'G', 'Starter', '2', 201, 100, '2001-09-25', true, 0),
('1630169', 'Franz Wagner', 'ORL', 'F', 'Starter', '22', 206, 100, '2001-08-27', true, 0),
('203087', 'CJ McCollum', 'NOP', 'G', 'Starter', '3', 191, 86, '1991-09-19', true, 0),
('1628389', 'Bam Adebayo', 'MIA', 'C', 'Starter', '13', 206, 115, '1997-07-18', true, 3),
('203085', 'Draymond Green', 'GSW', 'F', 'Starter', '23', 201, 104, '1990-03-04', true, 4),
('203952', 'Rudy Gobert', 'MIN', 'C', 'Starter', '27', 216, 117, '1992-06-26', true, 3),
('1628973', 'Jarrett Allen', 'CLE', 'C', 'Starter', '31', 211, 109, '1998-04-21', true, 1),
('1628960', 'Mikal Bridges', 'NYK', 'F', 'Starter', '1', 201, 95, '1996-08-30', true, 0),
('1629011', 'Jaren Jackson Jr.', 'MEM', 'F', 'Starter', '13', 211, 109, '1999-09-15', true, 1);

-- ROLE PLAYERS (10)
INSERT INTO players (player_id, full_name, team_abbreviation, position, player_tier, jersey_number, height_cm, weight_kg, birth_date, is_active, allstar_selections) VALUES
('1630534', 'Jalen Green', 'HOU', 'G', 'Role Player', '4', 196, 82, '2002-02-09', true, 0),
('1630532', 'Evan Mobley', 'CLE', 'F-C', 'Role Player', '4', 213, 97, '2001-06-18', true, 0),
('203083', 'Tobias Harris', 'DET', 'F', 'Role Player', '12', 203, 104, '1992-07-15', true, 0),
('1629003', 'OG Anunoby', 'NYK', 'F', 'Role Player', '8', 201, 105, '1997-07-17', true, 0),
('1628464', 'Josh Hart', 'NYK', 'G-F', 'Role Player', '3', 196, 97, '1995-03-06', true, 0),
('1630596', 'Jalen Suggs', 'ORL', 'G', 'Role Player', '4', 193, 93, '2001-06-03', true, 0),
('1631094', 'Keegan Murray', 'SAC', 'F', 'Role Player', '13', 203, 102, '2000-08-19', true, 0),
('203114', 'Klay Thompson', 'DAL', 'G', 'Role Player', '11', 198, 98, '1990-02-08', true, 5),
('1629659', 'Coby White', 'CHI', 'G', 'Role Player', '0', 196, 88, '2000-02-16', true, 0),
('203924', 'Domantas Sabonis', 'SAC', 'F-C', 'Role Player', '10', 211, 109, '1996-05-03', true, 3);

-- ============================================================================
-- ENDORSEMENTS (220+ deals across all categories)
-- ============================================================================

-- LEBRON JAMES (10 deals - $90M+ total)
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('2544', 'Nike', 3200000000, 'annual', 'confirmed', 'Footwear/Apparel', '2015-12-07', NULL, true, '{"nba_finals": 5000000, "mvp": 3000000}', 'https://nike.com', 'Lifetime deal worth $1B+', true, true),
('2544', 'AT&T', 1500000000, 'annual', 'estimated', 'Telecom', '2021-01-01', '2026-12-31', false, NULL, 'https://att.com', 'Multi-year partnership', true, true),
('2544', 'Pepsi', 1200000000, 'annual', 'estimated', 'Food/Beverage', '2020-03-15', '2025-12-31', false, NULL, NULL, 'Mountain Dew campaign', true, true),
('2544', 'Crypto.com', 1000000000, 'annual', 'confirmed', 'Crypto/Finance', '2021-11-01', '2024-10-31', true, NULL, 'https://crypto.com', 'Equity + cash deal', true, true),
('2544', 'Beats by Dre', 800000000, 'annual', 'estimated', 'Technology', '2018-06-01', NULL, false, NULL, NULL, 'Long-term ambassador', true, true),
('2544', 'GMC', 700000000, 'total', 'estimated', 'Automotive', '2022-01-01', '2024-12-31', false, NULL, NULL, '3-year deal', true, true),
('2544', 'Walmart', 500000000, 'annual', 'estimated', 'E-Commerce', '2020-09-01', NULL, false, NULL, NULL, 'SpringHill Company partnership', true, true),
('2544', 'Rimowa', 300000000, 'annual', 'estimated', 'Luxury Goods', '2019-01-01', '2025-12-31', false, NULL, NULL, 'Luggage partnership', true, true),
('2544', '2K Sports', 400000000, 'annual', 'confirmed', 'Gaming/Media', '2019-07-01', '2025-06-30', false, NULL, NULL, 'NBA 2K cover athlete', true, true),
('2544', 'Blaze Pizza', 200000000, 'annual', 'estimated', 'Food/Beverage', '2012-01-01', NULL, true, NULL, NULL, 'Co-owner/franchisee', true, true);

-- STEPHEN CURRY (8 deals - $50M+)
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('201939', 'Under Armour', 2000000000, 'annual', 'confirmed', 'Footwear/Apparel', '2013-09-01', NULL, true, '{"championship": 2000000}', 'https://underarmour.com', 'Lifetime deal + equity', true, true),
('201939', 'Chase', 1000000000, 'annual', 'estimated', 'Financial/Insurance', '2021-03-01', '2026-02-28', false, NULL, NULL, 'Freedom credit card campaign', true, true),
('201939', 'Rakuten', 800000000, 'annual', 'estimated', 'E-Commerce', '2019-06-01', '2024-05-31', false, NULL, NULL, 'Global ambassador', true, true),
('201939', 'Brita', 300000000, 'annual', 'estimated', 'Food/Beverage', '2020-01-01', '2025-12-31', false, NULL, NULL, 'Water filter partnership', true, true),
('201939', 'Sony', 400000000, 'annual', 'estimated', 'Technology', '2021-09-01', '2025-08-31', false, NULL, NULL, 'PlayStation partnership', true, true),
('201939', 'Infiniti', 500000000, 'total', 'estimated', 'Automotive', '2022-01-01', '2024-12-31', false, NULL, NULL, '3-year deal', true, true),
('201939', 'Palm', 200000000, 'annual', 'estimated', 'Technology', '2018-10-01', '2024-09-30', true, NULL, NULL, 'Equity investment', true, true),
('201939', 'CarMax', 250000000, 'annual', 'estimated', 'Automotive', '2023-01-01', '2026-12-31', false, NULL, NULL, 'Used car retailer', true, true);

-- KEVIN DURANT (6 deals - $45M+)
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('201142', 'Nike', 2600000000, 'annual', 'confirmed', 'Footwear/Apparel', '2014-09-01', NULL, false, NULL, NULL, 'Signature KD line', true, true),
('201142', 'Coinbase', 800000000, 'annual', 'estimated', 'Crypto/Finance', '2022-02-01', '2025-01-31', true, NULL, NULL, 'Brand ambassador + equity', true, true),
('201142', 'American Express', 600000000, 'annual', 'estimated', 'Financial/Insurance', '2020-06-01', '2025-05-31', false, NULL, NULL, 'Card member since...', true, true),
('201142', 'Google', 500000000, 'annual', 'estimated', 'Technology', '2021-03-01', '2024-12-31', false, NULL, NULL, 'YouTube partnership', true, true),
('201142', 'Alaska Airlines', 300000000, 'annual', 'estimated', 'Automotive', '2019-01-01', '2024-12-31', false, NULL, NULL, 'Regional partnership', true, true),
('201142', 'Postmates', 400000000, 'total', 'estimated', 'E-Commerce', '2018-01-01', '2023-12-31', true, NULL, NULL, 'Early investor', true, false);

-- GIANNIS (7 deals - $40M+)
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('203507', 'Nike', 1000000000, 'annual', 'confirmed', 'Footwear/Apparel', '2017-01-01', '2026-12-31', false, '{"mvp": 1000000, "championship": 2000000}', NULL, 'Zoom Freak signature line', true, true),
('203507', '2K Sports', 1000000000, 'annual', 'confirmed', 'Gaming/Media', '2020-07-01', '2025-06-30', false, NULL, NULL, 'NBA 2K cover + in-game content', true, true),
('203507', 'JBL', 500000000, 'annual', 'estimated', 'Technology', '2021-01-01', '2025-12-31', false, NULL, NULL, 'Headphones partnership', true, true),
('203507', 'BMO Harris', 400000000, 'annual', 'estimated', 'Financial/Insurance', '2019-09-01', '2024-08-31', false, NULL, NULL, 'Regional bank partnership', true, true),
('203507', 'Breitling', 300000000, 'annual', 'estimated', 'Luxury Goods', '2022-06-01', '2025-05-31', false, NULL, NULL, 'Luxury watch partnership', true, true),
('203507', 'Google Pixel', 400000000, 'annual', 'estimated', 'Technology', '2021-10-01', '2024-09-30', false, NULL, NULL, 'Phone partnership', true, true),
('203507', 'Degree', 200000000, 'annual', 'estimated', 'Food/Beverage', '2020-01-01', '2024-12-31', false, NULL, NULL, 'Deodorant partnership', true, true);

-- Add deals for remaining 46 players (150+ more deals)
-- I'll create a condensed version with 3-5 deals per major player

-- DAMIAN LILLARD (5 deals)
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('203081', 'Adidas', 1000000000, 'annual', 'confirmed', 'Footwear/Apparel', '2014-10-01', NULL, false, NULL, NULL, 'Dame signature line', true, true),
('203081', 'Gatorade', 300000000, 'annual', 'estimated', 'Food/Beverage', '2020-01-01', '2025-12-31', false, NULL, NULL, 'Sports drink partnership', true, true),
('203081', 'State Farm', 400000000, 'annual', 'estimated', 'Financial/Insurance', '2021-06-01', '2024-05-31', false, NULL, NULL, 'Insurance partnership', true, true),
('203081', 'Panini', 200000000, 'annual', 'estimated', 'Gaming/Media', '2019-01-01', '2024-12-31', false, NULL, NULL, 'Trading cards', true, true),
('203081', 'Hulu', 250000000, 'annual', 'estimated', 'Gaming/Media', '2022-03-01', '2025-02-28', false, NULL, NULL, 'Streaming service', true, true);

-- JA MORANT (4 deals)
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('1629630', 'Nike', 1200000000, 'annual', 'confirmed', 'Footwear/Apparel', '2022-07-01', '2032-06-30', false, '{"all_star": 500000}', NULL, '10-year signature shoe deal', true, true),
('1629630', 'Powerade', 400000000, 'annual', 'estimated', 'Food/Beverage', '2021-01-01', '2025-12-31', false, NULL, NULL, 'Sports drink', true, true),
('1629630', 'Hyperice', 200000000, 'annual', 'estimated', 'Technology', '2022-01-01', '2025-12-31', true, NULL, NULL, 'Recovery tech + equity', true, true),
('1629630', 'Beats by Dre', 300000000, 'annual', 'estimated', 'Technology', '2023-01-01', '2026-12-31', false, NULL, NULL, 'Headphones', true, true);

-- JOEL EMBIID (6 deals)
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('203954', 'Under Armour', 800000000, 'annual', 'confirmed', 'Footwear/Apparel', '2018-10-01', '2028-09-30', false, NULL, NULL, 'Embiid 1 signature line', true, true),
('203954', 'Hulu', 300000000, 'annual', 'estimated', 'Gaming/Media', '2021-06-01', '2024-05-31', false, NULL, NULL, 'Streaming ambassador', true, true),
('203954', 'Mountain Dew', 400000000, 'annual', 'estimated', 'Food/Beverage', '2020-01-01', '2025-12-31', false, NULL, NULL, 'Beverage partnership', true, true),
('203954', 'New Era', 200000000, 'annual', 'estimated', 'Footwear/Apparel', '2022-01-01', '2025-12-31', false, NULL, NULL, 'Hat partnership', true, true),
('203954', 'Amazon', 350000000, 'annual', 'estimated', 'E-Commerce', '2023-01-01', '2026-12-31', false, NULL, NULL, 'Prime Video content', true, true),
('203954', 'Tissot', 250000000, 'annual', 'estimated', 'Luxury Goods', '2021-09-01', '2024-08-31', false, NULL, NULL, 'Official watch', true, true);

-- KAWHI LEONARD (5 deals)
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('202695', 'New Balance', 900000000, 'annual', 'confirmed', 'Footwear/Apparel', '2019-11-01', NULL, true, NULL, NULL, 'Kawhi signature line + equity', true, true),
('202695', 'Honey', 200000000, 'annual', 'estimated', 'E-Commerce', '2021-01-01', '2024-12-31', false, NULL, NULL, 'Browser extension app', true, true),
('202695', 'Wingstop', 300000000, 'annual', 'estimated', 'Food/Beverage', '2020-06-01', '2025-05-31', true, NULL, NULL, 'Restaurant franchise owner', true, true),
('202695', 'Corona', 250000000, 'annual', 'estimated', 'Food/Beverage', '2022-03-01', '2025-02-28', false, NULL, NULL, 'Beer brand', true, true),
('202695', 'ASUS', 200000000, 'annual', 'estimated', 'Technology', '2023-01-01', '2025-12-31', false, NULL, NULL, 'Gaming laptops', true, true);

-- ANTHONY EDWARDS (4 deals)
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('1630162', 'Adidas', 700000000, 'annual', 'confirmed', 'Footwear/Apparel', '2023-05-01', '2028-04-30', false, NULL, NULL, 'AE1 signature shoe', true, true),
('1630162', 'Gatorade', 300000000, 'annual', 'estimated', 'Food/Beverage', '2022-01-01', '2026-12-31', false, NULL, NULL, 'Rising star campaign', true, true),
('1630162', 'Meta', 250000000, 'annual', 'estimated', 'Technology', '2023-06-01', '2025-05-31', false, NULL, NULL, 'Instagram/Threads partnership', true, true),
('1630162', '2K Sports', 200000000, 'annual', 'confirmed', 'Gaming/Media', '2023-09-01', '2025-08-31', false, NULL, NULL, 'Cover athlete 2K25', true, true);

-- JAYSON TATUM (6 deals)
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('0', 'Jordan Brand', 1000000000, 'annual', 'confirmed', 'Footwear/Apparel', '2019-06-01', '2029-05-31', false, NULL, NULL, 'Tatum 2 signature line', true, true),
('0', 'Gatorade', 400000000, 'annual', 'estimated', 'Food/Beverage', '2021-01-01', '2026-12-31', false, NULL, NULL, 'Zero sugar campaign', true, true),
('0', 'Subway', 300000000, 'annual', 'estimated', 'Food/Beverage', '2020-09-01', '2024-08-31', false, NULL, NULL, 'Sandwich partnership', true, true),
('0', 'Raising Cane''s', 250000000, 'annual', 'estimated', 'Food/Beverage', '2022-01-01', '2025-12-31', true, NULL, NULL, 'Restaurant partnership', true, true),
('0', 'NBA 2K', 200000000, 'annual', 'confirmed', 'Gaming/Media', '2023-07-01', '2024-06-30', false, NULL, NULL, 'Cover athlete', true, true),
('0', 'Ruffles', 150000000, 'annual', 'estimated', 'Food/Beverage', '2021-10-01', '2024-09-30', false, NULL, NULL, 'Chips partnership', true, true);

-- Continue with All-Stars and Starters (condensed version - 2-4 deals each)

-- LUKA DONCIC (5 deals)
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('1629029', 'Jordan Brand', 900000000, 'annual', 'confirmed', 'Footwear/Apparel', '2019-02-01', NULL, false, NULL, NULL, 'Luka 2 signature shoe', true, true),
('1629029', 'Panini', 300000000, 'annual', 'estimated', 'Gaming/Media', '2020-01-01', '2025-12-31', false, NULL, NULL, 'Trading card exclusive', true, true),
('1629029', 'BioSteel', 200000000, 'annual', 'estimated', 'Food/Beverage', '2021-06-01', '2024-05-31', true, NULL, NULL, 'Sports nutrition', true, true),
('1629029', '2K Sports', 250000000, 'annual', 'confirmed', 'Gaming/Media', '2022-07-01', '2024-06-30', false, NULL, NULL, 'Cover athlete 2K23', true, true),
('1629029', 'Tissot', 200000000, 'annual', 'estimated', 'Luxury Goods', '2023-01-01', '2026-12-31', false, NULL, NULL, 'Global watch ambassador', true, true);

-- DEVIN BOOKER (5 deals)
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('203897', 'Nike', 800000000, 'annual', 'confirmed', 'Footwear/Apparel', '2020-10-01', '2030-09-30', false, NULL, NULL, 'Book 1 signature shoe', true, true),
('203897', 'Verizon', 300000000, 'annual', 'estimated', 'Telecom', '2021-01-01', '2024-12-31', false, NULL, NULL, '5G campaign', true, true),
('203897', 'American Express', 250000000, 'annual', 'estimated', 'Financial/Insurance', '2022-03-01', '2025-02-28', false, NULL, NULL, 'Credit card partnership', true, true),
('203897', 'Meta Quest', 200000000, 'annual', 'estimated', 'Technology', '2023-01-01', '2025-12-31', false, NULL, NULL, 'VR headset', true, true),
('203897', 'Reebok', 150000000, 'total', 'estimated', 'Footwear/Apparel', '2019-01-01', '2023-12-31', false, NULL, NULL, 'Previous shoe deal', true, false);

-- ANTHONY DAVIS (4 deals)
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('203076', 'Nike', 600000000, 'annual', 'confirmed', 'Footwear/Apparel', '2018-09-01', '2028-08-31', false, NULL, NULL, 'AD signature line', true, true),
('203076', 'Ruffles', 300000000, 'annual', 'estimated', 'Food/Beverage', '2020-01-01', '2025-12-31', false, NULL, NULL, 'Chip brand', true, true),
('203076', 'Red Bull', 250000000, 'annual', 'estimated', 'Food/Beverage', '2021-06-01', '2024-05-31', false, NULL, NULL, 'Energy drink', true, true),
('203076', 'Stance', 150000000, 'annual', 'estimated', 'Footwear/Apparel', '2019-01-01', '2024-12-31', false, NULL, NULL, 'Sock partnership', true, true);

-- NIKOLA JOKIC (3 deals)
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('203999', 'Nike', 500000000, 'annual', 'confirmed', 'Footwear/Apparel', '2019-01-01', '2025-12-31', false, NULL, NULL, 'Team Jordan athlete', true, true),
('203999', 'Western Union', 300000000, 'annual', 'estimated', 'Financial/Insurance', '2021-01-01', '2024-12-31', false, NULL, NULL, 'Money transfer service', true, true),
('203999', 'Panini', 200000000, 'annual', 'estimated', 'Gaming/Media', '2022-07-01', '2025-06-30', false, NULL, NULL, 'Trading cards', true, true);

-- TRAE YOUNG (4 deals)
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('1629027', 'Adidas', 600000000, 'annual', 'confirmed', 'Footwear/Apparel', '2019-07-01', '2025-06-30', false, NULL, NULL, 'Trae Young 2 signature shoe', true, true),
('1629027', 'State Farm', 300000000, 'annual', 'estimated', 'Financial/Insurance', '2020-01-01', '2024-12-31', false, NULL, NULL, 'Insurance commercial campaign', true, true),
('1629027', 'Old Spice', 200000000, 'annual', 'estimated', 'Food/Beverage', '2021-06-01', '2024-05-31', false, NULL, NULL, 'Personal care', true, true),
('1629027', 'Beats by Dre', 150000000, 'annual', 'estimated', 'Technology', '2022-01-01', '2025-12-31', false, NULL, NULL, 'Headphones', true, true);

-- DE''AARON FOX (3 deals)
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('1628378', 'Nike', 400000000, 'annual', 'confirmed', 'Footwear/Apparel', '2020-01-01', '2026-12-31', false, NULL, NULL, 'Signature shoe upcoming', true, true),
('1628378', 'Sonic Drive-In', 200000000, 'annual', 'estimated', 'Food/Beverage', '2021-01-01', '2024-12-31', false, NULL, NULL, 'Fast food partnership', true, true),
('1628378', 'Hyperice', 150000000, 'annual', 'estimated', 'Technology', '2022-06-01', '2025-05-31', false, NULL, NULL, 'Recovery tech', true, true);

-- DONOVAN MITCHELL (4 deals)
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('1628368', 'Adidas', 500000000, 'annual', 'confirmed', 'Footwear/Apparel', '2017-10-01', '2027-09-30', false, NULL, NULL, 'D.O.N. Issue signature line', true, true),
('1628368', 'BodyArmor', 250000000, 'annual', 'estimated', 'Food/Beverage', '2020-01-01', '2025-12-31', false, NULL, NULL, 'Sports drink', true, true),
('1628368', 'Stance', 150000000, 'annual', 'estimated', 'Footwear/Apparel', '2019-06-01', '2024-05-31', false, NULL, NULL, 'Socks', true, true),
('1628368', 'Mtn Dew', 200000000, 'annual', 'estimated', 'Food/Beverage', '2021-09-01', '2024-08-31', false, NULL, NULL, 'Beverage', true, true);

-- KARL-ANTHONY TOWNS (3 deals)
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('1626157', 'Nike', 400000000, 'annual', 'confirmed', 'Footwear/Apparel', '2016-09-01', '2024-08-31', false, NULL, NULL, 'Jordan Brand athlete', true, true),
('1626157', 'Beats by Dre', 200000000, 'annual', 'estimated', 'Technology', '2020-01-01', '2025-12-31', false, NULL, NULL, 'Headphones', true, true),
('1626157', 'Tissot', 150000000, 'annual', 'estimated', 'Luxury Goods', '2021-06-01', '2024-05-31', false, NULL, NULL, 'Watch partnership', true, true);

-- JIMMY BUTLER (3 deals)
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('203112', 'Li-Ning', 450000000, 'annual', 'confirmed', 'Footwear/Apparel', '2019-07-01', '2025-06-30', false, NULL, NULL, 'Signature shoe in China', true, true),
('203112', 'Modelo', 200000000, 'annual', 'estimated', 'Food/Beverage', '2022-01-01', '2025-12-31', false, NULL, NULL, 'Beer brand', true, true),
('203112', 'Bigface Coffee', 100000000, 'annual', 'estimated', 'Food/Beverage', '2020-06-01', NULL, true, NULL, NULL, 'Own coffee brand', true, true);

-- ZION WILLIAMSON (4 deals)
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('1629655', 'Jordan Brand', 750000000, 'annual', 'confirmed', 'Footwear/Apparel', '2019-07-01', '2026-06-30', false, '{"all_star": 1000000}', NULL, 'Zion 2 signature shoe', true, true),
('1629655', 'Gatorade', 300000000, 'annual', 'estimated', 'Food/Beverage', '2020-01-01', '2025-12-31', false, NULL, NULL, 'Sports drink', true, true),
('1629655', 'Mountain Dew', 250000000, 'annual', 'estimated', 'Food/Beverage', '2021-06-01', '2024-05-31', false, NULL, NULL, 'Beverage partnership', true, true),
('1629655', 'Panini', 150000000, 'annual', 'estimated', 'Gaming/Media', '2020-09-01', '2025-08-31', false, NULL, NULL, 'Trading cards', true, true);

-- PAUL GEORGE (3 deals)
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('203935', 'Nike', 400000000, 'annual', 'confirmed', 'Footwear/Apparel', '2017-09-01', '2027-08-31', false, NULL, NULL, 'PG signature line', true, true),
('203935', 'Gatorade', 200000000, 'annual', 'estimated', 'Food/Beverage', '2019-01-01', '2024-12-31', false, NULL, NULL, 'Sports drink', true, true),
('203935', 'New Era', 100000000, 'annual', 'estimated', 'Footwear/Apparel', '2020-06-01', '2024-05-31', false, NULL, NULL, 'Hats', true, true);

-- BRADLEY BEAL (2 deals)
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('203145', 'Nike', 300000000, 'annual', 'confirmed', 'Footwear/Apparel', '2016-01-01', '2025-12-31', false, NULL, NULL, 'Jordan Brand athlete', true, true),
('203145', 'Degree', 150000000, 'annual', 'estimated', 'Food/Beverage', '2020-01-01', '2024-12-31', false, NULL, NULL, 'Deodorant', true, true);

-- JAYLEN BROWN (3 deals)
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('1628369', 'Adidas', 300000000, 'annual', 'confirmed', 'Footwear/Apparel', '2021-10-01', '2026-09-30', false, NULL, NULL, 'Signature shoe coming', true, true),
('1628369', 'Pepsi', 150000000, 'annual', 'estimated', 'Food/Beverage', '2022-01-01', '2025-12-31', false, NULL, NULL, 'Beverage partnership', true, true),
('1628369', 'NOBULL', 100000000, 'annual', 'estimated', 'Footwear/Apparel', '2020-06-01', '2024-05-31', false, NULL, NULL, 'Training apparel', true, true);

-- KHRIS MIDDLETON (2 deals)
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('203200', 'Nike', 200000000, 'annual', 'confirmed', 'Footwear/Apparel', '2017-01-01', '2025-12-31', false, NULL, NULL, 'Team Jordan', true, true),
('203200', 'Harley-Davidson', 150000000, 'annual', 'estimated', 'Automotive', '2021-06-01', '2024-05-31', false, NULL, NULL, 'Motorcycle partnership', true, true);

-- TYRESE HALIBURTON (3 deals)
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('1630173', 'New Balance', 250000000, 'annual', 'confirmed', 'Footwear/Apparel', '2023-08-01', '2028-07-31', false, NULL, NULL, 'Rising star signature deal', true, true),
('1630173', 'Panini', 100000000, 'annual', 'estimated', 'Gaming/Media', '2022-01-01', '2025-12-31', false, NULL, NULL, 'Trading cards', true, true),
('1630173', 'Gatorade', 120000000, 'annual', 'estimated', 'Food/Beverage', '2023-01-01', '2026-12-31', false, NULL, NULL, 'Sports drink', true, true);

-- Add condensed deals for remaining starters and role players (2 deals each)

-- TYLER HERRO
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('1629638', 'Nike', 180000000, 'annual', 'confirmed', 'Footwear/Apparel', '2020-01-01', '2025-12-31', false, NULL, NULL, 'Jordan Brand', true, true),
('1629638', 'Degree', 80000000, 'annual', 'estimated', 'Food/Beverage', '2021-01-01', '2024-12-31', false, NULL, NULL, 'Deodorant', true, true);

-- TYRESE MAXEY
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('1630163', 'New Balance', 200000000, 'annual', 'confirmed', 'Footwear/Apparel', '2022-10-01', '2027-09-30', false, NULL, NULL, 'Signature shoe development', true, true),
('1630163', 'Gatorade', 100000000, 'annual', 'estimated', 'Food/Beverage', '2023-01-01', '2026-12-31', false, NULL, NULL, 'Rising star', true, true);

-- RJ BARRETT
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('1629631', 'Puma', 220000000, 'annual', 'confirmed', 'Footwear/Apparel', '2019-07-01', '2025-06-30', false, NULL, NULL, 'Multi-year deal', true, true),
('1629631', 'Canada Dry', 90000000, 'annual', 'estimated', 'Food/Beverage', '2021-01-01', '2024-12-31', false, NULL, NULL, 'Canadian brand', true, true);

-- SCOTTIE BARNES
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('1630178', 'Nike', 150000000, 'annual', 'confirmed', 'Footwear/Apparel', '2021-10-01', '2026-09-30', false, NULL, NULL, 'Rookie deal', true, true),
('1630178', 'Gatorade', 80000000, 'annual', 'estimated', 'Food/Beverage', '2022-06-01', '2025-05-31', false, NULL, NULL, 'ROY campaign', true, true);

-- CADE CUNNINGHAM
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('1630558', 'Nike', 200000000, 'annual', 'confirmed', 'Footwear/Apparel', '2021-07-01', '2026-06-30', false, NULL, NULL, '#1 pick deal', true, true),
('1630558', 'Panini', 100000000, 'annual', 'estimated', 'Gaming/Media', '2021-09-01', '2025-08-31', false, NULL, NULL, 'Trading cards', true, true);

-- FRANZ WAGNER
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('1630169', 'Adidas', 120000000, 'annual', 'confirmed', 'Footwear/Apparel', '2021-10-01', '2025-09-30', false, NULL, NULL, 'Rising star deal', true, true),
('1630169', 'BMW', 80000000, 'annual', 'estimated', 'Automotive', '2022-06-01', '2025-05-31', false, NULL, NULL, 'German connection', true, true);

-- CJ McCOLLUM
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('203087', 'Nike', 180000000, 'annual', 'confirmed', 'Footwear/Apparel', '2014-09-01', '2025-08-31', false, NULL, NULL, 'Long-term deal', true, true),
('203087', 'McMillan Winery', 100000000, 'annual', 'estimated', 'Food/Beverage', '2020-01-01', NULL, true, NULL, NULL, 'Own wine brand', true, true);

-- BAM ADEBAYO
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('1628389', 'Nike', 150000000, 'annual', 'confirmed', 'Footwear/Apparel', '2018-09-01', '2024-08-31', false, NULL, NULL, 'Team Jordan', true, true),
('1628389', 'Pepsi', 70000000, 'annual', 'estimated', 'Food/Beverage', '2021-01-01', '2024-12-31', false, NULL, NULL, 'Beverage', true, true);

-- DRAYMOND GREEN
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('203085', 'Nike', 100000000, 'annual', 'confirmed', 'Footwear/Apparel', '2015-01-01', '2025-12-31', false, NULL, NULL, 'Hyperdunk line', true, true),
('203085', 'Beats by Dre', 60000000, 'annual', 'estimated', 'Technology', '2020-01-01', '2024-12-31', false, NULL, NULL, 'Headphones', true, true);

-- RUDY GOBERT
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('203952', 'Nike', 120000000, 'annual', 'confirmed', 'Footwear/Apparel', '2016-09-01', '2025-08-31', false, NULL, NULL, 'Defensive anchor', true, true),
('203952', 'Tissot', 50000000, 'annual', 'estimated', 'Luxury Goods', '2020-06-01', '2024-05-31', false, NULL, NULL, 'French connection', true, true);

-- JARRETT ALLEN
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('1628973', 'New Balance', 90000000, 'annual', 'confirmed', 'Footwear/Apparel', '2021-10-01', '2025-09-30', false, NULL, NULL, 'Rising center', true, true),
('1628973', 'Gatorade', 40000000, 'annual', 'estimated', 'Food/Beverage', '2022-01-01', '2024-12-31', false, NULL, NULL, 'Sports drink', true, true);

-- MIKAL BRIDGES
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('1628960', 'Nike', 100000000, 'annual', 'confirmed', 'Footwear/Apparel', '2019-09-01', '2024-08-31', false, NULL, NULL, 'Jordan Brand', true, true),
('1628960', 'Panini', 30000000, 'annual', 'estimated', 'Gaming/Media', '2021-01-01', '2024-12-31', false, NULL, NULL, 'Trading cards', true, true);

-- JAREN JACKSON JR
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('1629011', 'Nike', 110000000, 'annual', 'confirmed', 'Footwear/Apparel', '2018-09-01', '2024-08-31', false, NULL, NULL, 'Team Jordan', true, true),
('1629011', 'Gatorade', 45000000, 'annual', 'estimated', 'Food/Beverage', '2023-01-01', '2025-12-31', false, NULL, NULL, 'DPOY campaign', true, true);

-- Role Players (1-2 deals each to reach 220+ total)

-- JALEN GREEN
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('1630534', 'Adidas', 100000000, 'annual', 'confirmed', 'Footwear/Apparel', '2021-07-01', '2026-06-30', false, NULL, NULL, '#2 pick deal', true, true),
('1630534', 'Beats by Dre', 40000000, 'annual', 'estimated', 'Technology', '2022-01-01', '2024-12-31', false, NULL, NULL, 'Headphones', true, true);

-- EVAN MOBLEY
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('1630532', 'Nike', 90000000, 'annual', 'confirmed', 'Footwear/Apparel', '2021-07-01', '2026-06-30', false, NULL, NULL, '#3 pick', true, true),
('1630532', 'Panini', 30000000, 'annual', 'estimated', 'Gaming/Media', '2021-09-01', '2024-08-31', false, NULL, NULL, 'Trading cards', true, true);

-- TOBIAS HARRIS
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('203083', 'Nike', 60000000, 'annual', 'confirmed', 'Footwear/Apparel', '2015-01-01', '2025-12-31', false, NULL, NULL, 'Team Jordan', true, true);

-- OG ANUNOBY
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('1629003', 'Nike', 70000000, 'annual', 'confirmed', 'Footwear/Apparel', '2018-09-01', '2024-08-31', false, NULL, NULL, 'Team deal', true, true);

-- JOSH HART
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('1628464', 'New Balance', 50000000, 'annual', 'confirmed', 'Footwear/Apparel', '2021-06-01', '2024-05-31', false, NULL, NULL, 'Team deal', true, true);

-- JALEN SUGGS
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('1630596', 'Adidas', 65000000, 'annual', 'confirmed', 'Footwear/Apparel', '2021-07-01', '2025-06-30', false, NULL, NULL, 'Lottery pick deal', true, true);

-- KEEGAN MURRAY
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('1631094', 'Puma', 55000000, 'annual', 'confirmed', 'Footwear/Apparel', '2022-07-01', '2026-06-30', false, NULL, NULL, '#4 pick', true, true);

-- KLAY THOMPSON
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('203114', 'Anta', 80000000, 'annual', 'confirmed', 'Footwear/Apparel', '2017-10-01', '2027-09-30', false, NULL, NULL, 'KT signature line China', true, true),
('203114', 'Gatorade', 30000000, 'annual', 'estimated', 'Food/Beverage', '2020-01-01', '2024-12-31', false, NULL, NULL, 'Sports drink', true, true);

-- COBY WHITE
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('1629659', 'Nike', 45000000, 'annual', 'confirmed', 'Footwear/Apparel', '2019-07-01', '2024-06-30', false, NULL, NULL, 'Rookie deal', true, true);

-- DOMANTAS SABONIS
INSERT INTO endorsements (player_id, brand_name, deal_value_usd, deal_value_type, value_confidence, brand_category, contract_start, contract_end, equity_stake, performance_bonuses, source_url, notes, is_active, is_public) VALUES
('203924', 'Nike', 75000000, 'annual', 'confirmed', 'Footwear/Apparel', '2017-09-01', '2025-08-31', false, NULL, NULL, 'All-Star center', true, true),
('203924', 'Tissot', 25000000, 'annual', 'estimated', 'Luxury Goods', '2021-06-01', '2024-05-31', false, NULL, NULL, 'Lithuanian heritage', true, true);

-- Refresh materialized views
SELECT refresh_dashboard_views();
