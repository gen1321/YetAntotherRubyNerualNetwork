class Neuron
  attr_accessor :connections
  attr_accessor :input_connections
  attr_accessor :output_connections
  DEFAULT_WEIGHT = 1
  DEFAULT_BIAS = 1

  def setup(input_connections, output_connections)
    @output_connections = output_connections
    @input_connections_with_weights_and_biases = input_connections.map do |ic|
      { connection: ic, weight: DEFAULT_WEIGHT, bias: DEFAULT_BIAS }
    end
  end

  def process
    sum_of_inputs = @input_connections_with_weights_and_biases.map do |x|
      x[:connection].value * (x[:weight] * x[:bias])
    end.inject(:+)
    result = sigmoid(sum_of_inputs)
    output_connections.map { |c| c.value = result }
  end

  def sigmoid(x)
    1 / (1 + Math.exp(-x))
  end
end
