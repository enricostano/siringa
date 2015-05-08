Siringa::Engine.routes.draw do
  post "load_definition/:definition", :to => "siringa#load_definition"
  post "dump", :to => "siringa#dump"
  post "restore", :to => "siringa#restore"
end
