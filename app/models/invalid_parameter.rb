class InvalidParameter < Exception
  attr_accessor :resource

  def initialize(resource)
    self.resource = resource
  end
end