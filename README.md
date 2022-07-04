# computer-refurb

## Getting Started

### Installing Windows
Create a Windows 10 USB using the Microsoft Windows Media Creation Tool.
Copy the [autounattend.xml](/Assets/autounattend.xml) to the root of the USB. Perform a fresh install of Windows.

### Running refurb 
Download and copy the contents of this repository onto a USB stick or network drive which will be accessible throughout the refurb process.

Ensure the machine is connected to the internet, as some artifacts are downloaded such as installers and Windows Updates.

To start the refurb process, either browse to the directory and right click on startprovision.bat, then run as administrator. Or run cmd or powershell as admin and execcute the startprovision.bat script.

### Trobubleshooting
If at any point the refurb process fails to continue from the last step, the last script load is written to C:\schol-setup.txt. You can copy and paste the last command into a powershell window running as administrator to continue the process from where it last completed.

## Output
The refurb process outputs a report file into the reports folder. This can be provided to SCHolTech at the end to complete the TE2T report.


## Multi Language support

[Multi-language Support](/Docs/MultiLanguageSupport.md)

