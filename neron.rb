class Neuron
  attr_accessor :input_connections
  attr_accessor :output_connections
  attr_accessor :weight
  attr_accessor :bias
  attr_accessor :result
  attr_accessor :delta

  def initialize
    @input_connections = []
    @output_connections = []
  end

  def calculate_delta
    @delta = 0
    @output_connections.each do |conn|
      @delta += conn.end_neuron.delta * conn.weight
    end
    @delta *= derivative_sigmoid(@result)
  end

  def process
    sum_of_inputs = @input_connections.map do |conn|
      conn.value * conn.weight
    end.inject(:+)
    @result = sigmoid(sum_of_inputs)
    output_connections.map { |c| c.value = @result }
    @result
  end

  private

  def sigmoid(x)
    1 / (1 + Math.exp(-x))
  end

  def derivative_sigmoid(x)
    s = sigmoid(x)
    s * (1.0 - x)
  end
end
