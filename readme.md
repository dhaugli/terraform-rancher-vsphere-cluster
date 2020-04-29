The intent of this repo is to create a beginners guide / code to setup a Rancher cluster with utilizing VMware Vsphere, Vcenter and Local storage.

This guide will utilize Terraform 0.12x and GOVC (tool for getting some information you might not expect unless you know VMware really well).
The template requires you to fill out the variables in a .tfvars file, get your VMWare information (paths to storage, datacenter, etc)

I used Rancher 2.4.2 to setup the Kubernetes cluster. 

To prep the ubuntu node template for Rancher, follow this guide, 
URL= https://blah.cloud/kubernetes/creating-an-ubuntu-18-04-lts-cloud-image-for-cloning-on-vmware/ 
Though remember to skip the parts that removes / disables cloud-init. Rancher needs cloud-init. 

If you have any questions you can find me on the Rancher slack or on my Discord server: https://discord.gg/ZNWdd7 .

