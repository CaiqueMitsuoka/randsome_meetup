class Meetup::Group
  attr_reader :name, :id, :urlname, :who

  def initialize(group_hash = {}, options = {})
    group_hash.merge!(options)
    @name = group_hash[:name]
    @id = group_hash[:id]
    @urlname = group_hash[:urlname]
    @who = group_hash[:who]
  end
end
