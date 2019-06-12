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

ActiveRecord::Schema.define(version: 8) do

  create_table "applications", force: :cascade do |t|
    t.integer "student_id"
    t.integer "college_id"
    t.string "type"
  end

  create_table "colleges", force: :cascade do |t|
    t.integer "school_id"
    t.string "name"
    t.string "city"
    t.string "state"
    t.string "url"
    t.float "admission_rate_overall_2017"
    t.float "sat_scores_average_overall_2017"
    t.float "act_scores_average_cumulative_2013"
    t.string "username"
  end

  create_table "students", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.integer "grade"
    t.string "high_school"
    t.integer "grad_year"
    t.integer "act_score"
    t.integer "sat_score"
    t.string "username"
  end

end
