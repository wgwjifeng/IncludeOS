#! /bin/bash

# Start as a GDB service, for debugging
# (0 means no, anything else yes.)

DEBUG=0

[[ $1 = "debug" ]] && DEBUG=1 


# Get the Qemu-command (in-source, so we can use it elsewhere)
. ./qemu_cmd.sh


# Qemu with gdb debugging:
if [ $DEBUG -ne 0 ]
then
    echo "Building system..."
    make test
    echo "Starting VM: '$1'"
    echo "-----------------------"    
    
    # Build the image 
    ../vmbuild/vmbuild bootloader test_service

    echo "VM started in DEBUG mode. Connect with gdb/emacs:"
    echo " - M+x gdb, Enter, then start with command"
    echo "   gdb -i=mi service -x service.gdb"
    echo "-----------------------"  
    sudo $QEMU -s -S $QEMU_OPTS
else    
    #make clean all #stripped 
    make test

    # Build the image 
    ../vmbuild/vmbuild bootloader test_service

    echo "-----------------------"
    echo "Starting VM: '$1'", "Options: ",$QEMU_OPTS
    echo "-----------------------"
    
    sudo $QEMU $QEMU_OPTS 
fi

# Convert the image into VirtualBox / Qemu native formats
# . convert_image.sh

#reset
#bochs