require_relative './neron.rb'
require_relative './connection'

class Layer
  attr_accessor :neurons
  attr_accessor :income_connections
  attr_accessor :outcome_connections

  def initialize(number_of_neurons)
    @neurons = (1..number_of_neurons).map do
      Neuron.new
    end
  end

  def create_connections_with(layer)
    @income_connections = layer.neurons.map do |layer_neuron|
      neurons.each do |neuron|
        build_connection(layer_neuron, neuron)
      end
    end
  end

  def process_all_neurons
    @neurons.each(&:process)
  end

  def build_connection(input, output)
    Connection.new(start_neuron: input, end_neruon: output)
  end
end
