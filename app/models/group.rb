class Group < Sudo
  attr_accessor :id

  validates! :id, format: { with: /\A[a-zA-Z0-9]+\Z/ }, length: { maximum: 9 }
  before_validation :validate_existence_of_name

  def self.find(id)
    (group = Group.new(id: id)).valid?
    group
  end

  def name
    "repofs_#{id}"
  end

  def save
    if valid?
      output = `sudo /usr/sbin/addgroup #{name}`
      if output.lines.last.strip == 'Done.'
        repository.bare
        UserGroup.create(group: self, user: User.git)
        Owner.create(repository: repository, group: repository.group, user: User.git, recursive: true)
        return true
      else
        errors.add :base, output.first.strip
      end
    end
    false
  end

  def destroy
    UserGroup.delete(group: self, user: User.git)
    `sudo /usr/sbin/delgroup #{name}`.lines.last.strip == 'Done.' if exists?
  end

  def exists?
    !`/usr/bin/getent group #{name}`.empty?
  end

  def validate_existence_of_name
    errors.add :base, "#{name} already exists." if exists?
  end

  def repository
    @repository ||= Repository.find id
  end

  def as_json(options = {})
    options[:methods] = [:name]
    super.as_json options
  end
end
