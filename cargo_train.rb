class CargoTrain < Train
  def attachable_wagon?(wagon)
    return false unless wagon.is_a?(CargoWagon)
    wagon.train.nil?
  end
end
