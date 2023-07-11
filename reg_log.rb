require_relative 'user.rb'
require 'io/console'
require 'csv'

class RegLog
  MAX_ATTEMPTS = 3

 
  def register_user
    
    attempt = 0
    while !attempt_exceeded_max?(attempt)
      valid_username='Y'
      attempt = attempt+1
      puts 'Please enter the username: '
      username = gets.chomp.downcase.strip
      
      if username.empty?
        puts "username cannot be blank"
        valid_username='N'
        next
      end
      if username_exists?(username) 
        puts"this user already exists please enter different username "
        valid_username='N'
        next
      end
      break
    end
    if valid_username=='N'
      return
    end
    attempt=0
    while !attempt_exceeded_max?(attempt)
      valid_password='Y'
      attempt = attempt+1
      puts 'Please enter password: '
      password=masked_input
      if password.empty?
        puts "password cannot be blank"
        valid_password='N'
        next
      end
      if invalid_password?(password)
        valid_password='N'
        next
      end
      break
    end
    if valid_password=='N'
      return
    end
   save_user(username,password)
  end
  def login
    attempt=0
    while !attempt_exceeded_max?(attempt)
      valid_username='Y'
      attempt = attempt+1
      puts 'Please enter the username: '
      username = gets.chomp.downcase.strip
      
      if username.empty?
        puts "username cannot be blank"
        valid_username='N'
        next
      end
      if !username_exists?(username) 
        valid_username='N'
       puts "Please enter valid username"
       next
      end
      break
    end
    if valid_username=='N'
      return
    end
    attempt=0
    while !attempt_exceeded_max?(attempt)
      valid_password='Y'
      attempt = attempt+1
      puts 'Please enter password: '
      password=masked_input
      if password.empty?
        puts "password cannot be blank"
        valid_password='N'
        next
      end
      if !valid_credentials?(username,password)
        puts "please enter valid passwoword"
        valid_password='N'
        next
      end
      break
    end
    if valid_password=='Y'
      if username == 'admin'
        admin = Admin.new
        admin.admin_panel(username)
      else  
        user=User.new
        user.user_panel(username)
      end
    end
  end
  def save_user(username, password)
    user = { username: username, password: password }
    CSV.open('users.csv', 'a') do |csv|
      csv << [user[:username], user[:password]&.downcase]
       puts"\nRegistration Succesfull...."
    end
  end

  def username_exists?(username)
    users = CSV.read('users.csv').map { |user| user.map(&:downcase) }
    if users.any? { |user| user[0] == username }
      return true
    end
    false
  end
  
  def attempt_exceeded_max?(attempt)
    if attempt >= MAX_ATTEMPTS
      puts "You have reached the maximum attempt limit. Please try again later."
      return true
    end
    false
  end
    attempt = 0
     def invalid_password?(password)
        if password.length >= 8 && password =~ /[A-Za-z]/ && password =~ /[0-9]/ && password =~ /[!@#$%^&*(),.?":{}|<>]/
          return false
        end
      true
      end
    def masked_input
      password = ''
      while (char = STDIN.getch) != "\r"
        if char == "\u007F" || char == "\b"
          password.slice!(-1)
          print "\b \b"
        else
          password << char
          print '*'
        end
      end
      puts
      password
    end
 
    def valid_credentials?(username, password)
      users = CSV.read('users.csv').map { |user| user.map(&:downcase) }
      return users.any? { |user| user[0] == username && user[1] == password.downcase }
      return false
    end
    
end