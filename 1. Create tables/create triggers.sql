-- Для удобного добавления новых категорий
CREATE OR REPLACE FUNCTION categories_set_path() RETURNS trigger AS $$
BEGIN
  IF NEW.parent_id IS NULL THEN
    NEW.path := text2ltree(NEW.slug);
  ELSE
    NEW.path := (SELECT path FROM categories WHERE id = NEW.parent_id)
                 || text2ltree(NEW.slug);
  END IF;
  RETURN NEW;
END; $$ LANGUAGE plpgsql;

CREATE TRIGGER trg_categories_set_path
BEFORE INSERT OR UPDATE OF slug, parent_id ON categories
FOR EACH ROW EXECUTE FUNCTION categories_set_path();


-- Если название подкатегории изменилось, меняем путь
CREATE OR REPLACE FUNCTION categories_propagate_move() RETURNS trigger AS $$
BEGIN
  IF NEW.path <> OLD.path THEN
    UPDATE categories c
       SET path = NEW.path || subpath(c.path, nlevel(OLD.path))
     WHERE c.path <@ OLD.path AND c.id <> NEW.id;
  END IF;
  RETURN NEW;
END; $$ LANGUAGE plpgsql;

CREATE TRIGGER trg_categories_propagate_move
AFTER UPDATE OF path ON categories
FOR EACH ROW EXECUTE FUNCTION categories_propagate_move();