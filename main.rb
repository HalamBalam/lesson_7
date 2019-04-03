require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'

class Main
  
  MAIN_MENU              = ['Станции', 'Поезда', 'Маршруты']
  STATIONS_MENU          = ['Создать станцию', 'Показать поезда на станции', 'Показать поезда с вагонами на станции']
  TRAINS_MENU            = ['Создать поезд', 'Создать вагон', 'Выбрать поезд для дальнейших действий', 'Занять место (объем) в вагоне']
  ACTION_WITH_TRAIN_MENU = ['Прицепить вагон', 'Отцепить вагон', 'Посмотреть состав',
                            'Назначить маршрут', 'Отправиться на следующую станцию', 'Вернуться на предыдущую станцию']
  TRAIN_TYPES_MENU       = ['Грузовой', 'Пассажирский']
  ROUTES_MENU            = ['Создать маршрут', 'Выбрать маршрут для дальнейших действий']
  ACTION_WITH_ROUTE_MENU = ['Добавить станцию', 'Удалить станцию']

  def initialize
    @stations = []
    @trains = []
    @routes = []
    @wagons = []
  end

  def run
    loop do
      show_menu(MAIN_MENU)

      case gets.to_i
      when 0 then break
      when 1 then stations_menu
      when 2 then trains_menu
      when 3 then routes_menu
      end
    end  
  end

  private

  def show_menu(menu, show_exit = true)
    puts
    menu.each.with_index(1) do |item, index|
      puts "#{index}-#{item}"
    end
    puts "0-Выход" if show_exit
  end

  def show_collection(elements)
    elements.each.with_index(1) do |element, index|
      puts "#{index}-\"#{element.description}\""
    end  
  end

  def choose_element(elements)
    return if elements.empty?
    loop do
      show_collection(elements)

      index = gets.chomp.to_i - 1
      if index >= 0 && !elements[index].nil?
        return elements[index]  
      end
    end
  end

  def create_station
    puts "Введите название станции"
    name = gets.chomp
    station = Station.new(name)
    puts "Создана станция: \"#{station.description}\""
    @stations << station
  end

  def show_station_trains(with_wagons)
    station = choose_element(@stations)
    return unless station
    if station.trains.empty?
      puts "На станции \"#{station.description}\" нет поездов"
    else
      puts "Поезда на станции \"#{station.description}\":"
      if with_wagons
        station.trains.each.with_index(1) do |train, index|
          puts "#{index}-\"#{train.description}\""
          show_wagons(train)
        end 
      else
        show_collection(station.trains)
      end
    end
  end

  def stations_menu
    loop do
      show_menu(STATIONS_MENU)
      case gets.to_i
      when 0 then break
      when 1 then create_station
      when 2 then show_station_trains(false)
      when 3 then show_station_trains(true)
      end
    end
  end

  def create_train
    loop do
      show_menu(TRAIN_TYPES_MENU, false)
      train_type = gets.chomp.to_i

      next unless [1, 2].include?(train_type)

      puts "Введите номер поезда"
      train_number = gets.chomp

      begin
        train = train_type == 1 ? CargoTrain.new(train_number) : PassengerTrain.new(train_number)
      rescue RuntimeError => e
        puts "ОШИБКА: \"#{e.message}\""
        puts "Введите данные повторно"
        next
      end

      puts "Создан поезд: \"#{train.description}\""
      @trains << train
      break
    end  
  end

  def create_wagon
    loop do
      show_menu(TRAIN_TYPES_MENU, false)
      wagon_type = gets.chomp.to_i

      next unless [1, 2].include?(wagon_type)

      puts "Введите объем вагона" if wagon_type == 1
      puts "Введите общее количество мест" if wagon_type == 2

      wagon_size = gets.to_i
      wagon = wagon_type == 1 ? CargoWagon.new(wagon_size) : PassengerWagon.new(wagon_size)

      puts "Создан вагон: \"#{wagon.description}\""
      @wagons << wagon
      break
    end
  end

  def attach_wagon(train)
    wagon_class = train.is_a?(CargoTrain) ? CargoWagon : PassengerWagon
    wagon = choose_element(@wagons.select { |wagon| wagon.train.nil? && wagon.is_a?(wagon_class) })
    return unless wagon
    train.attach_wagon(wagon)
    puts train.description
  end

  def detach_wagon(train)
    wagon = choose_element(train.wagons)
    return unless wagon
    train.detach_wagon(wagon)
    puts train.description
  end

  def show_wagons(train)
    puts "Состав:"
    train.wagons.each do |wagon|
      puts "  #{wagon.description}"
    end 
  end

  def set_route(train)
    if @routes.empty?
      puts "ОШИБКА: Для начала создайте маршрут"
      return
    end

    puts "Выберите маршрут"
    route = choose_element(@routes)
    train.set_route(route)
  end

  def action_with_train_menu
    train = choose_element(@trains)
    return unless train

    loop do
      puts "\nВыберите действие с поездом \"#{train.description}\""
      show_menu(ACTION_WITH_TRAIN_MENU)

      case gets.to_i
      when 0 then break
      when 1 then attach_wagon(train)
      when 2 then detach_wagon(train)
      when 3 then show_wagons(train)
      when 4 then set_route(train)
      when 5 then train.go_forward
      when 6 then train.go_back
      end
    end
  end

  def action_with_wagon
    wagon = choose_element(@wagons)
    return unless wagon

    if wagon.is_a?(CargoWagon)
      puts "Введите занимаемый объем"
      volume = gets.to_i
      wagon.fill_space(volume)
    else
      puts "Введите занимаемое количество мест"
      number_of_seats = gets.to_i
      number_of_seats.times { wagon.take_a_seat }
    end

    puts wagon.description
  end

  def trains_menu
    loop do
      show_menu(TRAINS_MENU)
      case gets.to_i
      when 0 then break
      when 1 then create_train
      when 2 then create_wagon
      when 3 then action_with_train_menu
      when 4 then action_with_wagon
      end
    end
  end

  def create_route
    if @stations.size < 2
      puts "ОШИБКА: Для начала создайте минимум 2 станции"
      return
    end

    puts "Выберите начальную станцию"
    start = choose_element(@stations)

    puts "Выберите конечную станцию"
    finish = choose_element(@stations)

    return if start == finish
    route = Route.new(start, finish)
    puts "Создан маршрут: \"#{route.description}\""
    @routes << route
  end

  def add_station(route)
    puts "Выберите добавляемую станцию"
    station = choose_element(@stations)

    route.add_station(station) unless station.nil?
  end

  def delete_station(route)
    if route.stations.size < 3
      puts "ОШИБКА: У маршрута должно быть больше двух станций"
      return
    end

    puts "Выберите удаляемую станцию"
    station = choose_element(route.stations[1, route.stations.size - 2])

    route.delete_station(station) unless station.nil?
  end

  def action_with_route_menu
    route = choose_element(@routes)
    return unless route

    loop do
      puts "\nВыберите действие с маршрутом \"#{route.description}\""
      show_menu(ACTION_WITH_ROUTE_MENU)

      case gets.to_i
      when 0 then break
      when 1 then add_station(route)
      when 2 then delete_station(route)
      end
    end  
  end

  def routes_menu
    loop do
      show_menu(ROUTES_MENU)
      case gets.to_i
      when 0 then break
      when 1 then create_route
      when 2 then action_with_route_menu
      end
    end
  end

end

main = Main.new
main.run
