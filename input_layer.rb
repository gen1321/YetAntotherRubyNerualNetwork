require_relative './layer'
require_relative './neron.rb'
require_relative './connection'
class InputLayer < Layer
  def initialize(batch_size)
    @neurons = []
    (1..batch_size).each do
      n = Neuron.new
      @neurons.push(n)
      Connection.new(end_neuron: n)
    end
  end
end
