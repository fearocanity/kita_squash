#!/bin/bash
# This program, I'm lazy to explain, Just read it. lol

days_num="365"
days_left="$(<./days.txt)" || true

if [[ ! -e ./days.txt ]] || [[ "${days_left}" == 0 ]]; then
    echo "${days_num}" > ./days.txt
fi

post_fp(){
    local TEMP_imgin="${1}"
    curl -sfLX POST \
        --retry 2 --retry-connrefused --retry-delay 7 \
        "https://graph.facebook.com/me/photos?access_token=${fb_token}&published=1" \
        -F "message=${2}" \
        -F "source=@${TEMP_imgin}"
}

fb_token="${1}"
image_height="$(identify -format "%h" "kita.png")"
comp_1="$(printf "%.0f" "$(bc -l <<< "((${image_height} - 10) / ${days_num}) * ${days_left}")")"

identify -list resource
convert kita.png -resize "x${comp_1}!" kita_sqw.png
message_post="$(cat <<-EOF
${days_left} days until this kita is squashed.
EOF
)"
echo "$((days_left-1))" > ./days.txt
post_fp "kita_sqw.png" "${message_post}" || exit 0
