if status is-interactive
    # Commands to run in interactive sessions can go here
end
#create temp if its not here

if not test -d temp
    mkdir temp
end


set -g fish_read_limit 0
set -g FISHHOMEDIR (dirname (status --current-filename))
set -g FISHTEMPDIR $FISHHOMEDIR/temp

set -g FISHSCRIPTDIR $FISHHOMEDIR/helperscripts

function vz
    command nvim (locate / | fzf )
end

function htz
    command firefox (locate / | grep "\.html\$" | fzf)
end

function hx
    set rhv (history | fzf | string split -n " ")
    eval $rhv[1..]
end

function saveAllDb
    rm -f alldb.txt
    locate / >>alldb.txt
    for i in (cat alldb.txt)
        echo $i ----
    end
end

# zoxide init --cmd cd fish | source
source "$HOME/.cargo/env.fish"
alias sof 'source ~/.config/fish/config.fish'
alias fcd 'cd ~/.config/fish/'
function fnw
    rm -f $FISHTEMPDIR/outpt.txt
    touch $FISHTEMPDIR/outpt.txt
    set rhv = (locate / | grep  $argv[1])
    grep --binary-files=text -IsHn $argv[2] $rhv >>$FISHTEMPDIR/outpt.txt &
    set sfields (cat $FISHTEMPDIR/outpt.txt | fzf | string split -m2 ':')
    nvim +$sfields[2] $sfields[1]
end

function fndir
    rm -f $FISHTEMPDIR/outdirs.txt
    touch $FISHTEMPDIR/outdirs.txt
    locate / >>$FISHTEMPDIR/indirs.txt
    python3 $FISHSCRIPTDIR/extractDirs.py $FISHTEMPDIR/indirs.txt $FISHTEMPDIR/outdirs.txt
    cd (cat $FISHTEMPDIR/outdirs.txt | fzf)
end

function fndc
    cd (cat $FISHTEMPDIR/outdirs.txt | fzf)
end

function rels
    set sfields (cat $FISHTEMPDIR/outpt.txt | fzf | string split -m2 ':')
    nvim +$sfields[2] $sfields[1]
end

function edf
    nvim ~/.config/fish/config.fish
end

function edfd
    nvim (find $argv[1]  -type f | fzf)
end

function tx
    if test (count $argv) -lt 1
        echo "Error: No filename provided" >&2
        return 1
    end

    if test -f $argv[1]
        echo "File exists will not overwrite."
        return 1
    end

    if test (uname) = Darwin
        pbpaste
    else if test (uname) = Linux
        if test -n "$WAYLAND_DISPLAY" -o -n "$XDG_SESSION_TYPE" -a "$XDG_SESSION_TYPE" = wayland
            wl-paste >>$argv[1]
        else
            touch $argv[1]
            xclip -selection clipboard -o >>$argv[1]
        end
    end
end

function fcmds
    echo "sof source fish"
    echo "rels : fzf outpt.txt"
    echo "fnw [partial filename] [pattern] : create outpt.txt ,fzf, and edit with editor"
    echo "vz : locate and edit"
    echo "hx : fzf history"
    echo "edf : edit config.fish"
    echo "fndir : locate and cd to directory"
    echo "fndc : cd to directory from outdirs.txt"
    echo "htz : locate and open html file"

end
echo "Following directories are set :"
echo $FISHTEMPDIR $FISHHOMEDIR $FISHSCRIPTDIR
echo "fcmds for list of options"

zoxide init fish | source
