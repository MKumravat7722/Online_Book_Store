require_relative('bookstore.rb')
require 'csv'
class Order
  def self.process_order(curr_user)
    puts
    Order.search_book_for_order
    loop do
      puts "Please enter the book ID for processing the order or press 0 to go back"
      book_id = gets.chomp.strip
      if book_id.to_s == '0'
        puts "Exiting..."
        break
      end
     book_found, order_success = Order.process_order_for_book(curr_user, book_id)
     unless book_found
        puts "Book with ID '#{book_id}' not found in the inventory."
      end
    break if order_success
    end
  end
  def self.process_order_for_book(curr_user, book_id)
    csv_data = CSV.read('book.csv', headers: true)
    matching_index = csv_data.find_index { |row| row['Book_id'] == book_id }
    
    if matching_index
      book_found = true
    order_success = Order.process_order_quantity(matching_index, curr_user,csv_data)
      return book_found, order_success
    end
   return book_found = false, order_success = false
  end
  
  def self.process_order_quantity(matching_index, curr_user,csv_data)
    puts "Please specify the quantity"
    ordered_quantity = gets.chomp.to_i
    if ordered_quantity == 0
      puts "Quantity should be greater than 0"
      return order_success = false
    end
      stock=csv_data[matching_index]["Stock"].to_i
   
    if ordered_quantity <= stock
      if ordered_quantity < stock
        csv_data[matching_index]["Stock"] = (stock - ordered_quantity).to_s
      else
         csv_data[matching_index]["Stock"]=0
      end
     CSV.open('book.csv', 'w') do |csv|
        csv << csv_data.headers
        csv_data.each do |row|
          csv << row
        end 
      end
     puts "Order successfully placed"
     CSV.open('orderhistory.csv', 'a+') do |csv|
      csv << [curr_user,csv_data[matching_index]["Book_id"],csv_data[matching_index]["Category"],csv_data[matching_index]["Title"],csv_data[matching_index]["Author"],csv_data[matching_index]["Price"],ordered_quantity] 
      end 
     return order_success = true
     else
      puts "Quantity not available"
      return order_success = false
    end
  
  end

  def self.search_book_for_order
      puts "Available Books:"
      puts "----------------------"
      CSV.foreach('book.csv').with_index(0) do |row, index|
        puts "#{index}. #{row.join(', ')}"
        puts 
      end
        puts "----------------------"
  end
  def self.order_history_display(curr_user)
    if File.exist?('orderhistory.csv')
      history_found = 'N'
      CSV.foreach('orderhistory.csv', headers: true) do |row|
        user_name = row['User_name']
        book_id = row['Book_id']
        category = row['Category']
        title = row['Title']
        author = row['Author']
        price = row['Price'].to_f
        stock = row['Stock'].to_i
        book = Book.new(book_id, category, title, author, price, stock)
        if curr_user == 'admin' 
          puts "User_name: #{user_name}, BookId: #{book_id}, Category: #{category}, Title: #{title}, Author: #{author}, Price: #{price}, Stock: #{stock}"
          history_found = 'Y'
        end
        if user_name.downcase.include?(curr_user.downcase)
          puts "BookId: #{book_id}, Category: #{category}, Title: #{title}, Author: #{author}, Price: #{price}, Stock: #{stock}"
          history_found = 'Y'
        end
      end
      if history_found == 'N'
        puts "History not available for #{curr_user}"
      end
    end
  end
end
