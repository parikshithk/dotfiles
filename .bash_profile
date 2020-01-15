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

# a helper function for testing qai services
test_qai ()
{
    local PAYLOAD=$1;
    local META=${2:-5}
    local URL=${3:-localhost:5000}
    curl -X POST -d '[{"requestId":30629,"category":"TESTING","content":{"segmentId":"segmentCreationInput2","organizationId":1,"workspaceId":3051,"personaId":301,"languageCode":"en-us","userId":1,"documentId":"429659","operation":"update","segment":"'"$PAYLOAD"'","hash":"-1433874632","timestamp":1553128845},"meta":[{"resultTopic":"test-3.segment-delegator.result","styleGuideMeta":{"category":"TESTING","enabled":1,"value":"'"$META"'","displayName":"Gender","additionalField1":"Masculine","additionalField2":"Feminine"}}],"issues":[]}]' "$URL"
}

test_gender ()
{
    local PAYLOAD=$1
    local URL=${2:-localhost:5000}
    curl -X POST -d '[{"requestId":30629,"category":"formality","content":{"segmentId":"segmentCreationInput2","organizationId":1,"workspaceId":3051,"personaId":301,"languageCode":"en-us","userId":1,"documentId":"429659","operation":"update","segment":"'"$PAYLOAD"'","hash":"-1433874632","timestamp":1553128845},"meta":[{"resultTopic":"test-3.segment-delegator.result","styleGuideMeta":{"category":"gender","enabled":1,"value":"5","displayName":"Gender","additionalField1":"Masculine","additionalField2":"Feminine","subGroup":[{"category":"gender-inclusive-language","enabled":1,"displayName":"Prefer gender-inclusive language"},{"category":"implicit-masculine","enabled":1,"displayName":"Flag Implicit masculine"},{"category":"implicit-feminine","enabled":1,"displayName":"Flag Implicit feminine"},{"category":"explicit-masculine","enabled":1,"displayName":"Flag Explicit masculine"},{"category":"explicit-feminine","enabled":1,"displayName":"Flag Explicit feminine"}]}}],"issues":[]}]' "$URL"
}

french_test_qai ()
{
    local PAYLOAD=$1;
    curl -X POST -d '[{"requestId":30629,"category":"gender","content":{"segmentId":"segmentCreationInput2","organizationId":1,"workspaceId":3051,"personaId":301,"languageCode":"fr-fr","userId":1,"documentId":"429659","operation":"update","segment":"'"$PAYLOAD"'","hash":"-1433874632","timestamp":1553128845},"meta":[{"resultTopic":"test-3.segment-delegator.result","styleGuideMeta":{"category":"gender","enabled":1,"value":"5","displayName":"Gender","additionalField1":"Masculine","additionalField2":"Feminine"}}],"issues":[]}, {"requestId":30629,"category":"gender","content":{"segmentId":"segmentCreationInput2","organizationId":1,"workspaceId":3051,"personaId":301,"languageCode":"en-us","userId":1,"documentId":"429659","operation":"update","segment":"'"$PAYLOAD"'","hash":"-1433874632","timestamp":1553128845},"meta":[{"resultTopic":"test-3.segment-delegator.result","styleGuideMeta":{"category":"gender","enabled":1,"value":"5","displayName":"Gender","additionalField1":"Masculine","additionalField2":"Feminine"}}],"issues":[]}]' localhost:5000
}

efllex ()
{
	PAYLOAD=$1
	curl 'http://cental.uclouvain.be/cefrlex/efllex/common/php/search_lexicon.php' -H 'Cookie: SESSc66188e710cfb3ceec6b8ace4312246f=ubITBT5JgdpG9URT_nAm7pbvAAugIk6KS3EjGiXYEbk' -H 'Origin: http://cental.uclouvain.be' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.9' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.157 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Accept: application/json, text/javascript, */*; q=0.01' -H 'Referer: http://cental.uclouvain.be/cefrlex/efllex/' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'DNT: 1' --data 'lang=en&query1='"$PAYLOAD"'&query2=&db1=efllex&db2=efllex' --compressed --silent
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

del_pods_by_appname ()
{
    if [ $# -eq 1 ]; then
        kl delete pods -l app="$1"
    else
        echo "usage: del_pods_by_appname APP_NAME"
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

