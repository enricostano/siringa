Siringa::Engine.routes.draw do
  post "load/:definition", :to => "siringa#load" # To be deprecated in 0.1.0
  post "load_definition/:definition", :to => "siringa#load_definition"
  post "dump", :to => "siringa#dump"
  post "restore", :to => "siringa#restore"
end
