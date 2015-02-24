#!/bin/bash
set -e

# Expected environment variables:
#   MON_IP - (IP address of the monitor)
#   MON_NAME - (name of the monitor)

if [ ! -n "$MON_NAME" ]; then
    echo "ERROR- MON_NAME must be defined as the name of the monitor"
    exit 1
fi

if [ ! -n "$MON_IP" ]; then
    echo "ERROR- MON_IP must be defined as the IP address of the monitor"
    exit 1
fi

if [ ! -e /etc/ceph/ceph.conf ]; then
    echo "ERROR- ceph.conf is required"
    exit 2
fi

# If we don't have a monitor keyring, this is a new monitor
if [ ! -e /var/lib/ceph/mon/ceph-${MON_NAME}/keyring ]; then

    if [ ! -e /etc/ceph/ceph.client.admin.keyring ]; then 
        echo "ERROR- etc/ceph/ceph.client.admin.keyring must exist; get it from your existing mon"
        exit 3
    fi

    if [ ! -e /etc/ceph/ceph.mon.keyring ]; then 
        echo "ERROR- /etc/ceph/ceph.mon.keyring must exist. You can extract it from your current monitor by running 'ceph auth get mon. -o /tmp/ceph.mon.keyring'"
        exit 4
    fi

    if [ ! -e /etc/ceph/monmap ]; then
        echo "ERROR- /etc/ceph/monmap must exist.  You can extract it from your current monitor by running 'ceph mon getmap -o /tmp/monmap'"
        exit 5
    fi

    # Import the client.admin keyring and the monitor keyring into a new, temporary one
    ceph-authtool /tmp/ceph.mon.keyring --create-keyring --import-keyring /etc/ceph/ceph.client.admin.keyring
    ceph-authtool /tmp/ceph.mon.keyring --import-keyring /etc/ceph/ceph.mon.keyring

    # Make the monitor directory
    mkdir -p /var/lib/ceph/mon/ceph-${MON_NAME}

    # Prepare the monitor daemon's directory with the map and keyring
    ceph-mon --mkfs -i ${MON_NAME} --monmap /etc/ceph/monmap --keyring /tmp/ceph.mon.keyring

    # Clean up the temporary key
    rm /tmp/ceph.mon.keyring
fi

exec /usr/bin/ceph-mon -d -i ${MON_NAME} --public-addr ${MON_IP}:6789
