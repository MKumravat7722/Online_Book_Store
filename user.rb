require_relative('bookstore.rb')
require_relative('order.rb')

class User
  
    def user_panel(username)
    loop do
        puts "\nHi #{username}"
        puts "User Panel:"
        puts "1. Browse Books"
        puts "2. Search Books"
        puts "3. Order a Book"
        puts "4  Order History "
        puts "5  Exit"
        print "Please enter your choice: "
        admin_choice = gets.chomp.to_i
  
        case admin_choice
        when 1
            bookstore=BookStore.new
            bookstore.browse_books
        when 2
            bookstore=BookStore.new
            bookstore.search_book_by_title
        when 3
            order=Order.new
            order.process_order(username)
        when 4
            order=Order.new
            order.order_history_display(username)
        when 5
         return
        else
          puts "Invalid choice!"
        end
      end
    end
end