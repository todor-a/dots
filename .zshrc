export GPG_TTY=$(tty)
export ZSH="$HOME/.oh-my-zsh"
export PROJECTS_HOME="$HOME/projects/payhawk"
export SOLUTION_REPO="$PROJECTS_HOME/solution"
export DENO_INSTALL="/Users/todor/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
export ANDROID_HOME=~/Library/Android/sdk
export ANDROID_AVD_HOME=~/.android/avd
export PATH="$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  npm
  git
  history
  aliases
  zsh-bat
  colorize
  alias-finder
  git-auto-fetch
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

alias c=$'clear'

alias zl=$'zellij'

# rust
alias cfmt=$'cargo fmt'
alias cit=$'cargo insta test'
alias cia=$'cargo insta accept'

# npm
alias ni=$'npm i'
alias nr=$'npm run'
alias npm-clean=$'rm -rf ./package-lock.json && rm -rf node_modules'
alias nup=$'nr up'
alias nrs=$'nr start'
alias nrss=$'nr start:staging --ignore-scripts'
alias nrc=$'nr compile'
alias nrw=$'nr watch'
alias snap=$'nr snap'
alias t=$'() { npm run test --ignore-scripts -- --watch --no-coverage -u --verbose "$@" ;}'

# git
alias frequentgit='history | cut -c 8- | grep git | sort | uniq -c  | sort -n -r | head -n 10'
alias gp=$'git push'
alias ga=$'git add .'
alias gc=$'git checkout'
alias gpr=$'git fetch --prune && git pull --rebase'
alias gcb=$'git checkout -b'
alias gcm='git checkout $(git rev-parse --abbrev-ref origin/HEAD | sed "s|origin/||")'
alias gcau=$'git checkout auto-update'
alias git-list-untracked='git fetch --prune && git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}"'
alias git-remove-untracked='git fetch --prune && git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}" | xargs git branch -D'
alias gsq=$'git reset $(git merge-base master $(git branch --show-current))'

alias arr="$SOLUTION_REPO/tooling/arr.sh"
alias lfr="$SOLUTION_REPO/kubernetes/local-full-refresh.sh"
alias arrp=$'ENV=production DBD=true arr'

alias fmt=$'nr format'

alias run-sh=$'LOG_PRETTY=true LOG_LEVEL=error ./run.sh'

alias check-port=checkPort

alias dots='/usr/bin/git --git-dir=/Users/todor/.cfg/ --work-tree=/Users/todor'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/todor/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/todor/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/todor/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/todor/google-cloud-sdk/completion.zsh.inc'; fi

eval "$(zoxide init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Load zellij completions
autoload -U +X compinit && compinit
. <( zellij setup --generate-completion zsh | sed -Ee 's/^(_(zellij) ).*/compdef \1\2/' )

setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

. "$HOME/.local/bin/env"
