#!/bin/bash -

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We set up Firefox so that it does not bother us with dialogs."

# Define variables
FIREFOX_DIR="$HOME/.config/mozilla/firefox"
PROFILE_NAME="locked.default-esr" # You can name this anything, e.g., "myprofile"
INSTALL_HASH="6AFDA46A1A8AD48"
PROFILE_PATH="$FIREFOX_DIR/$PROFILE_NAME"
PROFILES_INI="$FIREFOX_DIR/profiles.ini"
INSTALLS_INI="$FIREFOX_DIR/installs.ini"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We use base path FIREFOX_DIR='$FIREFOX_DIR' and PROFILE_PATH='$PROFILE_PATH', which we will create now."

# Create the main firefox directory if it doesn't exist
mkdir -p "$FIREFOX_DIR"
# Create the specific profile directory
mkdir -p "$PROFILE_PATH"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now we write the PROFILES_INI='$PROFILES_INI'."
# Create profiles.ini to recognize the new profile
# This tells Firefox where to find the profile data
cat > "$PROFILES_INI" <<EOF
[General]
StartWithLastProfile=1
Version=2

[Profile0]
Name=$PROFILE_NAME
IsRelative=1
Path=$PROFILE_NAME
Default=1

[Install$INSTALL_HASH]
Default=$PROFILE_NAME
Locked=1
EOF

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now we write the INSTALLS_INI='$INSTALLS_INI'."
# Create installs.ini to recognize the new profile
# This tells Firefox where to find the profile data
cat > "$INSTALLS_INI" <<EOF
[$INSTALL_HASH]
Default=$PROFILE_NAME
Locked=1
EOF

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now we write the user.js file '$PROFILE_PATH/user.js'."
# Write the user.js file to disable Welcome and Translation dialogs
# user.js is read at startup and overrides default preferences
cat > "$PROFILE_PATH/user.js" <<'EOF'
// Disable the "Welcome to Firefox" / About Welcome screen
user_pref("browser.aboutwelcome.enabled", false);
user_pref("browser.startup.homepage_override.mstone", "ignore");
user_pref("startup.homepage_welcome_url", "");
user_pref("startup.homepage_welcome_url.additional", "");
user_pref("browser.startup.homepage_override.mstone", "ignore");
user_pref("browser.startup.page", 0);
user_pref("browser.disableResetPrompt", true);

// Disable the "Try Private Translations" prompt and feature
// Note: In newer ESR versions (128+), translation is local but still prompts
user_pref("browser.translations.enable", false);
user_pref("browser.translations.automaticallyPopup", false);
user_pref("browser.translation.ui.show", false);
user_pref("browser.translation.neverForLanguages", "");
user_pref("browser.translations.autoTranslate", false);

// Disable other common onboarding/nag screens
user_pref("browser.shell.checkDefaultBrowser", false);
user_pref("datareporting.policy.dataSubmissionPolicyAccepted", false);
user_pref("datareporting.policy.dataSubmissionPolicyBypassNotification", true);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.feeds.snippets", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.topstories", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.topsites", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.snippets", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.recommended", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.highlights", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.pocket", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.search", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.topstories", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.topsites", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.snippets", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.recommended", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.highlights", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.pocket", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.search", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.topstories", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.topsites", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.snippets", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.recommended", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.highlights", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.pocket", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.search", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.topstories", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.topsites", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.snippets", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.recommended", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.highlights", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.pocket", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.search", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.topstories", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.topsites", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.snippets", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.recommended", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.highlights", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.pocket", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.search", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.topstories", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.topsites", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.snippets", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.recommended", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.highlights", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.pocket", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.search", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.topstories", false);

// Disable the "You can't use speech synthesis ..." and other banners.
user_pref("media.webspeech.synth.dont_notify_on_error", true);
user_pref("dom.webnotifications.enabled", false);
user_pref("identity.fxaccounts.enabled", false);
EOF

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Firefox ESR profile configured successfully at: '$PROFILE_PATH'."
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Done setting up Firefox so that it does not bother us with dialogs."
