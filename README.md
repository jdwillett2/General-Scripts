# General-Scripts

This repository contains a few scripts written for random things.  I will describe them below:

## Cisco Amp Install

There are two scripts here that work together.  The -Multiple script takes input from the pipeline and starts a new powershell process for each computer it reads from the pipeline.  The other script then runs for each server to copy the Cisco Amp executable from the script folder to the remote server and install it.  The executable itself is not included since it is a proprietary version.

## Java Cleanup

First script is used to disable Java Update, the way it is written is to be run locally.  I believe I originally ran it with SCCM.

Second and third scripts are to be used together (-multiple calls the other, so it gets the input) to remove all the Java versions specified by the product code list in the JavaProductCodes.txt file.  It also includes everything in the previous script to disable Java Update.

### Create-AlwaysOn-Cluster.ps1

This script was written to create an Always On Windows cluster from the given set of servers.  It takes input for the cluster name, cluster IP, Listener name, and node names.  It installs the failover cluster role on each server, and creates the cluster with the specified IP and the -nostorage switch.  Then it creates the file share witness folder and sets the correct permissions on it.  Next it creates the listener account in AD, then waits for the both the listener and cluster account to show up with an AD query.  It adds the cluster and listener accounts for the File share witness admin group, and then sets AD permissions for each computer account and the cluster and listener accounts appropriately.  The last thing it does is set the cluster quorum to use the file share witness and then exits.

Assuming everything cooperates, the always on cluster is now running and ready for SQL to be installed and set up on it.

### Deploy-VM-2012r2.ps1 and Deploy-VM-2016.ps1

These two scripts utlize powerCLI to deploy a new VM within vSphere.  Takes input for the VM name, VLAN, cluster name, and folder name.  It picks the datastore with the most storage available and deploys the template with the correct customization.  It also creates an AD admin group for the server.

### RemoveCCM.ps1

This was created to remove the SCCM 2012 client from workstations and perform a bunch of cleanup to prepare them for a new SCCM client from a different site to be installed.
