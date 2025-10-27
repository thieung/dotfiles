# Fish Shell Aliases

# Basic aliases
alias ll 'ls -alF'
alias la 'ls -A'
alias l 'ls -CF'
alias cls 'clear'

# Git aliases (based on jhillyerd/plugin-git)
abbr -a g git
abbr -a ga "git add"
abbr -a gaa "git add --all"
abbr -a gau "git add --update"
abbr -a gapa "git add --patch"
abbr -a gb "git branch -vv"
abbr -a gba "git branch -a -v"
abbr -a gbd "git branch -d"
abbr -a gbD "git branch -D"
abbr -a gc "git commit -v"
abbr -a gca "git commit -v -a"
abbr -a gcm "git commit -m"
abbr -a gco "git checkout"
abbr -a gcb "git checkout -b"
abbr -a gd "git diff"
abbr -a gdca "git diff --cached"
abbr -a gl "git pull"
abbr -a glg "git log --stat"
abbr -a glog "git log --oneline --decorate --color --graph"
abbr -a gp "git push"
abbr -a gpo "git push origin"
abbr -a gpu "git push --set-upstream origin"
abbr -a grb "git rebase"
abbr -a grba "git rebase --abort"
abbr -a grbc "git rebase --continue"
abbr -a gsb "git status -sb"
abbr -a gst "git status"
abbr -a gsta "git stash"
abbr -a gstaa "git stash apply"
abbr -a gstd "git stash drop"
abbr -a gstl "git stash list"
abbr -a gstp "git stash pop"

# Directory navigation
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'

# Claude
alias ccs="claude --dangerously-skip-permissions"

# Neovim
alias v 'NVIM_APPNAME=my_nvim nvim'

# Lazygit
alias lg="lazygit"
