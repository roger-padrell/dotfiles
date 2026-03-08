if status is-interactive
# Commands to run in interactive sessions can go here
end

oh-my-posh init fish --config .config/ohmyposh/zen.toml | source
zoxide init fish --cmd cd | source

# android
set ANDROID_HOME "$HOME/Android/sdk"
set ANDROID_SDK_ROOT "$HOME/Android/sdk"
fish_add_path "$ANDROID_HOME/cmdline-tools/latest/bin"
fish_add_path "$ANDROID_HOME/platform-tools"

# flutter
fish_add_path "$HOME/.flutter/flutter/bin"

# tmux
if status is-interactive
    if not set -q TMUX
        exec tmux
    end
end
