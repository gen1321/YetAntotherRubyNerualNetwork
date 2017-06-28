require_relative './layer'
require_relative './neuron.rb'
require_relative './connection'
class InputLayer < Layer
  attr_accessor :input_connections

  def initialize(batch_size)
    @neurons = []
    @income_connections = []
    @outcome_connections = []
    (1..batch_size).each do
      neuron = Neuron.new
      @neurons.push(neuron)
    end
  end
end
