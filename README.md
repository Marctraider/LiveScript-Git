
# LiveScript-Git

## EXAMPLE Multi-Platform configuration script for Windows 10 Enterprise LTSC 1809 (x64).

This script is suited for my own personal use (Including all my hardware target systems) and is not ready to be used 'as is'. 
I.e. there are some personal additions that are of no use to most other people and will have to be purged from the script.

#Goal of script: Was done with all the 'tweaking' communities, bad advice etc, done with Windows 10 being an operating system with spying, telemetry, undesired behavior, and  desired a perfect desktop OS also suitable for high performance low latency gaming. Now it is just a matter of keeping it updated (Also for LTSC 2021?)



#Performance:

- Reduce OS jitter and latency, smaller memory footprint. Loads of functions removed/disabled/tweaked.
- Mitigations: Globally disabled (Except for DEP), needs to be explictly enabled/disabled per executable before firewall rule is allowed.
- Automatic power plan importing, remove useless plans.
- Configuration of global and per adapter network settings.
- Set IRQ affinities / MSI mode on devices.
    
#Security

- Firewall: Strict basic rules for core networking.
- Unsolicited firewall rules created by windows/programs are automatically purged.
- Event Viewer -> Security to see what ports/address needs to be allowed.
- Privacy: Minimized telemetry as much as possible. (Basically not existent).
- Autorun registry entries (User) are automatically purged.
- Root Certificates updated through logon script.
- hosts file updated through logon script. (Host based ad blocking)
- Use self-hosted NCSI file on router to detect if internet available on clients
    
#Context Menu:
- Set mitigations per executable (Prerequisite for allowing firewall rule)
- Set firewall rules per executable (Either predefined for ease, or custom)
- Set Large Pages per executable (Could improve performance)
- Take Ownership on files
- Classic Customize (Windows 7)
- Disable DPI Scaling
- Block executable from running
- Powershell / cmd 'open here'
- Purge all kind of useless default context menu entries

#Features:
- Automatic installation of Visual Runtime C++ and Direct3D9 Runtime pack if not installed.
- Automatic installation of HEIFImageExtension, VCLibs, VP9VideoExtensions, WebMediaExtensions
- Restore Windows Photo Viewer
- OldNewExplorer setup to fix LTSC explorer border outline on 'Light' theme
- Purge default annoying sound scheme
- Clean up control panel from unnecessary junk
    
And loads more!

# Script prerequisites:
- Activated Windows LTSC
- Built-in Administrator account
- Fully updated (Cumulative / NET4.x)
- Tools that are not published here but mentioned in the script.

# How to use?
- Run.cmd will start the corresponding elevated and unelevated scripts.
