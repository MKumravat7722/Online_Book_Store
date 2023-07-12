class ValidName
  def generate_unique_book_id
  
    csv_data = CSV.read('Book.csv', headers: true)
  numeric_part = (csv_data[(csv_data.length) -1][0]).match(/\d+/)[0].to_i
  next_numeric_part = numeric_part + 1
  new_book_id = "BK" + next_numeric_part.to_s.rjust(4, '0')  
  return new_book_id
  end
end
