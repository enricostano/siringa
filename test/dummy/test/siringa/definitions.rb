require 'siringa'
require File.expand_path('../../factories', __FILE__)

Siringa.add_definition :initial do
  FactoryGirl.create :user, name: 'Jesse Pinkman'
end
