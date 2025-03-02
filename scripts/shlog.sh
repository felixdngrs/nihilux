#!/bin/bash

RESET='\033[0m'    
RED='\033[31m'     
GREEN='\033[32m'   
YELLOW='\033[33m'  
BLUE='\033[34m'   
CYAN='\033[36m'    

shlog() {
    local level=$1
    shift
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    local message="$@"
    local file=${BASH_SOURCE[1]}
    case "$level" in
        INFO)  echo -e "${CYAN}[INFO]  [$timestamp][$file] $message${RESET}" ;;
        WARN)  echo -e "${YELLOW}[WARN]  [$timestamp][$file] $message${RESET}" ;;
        ERROR) echo -e "${RED}[ERROR] [$timestamp][$file] $message${RESET}" ;;
        DEBUG) echo -e "${BLUE}[DEBUG] [$timestamp][$file] $message${RESET}" ;;
        SUCCESS) echo -e "${GREEN}[SUCCESS] [$timestamp][$file] $message${RESET}" ;;
        *)     echo -e "[UNKNOWN] [$timestamp][$file] $message" ;;
    esac
}
