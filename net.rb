require_relative './layer'
require_relative './input_layer'
require_relative './output_layer'

class Net
  attr_accessor :layers

  def initialize(layers_representation, batch_size, classes)
    @input_layer = InputLayer.new(batch_size)
    @global_error = 1
    @output_layer = OutputLayer.new(classes.size)
    @classes = classes
    @layers = [@input_layer]
    layers_representation.map do |l|
      new_layer = Layer.new(l)
      new_layer.create_connections_with(@layers.last)
      @layers.push(new_layer)
    end
    @output_layer.create_connections_with(@layers.last)
    layers.push(@output_layer)
  end

  def process(input)
    put_data_into_net(input)
    hidden_layers_and_output_layer.each(&:process_all_neurons)
    output = {}
    results = @output_layer.result
    @classes.each_with_index do |c, index|
      output[c] = results[index]
    end
    output
  end

  def train_network(inputs, expected_output)
    inputs.each_with_index do |input, index|
      process(input)
      @global_error = calculate_global_error(expected_output[index])
      p "GLOBAL ERROR IS #{@global_error}" if (index % 100).zero?
      back_propogation(expected_output[index])
    end
  end

  private

  def back_propogation(expected_results)
    @output_layer.neurons.each_with_index do |neuron, index|
      error = neuron.result - expected_results[index]
      neuron.delta = -error * neuron.result
    end
    @output_layer.train
    hidden_layers_and_input_layer.reverse_each(&:calculate_delta_for_neurons)
    hidden_layers_and_input_layer.reverse_each(&:train)
  end

  def calculate_global_error(expected_result)
    sum = 0
    @output_layer.result.each_with_index do |result, index|
      sum += (expected_result[index] - result)**2.0
    end
    sum / expected_result.length
  end

  def put_data_into_net(array_of_digits)
    input_connections.each_with_index do |neuron, index|
      neuron.result = array_of_digits[index]
    end
  end

  def all_neurons
    @layers.map(&:neurons).flatten
  end

  def connections
    @layers.map(&:connections).compact.flatten
  end

  def network_result
    @output_layer.result
  end

  def input_connections
    @input_layer.neurons
  end

  def hidden_layers
    @layers[1..-2]
  end

  def hidden_layers_and_input_layer
    @layers[0..-1]
  end

  def hidden_layers_and_output_layer
    @layers[1..-1]
  end
end
