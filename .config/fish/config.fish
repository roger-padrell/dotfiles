if status is-interactive
# Commands to run in interactive sessions can go here
end

oh-my-posh init fish --config .config/ohmyposh/zen.toml | source
zoxide init fish --cmd cd | source
