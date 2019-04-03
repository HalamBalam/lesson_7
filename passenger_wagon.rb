class PassengerWagon < Wagon

  SIZE_ERROR = "Общее количество мест должно быть положительным числом"

  def take_a_seat
    reserve_space(1)
  end

  def size_error
    SIZE_ERROR
  end

end
