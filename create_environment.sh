#!/bin/bash

# Prompt for user's name
read -p "Enter your name: " username
main_dir="submission_reminder_${username}"

# Create directory structure
mkdir -p "$main_dir"/{config,assets,modules}

# Create config.env
cat > "$main_dir/config/config.env" << 'EOL'
# Configuration for Submission Reminder App
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=3
EOL

# Create submissions.txt
cat > "$main_dir/assets/submissions.txt" << 'EOL'
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Michael, Shell Navigation, submitted
Sarah, Git, not submitted
David, Shell Basics, submitted
Emily, Shell Navigation, not submitted
Robert, Git, submitted
Jessica, Shell Navigation, not submitted
EOL

# Create functions.sh
cat > "$main_dir/modules/functions.sh" << 'EOL'
#!/bin/bash

function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    while IFS=, read -r student assignment status; do
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file")
}
EOL

# Create reminder.sh
cat > "$main_dir/reminder.sh" << 'EOL'
#!/bin/bash

source ./config/config.env
source ./modules/functions.sh

submissions_file="./assets/submissions.txt"

echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOL

# Create startup.sh
cat > "$main_dir/startup.sh" << 'EOL'
#!/bin/bash

if [ ! -f "config/config.env" ]; then
    echo "Error: Missing config file!"
    exit 1
fi

chmod +x *.sh
chmod +x modules/*.sh

echo "Starting Submission Reminder App..."
echo ""
./reminder.sh
echo ""
echo "App execution completed."
EOL

# Set permissions
chmod +x "$main_dir"/*.sh
chmod +x "$main_dir"/modules/*.sh

echo "Setup complete! Run: cd $main_dir && ./startup.sh"
