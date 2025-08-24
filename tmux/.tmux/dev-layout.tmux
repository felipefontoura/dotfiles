# Start a new session named 'dev'
new-session -s dev -n editor
send-keys 'nvim .' Enter

# Split the first window vertically, with 30% on the right
split-window -h -p 25

# Create second window for console
new-window -n console

# Create second window for server and start foreman
new-window -n server

# Return to first window and select the left pane (for editor)
select-window -t editor
select-pane -t 0

