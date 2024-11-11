#!/bin/bash

# Set default value of days to 7 if no argument is passed
days=${1:-7}

# Function to display the changelog
function display_changelog {
    echo "Displaying changelog for the last $days days"
    git log --since="$days days ago" --pretty=format:"%h %ad | %s%d [%an]" --date=short --color
}

# Call the function to display the changelog
display_changelog

