# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_05_29_014929) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "cargos", force: :cascade do |t|
    t.string "nombre", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "departamentos", force: :cascade do |t|
    t.string "nombre", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "empleados", force: :cascade do |t|
    t.integer "departamento_id", null: false
    t.integer "cargo_id", null: false
    t.string "dui", null: false
    t.string "nombres"
    t.string "apellidos"
    t.string "numero_telefono"
    t.date "fecha_nacimiento"
    t.boolean "activo", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cargo_id"], name: "index_empleados_on_cargo_id"
    t.index ["departamento_id"], name: "index_empleados_on_departamento_id"
  end

  create_table "log_actividades", force: :cascade do |t|
    t.integer "usuario_id", null: false
    t.string "actividad"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["usuario_id"], name: "index_log_actividades_on_usuario_id"
  end

  create_table "misiones", force: :cascade do |t|
    t.string "nombre", null: false
    t.string "descripcion"
    t.date "fecha_inicio", null: false
    t.date "fecha_final", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "misiones_empleados", force: :cascade do |t|
    t.integer "misione_id", null: false
    t.integer "empleado_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["empleado_id"], name: "index_misiones_empleados_on_empleado_id"
    t.index ["misione_id"], name: "index_misiones_empleados_on_misione_id"
  end

  create_table "modulos", force: :cascade do |t|
    t.string "nombre", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "permisos", force: :cascade do |t|
    t.integer "modulo_id", null: false
    t.integer "role_id", null: false
    t.boolean "activo"
    t.boolean "crear"
    t.boolean "actualizar"
    t.boolean "eliminar"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["modulo_id"], name: "index_permisos_on_modulo_id"
    t.index ["role_id"], name: "index_permisos_on_role_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "nombre", null: false
    t.string "descripcion"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "usuarios", force: :cascade do |t|
    t.integer "empleado_id"
    t.integer "role_id", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.boolean "activo", default: true, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_usuarios_on_email", unique: true
    t.index ["empleado_id"], name: "index_usuarios_on_empleado_id"
    t.index ["reset_password_token"], name: "index_usuarios_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_usuarios_on_role_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "empleados", "cargos"
  add_foreign_key "empleados", "departamentos"
  add_foreign_key "log_actividades", "usuarios"
  add_foreign_key "misiones_empleados", "empleados"
  add_foreign_key "misiones_empleados", "misiones"
  add_foreign_key "permisos", "modulos"
  add_foreign_key "permisos", "roles"
  add_foreign_key "usuarios", "empleados"
  add_foreign_key "usuarios", "roles"
end
