#echo $1
if [[ "$1" == "xterm" ]]; 
then
    xterm
elif [[ "$1" == "vlc" ]];
then
    #xterm -name vlc -title 'vlc' -e 'vlc' &
    vlc
else
    ssh $1 -t -- /bin/sh -c 'tmux has-session && exec tmux attach || exec tmux'
fi
