require_relative './layer'
require_relative './neron.rb'
require_relative './connection'

class OutputLayer < Layer
  attr_accessor :result
  def initialize(classes)
    @classes = classes
    @income_connections = []
    @output_connections = []
    @neurons = (1..classes).map { Neuron.new }
  end

  def process_all_neurons
    @result = @neurons.map(&:process)
  end
end
