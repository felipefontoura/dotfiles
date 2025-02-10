# Start a new session named 'dev'
new-session -s dev -n editor
send-keys 'nvim .' Enter

# Split the first window vertically, with 30% on the right
split-window -h -p 30

# Create second window for server and start foreman
new-window -n server
send-keys 'bundle exec foreman start -f Procfile.dev' Enter

# Return to first window and select the left pane (for editor)
select-window -t editor
select-pane -t 0

