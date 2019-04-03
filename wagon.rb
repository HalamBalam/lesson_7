require_relative 'manufacturer'

class Wagon
  include Manufacturer

  attr_accessor :train
  attr_reader :size, :reserved_space

  def initialize(size)
    @size = size
    @reserved_space = 0
    validate!
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  def available_space
    size - reserved_space
  end

  def description
    number_text = wagon_number.nil? ? "" : "№ #{wagon_number} "

    if self.is_a?(PassengerWagon)
      "Пассажирский вагон #{number_text}на #{size} мест (свободно: #{available_space}, занято: #{reserved_space})"
    else
      "Грузовой вагон #{number_text}объемом #{size} кв.м. (свободно: #{available_space}, занято: #{reserved_space})"  
    end
  end

  protected

  def validate!
    raise size_error unless size > 0 
  end

  def wagon_number
    return if train.nil?
    wagon_index = train.wagons.index(self)
    return if wagon_index.nil?
    train.number + "-" + wagon_index.to_s
  end

  def reserve_space(delta)
    @reserved_space += [delta, available_space].min
  end
end
