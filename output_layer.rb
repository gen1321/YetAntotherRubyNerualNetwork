require_relative './layer'
require_relative './neron.rb'
require_relative './connection'

class OutputLayer < Layer
  attr_accessor :result
  def initialize(classes_size)
    @neurons = (1..classes_size).map { Neuron.new }
  end
end

# 0 -> 'white'
# 0.5 -> 'gray'
# 0.1 -> 'black'
