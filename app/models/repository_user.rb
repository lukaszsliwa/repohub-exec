class RepositoryUser < Sudo
  attr_accessor :user, :repository

  def self.create(params = {})
    RepositoryUser.new(params).save
  end

  def self.delete(params = {})
    RepositoryUser.new(params).delete
  end

  def save
    `sudo -u #{user.username} /bin/ln -s #{repository.path} /home/#{user.username}/#{repository.handle}.git`
  end

  def delete
    `sudo /bin/rm /home/#{user.username}/#{repository.handle}.git`
  end
end