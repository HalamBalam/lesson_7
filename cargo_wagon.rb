class CargoWagon < Wagon
  attr_reader :volume, :filled_space

  WRONG_VOLUME = "Объем должен быть положительным числом"

  def initialize(volume)
    @volume = volume
    @filled_space = 0
    validate!
  end

  def fill_space(volume)
    @filled_space += [volume, available_space].min
  end

  def available_space
    volume - filled_space
  end

  def description
    number = wagon_number
    if number.nil?
      "Грузовой вагон объемом #{volume} кв.м. (свободно: #{available_space}, занято: #{filled_space})"
    else
      "Грузовой вагон № #{number} объемом #{volume} кв.м. (свободно: #{available_space}, занято: #{filled_space})"  
    end
  end

  protected

  def validate!
    raise WRONG_VOLUME unless volume > 0
  end
end
