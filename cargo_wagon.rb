class CargoWagon < Wagon

  SIZE_ERROR = "Объем должен быть положительным числом"
  SIZE_LIMIT_ERROR = "Занимаемый объем превышает свободный"

  alias fill_space reserve_space

  def fill_space(delta)
    reserve_space(delta)
  end

  def size_error
    SIZE_ERROR
  end

  def size_limit_error
    SIZE_LIMIT_ERROR 
  end

end
