require 'csv'
require 'io/console'
 require_relative 'book.rb'

class BookStore
  attr_accessor :books, :orders
def initialize
    @books = []
end
def self.book_title_author_exists?(title, author)
    CSV.foreach('book.csv', headers: true) do |row|
      book_title = row['Title']
      book_author = row['Author']

      if book_title.downcase.include?(title.downcase) && book_author.downcase.include?(author.downcase)
        return true # Same title and author combination already exists
      end
    end
    return false # No matching title and author found, so allow adding the book
end
   def load_books_from_csv1
      if File.exist?('book.csv')
       CSV.foreach('book.csv', headers: true) do |row|
        book_id = row['Book_id']
        category = row['Category']
        title = row['Title']
        author = row['Author']
        price = row['Price'].to_f
        stock = row['Stock'].to_i
        puts "book_id: #{book_id}, Category: #{category}, Title: #{title}, Author: #{author}, Price: #{price}, Stock: #{stock}"
      end
    end
  end

  def browse_books
    puts "\nCategories:"
    CSV.foreach('category.csv').with_index(1) do |row, index|
      puts "#{index}. #{row.join(', ')}"
    end
  puts "--------------------------------------------------------------------------------------"
    # print_books
    load_books_from_csv1
    loop do
      print "\nEnter 1 to view more details about a book, 0 to go back: "
      choice = gets.chomp.to_i
      case choice
      when 1
       search_book_by_title
      when 0
        break
      else
        puts "Invalid choice!"
      end
    end
    puts
  end

  def book_title_author_exists?(title, author)
    CSV.foreach('book.csv', headers: true) do |row|
      book_title = row['Title']
      book_author = row['Author']
   if book_title.downcase.include?(title.downcase) && book_author.downcase.include?(author.downcase)
        return true # Same title and author combination already exists
      end
    end

    return false # No matching title and author found, so allow adding the book
  end

  def search_book_by_title
    loop do
      puts "Enter the book title to view details or press 0 to go back: "
      book_title = gets.chomp.to_s
      if book_title == '0'
        break
      end
      count = 0
      CSV.foreach('book.csv', headers: true) do |row|
        book_id =row['Book_id']
        category = row['Category']
        title = row['Title']
        author = row['Author']
        price = row['Price'].to_f
        stock = row['Stock'].to_i
        if title.downcase.include?(book_title.downcase)
          puts "book_id #{book_id}"
          puts "Category:#{category}"
          puts "Title: #{title}"
          puts "Author: #{author}"
          puts "Price: #{price}"
          puts "Stock: #{stock}"
          puts
          count = count + 1
        end
      end
     
      puts "Total book found #{count}"
    end
  end

  def delete_book
    load_books_from_csv1
    puts "Enter the book ID to delete:"
    book_id = gets.chomp.strip

    input_file = 'book.csv'
    rows = CSV.read(input_file, headers: true)
    matched_rows = rows.select { |row| row['Book_id'].downcase == book_id.downcase }
    
    if matched_rows.empty?
      puts "Book with ID '#{book_id}' not found in the inventory."
    else
      rows.delete_if { |row| row['Book_id'].downcase == book_id.downcase }

      CSV.open(input_file, 'w') do |csv|
        csv << rows.headers
        rows.each { |row| csv << row }
      end
      puts "Book with ID '#{book_id}' deleted successfully."
    end
  end


end
