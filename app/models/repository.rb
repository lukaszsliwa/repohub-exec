class Repository < Sudo
  attr_accessor :id

  validates! :id, format: { with: /\A[a-zA-Z0-9]+\Z/ }, length: { maximum: 9 }

  def bare
    sudo "git init --bare #{path}"
    sudo "chmod -R 770 #{path}"
  end

  def self.find(id)
    (repository = Repository.new(id: id)).valid?
    repository
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

  def group
    @group ||= Group.find id
  end

  def as_json(options)
    options[:methods] = [:handle, :path]
    super.as_json options
  end
end