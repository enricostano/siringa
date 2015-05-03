require 'siringa'
require File.expand_path('../../factories', __FILE__)

Siringa.add_definition :initial do
  FactoryGirl.create :user, name: 'Jesse Pinkman'
end

Siringa.add_definition :definition_with_arguments do |args|
  FactoryGirl.create :user, name: args[:name]
end

Siringa.add_definition :definition_with_return do |args|
  user = FactoryGirl.create :user, name: args[:name]
  { id: user.id, name: user.name, surname: 'Stark' }
end
