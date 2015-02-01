server 'productionhost', user: 'productionuser', roles: %w{web app db}
set :deploy_to, '/home/productionuser/app'
