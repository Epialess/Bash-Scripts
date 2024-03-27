#!/bin/bash

# This script takes the files in your home directory and changes their owner 
# from your username to the reverse of your username

current_user=$(whoami)

# Reverse the username
reversed_user=$(echo "$current_user" | rev)

# Check if reversed_user exists
if id "$reversed_user" &>/dev/null; then
    # Iterate over the files in the user's home directory and change their ownership
    for file in /home/"$current_user"/*; do
        # Change ownership
        sudo chown "$reversed_user":"$reversed_user" "$file"
    done
    echo "Ownership of files in /home/$current_user has been changed to $reversed_user."
else
    echo "User $reversed_user does not exist."
fi
