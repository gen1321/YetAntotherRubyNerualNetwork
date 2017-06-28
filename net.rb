require_relative './layer'
require_relative './input_layer'
require_relative './output_layer'

class Net
  attr_accessor :layers
  TRAINING_OPTIONS = {
    max_iterations:   1_000,
    error_threshold:  0.01
  }.freeze

  def initialize(layers_representation, batch_size, classes)
    @on_update = 0
    @update_after = 10
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
    @layers[1..-1].each(&:process_all_neurons)
    @layers[1..-1].map do |l|
      l.neurons.map(&:result)
    end
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
      p "GLOBAL ERROR IS #{@global_error}, #{@output_layer.result.map { |x| x.round(5) }} vs #{expected_output[index]}"
      back_propogation(expected_output[index])
    end
  end

  private

  def back_propogation(expected_results)
    @output_layer.neurons.each_with_index do |neuron, index|
      error = neuron.result - expected_results[index]
      neuron.delta = -error * neuron.result
      neuron.input_connections.each(&:calculate_gradient)
      neuron.input_connections.each(&:calculate_delta_change)
      neuron.input_connections.each(&:update_weight)
    end
    @layers[0..-1].reverse_each do |l|
      l.neurons.each(&:calculate_delta)
    end
    @layers[1..-1].reverse_each do |l|
      l.neurons.each do |n|
        n.input_connections do |conn|
          conn.calculate_gradient
          conn.calculate_delta_change
          conn.update_weight
        end
      end
    end
  end

  # def calculate_deltas(desired_results)
  #   @output_layer.neurons.each_with_index do |neuron, index|
  #     error = neuron.result - desired_results[index]
  #     neuron.delta = -error * neuron.result
  #   end
  #   @layers[1..-2].reverse_each do |layer|
  #     layer.neurons.each(&:calculate_delta)
  #   end
  # end

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
end
