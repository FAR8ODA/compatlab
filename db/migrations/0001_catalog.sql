BEGIN;

CREATE SCHEMA IF NOT EXISTS compatlab;

SET LOCAL search_path TO compatlab, public;

CREATE TABLE product_family (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name text NOT NULL,
    slug text NOT NULL,
    description text NOT NULL DEFAULT '',
    created_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT product_family_name_not_blank CHECK (btrim(name) <> ''),
    CONSTRAINT product_family_slug_format CHECK (
        slug ~ '^[a-z0-9]+(?:-[a-z0-9]+)*$'
    ),
    CONSTRAINT product_family_slug_unique UNIQUE (slug)
);

CREATE TABLE board_revision (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_family_id bigint NOT NULL REFERENCES product_family(id) ON DELETE RESTRICT,
    revision_code text NOT NULL,
    lifecycle_status text NOT NULL DEFAULT 'prototype',
    introduced_on date,
    retired_on date,
    notes text NOT NULL DEFAULT '',
    created_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT board_revision_code_not_blank CHECK (btrim(revision_code) <> ''),
    CONSTRAINT board_revision_lifecycle_valid CHECK (
        lifecycle_status IN ('prototype', 'active', 'deprecated', 'retired')
    ),
    CONSTRAINT board_revision_dates_ordered CHECK (
        retired_on IS NULL
        OR introduced_on IS NULL
        OR retired_on >= introduced_on
    ),
    CONSTRAINT board_revision_family_code_unique UNIQUE (
        product_family_id,
        revision_code
    )
);

CREATE TABLE component (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    manufacturer_name text NOT NULL,
    name text NOT NULL,
    category text NOT NULL,
    description text NOT NULL DEFAULT '',
    created_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT component_manufacturer_not_blank CHECK (
        btrim(manufacturer_name) <> ''
    ),
    CONSTRAINT component_name_not_blank CHECK (btrim(name) <> ''),
    CONSTRAINT component_category_not_blank CHECK (btrim(category) <> ''),
    CONSTRAINT component_identity_unique UNIQUE (manufacturer_name, name)
);

CREATE TABLE component_revision (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    component_id bigint NOT NULL REFERENCES component(id) ON DELETE RESTRICT,
    revision_code text NOT NULL,
    manufacturer_part_number text,
    lifecycle_status text NOT NULL DEFAULT 'active',
    specifications jsonb NOT NULL DEFAULT '{}'::jsonb,
    created_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT component_revision_code_not_blank CHECK (
        btrim(revision_code) <> ''
    ),
    CONSTRAINT component_revision_part_number_not_blank CHECK (
        manufacturer_part_number IS NULL
        OR btrim(manufacturer_part_number) <> ''
    ),
    CONSTRAINT component_revision_lifecycle_valid CHECK (
        lifecycle_status IN ('prototype', 'active', 'deprecated', 'end_of_life')
    ),
    CONSTRAINT component_revision_identity_unique UNIQUE (
        component_id,
        revision_code
    )
);

CREATE TABLE component_lot (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    component_revision_id bigint NOT NULL
        REFERENCES component_revision(id) ON DELETE RESTRICT,
    lot_code text NOT NULL,
    supplier_name text NOT NULL,
    received_on date NOT NULL,
    expires_on date,
    quantity_received integer NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT component_lot_code_not_blank CHECK (btrim(lot_code) <> ''),
    CONSTRAINT component_lot_supplier_not_blank CHECK (btrim(supplier_name) <> ''),
    CONSTRAINT component_lot_quantity_positive CHECK (quantity_received > 0),
    CONSTRAINT component_lot_dates_ordered CHECK (
        expires_on IS NULL OR expires_on >= received_on
    ),
    CONSTRAINT component_lot_identity_unique UNIQUE (
        component_revision_id,
        supplier_name,
        lot_code
    )
);

CREATE TABLE board_bom_item (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    board_revision_id bigint NOT NULL REFERENCES board_revision(id) ON DELETE CASCADE,
    component_revision_id bigint NOT NULL
        REFERENCES component_revision(id) ON DELETE RESTRICT,
    position_code text NOT NULL,
    quantity integer NOT NULL DEFAULT 1,
    is_optional boolean NOT NULL DEFAULT false,
    notes text NOT NULL DEFAULT '',
    CONSTRAINT board_bom_position_not_blank CHECK (btrim(position_code) <> ''),
    CONSTRAINT board_bom_quantity_positive CHECK (quantity > 0),
    CONSTRAINT board_bom_position_unique UNIQUE (board_revision_id, position_code)
);

CREATE TABLE component_bom_item (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    parent_component_revision_id bigint NOT NULL
        REFERENCES component_revision(id) ON DELETE CASCADE,
    child_component_revision_id bigint NOT NULL
        REFERENCES component_revision(id) ON DELETE RESTRICT,
    position_code text NOT NULL,
    quantity integer NOT NULL DEFAULT 1,
    is_optional boolean NOT NULL DEFAULT false,
    notes text NOT NULL DEFAULT '',
    CONSTRAINT component_bom_position_not_blank CHECK (btrim(position_code) <> ''),
    CONSTRAINT component_bom_quantity_positive CHECK (quantity > 0),
    CONSTRAINT component_bom_not_self_referencing CHECK (
        parent_component_revision_id <> child_component_revision_id
    ),
    CONSTRAINT component_bom_position_unique UNIQUE (
        parent_component_revision_id,
        position_code
    )
);

CREATE TABLE firmware_project (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    project_key text NOT NULL,
    name text NOT NULL,
    description text NOT NULL DEFAULT '',
    created_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT firmware_project_key_format CHECK (
        project_key ~ '^[A-Z][A-Z0-9_]{1,19}$'
    ),
    CONSTRAINT firmware_project_name_not_blank CHECK (btrim(name) <> ''),
    CONSTRAINT firmware_project_key_unique UNIQUE (project_key)
);

CREATE TABLE firmware_release (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    firmware_project_id bigint NOT NULL
        REFERENCES firmware_project(id) ON DELETE RESTRICT,
    version_major integer NOT NULL,
    version_minor integer NOT NULL,
    version_patch integer NOT NULL,
    prerelease_label text NOT NULL DEFAULT '',
    release_status text NOT NULL DEFAULT 'draft',
    source_revision text,
    released_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT firmware_version_major_nonnegative CHECK (version_major >= 0),
    CONSTRAINT firmware_version_minor_nonnegative CHECK (version_minor >= 0),
    CONSTRAINT firmware_version_patch_nonnegative CHECK (version_patch >= 0),
    CONSTRAINT firmware_prerelease_format CHECK (
        prerelease_label = ''
        OR prerelease_label ~ '^[0-9A-Za-z]+(?:[.-][0-9A-Za-z]+)*$'
    ),
    CONSTRAINT firmware_source_revision_not_blank CHECK (
        source_revision IS NULL OR btrim(source_revision) <> ''
    ),
    CONSTRAINT firmware_release_status_valid CHECK (
        release_status IN ('draft', 'candidate', 'released', 'deprecated')
    ),
    CONSTRAINT firmware_released_timestamp_required CHECK (
        release_status NOT IN ('released', 'deprecated') OR released_at IS NOT NULL
    ),
    CONSTRAINT firmware_release_version_unique UNIQUE (
        firmware_project_id,
        version_major,
        version_minor,
        version_patch,
        prerelease_label
    )
);

CREATE TABLE firmware_release_dependency (
    firmware_release_id bigint NOT NULL
        REFERENCES firmware_release(id) ON DELETE CASCADE,
    depends_on_release_id bigint NOT NULL
        REFERENCES firmware_release(id) ON DELETE CASCADE,
    dependency_kind text NOT NULL,
    rationale text NOT NULL DEFAULT '',
    created_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT firmware_dependency_kind_valid CHECK (
        dependency_kind IN ('bootloader', 'runtime', 'radio', 'toolchain')
    ),
    CONSTRAINT firmware_dependency_not_self_referencing CHECK (
        firmware_release_id <> depends_on_release_id
    ),
    CONSTRAINT firmware_dependency_primary_key PRIMARY KEY (
        firmware_release_id,
        depends_on_release_id,
        dependency_kind
    )
);

CREATE INDEX board_bom_component_revision_idx
    ON board_bom_item (component_revision_id);

CREATE INDEX component_bom_child_revision_idx
    ON component_bom_item (child_component_revision_id);

CREATE INDEX firmware_dependency_target_idx
    ON firmware_release_dependency (depends_on_release_id);

COMMENT ON TABLE product_family IS
    'A product line that can have multiple physical board revisions.';
COMMENT ON TABLE board_revision IS
    'A versioned hardware board belonging to one product family.';
COMMENT ON TABLE component IS
    'A manufacturer and component identity independent of revision and lot.';
COMMENT ON TABLE component_revision IS
    'A specific revision of a component used in a bill of materials.';
COMMENT ON TABLE component_lot IS
    'A received lot of one component revision from a named supplier.';
COMMENT ON TABLE board_bom_item IS
    'A component revision installed at a position on a board revision.';
COMMENT ON TABLE component_bom_item IS
    'A nested component relationship used to represent hardware assemblies.';
COMMENT ON TABLE firmware_project IS
    'An independently versioned firmware product such as an application or bootloader.';
COMMENT ON TABLE firmware_release IS
    'A concrete semantic version of a firmware project.';
COMMENT ON TABLE firmware_release_dependency IS
    'A directed dependency from one firmware release to another.';

COMMIT;
