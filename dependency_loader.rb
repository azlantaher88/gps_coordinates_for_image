def load_and_require_gem(name, version=nil)
  begin
    gem_name, gem_module = name.split("/")
    gem gem_name, version
  rescue LoadError
    version = "--version '#{version}'" unless version.nil?
    system("gem install #{gem_name} #{version}")
    Gem.clear_paths
    retry
  end
  require name
end

load_and_require_gem 'exifr/jpeg'

require 'fileutils'
require 'csv'
require 'erb'
require_relative 'image_processor'
require_relative 'exporter'

