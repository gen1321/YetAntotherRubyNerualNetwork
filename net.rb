require_relative './layer'
require_relative './input_layer'
require_relative './output_layer'

class Net
  attr_accessor :layers

  def initialize(layers_representation, batch_size, classes)
    @input_layer = InputLayer.new(batch_size)
    @output_layer = OutputLayer.new(classes.size)
    layers = [@input_layer]
    layers_representation.map do |l|
      new_layer = Layer.new(l)
      new_layer.create_connections_with(layers.last)
    end
    @output_layer.create_connections_with(layers.last)
    layers.push(@output_layer)
  end
end

Net.new([500], 100, ['a', 'b'])
