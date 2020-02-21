# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_21_194251) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artists", force: :cascade do |t|
    t.string "name"
    t.integer "fm_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "friendships", force: :cascade do |t|
    t.bigint "friender_id", null: false
    t.bigint "friended_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["friended_id"], name: "index_friendships_on_friended_id"
    t.index ["friender_id"], name: "index_friendships_on_friender_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "multiplier"
    t.string "final_score"
    t.bigint "user_id"
    t.bigint "song_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "genre_id", null: false
    t.index ["genre_id"], name: "index_games_on_genre_id"
    t.index ["song_id"], name: "index_games_on_song_id"
    t.index ["user_id"], name: "index_games_on_user_id"
  end

  create_table "genre_scores", force: :cascade do |t|
    t.integer "score"
    t.bigint "genre_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["genre_id"], name: "index_genre_scores_on_genre_id"
    t.index ["user_id"], name: "index_genre_scores_on_user_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "fm_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "answer"
    t.string "input"
    t.bigint "game_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "question_type"
    t.index ["game_id"], name: "index_questions_on_game_id"
  end

  create_table "rankings", force: :cascade do |t|
    t.integer "total_score"
    t.integer "rank"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_rankings_on_user_id"
  end

  create_table "song_genres", force: :cascade do |t|
    t.bigint "song_id", null: false
    t.bigint "genre_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["genre_id"], name: "index_song_genres_on_genre_id"
    t.index ["song_id"], name: "index_song_genres_on_song_id"
  end

  create_table "songs", force: :cascade do |t|
    t.string "title"
    t.string "release_date"
    t.integer "artist_id"
    t.string "album"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "fm_id"
    t.integer "listens"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.string "password_digest"
    t.string "genius_token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "friendships", "users", column: "friended_id", on_delete: :cascade
  add_foreign_key "friendships", "users", column: "friender_id", on_delete: :cascade
  add_foreign_key "games", "genres"
  add_foreign_key "genre_scores", "genres"
  add_foreign_key "genre_scores", "users"
  add_foreign_key "rankings", "users"
  add_foreign_key "song_genres", "genres"
  add_foreign_key "song_genres", "songs"
end
