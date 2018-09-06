# frozen_string_literal: true

require 'spaceship'
require 'json'
require 'dotenv/load'

# Constants
itc_username = ENV['ITC_USERNAME']
itc_password = ENV['ITC_PASSWORD']
bundle_id = ENV['BUNDLE_ID']

unless itc_username
  puts "ERROR: Can't get Itunes email address, please update .env file"
  exit
end

unless itc_password
  puts "ERROR: Can't get Itunes password, please update .env file"
end

unless bundle_id
  puts "ERROR: Can't get bundle id, please update .env file"
  exit
end

# auth itunes connnect
Spaceship::Tunes.login(itc_username, itc_password)
app = Spaceship::Tunes::Application.find(bundle_id)

edit_version_info = app.edit_version
live_version_info = app.live_version

# send app info to stdout as JSON
versions = {}

if edit_version_info
  versions['edit_version_info'] = {
    'name' => app.name,
    'version' => edit_version_info.version,
    'status' => edit_version_info.app_status,
    'appId' => app.apple_id,
    'iconUrl' => app.app_icon_preview_url
  }
end

if live_version_info
  versions['live_version_info'] = {
    'name' => app.name,
    'version' => live_version_info.version,
    'status' => live_version_info.app_status,
    'appId' => app.apple_id,
    'iconUrl' => app.app_icon_preview_url
  }
end

puts JSON.dump versions
