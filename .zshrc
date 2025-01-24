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

alias itl=$'() { ./test.sh --local "$@" }'

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
alias t=$'() { npm run test --ignore-scripts -- --watch --no-coverage -u --verbose --expand "$@" ;}'

# git
alias g='git'

alias prv='gh pr view --web'

alias frequentgit='history | cut -c 8- | grep git | sort | uniq -c  | sort -n -r | head -n 10'

alias git-list-untracked='git fetch --prune && git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}"'
alias git-remove-untracked='git fetch --prune && git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}" | xargs git branch -D'

alias ga=$'g aa'
alias gp=$'g gp'
alias gcb=$'g go'
alias gpr=$'g p'
alias gss=$'g s'
alias gd=$'g discard'
alias gsq=$'g reset-branch'
alias gcm='g com' # checkout the master/main branch
alias gcam='g ca' # commit all changes with message
alias gcau='g go auto-update' # go to the auto-update branch

# arr
alias arr="$SOLUTION_REPO/tooling/arr.sh"
alias arr-psql=$'arr sql -t=ro --skip-dbeaver; PGPASSWORD=$(arr print-sql-password) psql -h localhost -p 5433 -U todor.andonov@payhawk.com payhawk'
alias arr-pgcli=$'arr sql -t=ro --skip-dbeaver; PGPASSWORD=$(arr print-sql-password) pgcli -h localhost -p 5433 -U todor.andonov@payhawk.com -d payhawk --less-chatty'
alias arrp=$'ENV=production DBD=true arr'
alias arrp-psql=$'arrp sql -t=ro -r="support tickets" --skip-dbeaver; PGPASSWORD=$(arrp print-sql-password) psql -h localhost -p 5432 -U todor.andonov@payhawk.com payhawk'
alias arrp-pgcli=$'arrp sql -t=ro -r="support tickets" --skip-dbeaver; PGPASSWORD=$(arrp print-sql-password) pgcli -h localhost -p 5432 -U todor.andonov@payhawk.com -d payhawk --less-chatty'
# alias sync-db=$'arr sql -t=ro --skip-dbeaver; export SCHEMA="$1"; export PGUSER=$(arr print-sql-username); export PGPASSWORD=$(arr print-sql-password); pg_dump --dbname="postgresql://localhost:5433/payhawk" --schema="$SCHEMA" --file="$HOME/Documents/$SCHEMA.sql"; psql --dbname="postgresql://postgres:password@localhost:31234/payhawk" --file="$HOME/Documents/$1.sql"'
alias sync-db-prod=$'arrp sql -t=ro -r="Sync schema" --skip-dbeaver; export SCHEMA="$1"; export PGUSER=$(arrp print-sql-username); export PGPASSWORD=$(arrp print-sql-password); pg_dump --dbname="postgresql://localhost:5432/payhawk" --schema="$SCHEMA" --file="$HOME/Documents/$SCHEMA.sql"; psql --dbname="postgresql://postgres:password@localhost:31234/payhawk" --file="$HOME/Documents/$SCHEMA.sql"'

# utility
alias lfr="$SOLUTION_REPO/kubernetes/local-full-refresh.sh"
alias run-sh=$'LOG_PRETTY=true LOG_LEVEL=info ./run.sh'

alias fmt=$'nr format'

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

sync_db() {
  # Check if schema name is provided
  if [ -z "$1" ]; then
    echo "Usage: sync_db <schema_name>"
    return 1
  fi

  # Variables
  local SCHEMA="$1"
  local PGUSER=$(arr print-sql-username)
  local PGPASSWORD=$(arr print-sql-password)
  local DUMP_FILE="$HOME/Documents/$SCHEMA.sql"
  local SOURCE_DB="postgresql://localhost:5433/payhawk"
  local TARGET_DB="postgresql://postgres:password@localhost:31234/payhawk"

  # Execute commands
  arr sql -t=ro --skip-dbeaver
  export SCHEMA
  export PGUSER
  export PGPASSWORD

  # Perform pg_dump
  pg_dump --dbname="$SOURCE_DB" --schema="$SCHEMA" --file="$DUMP_FILE"

  # Import to target database
  psql --dbname="$TARGET_DB" --file="$DUMP_FILE"
}
