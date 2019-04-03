class CargoWagon < Wagon

  SIZE_ERROR = "Объем должен быть положительным числом"

  def fill_space(delta)
    reserve_space(delta)
  end

  def size_error
    SIZE_ERROR
  end

end
