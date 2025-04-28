#!/bin/bash

# Check for minimum arguments
if [ $# -lt 2 ]; then
    if [ $# -eq 1 ] && [[ $1 == -* ]]; then
        echo "Error: Missing search string and file"
    elif [ $# -eq 1 ]; then
        echo "Error: Missing file argument"
    else
        echo "Usage: $0 [options] <search_string> <file>"
        echo "Options:"
        echo "  -n    Show line numbers"
        echo "  -v    Invert match"
    fi
    exit 1
fi

# Initialize options
show_line_numbers=0
invert_match=0
search_string=""
file=""

# Parse options
while [[ $1 == -* ]]; do
    case "$1" in
        -n) 
            show_line_numbers=1
            ;;
        -v) 
            invert_match=1
            ;;
        -vn|-nv)
            show_line_numbers=1
            invert_match=1
            ;;
        *)
            echo "Error: Unknown option $1"
            exit 1
            ;;
    esac
    shift
done

# Check if search string is provided
if [ $# -lt 2 ]; then
    echo "Error: Missing search string or file"
    echo "Usage: $0 [options] <search_string> <file>"
    exit 1
fi

search_string="$1"
file="$2"

# Check if file exists
if [ ! -f "$file" ]; then
    echo "Error: File '$file' not found"
    exit 1
fi

# Perform the search (CASE-INSENSITIVE NOW)
line_number=0
while IFS= read -r line; do
    line_number=$((line_number + 1))
    # Convert both line and search string to lowercase for case-insensitive match
    if [[ "${line,,}" =~ ${search_string,,} ]]; then
        match=1
    else
        match=0
    fi
    
    # Handle invert match
    if [ $invert_match -eq 1 ]; then
        if [ $match -eq 0 ]; then
            if [ $show_line_numbers -eq 1 ]; then
                echo "$line_number:$line"
            else
                echo "$line"
            fi
        fi
    else
        if [ $match -eq 1 ]; then
            if [ $show_line_numbers -eq 1 ]; then
                echo "$line_number:$line"
            else
                echo "$line"
            fi
        fi
    fi
done < "$file"
