#!/usr/bin/env bash

tput civis
clear

# --- CLEAN EXIT ---
cleanup() {
    tput cnorm
    stty sane
    clear
    exit
}

trap cleanup SIGINT SIGTERM EXIT

# --- INPUT HANDLING ---
mode="clock"
duration=0

case "$1" in
    --timer)
        mode="timer"
        duration=$(( $2 * 60 ))
        ;;
    --timers)
        mode="timer"
        duration=$2
        ;;
    --watch)
        mode="watch"
        ;;
    --pomo)
        mode="pomo"
        ;;
esac

# --- SOUND ---
play_sound() {
    if command -v paplay >/dev/null 2>&1; then
        paplay /usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga \
            2>/dev/null &
    elif command -v aplay >/dev/null 2>&1; then
        aplay /usr/share/sounds/alsa/Front_Left.wav \
            2>/dev/null &
    else
        printf "\a"
    fi
}

# --- DIGITS ---
declare -A DIGITS

DIGITS[0]=$'
 0000000 
00     00
00     00
00     00
00     00
00     00
 0000000 
 '

DIGITS[1]=$'
   111   
  1111   
    11   
    11   
    11   
    11   
  111111 
  '

DIGITS[2]=$'
 2222222 
22     22
      22 
 222222  
22       
22       
22222222 
'

DIGITS[3]=$'
 3333333 
33     33
      33 
  333333 
      33 
33     33
 3333333 
 '

DIGITS[4]=$'
44    44 
44    44 
44    44 
44444444 
      44 
      44 
      44 
     '

DIGITS[5]=$'
55555555 
55       
55       
5555555  
      55 
55     55
 5555555 
 '

DIGITS[6]=$'
 6666666 
66       
66       
6666666  
66     66
66     66
 6666666 
 '

DIGITS[7]=$'
77777777 
     77  
    77   
   77    
  77     
 77      
77       
'

DIGITS[8]=$'
 8888888 
88     88
88     88
 8888888 
88     88
88     88
 8888888 
 '

DIGITS[9]=$'
 999999  
99    99 
99    99 
 9999999 
      99 
      99 
 9999999 
 '

DIGITS[:]=$'
 ::
 ::
   
 ::
 ::
   
 ::
   '

# --- RENDER FUNCTION ---
render_time() {
    local time="$1"
    local -n out_array=$2

    out_array=()

    local height=$(($(printf "%s" "${DIGITS[0]}" | wc -l) - 0))

    for ((i=0; i<height; i++)); do
        line=""

        for ((j=0; j<${#time}; j++)); do
            char="${time:j:1}"
            digit="${DIGITS[$char]}"
            digit_line=$(echo "$digit" | sed -n "$((i+1))p")
            line+="$digit_line  "
        done

        out_array+=("$line")
    done
}

# --- TIME HELPERS ---
format_time() {
    local total=$1

    printf "%02d:%02d:%02d" \
        $((total / 3600)) \
        $(((total % 3600) / 60)) \
        $((total % 60))
}

# --- STATE ---
start_time=$(date +%s)
prev_time=""
quote="Hello :)"

# Pomodoro state
pomo_phase="work"
pomo_counter=0
pomo_start=$(date +%s)
pomo_duration=$((25 * 60))

# --- TERMINAL INPUT MODE ---
stty -echo -icanon time 0 min 0

# --- MAIN LOOP ---
while true; do

    # --- NON-BLOCKING KEY INPUT ---
    key=$(dd bs=1 count=1 2>/dev/null)

    if [[ "$key" == "q" ]]; then
        cleanup
    fi

    now=$(date +%s)

    case "$mode" in

        clock)
            time=$(date +"%H:%M:%S")
            quote="Hello :)"
            ;;

        watch)
            elapsed=$((now - start_time))
            time=$(format_time "$elapsed")
            quote="Stopwatch"
            ;;

        timer)
            remaining=$((duration - (now - start_time)))

            if ((remaining <= 0)); then
                remaining=0

                if [[ "$prev_time" != "00:00:00" ]]; then
                    play_sound
                fi
            fi

            time=$(format_time "$remaining")
            quote="Timer"
            ;;

        pomo)
            elapsed=$((now - pomo_start))

            if ((elapsed >= pomo_duration)); then

                play_sound

                if [[ "$pomo_phase" == "work" ]]; then

                    pomo_counter=$((pomo_counter + 1))
                    pomo_phase="break"

                    if ((pomo_counter % 3 == 0)); then
                        pomo_duration=$((15 * 60))
                    else
                        pomo_duration=$((5 * 60))
                    fi

                else
                    pomo_phase="work"
                    pomo_duration=$((25 * 60))
                fi

                pomo_start=$now
                elapsed=0
            fi

            remaining=$((pomo_duration - elapsed))
            time=$(format_time "$remaining")

            if [[ "$pomo_phase" == "work" ]]; then
                quote="Work"
            else
                quote="Break"
            fi
            ;;

    esac

    # --- ONLY REDRAW ON CHANGE ---
    if [[ "$time" != "$prev_time" ]]; then

        render_time "$time" lines

        rows=$(tput lines)
        cols=$(tput cols)

        height=${#lines[@]}
        width=$(printf "%s\n" "${lines[@]}" | wc -L)

        start_row=$(( (rows - height) / 2 ))
        start_col=$(( (cols - width) / 2 ))

        

        for i in "${!lines[@]}"; do
            tput cup $((start_row + i)) "$start_col"
            printf "%s" "${lines[$i]}"
        done

        tput cup $((start_row + i + 2)) \
            $(( (cols - ${#quote}) / 2 ))

        printf "%s" "$quote"

        prev_time="$time"
    fi

    sleep 0.2
done
