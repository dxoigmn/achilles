ActionController::Routing::Routes.draw do |map|
  map.resources :scans
  map.resources :vulnerabilities
  map.resources :hosts
  map.resources :plugins
  map.resources :classifications
  map.resources :severities
  map.root :controller => 'Hosts'
end
