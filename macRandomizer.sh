#!/bin/bash
# macRandomizer
# by github.com/n0nexist

# Check if the first argument is not present
if [ $# -lt 1 ]; then
  echo "Usage: $0 <interface>"
  exit 1
fi

echo "Changing mac address on interface: $1"

# Function to generate a random hexadecimal digit
function random_hex_digit() {
  echo -n "$(echo $((RANDOM % 16)) | xxd -p)"
}

# Function to generate a random MAC address
function generate_mac_address() {
  # The first byte should be even, so we ensure that by clearing the least significant bit
  first_byte="$(printf "%02X" $((0x$(random_hex_digit) & 0xFE)))"
  mac_address="$first_byte"

  # Generate the remaining 5 bytes
  for i in {1..5}; do
    mac_address+=":$(random_hex_digit)$(random_hex_digit)"
  done

  echo "$mac_address"
}

# Generate and print a random MAC address
mac_address=$(generate_mac_address)

# Sets the new address
sudo ifconfig $1 down
sudo ifconfig $1 hw ether $mac_address
sudo ifconfig $1 up

# Shows the new address
ifconfig $1 | grep ether

echo "You are now anonymous in your lan ;)"
