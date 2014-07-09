Progno::Application.routes.draw do


  match "un_authorized"=>"un_authorized#index"

  match "admin/users_summary"=>"admin#users_summary"
  get "admin/dashboard"
  match"admin" => "admin#dashboard"
  get "admin/functional_admins_new"
  post "admin/create_functional_admin"
  post "admin/functional_admin/more_details" => "admin#more_details"
  match "admin/functional_admin_edit"=>"admin#functional_admin_edit"
  post "admin/functional_admin_update"
  get "admin/functional_admin_index"
  match "admin/functional_admin"=>"admin#functional_admin_index"
  get "admin/invitations"
  match "admin/invites_by_user"=>"admin#invites_by_user"
  get "admin/settings"
  match "admin/update_settings"=>"admin#update_settings"
  match "admin/functional_admin_delete"=>"admin#functional_admin_delete"
  #routes for user_group
  match "admin/users/user_group"=>"user_group#index"
  match "admin/users/user_group/new"=>"user_group#new"
  match "admin/users/user_group/edit"=>"user_group#edit"
  match "admin/users/user_group/create"=>"user_group#create"
  match "admin/users/user_group/update"=>"user_group#update"
  match "admin/users/user_group/delete"=>"user_group#delete_or_undelete"
  match "admin/users/user_group/undelete"=>"user_group#delete_or_undelete"

  get '/users/sign_in', to: redirect('/')
  #match 'home/sign_up' => 'home#sign_up'
  devise_for :users , :controllers => { :omniauth_callbacks => "users"}

  #routes for risk profile module
  match 'admin/investment' => 'risk_profile#index'
  match 'admin/investment/risk_profile' => 'risk_profile#index'
  match 'admin/investment/risk_profile/new_questions' => 'risk_profile#new_questions'
  post 'risk_profile/create' => 'risk_profile#create'
  match 'admin/risk_profile/set_questions' =>  'risk_profile#index'
  match 'admin/risk_profile/set_risk_profile' =>  'risk_profile#set_risk_profile'
  post 'risk_profile/save_risk_profile' => 'risk_profile#save_risk_profile'
  match 'admin/risk_profile/view_questionaire' =>  'risk_profile#view_questionaire'
  match 'admin/risk_profile/view_report' =>  'risk_profile#view_report'
  delete 'risk_profile/destroy/:id' => 'risk_profile#destroy'
  post 'risk_profile/edit_question/:id' => 'risk_profile#edit_question'
  post 'risk_profile/update_question'
  match 'risk_profile/edit_option' => 'risk_profile#edit_option'
  match 'risk_profile/update_option' => 'risk_profile#update_option'
  match 'risk_profile/delete_option' => 'risk_profile#delete_option'
  match 'risk_profile/add_option' => 'risk_profile#add_option'
  match 'risk_profile/create_option' => 'risk_profile#create_option'
  post 'risk_profile/sort'
  match 'admin/risk_profile/new_risk_profile' => 'risk_profile#new_risk_profile
  '
  match 'admin/risk_profile/sequence_change' => 'risk_profile#sequence_change'
  match 'admin/risk_profile/sort' => 'risk_profile#sort'
  #routes for financial profile module
  match 'admin/investment/financial_profile_new' => 'financial_profile#new'
  match 'admin/investment/financial_profile' => 'financial_profile#index'
  match 'admin/investment/financial_profile_analytics' => 'financial_profile#measure_options'

  match 'admin/investment/financial_profile_trial' => 'financial_profile#trial'
  match 'admin/investment/financial_profile_report' => 'financial_profile#trial_calculate'
  post 'financial_profile/create'
  post 'financial_profile/update'

  delete 'financial_profile/destroy/:id' => 'financial_profile#destroy'
  post 'financial_profile/edit/:id' => 'financial_profile#edit'

  match 'financial_profile/measure_options_new' => 'financial_profile#measure_options_new'
  match 'financial_profile/measure_options_edit' => 'financial_profile#measure_options_edit'
  match 'financial_profile/measure_options_update' => 'financial_profile#measure_options_update'
  match 'financial_profile/measure_options_destroy' => 'financial_profile#measure_options_destroy'


  match 'admin/investment/asset_class' => 'asset_class#index'
  match 'admin/investment/asset_class_new' => 'asset_class#new'
  match 'admin/investment/asset_class_file/:id' => 'asset_class#data_point_upload'  
  get 'asset_class/correlation'
  post 'asset_class/create'
  post 'asset_class/file_update'
  delete 'asset_class/destroy/:id' => 'asset_class#destroy'
  delete 'asset_class/flush_data/:id' => 'asset_class#flush_data'
  post 'asset_class/edit/:id' => 'asset_class#edit'
  post 'asset_class/update'

  match 'admin/investment/asset_class/process_file_data_points/:id' => 'asset_class#process_file_data_points'
  match 'admin/investment/asset_class/set_time_periods' => 'asset_class#rolling_time_period'
  match 'admin/investment/asset_class/set_time_periods/new' => 'asset_class#rolling_time_period_new'
  match 'admin/investment/asset_class/set_time_periods/create' => 'asset_class#rolling_time_period_create'
  match 'admin/investment/asset_class/set_time_periods/edit' => 'asset_class#rolling_time_period_edit'
  match 'admin/investment/asset_class/set_time_periods/update' => 'asset_class#rolling_time_period_update'
  match 'admin/investment/asset_class/set_time_periods/delete' => 'asset_class#rolling_time_period_delete'
  match 'admin/investment/asset_class/view_matrics' => 'asset_class#view_matrics'
  match 'admin/investment/asset_class/view_matrics_stats' => 'asset_class#view_matrics_stats'
  match 'admin/investment/asset_class/update_view_matrics' => 'asset_class#update_view_matrics'
  match 'admin/investment/asset_class/download_stats/:id/:name' => 'asset_class#download_stats'
  match 'admin/investment/asset_class/update/daily/rolling/:id' => 'asset_class#update_daily_rolling'


  #routes for porftolio module
  match 'admin/investment/portfolio_group/' => 'portfolio_group#index'
  match 'admin/investment/portfolio_group/setportfoliofamily' => 'portfolio_group#index'
  match 'admin/investment/portfolio_group/viewmatrics' => 'portfolio_group#viewmatrics'
  match 'admin/investment/portfolio_group/viewefficientfrontier' => 'portfolio_group#viewefficientfrontier'
  match 'admin/investment/portfolio_group/efficient_frontier/' => 'portfolio_group#efficient_frontier'
  match 'admin/investment/portfolio_group/efficient_frontier/:id' => 'portfolio_group#efficient_frontier'
  match 'admin/investment/portfolio_group/periodic_risk' => 'portfolio_group#periodic_risk'
  delete 'portfolio_group/destroy/:id' => 'portfolio_group#destroy'
  match 'admin/investment/portfolio_group/portfolios' => 'portfolio_group#portfolio_status'
  match 'admin/investment/portfolio_group/change_portfolio_status' => 'portfolio_group#change_portfolio_status'

  match 'portfolio_group/calculate_all_corerelation'
  match 'portfolio_group/create'

  #routes for RTA
  match '/admin/investment/risk_tolerance' => 'risk_tolerance#index'
  match 'admin/investment/risk_tolerance/new' => 'risk_tolerance#new'
  match 'admin/investment/risk_tolerance/create' => 'risk_tolerance#create'
  match 'admin/investment/risk_tolerance/edit' => 'risk_tolerance#edit'
  match 'admin/investment/risk_tolerance/update' => 'risk_tolerance#update'
  match 'admin/investment/risk_tolerance/destroy' => 'risk_tolerance#destroy'
  match 'admin/investment/risk_tolerance/preview' => 'risk_tolerance#preview'
  match 'admin/investment/risk_tolerance/view_report_behaviour' => 'risk_tolerance#view_report_behaviour'
  match 'admin/investment/risk_tolerance/view_report_finance' => 'risk_tolerance#view_report_finance'

  # routes for frequently asked questions
  match 'admin/cms/faq' => 'frequently_asked_question#index'
  match 'admin/cms/faq/unpublish' => 'frequently_asked_question#unpublish'
  match 'admin/cms/faq/new' => 'frequently_asked_question#new'
  match 'admin/cms/faq/edit' => 'frequently_asked_question#edit'
  match 'admin/cms/faq/destroy' => 'frequently_asked_question#destroy'
  match 'admin/cms/faq/destroy_from_category' => 'frequently_asked_question#destroy_from_category'
  match 'admin/cms/faq/create' => 'frequently_asked_question#create'
  match 'admin/cms/faq/update' => 'frequently_asked_question#update'
  match 'admin/cms/faq/show'  => 'frequently_asked_question#admin_view'
  #for guest/users
  match 'faq'            =>  'frequently_asked_question#guest'
  match 'faq/show'   => 'frequently_asked_question#show'

  #routes for question categories
  match 'admin/cms/faq/category' => 'question_category#index'
  match 'admin/cms/faq/category/new' => 'question_category#new'
  match 'admin/cms/faq/category/edit' => 'question_category#edit'
  match 'admin/cms/faq/category/destroy' => 'question_category#destroy'
  match 'admin/cms/faq/category/create' => 'question_category#create'
  match 'admin/cms/faq/category/update' => 'question_category#update'

  #OMNIAUTH ROUTES

  match "users/auth/facebook/callback" => 'users#facebook'
  match "users/auth/linkedin/callback" => 'users#linkedin'
  #match "users/auth/google/callback" => 'risk_profile#index'


  match 'users/profile' => 'users#index'
  match 'users/profile/edit_personal' => 'users#edit_personal'
  match 'users/profile/edit_professional' => 'users#edit_professional'
  match 'users/profile/update' => 'users#update'
  match 'users/home'  => 'users#home'
  match 'users/invite' => 'users#invite'
  match 'users/invitation_status' => 'users#invitation_status'
  match 'users/points' => 'users#points'
  get "users/sync_with_fb"
  get "users/sync_with_linkedin"
  get "users/sync_with_google"
  match 'users/invite/bulk' => 'users#bulk_invite'
  match 'users/invite/send_bulk_invitations' => 'users#send_bulk_invitations'
  match "users/invite_contacts" => "users#invite_contacts"
  match 'users/send_invites' => 'users#send_invites'
  match 'users/profile/edit_password'=> 'users#edit_password'
  match 'users/profile/update_password' => "users#update_password"
  #match 'users/invite/new' => 'devise/invitations#new'
  #match 'detail'
  match 'users/more_invites'=>'users#more_invites'
  devise_scope :user do
    get "users/invite/new", :to => "devise/invitations#new"
  end

  match 'users/invite/resend' => 'users#resend'
  match 'users/invite/resend_invite' => 'users#resend_invite'
  match '/users' => 'users#index'
  #match 'users/invite/gmail' => 'users#invite_gmail'

  root :to => 'home#index'

  match 'admin/users/ability/new' => 'ability#new'
  match 'admin/users/ability' => 'ability#index'
  match 'admin/users/ability/create'    => 'ability#create'
  match 'admin/users/ability/update'    => 'ability#update'
  match 'admin/users/ability/edit'  => 'ability#edit'
  match 'admin/users/ability/delete'  => 'ability#delete_or_undelete'
  match 'admin/users/ability/undelete'  => 'ability#delete_or_undelete'
  match 'users/facebook_invite' => 'users#facebook_invite'

  match "advisor/personal/new"=>"advisor#new_user"
  post "advisor/create_user"
  match "advisor/personal/edit"=>"advisor#personal_edit"
  post "advisor/personal_update"
  match "advisor/personal/view"=>"advisor#personal_view"
  match "advisor/behaviour/edit"=>"advisor#behaviour_edit"
  post "advisor/behaviour_update"
  match "advisor/behaviour/view"=>"advisor#behaviour_view"
  match "advisor/financial/edit"=>"advisor#financial_edit"
  post "advisor/financial_update"
  match "advisor/financial/view"=>"advisor#financial_view"
  post "advisor/risk_profile"
  match "advisor"=>"advisor#index"
  get "advisor/asset_allocation"
  match 'advisor/select_user' => 'advisor#select_user'
  match 'advisor/risk_profile' => 'advisor#risk_profile'
  match "advisor/risk_profile/:name"=>"advisor#risk_profile"
  match 'advisor/save_asset_allocation' => 'advisor#save_asset_allocation'
  match 'advisor/view_profiling' => 'advisor#view_profiling'
  match "/advisor/asset_allocation/:name"=>"advisor#asset_allocation"
  match "advisor/asset_allocation/download_excel"=>"advisor#download_excel"
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'users/profile'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
