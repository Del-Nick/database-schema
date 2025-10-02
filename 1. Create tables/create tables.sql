CREATE EXTENSION IF NOT EXISTS ltree;

CREATE TABLE categories (
    id         uuid     PRIMARY KEY DEFAULT uuidv7(),
    title      TEXT     NOT NULL,
    slug       TEXT     NOT NULL CHECK (slug ~ '^[A-Za-z0-9_-]+$'),
    parent_id  uuid     REFERENCES categories(id) ON DELETE SET NULL,
    path       LTREE    NOT NULL UNIQUE,
    depth      INT      GENERATED ALWAYS AS (nlevel(path)) STORED,
    UNIQUE (parent_id, slug)
);

CREATE INDEX categories_path_gist ON categories USING GIST(path);

CREATE TABLE products (
    id           uuid             PRIMARY KEY DEFAULT uuidv7(),
    name         TEXT             NOT NULL,
    price        NUMERIC(12,2)    NOT NULL DEFAULT 0 CHECK (price >= 0),
    category_id  uuid             NOT NULL REFERENCES categories(id) ON DELETE RESTRICT
);

CREATE INDEX products_category_idx ON products(category_id);

CREATE TABLE customers (
    id        UUID    PRIMARY KEY DEFAULT uuidv7(),
    name      TEXT    NOT NULL,
    address   TEXT    NOT NULL
);

CREATE TABLE orders (
    id          UUID        PRIMARY KEY DEFAULT uuidv7(),
    customer_id UUID        NOT NULL REFERENCES customers(id) ON DELETE RESTRICT,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX orders_customer_idx ON orders(customer_id);

CREATE TABLE order_items (
    id          UUID            PRIMARY KEY DEFAULT uuidv7(),
    order_id    UUID            NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id  UUID            NOT NULL REFERENCES products(id) ON DELETE RESTRICT,
    quantity    INT             NOT NULL check (quantity > 0),
    unit_price  numeric(12, 2)  NOT NULL CHECK (unit_price >= 0)
);
CREATE INDEX order_items_order_idx   ON order_items(order_id);
CREATE INDEX order_items_product_idx ON order_items(product_id);
