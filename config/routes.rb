ActionController::Routing::Routes.draw do |map|
  map.resources :scans
  map.resources :vulnerabilities
  map.resources :hosts
  map.resources :plugins
  map.resources :severities
  map.resources :locations
  map.resources :plugin_classifications
  map.resources :classifications
  map.root :controller => 'Scans'
end
