# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160515034825) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "entidades", force: :cascade do |t|
    t.string   "nome"
    t.string   "cnpj"
    t.string   "latitude"
    t.string   "longitude"
    t.string   "estado"
    t.string   "cidade"
    t.string   "bairro"
    t.string   "cep"
    t.string   "rua"
    t.integer  "numero"
    t.string   "telefone"
    t.string   "contato"
    t.integer  "status"
    t.integer  "ramo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "entidades", ["ramo_id"], name: "index_entidades_on_ramo_id", using: :btree

  create_table "horarios", force: :cascade do |t|
    t.string   "dia_semana"
    t.time     "hora_inicio"
    t.time     "hora_fim"
    t.date     "data"
    t.integer  "entidade_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "horarios", ["entidade_id"], name: "index_horarios_on_entidade_id", using: :btree

  create_table "lista_precos", force: :cascade do |t|
    t.float    "preco"
    t.integer  "tempo"
    t.integer  "status"
    t.integer  "servico_id"
    t.integer  "entidade_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "lista_precos", ["entidade_id"], name: "index_lista_precos_on_entidade_id", using: :btree
  add_index "lista_precos", ["servico_id"], name: "index_lista_precos_on_servico_id", using: :btree

  create_table "profissional_servicos", force: :cascade do |t|
    t.integer  "profissional_id"
    t.integer  "lista_preco_id"
    t.integer  "entidade_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "profissional_servicos", ["entidade_id"], name: "index_profissional_servicos_on_entidade_id", using: :btree
  add_index "profissional_servicos", ["lista_preco_id"], name: "index_profissional_servicos_on_lista_preco_id", using: :btree
  add_index "profissional_servicos", ["profissional_id"], name: "index_profissional_servicos_on_profissional_id", using: :btree

  create_table "profissionals", force: :cascade do |t|
    t.string   "nome"
    t.string   "email"
    t.string   "telefone"
    t.integer  "status"
    t.integer  "entidade_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "profissionals", ["entidade_id"], name: "index_profissionals_on_entidade_id", using: :btree

  create_table "ramos", force: :cascade do |t|
    t.string   "nome"
    t.string   "descricao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reservas", force: :cascade do |t|
    t.date     "data"
    t.time     "hora_inicio"
    t.integer  "nota"
    t.integer  "status"
    t.string   "telefone"
    t.integer  "lista_preco_id"
    t.integer  "profissional_id"
    t.integer  "user_id"
    t.integer  "entidade_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "reservas", ["entidade_id"], name: "index_reservas_on_entidade_id", using: :btree
  add_index "reservas", ["lista_preco_id"], name: "index_reservas_on_lista_preco_id", using: :btree
  add_index "reservas", ["profissional_id"], name: "index_reservas_on_profissional_id", using: :btree
  add_index "reservas", ["user_id"], name: "index_reservas_on_user_id", using: :btree

  create_table "servicos", force: :cascade do |t|
    t.string   "nome"
    t.string   "descricao"
    t.integer  "tempo"
    t.float    "preco"
    t.integer  "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "nome"
    t.string   "email"
    t.integer  "tipo"
    t.integer  "status"
    t.integer  "entidade_id"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "users", ["entidade_id"], name: "index_users_on_entidade_id", using: :btree

  add_foreign_key "entidades", "ramos"
  add_foreign_key "horarios", "entidades"
  add_foreign_key "lista_precos", "entidades"
  add_foreign_key "lista_precos", "servicos"
  add_foreign_key "profissional_servicos", "entidades"
  add_foreign_key "profissional_servicos", "lista_precos"
  add_foreign_key "profissional_servicos", "profissionals"
  add_foreign_key "profissionals", "entidades"
  add_foreign_key "reservas", "entidades"
  add_foreign_key "reservas", "lista_precos"
  add_foreign_key "reservas", "profissionals"
  add_foreign_key "reservas", "users"
  add_foreign_key "users", "entidades"
end
