class Owner < Sudo
  attr_accessor :recursive, :user, :group, :repository

  def self.create(params = {})
    Owner.new(params).save
  end

  def save
    `sudo /bin/chown #{parameters} #{user.username}:#{group.name} #{repository.path}`
  end

  def parameters
    "-R" if recursive
  end
end