class Repository < Sudo
  attr_accessor :id

  def bare
    sudo "git init --bare #{path}"
  end

  def self.find(id)
    Repository.new(id: id).raise_an_exception_on_wrong_id!
  end

  def handle
    id
  end

  def path
    "#{Settings.git.home}/#{id}.git"
  end

  def exists?
    Dir.exists? path
  end

  def destroy
    group.destroy
    `sudo /bin/rm -rf #{path}`
  end

  def raise_an_exception_on_wrong_id!
    if id.to_s =~ /\A[a-zA-Z0-9\-\_]+\Z/
      self
    else
      raise InvalidParameter.new(self), "Invalid `id' parameters"
    end
  end

  def group
    @group ||= Group.find id
  end

  def as_json(options)
    options[:methods] = [:handle, :path]
    super.as_json options
  end
end