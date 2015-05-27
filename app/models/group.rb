class Group < Sudo
  attr_accessor :id

  validates_numericality_of :id
  before_validation :validate_existence_of_name

  def self.find(id)
    Group.new(id: id).raise_an_exception_on_wrong_id!
  end

  def name
    "repository_#{id}"
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

  def raise_an_exception_on_wrong_id!
    if id.is_a?(Integer) || id.is_a?(String) && id =~ /\A[0-9]+\Z/
      return self
    end
    raise InvalidParameter.new(self), "Invalid `id' parameters"
  end

  def repository
    @repository ||= Repository.find id
  end

  def as_json(options = {})
    options[:methods] = [:name]
    super.as_json options
  end
end
