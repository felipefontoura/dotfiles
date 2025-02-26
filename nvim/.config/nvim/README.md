# Neovim Configuration

This is my personal Neovim configuration focused on providing a modern and efficient development environment based on LazyVim.

## 🎯 Key Features

- Modern UI with bufferline and statusline
- LSP integration
- Intelligent code completion
- Git integration
- File explorer
- Fuzzy finding
- AI assistance with Claude
- Tmux integration

## ⌨️ Key Mappings

### Navigation

#### Basic Movement

| Key              | Description                                  |
| ---------------- | -------------------------------------------- |
| `j`, `k`         | Smart line movement (respects wrapped lines) |
| `<Down>`, `<Up>` | Smart line movement (respects wrapped lines) |

#### Window Navigation

| Key     | Description                  |
| ------- | ---------------------------- |
| `<C-h>` | Go to left window/tmux pane  |
| `<C-j>` | Go to lower window/tmux pane |
| `<C-k>` | Go to upper window/tmux pane |
| `<C-l>` | Go to right window/tmux pane |
| `<C-\>` | Go to previous tmux pane     |

#### Window Management

| Key          | Description        |
| ------------ | ------------------ |
| `<leader>-`  | Split window below |
| `<leader>\|` | Split window right |
| `<leader>wd` | Delete window      |
| `<leader>wm` | Toggle window zoom |
| `<leader>uz` | Toggle zen mode    |

#### Window Resizing

| Key         | Description            |
| ----------- | ---------------------- |
| `<C-Up>`    | Increase window height |
| `<C-Down>`  | Decrease window height |
| `<C-Left>`  | Decrease window width  |
| `<C-Right>` | Increase window width  |

### Buffer Management

#### Buffer Navigation

| Key                                   | Description            |
| ------------------------------------- | ---------------------- |
| `<S-h>`, `[b`                         | Previous buffer        |
| `<S-l>`, `]b`                         | Next buffer            |
| `<leader>bb`, <code><leader>\`</code> | Switch to other buffer |

#### Buffer Operations

| Key          | Description              |
| ------------ | ------------------------ |
| `<leader>bd` | Delete buffer            |
| `<leader>bo` | Delete other buffers     |
| `<leader>bD` | Delete buffer and window |

#### Buffer Line Operations

| Key          | Description                 |
| ------------ | --------------------------- |
| `<leader>bp` | Toggle pin                  |
| `<leader>bP` | Delete non-pinned buffers   |
| `<leader>br` | Delete buffers to the right |
| `<leader>bl` | Delete buffers to the left  |
| `[B`         | Move buffer prev            |
| `]B`         | Move buffer next            |

### File Operations

#### File Navigation

| Key                | Description |
| ------------------ | ----------- |
| `<leader><leader>` | Find files  |
| `<leader>/`        | Live grep   |
| `<leader>fn`       | New file    |

#### File Explorer

| Key          | Description            |
| ------------ | ---------------------- |
| `<leader>fe` | Toggle file explorer   |
| `<leader>ge` | Toggle git explorer    |
| `<leader>be` | Toggle buffer explorer |

### Code Navigation & Editing

#### LSP

| Key          | Description         |
| ------------ | ------------------- |
| `K`          | Hover documentation |
| `<leader>gd` | Go to definition    |
| `<leader>gr` | Find references     |
| `<leader>ca` | Code action         |

#### Diagnostics

| Key          | Description          |
| ------------ | -------------------- |
| `<leader>cd` | Line diagnostics     |
| `]d`, `[d`   | Next/prev diagnostic |
| `]e`, `[e`   | Next/prev error      |
| `]w`, `[w`   | Next/prev warning    |

#### Search and Replace

| Key     | Description         |
| ------- | ------------------- |
| `s`     | Flash jump          |
| `S`     | Flash treesitter    |
| `r`     | Remote flash        |
| `R`     | Treesitter search   |
| `<C-s>` | Toggle flash search |

### Git Operations

#### Git Navigation

| Key        | Description     |
| ---------- | --------------- |
| `]h`, `[h` | Next/prev hunk  |
| `]H`, `[H` | Last/first hunk |

#### Git Actions

| Key          | Description              |
| ------------ | ------------------------ |
| `<leader>gg` | Open Lazygit             |
| `<leader>gf` | Git current file history |
| `<leader>gl` | Git log                  |
| `<leader>gb` | Git blame line           |
| `<leader>gB` | Git browse (open)        |
| `<leader>gY` | Git browse (copy)        |

### Testing

| Key          | Description  |
| ------------ | ------------ |
| `<leader>t`  | Test nearest |
| `<leader>tt` | Test file    |
| `<leader>tT` | Test suite   |
| `<leader>tl` | Test last    |
| `<leader>tg` | Test go      |

### AI Assistant (Claude)

| Key          | Description          |
| ------------ | -------------------- |
| `<leader>aa` | Ask AI               |
| `<leader>ae` | Edit with AI         |
| `<leader>ar` | Refresh AI response  |
| `<leader>af` | Focus AI             |
| `<leader>at` | Toggle AI            |
| `<leader>ad` | Toggle AI debug      |
| `<leader>ah` | Toggle AI hint       |
| `<leader>as` | Toggle AI suggestion |
| `<leader>aR` | Toggle AI repomap    |

## 📦 Dependencies

- Neovim >= 0.9.0
- Git
- A Nerd Font
- `ripgrep` for telescope
- `lazygit` for git integration
- `tmux` for terminal integration
