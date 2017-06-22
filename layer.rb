class Layer
  attr_accessor :neurons
  def initialize(number_of_neurons, income_layer, outcome_layer)
    @neurons = 1..number_of_neurons.map do
      neuron = Neuron.new
      income_connections = income_layer.neurons.map do |income_layer_neuron|
        build_connection(income_layer_neuron, neuron)
      end
      outcome_connections = outcome_layer.neurons.map do |outcome_layer_neuron|
        build_connection(neuron, outcome_layer_neuron)
      end
      neuron.setup(income_connections, outcome_connections)
    end
  end

  def process_all_neurons
    @neurons.each(&:process)
  end

  def build_connection(input, output)
    Connection.new(start_neuron: input, end_neruon: output)
  end
end
