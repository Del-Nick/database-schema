INSERT INTO categories (title, slug, parent_id, path) VALUES
	('Бытовая техника', 'appliances', NULL, 'appliances');

INSERT INTO categories (title, slug, parent_id)
	SELECT 'Стиральные машины', 'washing_machine', id FROM categories WHERE slug='appliances';

INSERT INTO categories (title, slug, parent_id)
	SELECT 'Холодильники', 'fridges', id FROM categories WHERE slug='appliances';

INSERT INTO categories (title, slug, parent_id)
	SELECT 'Однокамерные', 'single_chamber_fridges', id FROM categories WHERE slug='fridges';

INSERT INTO categories (title, slug, parent_id)
	SELECT 'Двухкамерные', 'double_chamber_fridges', id FROM categories WHERE slug='fridges';

INSERT INTO categories (title, slug, parent_id)
	SELECT 'Телевизоры', 'TV', id FROM categories WHERE slug='appliances';

INSERT INTO categories (title, slug, parent_id, path) VALUES
	('Компьютеры', 'computers', NULL, 'computers');

INSERT INTO categories (title, slug, parent_id)
	SELECT 'Ноутбуки', 'notebooks', id FROM categories WHERE slug='computers';

INSERT INTO categories (title, slug, parent_id)
	SELECT '17"', '17_inches', id FROM categories WHERE slug='notebooks';

INSERT INTO categories (title, slug, parent_id)
	SELECT '19"', '19_inches', id FROM categories WHERE slug='notebooks';

INSERT INTO categories (title, slug, parent_id)
	SELECT 'Моноблоки', 'monoblocks', id FROM categories WHERE slug='computers';



