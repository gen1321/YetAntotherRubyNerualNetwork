class Connection
  attr_accessor :value
  attr_accessor :start_neuron
  attr_accessor :end_neuron

  def initialize(params)
    @value = params[:value]
    @start_neuron = params[:start_neuron]
    @end_neruon = params[:end_neuron]
  end
end
