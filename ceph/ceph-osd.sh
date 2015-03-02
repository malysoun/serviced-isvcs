# Code provided by https://github.com/ceph/ceph-docker
# Copyright (c) 2014 Seán C. McCord (MIT License)

#!/bin/bash
set -e

: ${CLUSTER:=ceph}
: ${POOL:=default}
: ${WEIGHT:=1.0}
: ${JOURNAL:=/var/lib/ceph/osd/${CLUSTER}-${OSD_ID}/journal}

if [ ! -n "$OSD_ID" ]; then
    echo "OSD_ID must be set; call 'ceph osd create' to allocate the next available osd id"
    exit 1
fi

# Make sure the osd directory exists
mkdir -p /var/lib/ceph/osd/${CLUSTER}-${OSD_ID}

# Mount the device (if it exists)
if `df /dev/ceph` ; then
    mount -t xfs /dev/ceph /var/lib/ceph/osd/${CLUSTER}-${OSD_ID}
fi

# Check to see if the OSD has been initialized
if [ ! -e /var/lib/ceph/osd/${CLUSTER}-${OSD_ID}/keyring ]; then
    # Create the OSD key and file structure
    ceph-osd -i $OSD_ID --mkfs --mkjournal --osd-journal ${JOURNAL}

    # Add OSD key to the authentication database
    if [ ! -e /etc/ceph/${CLUSTER}.client.admin.keyring ]; then
        echo "Cannot authenticate to Ceph monitor without /etc/ceph/${CLUSTER}.client.admin.keyring.  Retrieve this from /etc/ceph on a monitor node."
        exit 2
    fi
    ceph auth get-or-create osd.${OSD_ID} osd 'allow *' mon 'allow profile osd' -o /var/lib/ceph/osd/${CLUSTER}-${OSD_ID}/keyring

    # Add the OSD to the CRUSH map
    if [ ! -n "${HOSTNAME}" ]; then
        echo "HOSTNAME not set; cannot add OSD to CRUSH map"
        exit 1
    fi
    ceph osd crush add ${OSD_ID} ${WEIGHT} root=$POOL host=$HOSTNAME
fi

exec ceph-osd -d -i ${OSD_ID} -k /var/lib/ceph/osd/${CLUSTER}-${OSD_ID}/keyring
