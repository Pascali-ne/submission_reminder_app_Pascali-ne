#!/bin/bash

# Get the correct path to config.env
config_path="submission_reminder_Pascaline/config/config.env"

if [ ! -f "$config_path" ]; then
    echo "Error: Could not find config file at $config_path"
    echo "Please make sure:"
    echo "1. You've run create_environment.sh"
    echo "2. You're in the parent directory of submission_reminder_Pascaline"
    exit 1
fi

read -p "Enter new assignment name: " new_assignment
sed -i "s/^ASSIGNMENT=.*/ASSIGNMENT=\"$new_assignment\"/" "$config_path"

echo "Assignment updated to $new_assignment"
echo "Restarting application..."
cd "submission_reminder_Pascaline" && ./startup.sh
