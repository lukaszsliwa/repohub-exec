class User < Sudo
  attr_accessor :id

  def self.find(id)
    User.new(id: id).raise_an_exception_on_wrong_id!
  end

  def home
    "/home/#{username}"
  end

  def username
    id
  end

  def exists?
    !`/usr/bin/getent passwd #{username}`.empty?
  end

  def raise_an_exception_on_wrong_id!
    if id != 'root' && exists?
      return self
    end
    raise InvalidParameter.new(self)
  end

  def as_json(options = {})
    options[:methods] = :username
    super.as_json options
  end

  def update_keys(array = [])
    keys = array.map do |attributes|
      Key.new attributes
    end
    File.open("#{home}/.ssh/authorized_keys", "w") do |file|
      keys.each do |key|
        file.write "#{key.value}\n\n"
      end
    end
  end

  def self.git
    User.find 'git'
  end
end