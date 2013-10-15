# Use 'cap production deploy' or 'cap production deploy:migrations' to deploy

# =============================================================================
# REQUIRED VARIABLES
# =============================================================================

set :keep_releases, 5
set :application,   'northwoodmortgage.com'
set :repository,    'https://twg.unfuddle.com/svn/twg_northwood/trunk'
set :scm_username,  'sean'
set :scm_password,  'byedude'
set :user,          'deploy'
set :password,      'anilrm='
set :deploy_to,     "/web/northwoodmortgage.com_production"
set :deploy_via,    :export
set :scm,           :subversion
set :app_symlinks,  %w{shared_files public/site_images}

set :use_sudo, false

ssh_options[:paranoid] = false

# =============================================================================
# ROLES
# =============================================================================

task :production do
  role :web, 'northwoodmortgage.com'  
  role :app, 'northwoodmortgage.com'
  role :db, 'northwoodmortgage.com', :primary => true  
  
  set :environment_database, Proc.new { production_database }
  set :rails_env, 'production'
end

# =============================================================================
# TASKS
# =============================================================================

after "deploy", "deploy:sass"
after "deploy", "deploy:cleanup"
after "deploy", "deploy:symlinks"
after "deploy", "deploy:permissions"
after "deploy:migrations", "deploy:sass"
after "deploy:migrations", "deploy:cleanup"
after "deploy:migrations", "deploy:symlinks"

# =============================================================================
namespace :deploy do  
  desc "Restarting mod_rails with restart.txt"
    task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{release_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  desc "Update Sass Stylesheets"
  task :sass do
    run "/web/northwoodmortgage.com_production/current/script/runner 'Sass::Plugin.update_stylesheets'"
  end
  
  desc "Create Symlinks"
  task :symlinks do
    run("ln -s #{shared_path}/public/site_images #{release_path}/public/site_images")
    run("ln -s #{shared_path}/shared_files #{release_path}/shared_files")    
    run("rm -rf #{release_path}/public/user/photo")            
    run("ln -s #{shared_path}/photo #{release_path}/public/user/photo")        
  end
  
  desc "Set Permissions"
  task :permissions do
    run("chmod 764 #{release_path}/script/northwood_maintenance.sh")
    run("chmod 764 #{release_path}/script/northwood_shared_files_notification.sh")
  end
  
end

# =============================================================================
set :production_database,'nwm_production'
set :sql_user, 'nwm_production'
set :sql_pass, 'anilrm='
set :sql_host, 'localhost'

  
