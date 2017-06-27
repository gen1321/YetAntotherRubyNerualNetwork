class Connection
  attr_accessor :value
  attr_accessor :start_neuron
  attr_accessor :end_neuron
  attr_accessor :weight
  attr_accessor :layer
  attr_accessor :gradient

  LEARNING_RATE = 0.7
  MOMENTUM = 0.3

  def initialize(params)
    @weight = (rand(200) / 100.0) - 1
    @start_neuron = params[:start_neuron]
    @end_neuron = params[:end_neuron]
    @layer = params[:layer]
    @gradient = 0
    @delta_change = 0
  end

  def value
    start_neuron.result
  end

  def calculate_gradient
    @gradient += @start_neuron.result * @end_neuron.delta
  end

  def calculate_delta_change
    @delta_change = (LEARNING_RATE * @gradient) + (MOMENTUM * @delta_change)
    @gradient = 0
  end

  def update_weight
    @weight += @delta_change
  end
end
