# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

# # ex = EXtractor for all kinds of archives
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   tar xf $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Aliases
alias ls='ls --color'
alias vim='nvim'
alias c='clear'
alias ll='ls -la'
alias update='sudo pacman -Syyu;yay -Su'
alias cleanup='sudo pacman -Rns $(pacman -Qtdq);yay -Sc --noconfirm'

# pacman unlock
alias unlock="sudo rm /var/lib/pacman/db.lck"
alias rmpacmanlock="sudo rm /var/lib/pacman/db.lck"

# get fastest mirrors in your neighborhood
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 30 --number 10 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 30 --number 10 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 30 --number 10 --sort age --save /etc/pacman.d/mirrorlist"

# Maven
alias mvn-ci="mvn clean install"
alias mvn-ci-sk="mvn clean install -DskipTests"
alias mvn-it="mvn failsafe:integration-test"
alias mvn-check-updates="mvn versions:display-property-updates"

# neovim
alias nvchad="NVIM_APPNAME=nvchad nvim"
alias lazyvim="NVIM_APPNAME=lazyvim nvim"
alias astronvim="NVIM_APPNAME=astronvim nvim"

# Shell integrations
eval "$(fzf --bash)"
eval "$(zoxide init --cmd cd bash)"
source /usr/share/nvm/init-nvm.sh

# Starship
# https://github.com/starship/starship/issues/560#issuecomment-2197994300
PROMPT_COMMAND="export PROMPT_COMMAND=echo"
eval "$(starship init bash)"
