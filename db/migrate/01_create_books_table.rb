class CreateBooksTable < ActiveRecord::Migration[5.2]
    def change
        create_table :books do |t|
            t.float :author_average_rating
            t.string :author_gender
            t.string :author_genres
            t.integer :author_id
            t.string :author_name
            t.string :author_page_url
            t.integer :author_rating_count
            t.integer :author_review_count
            t.string :birthplace
            t.integer :book_average_rating
            t.string :book_fullurl
            t.integer :book_id
            t.string :book_title
            t.string :genre_1
            t.string :genre_2
            t.integer :num_ratings
            t.integer :num_reviews
            t.integer :pages
            t.string :publish_date
            t.integer :score
        end
    end
end