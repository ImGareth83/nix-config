# Testing Guide for Modularized Configuration

## Quick Verification Commands

### 1. Check Module Files Exist
```bash
ls -la modules/
# Should show: dotfiles.nix, neovim.nix, packages.nix, programs.nix, shell.nix
```

### 2. Verify Zsh Configuration
```bash
# Check zshrc exists
ls -la ~/.zshrc

# Test aliases
ll          # Should show long listing
k version   # Should show kubectl version
a version   # Should show argocd version

# Test zsh plugins (should see autosuggestions and syntax highlighting)
zsh -c 'echo "Testing zsh"'
```

### 3. Verify Git Configuration
```bash
# Check git config
git config --list | grep -E "(user.name|user.email|alias)"

# Test git aliases
git st      # Should show git status
git co -h   # Should show checkout help
git ci -h   # Should show commit help
git lg      # Should show formatted log
```

### 4. Verify Neovim Configuration
```bash
# Open neovim and check settings
nvim --version

# In nvim, check:
# :set number?      # Should show number
# :set tabstop?     # Should show 2
# :set shiftwidth?  # Should show 2
# :colorscheme      # Should show dark background
```

### 5. Verify Packages
```bash
# Test CLI tools
bat --version
fd --version
jq --version
tree --version

# Test development tools
node --version
pnpm --version
java -version
gradle --version
maven --version

# Test cloud tools
aws --version
kubectl version --client
argocd version --client
```

### 6. Verify Dotfiles
```bash
# Check dotfiles exist
ls -la ~/.aws/config
ls -la ~/.aws/credentials
ls -la ~/.vimrc
ls -la ~/.tmux.conf

# Check content
cat ~/.vimrc | head -3
cat ~/.tmux.conf | head -3
```

### 7. Verify Environment Variables
```bash
echo $EDITOR      # Should show: nvim
echo $JAVA_HOME   # Should show Java path
```

### 8. Verify Home Manager Generation
```bash
# Check Home Manager generation
home-manager generations

# Verify activation
home-manager switch --dry-run
```

## Expected Results

✅ **All commands should execute without errors**
✅ **All configurations should match your settings**
✅ **All aliases and shortcuts should work**
✅ **All programs should be accessible**

## Troubleshooting

If something doesn't work:
1. Check the specific module file in `modules/`
2. Verify the import in `home.nix`
3. Check Home Manager logs: `home-manager generations`
4. Rebuild: `sudo darwin-rebuild switch --flake '.#mbp'`
