# integration tests for docker-compose

require 'serverspec'
require 'specinfra/backend/docker_compose'

set :docker_compose_file, 'docker-compose.yml'
set :docker_compose_container, :mongo # The compose container to test
set :docker_wait, 5 # wait 15 seconds before running the tests
set :backend, :docker_compose

describe 'Test of mongo service (docker-compose run mongo)' do
  describe 'Related packages should be installed' do
    %w(numactl procps net-tools lsof less jq).each do |rpackage|
      describe package(rpackage) do
        it { should be_installed }
      end
    end
  end

  describe 'Intermidiate packages should be removed' do
    %w(wget ca-certificates).each do |tpackage| 
      describe package(tpackage) do
       it { should_not be_installed }
      end
    end
  end

  describe 'Mongo packages should be installed with correct version' do
    mongo_version = '3.2.4'
    %w(mongodb-org 
       mongodb-org-server
       mongodb-org-shell
       mongodb-org-mongos
       mongodb-org-tools).each do |mongo_package|
      describe package(mongo_package) do
        it { should be_installed.with_version(mongo_version) }
      end
    end
  end

  describe 'Environment and files checks' do
    describe file('/entrypoint.sh') do
      it { should be_file }
      it { should exist }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end

    describe 'Mongo work dirs checks' do
      %w(/data/db /data/configdb).each do |mongo_dir|
        describe file(mongo_dir) do
          it { should be_directory }
          it { should exist }
          it { should be_owned_by 'mongodb' }
        end
      end
    end

    describe user('mongodb') do
      it { should exist }
      it { should have_login_shell '/bin/sh' }
      it { should belong_to_group 'mongodb' }
    end 

  end

  describe 'Running environment checks' do
    describe port(27017) do
      it { should be_listening }
    end
  
    describe process('mongod') do
      it { should be_running }
      its(:user) { should eq "mongodb" }
      its(:count) { should eq 1 }
    end
  
    describe 'Mongo server status check' do
      command = %(
                su mongodb -c '
                mongo --quiet --eval 
                "JSON.stringify(db.runCommand({ serverStatus: 1 }))"
                ' 
                | jq -r .ok
                ).gsub(/\s+/, ' ').strip
      describe command(command) do
        its(:stdout) { should eq "1\n" }
      end
    end
  end

end
