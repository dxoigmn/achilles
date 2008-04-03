ActionController::Routing::Routes.draw do |map|
  map.resources :scans
  map.resources :vulnerabilities
  map.resources :hosts
  map.resources :plugins
  map.resources :severities
  map.resources :locations
  map.root :controller => 'Hosts'
end
