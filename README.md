
# LiveScript-Git
Multi-Platform configuration script for Windows 10 Enterprise LTSC 1809 (x64).
(Ps. Great for gaming ;-)

This script is suited for my own personal use (Including all my hardware systems) and is not ready to be used 'as is'. There are some personal additions that are of no use to most other people and will have to be purged from the script.

Some tools that are required are not included here so you'll have to fetch them yourself.



Performance:
    - Reduce OS jitter and latency, smaller memory footprint. Loads of functions removed/disabled.
    - Mitigations: Globally disabled (Except for DEP), needs to be explictly enabled/disabled per executable before firewall rule is allowed.
    - Automatic power plan importing, remove useless plans.
    - Configuration of global and per adapter network settings.
    
Security:
    - Firewall: Strict basic rules for core networking.
        - Unsolicited firewall rules created by windows/programs are automatically purged.
    - Event Viewer -> Security to see what ports/address needs to be allowed.
    - Privacy: Minimized telemetry as much as possible. (Basically not existent).
    - Autorun registry entries (User) are automatically purged.
    - Root Certificates updated through logon script.
    - hosts file updated through logon script. (Host based ad blocking)
    
Context Menu:
    - Set mitigations per executable (Prerequisite for allowing firewall rule)
    - Set firewall rules per executable (Either predefined for ease, or custom)
    - Set Large Pages per executable (Could improve performance)
    - Take Ownership on files
    - Classic Customize (Windows 7)
    - Disable DPI Scaling
    - Block executable from running
    - Powershell / cmd 'open here'
    - Purge all kind of useless default context menu entries

Features:
    - Automatic installation of Visual Runtime C++ and Direct3D9 Runtime pack if not installed.
    - Automatic installation of HEIFImageExtension, VCLibs, VP9VideoExtensions, WebMediaExtensions
    - Restore Windows Photo Viewer
    - OldNewExplorer setup to fix LTSC explorer border outline on 'Light' theme
    - Purge default annoying sound scheme
    - Clean up control panel from unnecessary junk
    
    
And loads more!
