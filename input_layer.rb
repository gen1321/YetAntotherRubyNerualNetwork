require 'layer'
class InputLayer < Layer
  def initialize(values)
    @neurons = []
    values.each do |v|
      n = Neuron.new
      @neurons.push(n)
      Connection.new(value: v, end_neuron: n)
    end
  end
end
