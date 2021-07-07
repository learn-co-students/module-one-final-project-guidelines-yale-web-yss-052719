class Book < ActiveRecord::Base
    has_many :list_books
    has_many :lists, through: :list_books

    def hash
        {
            self.book_title => {
                id: self.book_id,
                author: self.author_name,
                genre: [self.genre_1, self.genre_2],
                publication_date: self.publish_date,
                rating: self.book_average_rating,
                url: self.book_fullurl,
                pages: self.pages
            }
        }
    end

end