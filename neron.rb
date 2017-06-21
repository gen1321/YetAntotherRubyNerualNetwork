class Neuron
  attr_accessor :connections

  def initialize(connections)
    @connections = connections
  end

  def process
    sum_of_inputs = @connections.map { |c| c.value * (c.weight * c.bias) }
                                .inject(:+)
    sigmoid(sum_of_inputs)
  end

  def sigmoid(x)
    1 / (1 + Math.exp(-x))
  end
end
