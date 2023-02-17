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

ActiveRecord::Schema[7.0].define(version: 2023_02_11_231708) do
  create_table "assignments", force: :cascade do |t|
    t.integer "dinosaur_id", null: false
    t.integer "cage_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cage_id"], name: "index_assignments_on_cage_id"
    t.index ["dinosaur_id"], name: "index_assignments_on_dinosaur_id"
  end

  create_table "cages", force: :cascade do |t|
    t.string "number", null: false
    t.integer "vore_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["vore_id"], name: "index_cages_on_vore_id"
  end

  create_table "dinosaurs", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "alive", default: true, null: false
    t.integer "species_id", null: false
    t.integer "vore_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["species_id"], name: "index_dinosaurs_on_species_id"
    t.index ["vore_id"], name: "index_dinosaurs_on_vore_id"
  end

  create_table "species", force: :cascade do |t|
    t.string "name", null: false
    t.integer "vore_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["vore_id"], name: "index_species_on_vore_id"
  end

  create_table "vores", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "assignments", "cages"
  add_foreign_key "assignments", "dinosaurs"
  add_foreign_key "cages", "vores"
  add_foreign_key "dinosaurs", "species"
  add_foreign_key "dinosaurs", "vores"
  add_foreign_key "species", "vores"
end
