require_relative 'bookstore.rb'
require_relative 'reg_log.rb'
require_relative 'admin.rb'
require_relative 'book.rb'

class Main
  def main
  
    bookstore = BookStore.new
  loop do
    puts "Welcome to the Online Bookstore!"
    puts "\nMenu:"
    puts "1. Registration"
    puts "2. Login"
    puts "3. Exit"

    print "\nPlease enter your choice: "
    choice = gets.chomp.to_i
    
    case choice
    when 1
      reglog = RegLog.new
      reglog.register_user
    when 2
      reglog = RegLog.new
      reglog.login
    when 3
      puts "Thank you for using the Online Bookstore. Goodbye!"
    exit;
    else
      puts "Invalid choice!"
    end
  end

   
 end

end
main1=Main.new 
main1.main
