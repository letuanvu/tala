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

ActiveRecord::Schema.define(version: 2018_08_08_101336) do

  create_table "card_storages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "card_type"
    t.integer "card_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_number"], name: "index_card_storages_on_card_number"
    t.index ["card_type"], name: "index_card_storages_on_card_type"
  end

  create_table "cards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "card_type"
    t.integer "card_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_number"], name: "index_cards_on_card_number"
    t.index ["card_type"], name: "index_cards_on_card_type"
  end

  create_table "options", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "option_name"
    t.string "option_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["option_name"], name: "index_options_on_option_name"
  end

  create_table "player_cards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "player_slot"
    t.string "card_type"
    t.integer "card_number"
    t.boolean "is_showing"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_number"], name: "index_player_cards_on_card_number"
    t.index ["card_type"], name: "index_player_cards_on_card_type"
    t.index ["is_showing"], name: "index_player_cards_on_is_showing"
    t.index ["player_slot"], name: "index_player_cards_on_player_slot"
  end

  create_table "players", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "player_name"
    t.integer "player_slot"
    t.text "player_cards"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
