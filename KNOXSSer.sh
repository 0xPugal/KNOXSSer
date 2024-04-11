#!/bin/bash

CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

print_banner() {
    echo -e "${RED}                                                                                                                            ${NC}"
    echo -e "${RED}  ██ ▄█▀ ███▄    █  ▒█████  ▒██   ██▒  ██████   ██████ ▓█████  ██▀███    ${NC}"
    echo -e "${RED}  ██▄█▒  ██ ▀█   █ ▒██▒  ██▒▒▒ █ █ ▒░▒██    ▒ ▒██    ▒ ▓█   ▀ ▓██ ▒ ██▒  ${NC}"
    echo -e "${RED} ▓███▄░ ▓██  ▀█ ██▒▒██░  ██▒░░  █   ░░ ▓██▄   ░ ▓██▄   ▒███   ▓██ ░▄█ ▒  ${NC}"
    echo -e "${RED} ▓██ █▄ ▓██▒  ▐▌██▒▒██   ██░ ░ █ █ ▒   ▒   ██▒  ▒   ██▒▒▓█  ▄ ▒██▀▀█▄    ${NC}"
    echo -e "${RED} ▒██▒ █▄▒██░   ▓██░░ ████▓▒░▒██▒ ▒██▒▒██████▒▒▒██████▒▒░▒████▒░██▓ ▒██▒  ${NC}"
    echo -e "${RED} ▒ ▒▒ ▓▒░ ▒░   ▒ ▒ ░ ▒░▒░▒░ ▒▒ ░ ░▓ ░▒ ▒▓▒ ▒ ░▒ ▒▓▒ ▒ ░░░ ▒░ ░░ ▒▓ ░▒▓░  ${NC}"
    echo -e "${RED} ░ ░▒ ▒░░ ░░   ░ ▒░  ░ ▒ ▒░ ░░   ░▒ ░░ ░▒  ░ ░░ ░▒  ░ ░ ░ ░  ░  ░▒ ░ ▒░  ${NC}"
    echo -e "${RED} ░ ░░ ░    ░   ░ ░ ░ ░ ░ ▒   ░    ░  ░  ░  ░  ░  ░  ░     ░     ░░   ░   ${NC}"
    echo -e "${RED} ░  ░            ░     ░ ░   ░    ░        ░        ░     ░  ░   ░       ${NC}"
    echo -e "${RED}     Mass XSS Scanning for profit using KNOXSS API  - 0xPugal        ${NC}"
    echo -e ""
}

if [[ $# -eq 0 ]]; then
    print_banner
    exit 0
fi

# Default values
input_file=""
output_file="xss.txt"
api_key="API KEY"

usage() {
    echo "Usage: $0 [OPTIONS]"
    print_banner
    echo "Options:"
    echo "  -i, --input     Input file containing URLs to scan"
    echo "  -o, --output    Output file to save XSS results (default: xss.txt)"
    echo "  -A, --api       API key for Knoxss"
    echo "  -h, --help      Display this help message"
    exit 1
}

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -i|--input)
            input_file="$2"
            shift
            shift
            ;;
        -o|--output)
            output_file="$2"
            shift
            shift
            ;;
        -A|--api)
            api_key="$2"
            shift
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Error: Unknown option: $1"
            usage
            ;;
    esac
done

if [[ -z "$input_file" ]]; then
    echo "Error: Input file not specified"
    usage
fi

sed -i 's/&/%26/g' "$input_file"

handle_ctrl_c() {
    echo -e "\nCtrl-C detected. Saving remaining URLs to $todo_file..."
    sed -n "${lineno},\$p" "$input_file" > "$todo_file"
    echo "Remaining URLs saved to $todo_file"
    echo "Total API calls made: $api_calls"
    exit 1
}

trap handle_ctrl_c INT

lineno=1
api_calls=0
todo_file="${input_file%.*}-$(date +'%Y%m%d%H%M%S').todo"

print_banner
while read line; do
    echo -e "${CYAN}Scanning $line...${NC}"

    response=$(curl https://api.knoxss.pro -d target="$line" -H "X-API-KEY: $api_key" -s)
    api_calls=$((api_calls + 1))
    xss=$(jq -r '.XSS' <<< "$response")
    poc=$(jq -r '.PoC' <<< "$response")
    error=$(jq -r '.Error' <<< "$response")
    api_call=$(jq -r '.["API Call"]' <<< "$response")

    if [[ "$xss" == "true" ]]; then
        echo -e "${GREEN}XSS found - $poc ${NC} [API call: $api_call]"
    elif [[ "$xss" == "false" ]]; then
        echo -e "${RED}No XSS found - $line${NC} [API call: $api_call]"
    elif [[ "$error" == "KNOXSS can't test it (forbidden)" ]]; then
        echo -e "${RED}Forbidden - $line ${NC} [API call: $api_call]"
    else
        echo -e "${RED}KNOXSS error - $line ${NC} [API call: $api_call]"
    fi
                echo "$response" >> "$output_file"
                lineno=$((lineno + 1))
done < "$input_file"

echo "Total API calls made: $api_calls"
