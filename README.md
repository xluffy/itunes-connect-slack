itunes-connect-slack
--------------------

These scripts fetch app info directly from iTunes Connect and posts changes in Slack as a bot. Since iTC doesn't provide event webhooks, these scripts use polling with the help of Fastlane's [Spaceship](https://github.com/fastlane/fastlane/tree/master/spaceship).

![example](https://raw.githubusercontent.com/erikvillegas/itunes-connect-slack/master/example.png)

# Set up

### Environment Variables

The scripts read config environment from `.env` file (require `dotenv` for nodejs + ruby). Be sure to create it follow `env.example`:

```bash
ITC_USERNAME=""
ITC_PASSWORD=""
BUNDLE_ID=""
SLACH_BOT_API_TOKEN="xoxb-"
SLACK_CHANNEL="random"
```

### Install node modules + gem

```bash
> yarn install
> bundle install
```

### Channel info

Set the specific channel you'd like the bot to post to `.env`. By default, it posts to `#ios-app-updates`.

### Polling interval

In `poll-itc.js`, set the `pollIntervalSeconds` value to whatever you like.

### Running the scripts

```bash
> node poll-itc.js
```

Or you can use the [pm2](https://github.com/Unitech/pm2) tool to keep it up indefinitely:

```bash
> pm2 start poll-itc.js --name 'itunes-connect-slack'
```

# Files

### get-app-status.rb

Ruby script that uses Spaceship to connect to iTunes Connect. It then stdouts a JSON blob with your app info. It only looks for apps that aren't yet live.

### poll-itc.js

Node script to invoke the ruby script at certain intervals. It uses a key/value store to check for changes, and then invokes `slacker.js`.

### slacker.js

Node script that uses Slack's node.js SDK to send a message as a bot. It also calculates the number of hours since submission.
