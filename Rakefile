# -*- ruby -*-

require 'rubygems'
require 'hoe'

Hoe.plugin :isolate

Hoe.spec 'geera' do
  developer('Aaron Patterson', 'apatterson@atti.com')
  self.readme_file      = 'README.rdoc'
  self.history_file     = 'ChangeLog'
  self.extra_rdoc_files = FileList['*.rdoc']
  self.extra_deps       << ['jira4r', '>= 0.3.0']
  self.extra_dev_deps   << ['flexmock', '>= 0']
end

# vim: syntax=ruby
