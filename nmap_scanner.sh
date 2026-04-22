#!/bin/bash

# ============================================
#   Nmap Automation Scanner
#   Author: Faysal Amin
#   Description: Interactive Nmap scanner
#   with multiple scan types and output formats
# ============================================

echo "========================================"
echo "       Nmap Automation Scanner          "
echo "       By: Faysal Amin                  "
echo "========================================"
echo ""

# Take IP input
read -p "Enter Target IP: " ip

# Simple IP validation
if ! [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    echo "Invalid IP address!"
    exit 1
fi

echo ""

# Scan type menu
echo "Select Scan Type:"
echo "1) TCP Connect (-sT)"
echo "2) UDP Scan (-sU)"
echo "3) SYN Scan (-sS)"
echo "4) Xmas Scan (-sX)"
echo "5) Null Scan (-sN)"
echo ""

read -p "Enter choice (1-5): " scan_choice

case $scan_choice in
    1) scan="-sT" ;;
    2) scan="-sU" ;;
    3) scan="-sS" ;;
    4) scan="-sX" ;;
    5) scan="-sN" ;;
    *) echo "Invalid scan type"; exit 1 ;;
esac

echo ""

# Port range option
read -p "Enter port range (e.g. 1-1000 or press Enter for all ports): " ports
if [ -z "$ports" ]; then
    port_option=""
    echo "Scanning all ports..."
else
    port_option="-p $ports"
    echo "Scanning ports: $ports"
fi

echo ""

# OS detection option
read -p "Enable OS detection? (y/n): " os_detect
if [ "$os_detect" == "y" ]; then
    os_option="-O"
    echo "OS detection enabled."
else
    os_option=""
    echo "OS detection disabled."
fi

echo ""

# Ask for filename
read -p "Enter file name (without extension): " filename

# Remove spaces for safety
filename=$(echo "$filename" | tr -d ' ')

# Add timestamp to filename automatically
timestamp=$(date +%Y%m%d_%H%M%S)
filename="${filename}_${timestamp}"

echo ""

# Output format menu
echo "Select Output Format:"
echo "1) Normal (.txt)"
echo "2) XML (.xml)"
echo "3) Grepable (.csv)"
echo ""

read -p "Enter choice (1-3): " format_choice

case $format_choice in
    1) output="-oN ${filename}.txt" ; ext="txt" ;;
    2) output="-oX ${filename}.xml" ; ext="xml" ;;
    3) output="-oG ${filename}.csv" ; ext="csv" ;;
    *) echo "Invalid format"; exit 1 ;;
esac

# Verbosity
verbose="-v"

echo ""
echo "========================================"
echo " Scan Summary:"
echo "   Target IP   : $ip"
echo "   Scan Type   : $scan"
echo "   Port Range  : ${ports:-All Ports}"
echo "   OS Detect   : ${os_detect^^}"
echo "   Output File : ${filename}.${ext}"
echo "========================================"
echo ""

# Confirm before running
read -p "Start scan? (y/n): " confirm
if [ "$confirm" != "y" ]; then
    echo "Scan cancelled."
    exit 0
fi

echo ""
echo "Running scan on $ip..."
echo ""

# Run scan
nmap $scan $port_option $os_option $verbose $output $ip

echo ""
echo "========================================"
echo " Scan completed!"
echo " Results saved as: ${filename}.${ext}"
echo "========================================"
