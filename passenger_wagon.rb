class PassengerWagon < Wagon
  attr_reader :number_of_seats, :occupied_seats

  WRONG_NUMBER_OF_SEATS = "Общее количество мест должно быть положительным числом"

  def initialize(number_of_seats)
    @number_of_seats = number_of_seats
    @occupied_seats = 0
    validate!
  end

  def take_a_seat
    @occupied_seats += 1 if empty_seats > 0
  end

  def empty_seats
    number_of_seats - occupied_seats
  end

  def description
    number = wagon_number
    if number.nil?
      "Пассажирский вагон на #{number_of_seats} мест (свободно: #{empty_seats}, занято: #{occupied_seats})"
    else
      "Пассажирский вагон № #{number} на #{number_of_seats} мест (свободно: #{empty_seats}, занято: #{occupied_seats})"
    end
  end

  protected

  def validate!
    raise WRONG_NUMBER_OF_SEATS unless number_of_seats > 0 
  end
end
