ActionController::Routing::Routes.draw do |map|


  # The admin areas
  map.resources :sessions, 
                :rates, 
                :career_reports,
                :job_candidates, 
                :shared_files,
                :policies_procedures_files,
                :pages,
                :site_images,
                :referrals,
                :path_prefix => '/admin'
  
  
  # Also admin areas
  map.resources :users, :path_prefix => '/admin', :member => {:welcome => :get} do |users|
    users.resources :contacts do |contacts|
      contacts.resources :reminders
    end
  end
  
  # Newsletters
  map.resources :newsletters, :path_prefix => '/admin' do |newsletters|
    newsletters.resources :newsletter_issues, :member => {:schedule_for_sending => :get, :unschedule_for_sending => :get, :test_send => :get, :copy => :get} 
  end  

  map.shared_files_notification 'shared_files/notify',
                                :controller => 'shared_files',
                                :action => 'notify'
                                
  map.confirm_unsubscribe_newsletter  'newsletters/:id/unsubscribe/*email',
                                :controller => 'newsletters',
                                :action => 'confirm_unsubscribe',
                                :conditions => {:method => :get}

  map.unsubscribe_newsletter  'newsletters/:id/unsubscribe/*email',
                                :controller => 'newsletters',
                                :action => 'unsubscribe',
                                :conditions => {:method => :post}

  # agents webpage paths
  map.agents                  'agents',
                                :controller => 'content',
                                :action => 'agents',
                                :public_area => true
                               
  # Contact request form
  map.contact_request          'create_contact_request',
                                :controller => 'content',
                                :action => 'create_contact_request'
                                
  # Mortgage renew form
  map.mortgage_renew_request    'create_mortgage_renew_request',
                                :controller => 'content',
                                :action => 'create_mortgage_renew_request'

  # Northwood Mortgage Life Contact request form
  map.mortgage_life_contact_request          'create_mortgage_life_contact_request',
                                :controller => 'content',
                                :action => 'create_mortgage_life_contact_request'

  # Northwood Mortgage Life Contact request form
  map.reverse_mortgages_contact_request          'create_reverse_mortgages_contact_request',
                                :controller => 'content',
                                :action => 'create_reverse_mortgages_contact_request'

                                  
  # Pre-approval application
  map.with_options :controller => 'pre_approval_application' do |page|
    page.agent_pre_approval_application ':webpage_address/pre-approval', 
                                :action => 'new',     :conditions => {:method => :get}
    page.agent_pre_approval_application ':webpage_address/pre-approval',
                                :action => 'create',  :conditions => {:method => :post}
    page.pre_approval_application 'pre-approval',
                                :action => 'new',     :conditions => {:method => :get}
    page.pre_approval_application 'pre-approval',
                                :action => 'create',  :conditions => {:method => :post}
  end
  
  # Rate Watch sign-up
  map.with_options :controller => 'rate_watch' do |page|
    page.agent_rate_watch_signup ':webpage_address/rate-watch-signup',
                                  :action => 'new',    :conditions => {:method => :get}
    page.agent_rate_watch_signup ':webpage_address/rate-watch-signup',
                                  :action => 'create', :conditions => {:method => :post}
    page.rate_watch_signup     '/rate-watch-signup',
                                  :action => 'new',    :conditions => {:method => :get}
    page.rate_watch_signup     '/rate-watch-signup',
                                  :action => 'create', :conditions => {:method => :post}
  end
  
  # Mortgage rates
  map.with_options :controller => 'content' do |page|
    page.agent_mortgage_rates ':webpage_address/mortgage-rates',
                                :action => 'best_mortgage_rates', :agent_area => true
    page.mortgage_rates     '/mortgage-rates',
                                :action => 'best_mortgage_rates', :public_area => true
  end
  
  # Other stuff                                                                    
  map.connect                 'agents/:webpage_address/*agent_path',
                               :controller => 'users',
                               :action => 'webpage'                      
  map.all_contacts            '/admin/contacts',
                                :controller => 'contacts',
                                :action => 'all'
  map.unassigned_contacts     '/admin/company-contacts',
                                :controller => 'contacts',
                                :action => 'list_unassigned'
  map.unassigned_contact      '/admin/company-contacts/:id',
                                :conditions => {:method => :get},
                                :controller => 'contacts',
                                :action => 'show_unassigned'
  map.unassigned_contact      '/admin/company-contacts/:id',
                                :conditions => {:method => :put},
                                :controller => 'contacts',
                                :action => 'update'
  map.unassigned_contact      '/admin/company-contacts/:id',
                                :conditions => {:method => :delete},
                                :controller => 'contacts',
                                :action => 'destroy'
  map.edit_unassigned_contact '/admin/company-contacts/:id;edit', 
                                :controller => 'contacts', 
                                :action => 'edit_unassigned'
  map.transfer_contacts       '/admin/contacts/transfer/:id',
                                :controller => 'contacts',
                                :action => 'transfer'
  map.login                   '/login',
                                :controller => 'sessions', 
                                :action => 'new'
  map.logout                  '/logout',
                                :controller => 'sessions', 
                                :action => 'destroy'
  map.forgot_password         '/forgot_password',
                                :controller => 'users',
                                :action => 'forgot_password'
  map.careers                 '/careers',                     
                                :controller => 'job_candidates',    
                                :action => 'new',
                                :public_area => true

  # Referral webpages
  map.connect '/referral/*path', :controller => 'referrals',  :action => 'webpage'
  map.resources :referrals, :member => {:contact => :post}     
  
                                                                
  # catchall for all the routes that don't match ones above
  map.connect                 '*path',
                                :controller => 'content', 
                                :action => 'load_content'

end
