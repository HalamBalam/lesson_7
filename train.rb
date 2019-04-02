require_relative 'manufacturer'
require_relative 'instance_counter'

class Train
  include Manufacturer
  include InstanceCounter

  attr_reader :number, :speed, :wagons

  NUMBER_FORMAT = /^[\da-z]{3}-?[\da-z]{2}$/i
  WRONG_NUMBER_FORMAT = "Неверный формат номера"

  @@trains = {}

  def self.find(number)
    @@trains[number]
  end

  def initialize(number)
    @number = number
    @speed = 0
    @wagons = []
    validate!
    @@trains[number] = self
    register_instance
  end

  def up_speed(delta)
    @speed += delta
  end

  def down_speed(delta)
    @speed -= delta
    @speed = 0 if @speed < 0 
  end

  def attach_wagon(wagon)
    return unless speed.zero?
    return unless attachable_wagon?(wagon)
    @wagons << wagon
    wagon.train = self
  end

  def detach_wagon(wagon)
    return unless speed.zero?
    @wagons.delete(wagon)
    wagon.train = nil
  end

  def wagons_count
    @wagons.size()
  end

  def set_route(route)
    @route = route
    @current_station = 0
    current_station.arrive(self)
  end

  def current_station
    @route.stations[@current_station] unless @route.nil?
  end

  def next_station
    @route.stations[@current_station + 1] unless @route.nil?
  end

  def previous_station
    @route.stations[@current_station - 1] if !@route.nil? && @current_station > 0
  end

  def go_forward
    return if next_station.nil?
    current_station.depart(self)
    next_station.arrive(self)
    @current_station += 1
  end

  def go_back
    return if previous_station.nil?
    current_station.depart(self)
    previous_station.arrive(self)
    @current_station -= 1
  end

  def description
    type_str = self.is_a?(CargoTrain) ? "Грузовой" : "Пассажирский"
    if @route.nil?
      "#{type_str} поезд № #{number} (вагонов: #{wagons_count}, скорость: #{speed})"
    else
      "#{type_str} поезд № #{number} (вагонов: #{wagons_count}, скорость: #{speed}, текущая станция: #{current_station.name})"
    end
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  def each_wagon
    wagons.each { |wagon| yield(wagon) }
  end

  protected

  def validate!
    raise WRONG_NUMBER_FORMAT if number !~ NUMBER_FORMAT
  end

end
