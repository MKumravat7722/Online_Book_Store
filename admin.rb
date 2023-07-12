
require 'io/console'
require_relative 'validname.rb'
require_relative 'bookstore.rb'
require_relative 'order.rb'
require 'csv'

class Admin
  MAX_ATTEMPT = 3
  bookstore = BookStore.new
  order=Order.new
  vn=ValidName.new
  def admin_panel(curr_user)
    loop do
      puts "\nAdmin Panel:"
      puts "1. Add book"
      puts "2. Delete book"
      puts "3. Browse book"
      puts "4. Order history"
      puts "5. Back"
      print "Please enter your choice: "
      admin_choice = gets.chomp.to_i

      case admin_choice
      when 1
        add_book
      when 2
       
        bookstore.delete_book
      when 3
        
        bookstore.load_books_from_csv1
      when 4
        order.order_history_display(curr_user)
      when 5
        break
      else
        puts "Invalid choice!"
      end
    end
  end

def add_book
  book_id = vn.generate_unique_book_id
  category = get_valid_category
  return if category.nil?

  add_new_category(category) unless category_exists?(category)

  title = get_valid_input("Please enter the book title: ", "Title cannot be blank.")
  return if title.nil?

  author = get_valid_input("Please enter the author: ", "Author cannot be blank.")
  return if author.nil?

  check_author_title(title, author)

  return if book_exists?(title, author)

  price = validate_positive_float_input("Please enter the price: ")
  return if price.nil?

  stock = validate_positive_integer_input("Please enter the stock quantity: ")
  return if stock.nil?

  

  CSV.open('book.csv', 'a+') do |csv1|
    csv1 << [book_id, category, title, author, price, stock]
  end
  puts "your new book has been succesfully saved under BookId: #{book_id}"
end


def get_valid_category
  attempt = 1

  print "Please enter the book category: "
  category = gets.chomp.strip

  while category.empty?
    if attempt >= MAX_ATTEMPT
      puts "You have reached the maximum attempt limit. Please try again later."
      return nil
    end

    puts "Category cannot be blank."
    attempt += 1
    print "Please enter the category: "
    category = gets.chomp.strip
  end

  category
end

def category_exists?(category)
  cat = CSV.read('category.csv')
  cat.any? { |cat| cat[0] == category }
end

def get_valid_input(prompt, error_message)
  attempt = 1

  print prompt
  input = gets.chomp.strip

  while input.empty?
    if attempt >= MAX_ATTEMPT
      puts "You have reached the maximum attempt limit. Please try again later."
      return nil
    end

    puts error_message
    attempt += 1
    print prompt
    input = gets.chomp.strip
  end

  input
end

def check_author_title(title, author)
  if title == author
    puts "An author name and book title cannot be the same."
    return
  end
end

def book_exists?(title, author)
  bookstore.book_title_author_exists?(title, author)
end

def add_new_category(category1)
  CSV.open('category.csv', 'a+') do |csv|
    csv << [category1]
    puts "Category added successfully."
  end
end

def validate_positive_float_input(prompt)
  attempt = 1

  loop do
    print prompt
    value = gets.chomp.to_f

    if value > 0
      return value
    else
      if attempt >= MAX_ATTEMPT
        puts "You have reached the maximum attempt limit. Please try again later."
        return nil
      end

      puts "Please enter a valid price greater than zero."
      attempt += 1
    end
  end
end




  def validate_positive_integer_input(prompt)
    attempt = 1
    loop do
      print prompt
      value = gets.chomp.to_i
      if value > 0
        return value
      else
        if attempt >= MAX_ATTEMPT
          puts "You have reached the maximum attempt limit. Please try again later."
          return nil
        end
        puts "Please enter a valid stock quantity."
        attempt += 1
      end
    end
  end
end
