require 'spec_helper'

files = { "glance-api.conf"=> 640, "glance-api-paste.ini"=> 640, "glance-registry.conf"=> 640, "glance-registry-paste.ini"=> 640, "glance-swift-store.conf"=> 640, "policy.json"=> 644 } 
files.each do |file, mode|
  describe file("/etc/glance/#{file}") do
    it { should be_mode mode }
    it { should be_owned_by 'glance' }
    it { should be_grouped_into 'glance' }
  end
end

describe file('/var/log/glance/glance-api.log') do
  it { should be_mode 644 }
  it { should be_owned_by 'glance' }
  it { should be_grouped_into 'adm' }
end

describe file('/var/log/glance/glance-manage.log') do
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'adm' }
end

describe file('/var/log/glance/glance-registry.log') do
  it { should be_mode 644}
  it { should be_owned_by 'glance' }
  it { should be_grouped_into 'adm'}
end

describe file('/etc/logrotate.d/glance') do
  it { should exist }
  file_contents = [ '# Generated by Ansible.',
                    '# Local modifications will be overwritten.',
                    '',
                    '/var/log/glance/*.log',
                    '{',
                    '  daily',
                    '  missingok',
                    '  rotate',
                    '  compress',
                    '}']
  file_contents.each do |file_line|
    it { should contain file_line}
  end
end

describe file("/etc/glance/glance-registry.conf") do
  it { should contain "debug = {{ glance.logging.debug }}" }
end
