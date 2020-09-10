#!/bin/bash

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# added by Anaconda3 2018.12 installer
# >>> conda init >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$(CONDA_REPORT_ERRORS=false '/anaconda3/bin/conda' shell.bash hook 2> /dev/null)"
if [ $? -eq 0 ]; then
    \eval "$__conda_setup"
else
    if [ -f "/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/anaconda3/etc/profile.d/conda.sh"
        CONDA_CHANGEPS1=false conda activate base
    else
        \export PATH="/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda init <<<

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/sh/google-cloud-sdk/path.bash.inc' ]; then . '/Users/sh/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/sh/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/sh/google-cloud-sdk/completion.bash.inc'; fi

# The next line makes Google Cloud SDK work post 2020
# No, I don't understand why I need to do this, but it works
export CLOUDSDK_PYTHON=/Users/sh/.pyenv/versions/3.6.9/bin/python

# k8s in the prompt
source /usr/local/opt/kube-ps1/share/kube-ps1.sh

##############################
# Fancy git bash integration #
##############################

YELLOW="\[$(tput setaf 3)\]"
BLUE="\[$(tput setaf 4)\]"
TEAL="\[$(tput setaf 6)\]"
WHITE="\[\033[00m\]"
MAGENTA="\[\033[00;35m\]"

test -f ~/.git-completion.bash && . $_
source /usr/local/etc/bash_completion.d/git-prompt.sh
if [ -f ~/.git-prompt.sh ]; then
  source ~/.git-prompt.sh
fi

GIT_PS1_SHOWDIRTYSTATE=true
PS1="┌─ ${BLUE}\D{%m-%d %T} ${MAGENTA}\u@\h${WHITE}:\w "
PS1+="${YELLOW}\$(__git_ps1)${WHITE}\$(kube_ps1)\n└\\$ "
export PS1

## End fancy git bash

# Expects `fd` - brew install fd - alt. to `find`
export FZF_DEFAULT_COMMAND='fd --type f'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias mkenv="/Users/sh/.pyenv/shims/python -m virtualenv venv"
alias vactivate="source venv/bin/activate"

# For compilers to find zlib you may need to set:
export LDFLAGS="-L/usr/local/opt/zlib/lib"
export CPPFLAGS="-I/usr/local/opt/zlib/include"
# For pkg-config to find zlib you may need to set:
export PKG_CONFIG_PATH="/usr/local/opt/zlib/lib/pkgconfig"
eval "$(pyenv init -)"

alias repos="cd ~/q/repos/"

# functions for testing qai services

export SENSITIVITY_META='{"subGroup": [{"category":"age","enabled":1,"displayName":"Age and family status","ordering":1},{"category":"disability","enabled":1,"displayName":"Disability","ordering":2},{"category":"gender-identity","enabled":1,"displayName":"Gender identity","ordering":3},{"category":"race-ethnicity-nationality","enabled":1,"displayName":"Race, ethnicity, and nationality","ordering":4},{"category":"sexual-orientation","enabled":1,"displayName":"Sexual orientation","ordering":5},{"category":"substance-use","enabled":1,"displayName":"Substance use","ordering":6}]}'
export GENDER_META='{"category":"entities","enabled":1,"displayName":"GENDER","subGroup":[{"category":"use-gender-inclusive-pronouns","enabled":1,"displayName":"Prefer gender-inclusive pronouns"},{"category":"use-gender-inclusive-nouns","enabled":1,"displayName":"nouns"}]}'
export PLAIN_LANGUAGE_META='{"category":"plain-language","displayName":"Plain Language","subGroup":[{"category":"passive-voice","enabled":1},{"category":"wordiness","enabled":1},{"category":"unclear-references","enabled":1}]}'
# binary on/off by default

test_qai()
{
    local segment=$1
    local meta=${2-'{"category":"testing-category","enabled":1,"displayName":"testingtesting","subGroup":[]}'}
    local url=${3-localhost:5000}
    curl -X POST -d '[{"category":"TESTING","content":{"segmentId":"testing-123-testing-420","organizationId":69,"workspaceId":69,"personaId":666,"languageCode":"en-us","documentId":"invalid-id-666-420-69","userId":66,"operation":"create","segment":"'"$segment"'"},"chain":{"topic":"dev4.segment-delegator.non-priority.cai-latch.allLang","meta":'"$meta"',"chain":[]},"issues":[]}]' "$url"
}

# special functions for special payloads

test_meta_qai ()
{
    local SEGMENT=$1;
    local URL=${2:-localhost:5000}
    local META_VALUE=${3:-2}
    curl -X POST -d '[{"category":"TESTING","content":{"segmentId":"e0da52a8-3a37-4060-a07c-81835a6e08cf","organizationId":93,"workspaceId":82,"personaId":186,"languageCode":"en-us","documentId":"f9afef2a-74e9-4ab7-899b-f47e026f6f2a","userId":125,"operation":"create","segment":"'"$SEGMENT"'"},"chain":{"topic":"dev4.segment-delegator.non-priority.cai-latch.allLang","meta":{"category":"entities","enabled":1,"displayName":"Named entity detection","value":"'"$META_VALUE"'"},"chain":[]},"issues":[]}]' "$URL"
}


test_oxford_comma ()
{
    local SEGMENT=$1;
    local PAYLOAD=${2-add}
    local URL=${3:-localhost:5000}
    # attempt to parse any reasonable way
    if [[ "${PAYLOAD,,}" == *"remove"* || "${PAYLOAD,,}" == *"off"* || "${PAYLOAD,,}" == *"ban"* ]]; then
        PAYLOAD="BAN_OXFORD_COMMA"
    else
        PAYLOAD="ENFORCE_OXFORD_COMMA"
    fi
    curl -X POST -d '[{"category":"TESTING","content":{"segmentId":"e0da52a8-3a37-4060-a07c-81835a6e08cf","organizationId":93,"workspaceId":82,"personaId":186,"languageCode":"en-us","documentId":"f9afef2a-74e9-4ab7-899b-f47e026f6f2a","userId":125,"operation":"create","segment":"'"$SEGMENT"'"},"chain":{"topic":"dev4.segment-delegator.non-priority.cai-latch.allLang","meta":{"category":"oxford-comma","enabled":1,"displayName":"Oxford Comma","subGroup":[{"enabled":1,"value":"'"$PAYLOAD"'","displayName":"Oxford-Comma"}]},"chain":[]},"issues":[]}]' "$URL"
}

test_sent_complexity()
{
    local SEGMENT=$1;
    local URL=${2:-localhost:5000}
    local META_VALUE=${3:-2}
    curl -X POST -d '[{"category":"TESTING","content":{"segmentId":"e0da52a8-3a37-4060-a07c-81835a6e08cf","organizationId":93,"workspaceId":82,"personaId":186,"languageCode":"en-us","documentId":"f9afef2a-74e9-4ab7-899b-f47e026f6f2a","userId":125,"operation":"create","segment":"'"$SEGMENT"'"},"chain":{"topic":"dev4.segment-delegator.non-priority.cai-latch.allLang","meta":{"category":"readability","enabled":1,"displayName":"Readability Score","subGroup":[{"category":"sentence-complexity","enabled":1,"value":"'"$META_VALUE"'","displayName":"Sentence complexity","ordering":1},{"category":"vocabulary","enabled":1,"value":"12","displayName":"Vocabulary","ordering":2},{"category":"paragraph-length","enabled":1,"value":"medium","displayName":"Paragraph length","ordering":3}]},"chain":[]},"issues":[]}]' "$URL"
}


[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

alias jn="jupyter notebook"

export MAVEN_HOME=/Users/sh/java/apache-maven-3.6.1
export PATH=$PATH:$MAVEN_HOME/bin

# Created by `userpath` on 2019-08-26 21:47:33
export PATH="$PATH:/Users/sh/.local/bin"

# homebrew complained aobut this being missing on 2020-01-13
export PATH="/usr/local/sbin:$PATH"

proxy_url ()
{
    if [ $# -eq 0 ]; then
        echo "syntax is 'proxy_url service_name optional_proxy_port'"
    elif [ $# -eq 1 ]; then
        echo http://127.0.0.1:8001/api/v1/namespaces/default/services/"$1":80/proxy/
    elif [ $# -eq 2 ]; then
        echo http://127.0.0.1:"$2"/api/v1/namespaces/default/services/"$1":80/proxy/
    else
        echo "syntax is 'proxy_url service_name optional_proxy_port'"
    fi
}

mkalias ()
{
if [[ $1 == *"="* ]]; then
    local OIFS=$IFS
    IFS="="
    read -r NAME CMD <<< "$1"
    IFS=$OIFS
    echo "# Added by mkalias command" >> ~/.bash_profile
    echo "alias $NAME=\"$CMD\"" >> ~/.bash_profile
    # shellcheck disable=SC1090
    source ~/.bash_profile
    echo "'$NAME' Alias added to your profile"
else
    echo ""
    echo "syntax is mkalias name=command"
    echo ""
    echo "e.g."
    echo "  mkalias pl=\"sudo lsof -i -P -n | grep LISTEN\""
    echo ""
    echo "Active mkalias commands-"
    echo ""
    sed -n '/# Added by mkalias/,$p' ~/.bash_profile | grep ^alias
    echo ""
fi
}

backup_dotfiles ()
{
    (
    cd /Users/sh/q/repos/dotfiles || exit
    ./backup.sh
    )
}

mkpoetryproj ()
{
    if [ $# -eq 1 ]; then
        poetry new "$1"
        cd "$1" || exit
        # get gitignore
        curl https://raw.githubusercontent.com/github/gitignore/master/Python.gitignore -o .gitignore
        {
            echo ""
            echo ".vscode/"
        } >> .gitignore
        mkdir -p .vscode
        touch .vscode/settings.json
        {
            echo "{"
            echo "    \"python.pythonPath\": \"$(poetry env info -p)/bin/python\","
            echo "    \"terminal.integrated.shellArgs.linux\": [\"poetry shell\"],"
            echo "    \"files.exclude\": {"
            echo "        \"**/.git\": true,"
            echo "        \"**/.DS_Store\": true,"
            echo "        \"**/*.pyc\": true,"
            echo "        \"**/__pycache__\": true,"
            echo "        \"**/.mypy_cache\": true"
            echo "    },"
            echo "    \"python.linting.enabled\": true,"
            echo "    \"python.linting.mypyEnabled\": true,"
            echo "    \"python.formatting.provider\": \"black\""
            echo "}"
        } >> .vscode/settings.json
        poetry add -D black mypy
        mv README.rst README.md
        git init && git add . && git commit -m "ready to start"
        # shellcheck source=/dev/null
        source "$(poetry env info -p)/bin/activate"  --prompt "poetry env"
        code .
    else
        echo "usage: mkpoetryproj FOLDER_TO_MAKE"
        echo ""
        echo "This inits a new project folder with poetry"
        echo "It adds the GitHub recommended .gitignore, connects VSCode to the poetry venv,"
        echo "and adds black and mypy, and makes sure VSCode knows about them"
        echo "it then inits a git repo, adds everything and commits it, then opens VSCode"
    fi
}

km ()
{
    if [ $# -eq 0 ]; then
        local name=${PWD##*/}
        local conf_path=./conf
    elif [ $# -eq 1 ]; then
        local name="$1"
        local conf_path=./conf
    elif [ $# -eq 2 ]; then
        local name="$1"
        local conf_path="$2"
    else
        echo "syntax is 'km (optinal configmap-name, defaults to current folder name) (optional path to config dir, defaults to ./config)'"
        echo ""
        echo "example:"
        echo "cd qordoba.k8s/dev4/confidence"
        echo "kx dev"
        echo "km"
    fi
    echo "Current context is"
    kubectl config current-context
    read -p "press y to proceed: " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        echo
    fi
    kubectl create cm "$name" --from-file="$conf_path" -o yaml --dry-run | kubectl apply -f -
}

# a fuckload of kubectl aliases
[ -f ~/.kubectl_aliases ] && source ~/.kubectl_aliases

# Added by mkalias command
alias ppjson_clip="pbpaste | jq . | pbcopy"
# Added by mkalias command
alias pwdcp="pwd | pbcopy"
# Added by mkalias command
alias pinit="mkenv && vactivate && pip install -r requirements.txt"
# Added by mkalias command
alias kl="kubectl"
# Added by mkalias command
alias kx="kubectx"
# Added by mkalias command
alias kns="kubens"
# Added by mkalias command
alias trim="awk '{=};1'"
# Added by mkalias command
alias poppy="python ~/.poppy/pop.py"


export PATH="$HOME/.cargo/bin:$PATH"
# Added by mkalias command
alias dmp="python ~/.sh/gdmp.py"
# added by sentdict on Thu Apr 30 11:16:52 PDT 2020
source ~/.sentdict/bash_funcs.sh

# Added by mkalias command
alias untar="tar -zxvf"
# Added by mkalias command
alias mkgitignore="curl https://raw.githubusercontent.com/github/gitignore/master/Python.gitignore -o .gitignore"
# Added by mkalias command
alias mkpyproj="mkenv && vactivate && mkgitignore && touch requirements.txt && git init && git add . && git commit -m 'ready to start'"

export PATH="$HOME/.poetry/bin:$PATH"
# Added by mkalias command
alias weather="curl -s 'wttr.in/portland'"
