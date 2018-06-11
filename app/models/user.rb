class User < Sudo
  attr_accessor :id

  validates! :id, format: { with: /\A[a-zA-Z0-9]+\Z/ }, length: { maximum: 16 }
  before_validation :validate_existence_of_id

  def self.find(id)
    (user = User.new(id: id)).valid?
    user
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

  def validate_existence_of_id
    errors.add :id, 'is incorrect' if root? || exists?
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