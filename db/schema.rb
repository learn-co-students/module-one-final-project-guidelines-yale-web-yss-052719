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

ActiveRecord::Schema.define(version: 5) do

  create_table "books", force: :cascade do |t|
    t.float   "author_average_rating"
    t.string  "author_gender"
    t.string  "author_genres"
    t.integer "author_id"
    t.string  "author_name"
    t.string  "author_page_url"
    t.integer "author_rating_count"
    t.integer "author_review_count"
    t.string  "birthplace"
    t.integer "book_average_rating"
    t.string  "book_fullurl"
    t.integer "book_id"
    t.string  "book_title"
    t.string  "genre_1"
    t.string  "genre_2"
    t.integer "num_ratings"
    t.integer "num_reviews"
    t.integer "pages"
    t.string  "publish_date"
    t.integer "score"
  end

  create_table "list_books", force: :cascade do |t|
    t.integer "book_id"
    t.integer "list_id"
  end

  create_table "lists", force: :cascade do |t|
    t.string  "name"
    t.integer "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string  "username"
    t.integer "age"
    t.string  "favourite_genre"
    t.string  "favourite_book"
  end

end
