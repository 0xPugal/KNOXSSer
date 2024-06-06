# KNOXSSer v1.4

**An powerful bash script for massive XSS scanning leveraging Brute Logic's KNOXSS API**

[![made-with-bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)](https://www.gnu.org/software/bash/) [![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/0xPugal/KNOXSSer/graphs/commit-activity) [![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/) [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com) [![Latest release](https://badgen.net/github/release/0xPugal/KNOXSSer?sort=semver&label=version)](https://github.com/0xPugal/KNOXSSer/releases) [![Open Source Love svg1](https://badges.frapsoft.com/os/v1/open-source.svg?v=103)](https://github.com/0xPugal/KNOXSSer)

<img src=KNOXSSer.png>

## Installation
```
curl -sSL https://raw.githubusercontent.com/0xPugal/KNOXSSer/master/knoxsser -o knoxsser && chmod +x knoxsser && sudo mv knoxsser /usr/bin/
```

## Prerequisites
> jq and parallel must be installed in your system to run this tool
``sudo apt install -y jq && sudo apt install -y parallel``

> Configure your knoxss api keyin [line 30 of knoxsser](https://github.com/0xPugal/KNOXSSer/blob/master/knoxsser#L30) or pass the API key with ``-A`` argument.


> [Notify](https://github.com/projectdiscovery/notify) must be installed on your system, to send notifications on sucessful xss.(optional)


## Help
```
Options:
  -i, --input     Input file containing URLs or single URL to scan
  -o, --output    Output file to save XSS results (default: xss.txt)
  -A, --api       API key for Knoxss
  -s, --silent    Print only results without displaying the banner and target count
  -n, --notify    Send notifications on successful XSSes via notify
  -p, --process   Number of URLs to scan parallely(1-5) (default: 1)
  -v, --version   Display the version and exit
  -V, --verbose   Enable verbose output
  -h, --help      Display this help message and exit
```

## Features
   - Enables scanning of both single URLs and files containing multiple URLs
   - Unscanned URLs are saved in a `<input>+date-time.todo` file, providing a record of URLs not successfully scanned along with a timestamp.
   - URLs that encountered errors during scanning, possibly due to issues with the KNOXSS API, are saved in a `<input>.errors.todo` file. 
   - Successful XSS results are saved by default in `xss.txt`, with their full JSON responses.
   - Prints the API calls number along with the scanning process.
   - Send notifications on successful XSSes through notify
   - Parallel scans options for faster scan completion
   - Verbose option functionality for printing response from knoxss api in the terminal

## Usage
```
# All in one
  knoxsser -i input.txt -p 3 -n -V -o knoxss.txt

# Single URL scan
  knoxsser --input https://brutelogic.com.br/xss.php?a=1

# Scan a list of URLs
  knoxsser --input urls.txt

# Send the notification on successful xss through notify
  knoxsser --input input.txt --notify

# Verbose option functionality
  knoxsser --input input.txt --verbose

# Parallel scan process
  knoxsser --input input.txt --process 3
```

## ToDo
+ Allow knoxsser to read input from stdin

## Credits
+ An amazing [KNOXSS](https://knoxss.me/) API by Brute Logic.
+ This script was inspired from the [knoxnl](https://github.com/xnl-h4ck3r/knoxnl) tool created by [xnl_h4ck3r](https://twitter.com/xnl_h4ck3r).
+ Notification on successful XSS via [Project Discovery](https://github.com/projectdiscovery)'s [Notify](https://github.com/projectdiscovery/notify).

> [!CAUTION]
> ⚠️ Disclaimer: I am not responsible for any use, and especially misuse, of this tool or the KNOXSS API
