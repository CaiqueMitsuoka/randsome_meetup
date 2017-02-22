require 'rails_helper'


RSpec.describe Meetup::Group, type: :model do
  it_behaves_like 'instance has attribute',
                  Meetup::Group.new(name: 'Guru Raiz'),
                  :name,
                  'Guru Raiz'

  it_behaves_like 'instance has attribute',
                  Meetup::Group.new(id: '12b123c'),
                  :id,
                  '12b123c'

  it_behaves_like 'instance has attribute',
                  Meetup::Group.new(urlname: 'guru-sorocaba'),
                  :urlname,
                  'guru-sorocaba'

  it_behaves_like 'instance has attribute',
                  Meetup::Group.new(who: ['Irineu', 'Douglas']),
                  :who,
                  ['Irineu', 'Douglas']
end
