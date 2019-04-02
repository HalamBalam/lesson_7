require_relative 'manufacturer'

class Wagon
  include Manufacturer

  attr_accessor :train

  def wagon_number
    return if train.nil?
    wagon_index = train.wagons.index(self)
    return if wagon_index.nil?
    train.number + "-" + wagon_index.to_s
  end

  def valid?
    validate!
    true
  rescue
    false
  end
end
