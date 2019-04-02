module Manufacturer

  attr_reader :manufacturer

  def set_manufacturer
    puts "Введите название производителя"
    self.manufacturer = gets.chomp
  end

end
