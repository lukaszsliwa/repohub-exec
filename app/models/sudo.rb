class Sudo
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include ActiveModel::Serializers::JSON

  def sudo(cmd)
    `sudo #{cmd}`
  end

  def attributes
    instance_values
  end
end