require_relative './neuron.rb'
require_relative './connection'

class Layer
  attr_accessor :neurons
  attr_accessor :income_connections
  attr_accessor :outcome_connections

  def initialize(number_of_neurons)
    @income_connections = []
    @outcome_connections = []
    @neurons = (1..number_of_neurons).map do
      Neuron.new
    end
  end

  def create_connections_with(previous_layer)
    previous_layer.neurons.map do |previous_layer_neuron|
      neurons.each do |current_layer_neuron|
        @income_connections.push(
          build_connection(previous_layer_neuron, current_layer_neuron)
        )
      end
    end
    previous_layer.outcome_connections = @income_connections
  end

  def process_all_neurons
    @neurons.each(&:process)
  end

  def connections
    return if @income_connections.nil? || @outcome_connections.nil?
    @income_connections + @outcome_connections
  end

  private

  def build_connection(input, output)
    conn = Connection.new(start_neuron: input, end_neuron: output, layer: self)
    input.output_connections.push(conn)
    output.input_connections.push(conn)
  end
end
