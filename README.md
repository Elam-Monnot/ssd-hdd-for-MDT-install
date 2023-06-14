# ssd-hdd-for-MDT-install
Just a PowerShell script to tell the system on which disk the OS should be installed with MDT
## How it works
This script seek for HDDs and SSDs on the host and select one of them, then returns the number of the disk. The disk number corresponds to the slot of the disk in BIOS .   
The script will choose preferably the largest SSD for installation of the Operating System, if no SSD is detected the largest HDD will be coosed instead.   
## 📝Notes :
**This script does nothing on it's own**, it is used to determine the optimal disk for OS install.   
It has been thought to allow smoother installation process in corporate environment with tools like [*Microsoft Deployment Toolkit*](https://learn.microsoft.com/en-us/windows/deployment/deploy-windows-mdt/get-started-with-the-microsoft-deployment-toolkit).
