% function xbin() {
  command="$1"
  args="${@:2}"
  if [ -t 0 ]; then
    curl -X POST "https://xbin.io/${command}" -H "X-Args: ${args}"
  else
    curl --data-binary @- "https://xbin.io/${command}" -H "X-Args: ${args}"
  fi
}

function pyc {
  command find . -name "*.pyc" -exec rm -rf {} \;
}

proxy_port=7890

allproxy() {
  export https_proxy=http://127.0.0.1:$proxy_port http_proxy=http://127.0.0.1:$proxy_port all_proxy=socks5://127.0.0.1:$proxy_port
}

unproxy() {
  unset https_proxy http_proxy all_proxy
}

gt() {
  cd $HOME/wkspace/github/$1
}

_gt() {
  _arguments "1:filename:_files -W $HOME/wkspace/github"
}
compdef _gt gt

n() {
  $HOME/wkspace/logseq/scripts/sync.sh
}

up() {
  abrew update && abrew upgrade && pipx upgrade-all
}

serve() {
  python3 -m http.server "$@"
}

transfer() {
    # check arguments
    if [ $# -eq 0 ];
    then
        echo "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"
        return 1
    fi

    # get temporarily filename, output is written to this file show progress can be showed
    tmpfile=$( mktemp -t transferXXX )

    # upload stdin or file
    file=$1

    if tty -s;
    then
        basefile=$(basename "$file" | sed -e 's/[^a-zA-Z0-9._-]/-/g')

        if [ ! -e $file ];
        then
            echo "File $file doesn't exists."
            return 1
        fi

        if [ -d $file ];
        then
            # zip directory and transfer
            zipfile=$( mktemp -t transferXXX.zip )
            cd $(dirname $file) && zip -r -q - $(basename $file) >> $zipfile
            curl --progress-bar --upload-file "$zipfile" "https://transfer.sh/$basefile.zip" >> $tmpfile
            rm -f $zipfile
        else
            # transfer file
            curl --progress-bar --upload-file "$file" "https://transfer.sh/$basefile" >> $tmpfile
        fi
    else
        # transfer pipe
        curl --progress-bar --upload-file "-" "https://transfer.sh/$file" >> $tmpfile
    fi

    # cat output link
    cat $tmpfile

    # cleanup
    rm -f $tmpfile
}

fix_venv() {
    local venvPath=$1
    # get the absolute path of the python
    local python=$(which $2)

    if [ -z "$python" ]; then
        echo "Usage: fix_venv <python>"
        return 1
    fi
    set -e
    
    for bin in $(ls $venvPath/bin/python*); do
        local target=$(readlink $bin)
        # if target starts with '/'
        if [[ $target == /* ]]; then
            echo "Fixing $bin"
            ln -sf $python $bin
        fi
    done

    local venvConfig=$venvPath/pyvenv.cfg
    # replace the home = (...) with the python path
    gsed -i "s|home = .*|home = $python|" $venvConfig
    # Fix the version = (...) with the python version
    local version=$($python -c "import platform;print(platform.python_version())")
    gsed -i "s|version = .*|version = $version|" $venvConfig
    echo Successfully fixed the virtual environment $venvPath
}