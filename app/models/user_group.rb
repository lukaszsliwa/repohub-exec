class UserGroup < Sudo
  attr_accessor :user, :group

  def self.create(params = {})
    UserGroup.new(params).save
  end

  def self.delete(params = {})
    UserGroup.new(params).delete
  end

  def save
    `sudo /usr/sbin/addgroup #{user.username} #{group.name} `
  end

  def delete
    `sudo /usr/sbin/delgroup #{user.username} #{group.name} `
  end
end