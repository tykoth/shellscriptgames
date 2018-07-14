#!/bin/bash

# No the position and stuff

xaxis=10
yaxis=10
mapwidth=30
mapheight=15
clear
while read -rsn1 ui; do
    cols=$(tput cols)
    lines=$(tput lines)
    
    case "$ui" in
    $'\x1b')    # Handle ESC sequence.

        read -rsn1 -t 0.01 tmp
        if [[ "$tmp" == "[" ]]; then
            read -rsn1 -t 0.01 tmp
            case "$tmp" in
            "A") 
		(( yaxis-- ))
		;;
            "B") 
		(( yaxis++ ))
		;;
            "C") 
		(( xaxis++ ))
		;;
            "D") 
		(( xaxis-- ))
		;;
            esac
        fi
        # Flush "stdin" with 0.1  sec timeout.
        read -rsn5 -t 0.01
	msg=""
	if [[ $yaxis -lt 1 ]]; then
		yaxis=1
		msg=" < ouch! > "
	fi

        lines=$(( lines-1 ))
	if [[ $yaxis -gt $lines ]]; then
		yaxis=$lines
		msg=" < ouch! > "
	fi
        ybound=$((mapheight+2))
	if [[ $yaxis -gt $ybound ]]; then
		yaxis=$ybound
		msg=" < ouch! > "
	fi

	if [[ $xaxis -lt 1 ]]; then
		xaxis=1
		msg=" < ouch! > "
	fi

        cols=$(( cols-1 ))
	if [[ $xaxis -gt $cols ]]; then
		xaxis=$cols
		msg=" < ouch! > "
	fi

        xbound=$((mapwidth+1))
	if [[ $xaxis -gt $xbound ]]; then
		xaxis=$xbound
		msg=" < ouch! > "
	fi


    # printmap
        mapstring=" "
        # print top walls
        for x in $(seq 0 $mapwidth)
        do 
            mapstring="${mapstring}_"
        done

#        # print maps
        for x in $(seq 0 $mapheight) ; do 
            mapstring="${mapstring}\n|"
            for x in $(seq 0 $mapwidth); do mapstring="${mapstring} "; done;
            mapstring="${mapstring}|"
        done;
#
        # print bottom walls
        mapstring="${mapstring}\n|"; 
        for x in $(seq 0 $mapwidth); do mapstring="${mapstring}_"; done;
        mapstring="${mapstring}|"; 
#        tput cup 0, 1
        
    # /printmap


	tput clear
        printf "$mapstring"
        echo -ne "\n\n\n"
        echo -ne "\nposition(x,y) =  $xaxis, $yaxis"
        echo -ne "\nmessage = $msg"
	tput cup $yaxis $xaxis
	if [[ "$msg" != "" ]]; then
		printf " $msg"
                tput cup $yaxis $xaxis
	fi
        ;;
    # Other one byte (char) cases. Here only quit.
    q) break;;
    esac
done

