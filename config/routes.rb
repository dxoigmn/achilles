ActionController::Routing::Routes.draw do |map|
  map.resources :scans
  map.resources :vulnerabilities
  map.resources :hosts
  map.resources :plugins
  map.root :controller => 'Hosts'
end
