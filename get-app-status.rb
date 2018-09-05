require 'Spaceship'
require 'json'
require 'dotenv/load'

# Constants
itc_username = ENV["ITC_USERNAME"]
itc_password = ENV["ITC_PASSWORD"]
bundle_id = ENV["BUNDLE_ID"]

if (!itc_username)
  puts "ERROR: Can't get Itunes email address, please update .env file"
  exit
end

if (!itc_password)
  puts "ERROR: Can't get Itunes password, please update .env file"
end

if (!bundle_id)
  puts "ERROR: Can't get bundle id, please update .env file"
  exit
end

# auth itunes connnect
Spaceship::Tunes.login(itc_username, itc_password)
app = Spaceship::Tunes::Application.find(bundle_id)

editVersionInfo = app.edit_version
liveVersionInfo = app.live_version

# send app info to stdout as JSON
versions = Hash.new

if editVersionInfo
  versions["editVersion"] = {
    "name" => app.name,
    "version" => editVersionInfo.version,
    "status" => editVersionInfo.app_status,
    "appId" => app.apple_id,
    "iconUrl" => app.app_icon_preview_url
  }
end

if liveVersionInfo
  versions["liveVersion"] = {
    "name" => app.name,
    "version" => liveVersionInfo.version,
    "status" => liveVersionInfo.app_status,
    "appId" => app.apple_id,
    "iconUrl" => app.app_icon_preview_url
  }
end

puts JSON.dump versions
