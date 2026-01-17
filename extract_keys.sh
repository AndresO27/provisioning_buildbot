#!/bin/bash

# Function to extract the ECDSA key from a given node
extract_key() {
    local NODE="$1"
    ssh "$NODE" 'cat /etc/ssh/ssh_host_ecdsa_key' > "${PROVISIONING}${NODE}/ssh_host_ecdsa_key"
    ssh "$NODE" 'cat /etc/ssh/ssh_host_ecdsa_key.pub' > "${PROVISIONING}${NODE}/ssh_host_ecdsa_key.pub"
    ssh "$NODE" 'cat /etc/ssh/ssh_host_ed25519_key' > "${PROVISIONING}${NODE}/ssh_host_ed25519_key"
    ssh "$NODE" 'cat /etc/ssh/ssh_host_ed25519_key.pub' > "${PROVISIONING}${NODE}/ssh_host_ed25519_key.pub"
    ssh "$NODE" 'cat /etc/ssh/ssh_host_rsa_key' > "${PROVISIONING}${NODE}/ssh_host_rsa_key"
    ssh "$NODE" 'cat /etc/ssh/ssh_host_rsa_key.pub' > "${PROVISIONING}${NODE}/ssh_host_rsa_key.pub"
    if [ $? -eq 0 ]; then
        echo "The keys extracted successfully from $NODE and saved to ${PROVISIONING}${NODE}"
    else
        echo "Failed to extract keys from $NODE."
    fi
}

for i in $(seq -w 1 28); do
    extract_key "l$i"
    echo "copied"
done
