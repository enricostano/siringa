Siringa::Engine.routes.draw do
  post "load/:definition", :to => "siringa#load"
  post "dump", :to => "siringa#dump"
  post "restore", :to => "siringa#restore"
end
