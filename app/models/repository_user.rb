class RepositoryUser < Sudo
  attr_accessor :user, :repository, :space, :handle

  def self.create(params = {})
    RepositoryUser.new(params).save
  end

  def self.delete(params = {})
    RepositoryUser.new(params).delete
  end

  def save
    if space.present?
      user_space_dir = "#{Settings.user.home}/#{user.username}/#{space}"
      `sudo -u #{user.username} /bin/mkdir -p #{user_space_dir}`
      `sudo -u #{user.username} /bin/rm -rf #{user_space_dir}/#{handle}.git`
      `sudo -u #{user.username} /bin/ln -s #{repository.path} #{user_space_dir}/#{handle}.git`
    else
      `sudo -u #{user.username} /bin/rm -rf #{Settings.user.home}/#{user.username}/#{handle}.git`
      `sudo -u #{user.username} /bin/ln -s #{repository.path} #{Settings.user.home}/#{user.username}/#{handle}.git`
    end
    UserGroup.create(user: user, group: repository.group)
  end

  def delete
    if space.present?
      `sudo -u #{user.username} /bin/rm -rf #{Settings.user.home}/#{user.username}/#{space}/#{handle}.git`
    else
      `sudo -u #{user.username} /bin/rm -rf #{Settings.user.home}/#{user.username}/#{handle}.git`
    end
    UserGroup.delete(user: user, group: repository.group)
  end
end