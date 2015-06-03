class User < Sudo
  attr_accessor :id

  def self.find(id)
    User.new(id: id).raise_an_exception_on_wrong_id!
  end

  def home
    "#{Settings.user.home}/#{username}"
  end

  def username
    id
  end

  def root?
    id == 'root'
  end

  def save
    unless exists? && root?
      sudo "useradd -b #{home} -d #{home} -m -s /usr/bin/git-shell #{username}"
    end
  end

  def destroy
    sudo "userdel -rf #{username}" if exists? && !root?
  end

  def exists?
    !`/usr/bin/getent passwd #{username}`.empty?
  end

  def raise_an_exception_on_wrong_id!
    if !root? && exists?
      return self
    end
    raise InvalidParameter.new(self)
  end

  def as_json(options = {})
    options[:methods] = :username
    super.as_json options
  end

  def update_keys(array = [])
    seed = rand(10000000).to_s(32)
    keys = array.map do |attributes|
      Key.new attributes
    end
    content = keys.map { |key| key.value }.join("\n\n")
    File.open("/tmp/keys_#{id}_#{seed}", "w") do |file|
      file.write content
    end
    `sudo cp --remove-destination /tmp/keys_#{id}_#{seed} /etc/ssh/keys/#{id} && rm /tmp/keys_#{id}_#{seed}`
  end

  def self.git
    User.find Settings.git.login
  end
end