class PassengerTrain < Train
  def attachable_wagon?(wagon)
    return false unless wagon.is_a?(PassengerWagon)
    wagon.train.nil?
  end
end
