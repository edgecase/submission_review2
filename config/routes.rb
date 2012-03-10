SubmissionReview::Application.routes.draw do
  match 'reviewer_sessions/callback' => 'reviewer_sessions#callback', :as=>:oauth_callback

  resources :reviewer_sessions, :only=>[:new, :destroy]
  resources :proposals, :only=>[:index, :show], :member=>{:rate=>:put}

  namespace :admin do |admin|
    resources :ratings, :only=>[:index] do
      collection do 
        get :print_cards
      end
    end
    resources :proposals, :only=>[:index] do
      member do
        put :update_state
      end
      collection do
        get :delegate_votes
      end
    end
  end

  root :to => "proposals#default_route"
end
