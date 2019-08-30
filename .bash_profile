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

##############################
# Fancy git bash integration #
##############################

YELLOW="\[$(tput setaf 3)\]"
BLUE="\[$(tput setaf 4)\]"
TEAL="\[$(tput setaf 6)\]"
RESET="\[$(tput sgr0)\]"

if [ -f ~/.git-prompt.sh ]; then
  source ~/.git-prompt.sh
  export PS1='Geoff[\W]$(__git_ps1 "(%s)"): '
fi

test -f ~/.git-completion.bash && . $_

source /usr/local/etc/bash_completion.d/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=true
export PS1="\h:\W \u@mbp\$(__git_ps1 \" ${TEAL}(%s)${RESET} \")\$ "

## End fancy git bash

# Don't use raw kubectl command
alias kudv4="kubectl --context=gke_qordoba-devel_us-central1_dev4"
alias kuts4="kubectl --context=gke_qordoba-test_us-central1_test4"
alias kupr3="kubectl --context=gke_qordoba-prod_us-central1-c_prod-3"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias mkenv="/usr/local/bin/python3 -m virtualenv venv"
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

replace_config ()
{
    local PROJECT=$1
    local SERVICE=$2

    declare -A project2command=( ["dev4"]="kudv4" ["test4"]="kuts4" )
    # declare -A project2command=( ["dev4"]="/usr/local/bin/kubectl --context=gke_qordoba-devel_us-central1_dev4" ["test4"]="/usr/local/bin/kubectl --context=gke_qordoba-test_us-central1_test4" )

    local COMMAND="${project2command[$PROJECT]}"

    $("${COMMAND}" create configmap "${SERVICE}"-config --from-file /Users/sh/q/repos/qordoba.k8s/"${PROJECT}"/"${SERVICE}"/configmaps/ -o yaml --dry-run | "${COMMAND}" replace -f -)
}



[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

alias jn="jupyter notebook"


# Created by `userpath` on 2019-08-26 21:47:33
export PATH="$PATH:/Users/sh/.local/bin"

mkalias ()
{
if [[ $1 == *"="* ]]; then
    local OIFS=$IFS
    IFS="="
    read -r NAME CMD <<< "$1"
    IFS=$OIFS
    echo "alias $NAME=\"$CMD\"" >> ~/.bash_profile
    # shellcheck disable=SC1091
    source /Users/sh/.bash_profile
else
    echo "syntax is mkalias name=command"
fi
}
alias ppjson_clip="pbpaste | jq . | pbcopy"
