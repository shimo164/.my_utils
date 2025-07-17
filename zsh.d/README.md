# Zsh Configuration

Modular zsh configuration with organized file structure and enhanced functionality.

## Setup

1. Create symbolic link to main zshrc:
   ```bash
   ln -s ~/.zsh.d/zshrc ~/.zshrc
   source ~/.zshrc
   ```

## File Structure

```
.zsh.d/
├── init/                    # Initialization files (loaded first)
│   ├── oh_my_zsh           # Oh My Zsh configuration and plugins
│   ├── loader              # Auto-loads other .zsh files
│   ├── fzf_helper          # fzf history search and directory navigation
│   └── history_*           # History management utilities
├── zshrc                   # Main configuration file
├── profile.zsh             # Environment variables (sensitive)
├── alias.zsh               # Project-specific aliases (sensitive)
├── alias_common.zsh        # Common aliases
├── history.zsh             # History settings
├── git.zsh                 # Git utilities and functions
├── cd_history.zsh          # Directory navigation history
└── README.md               # This file
```

## Key Features

### Enhanced History Search

- **Ctrl+R**: fzf-powered history search
- Automatic duplicate removal on terminal startup
- Smart filtering of failed commands

### Modular Configuration

- Automatic loading of `.zsh` files
- Organized initialization sequence
- Clean separation of concerns

## Sensitive Files

The following files contain sensitive information and are excluded from version control:

- `profile.zsh` - Environment variables, API keys, personal settings
- `alias.zsh` - Project-specific aliases that may contain sensitive paths
- Files matching patterns in `.qignore` - Excluded from AI analysis

### Aliases

- Common aliases → `alias_common.zsh`
- Sensitive/project-specific aliases → `alias.zsh`

## Dependencies

- zsh
- oh-my-zsh
- fzf
- git

## Maintenance

- History duplicates are automatically cleaned on startup
- Use `.qignore` to exclude files from AI analysis
- Use `.gitignore` to exclude files from version control
-

## Customization

### Adding New Functionality

- Create `.zsh` files in the root directory for automatic loading
- Use `init/` directory for initialization-specific code
- Follow the existing naming conventions
