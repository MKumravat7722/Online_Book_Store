class Book
  attr_accessor :book_id, :category, :title, :author, :price, :stock

  def initialize(book_id,category, title, author, price, stock)
    @book_id = book_id
    @category = category
    @title = title
    @author = author
    @price = price
    @stock = stock
  end

  def to_s
    "Category: #{@category}, Title: #{@title}, Author: #{@author}, Price: #{@price}, Stock: #{@stock}"
  end
end
