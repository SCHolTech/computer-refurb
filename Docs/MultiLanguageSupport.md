# Multi-Language Support

The refurb scripts contain an option to set dual-keyboard language with multi-onscreen language options. The key pieces of this code are:

[Language Switching Scripts](/Assets/LanguageSwitches) - In each folder there is a Set-Language.ps1 script. This sets the Windows UI language override, and the Keyboard Input Default override. It then logs the user out. On login, the overrides that were set are used. This only works on W10 Pro natively, on W10 Home you need to copy the logoff.exe into the Windows\System32 folder. The appropriate language pack must be installed with the corresponding keyboard layout. To discover the correct options for the script, run `Get-WinUserLanguageList` which will list the Language Tag and InputMethodTips values for each language pack you have installed. the lnk files are shortcuts that run the script in the same folder.

[Set Language Switching](/Functions/Set-LanguageSwitches.ps1) - This script is run during the refurb. Based on the language option passed to it, it copies the appropriate assets to the computer being refurbed. There are 2 additional actions it take. Firstly, it sets the execution policy to remotesigned. This allows the switch sctripts to run without erroring. It also copies the lnk shortcut files to the desktop so they are available to the user.

[Set Language Switching Shortcuts on the Start Menu](/setup-stage025.ps1#L70) - This script copies the appropriate shortcut files to the start menu folder so they can be used in the start menu. The start menu layouts can be found [here](/Assets/StartMenuLayouts)