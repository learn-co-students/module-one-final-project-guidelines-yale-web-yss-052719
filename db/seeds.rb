require 'csv'
require './config/environment.rb'


# user1 = User.new(username:"user")
# list1 = List.new(name:"list1", user_id:user1.id)

path = File.join(File.dirname(__FILE__), './seeds/goodreads.csv')
puts path

Book.destroy_all

csv_text = File.read(path)
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
(0..200).each do |i|
    row = csv[i]
    t = Book.new
    t.author_average_rating = row[0]
    t.author_gender = row[1]
    t.author_genres = row[2]
    t.author_id = row[3]
    t.author_name = row[4].strip
    t.author_page_url = row[5]
    t.author_rating_count = row[6]
    t.author_review_count = row[7]
    t.birthplace = row[8].strip
    t.book_average_rating = row[9]
    t.book_fullurl = row[10]
    t.book_id = row[11]
    t.book_title = row[12].strip
    t.genre_1 = row[13]
    t.genre_2 = row[14]
    t.num_ratings = row[15]
    t.num_reviews = row[16]
    t.pages = row[17]
    t.publish_date = row[18]
    t.score = row[19]
    t.save
end


