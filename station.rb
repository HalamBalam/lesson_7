require_relative 'instance_counter'

class Station
  include InstanceCounter

  attr_reader :name, :trains

  EMPTY_NAME = "Не указано наименование"

  @@instances = []

  def self.all
    @@instances
  end

  def initialize(name)
    @name = name
    @trains = []
    validate!
    @@instances << self
    register_instance
  end

  def arrive(train)
    @trains << train
  end

  def depart(train)
    @trains.delete(train)
  end

  def trains_count(type)
    trains_by_type(type).size  
  end

  def description
    name
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  def each_train
    trains.each { |train| yield(train) }
  end

  protected

  def validate!
    raise EMPTY_NAME if name.empty?
  end

  private
  
  def trains_by_type(type)
    trains.select { |train| train.type == type }
  end
end
