SampleApp::Application.routes.draw do |map|
 

  resources :users
  resources :sessions, :only => [:new, :create, :destroy]
  
  
  match '/contact', :to => 'pages#contact'
  match '/about', :to => 'pages#about'
  match '/help', :to => 'pages#help'
  match '/signup', :to => 'users#new'
  match '/signin', :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
  
  map.resources :imports
  match '/import', :to => 'imports#new'
  
  map.import_proc '/import/proc/:id', :controller => "imports", :action => "proc_csv"
  
  root :to => 'pages#home'

end
