
$RussianInEnglish = "Russian"
$RussianInUkrainian = "Російська"
$RussianInRussian = "русский"

Set-WinUILanguageOverride -Language "ru-UA"
Set-WinDefaultInputMethodOverride -InputTip "2000:00000419"
logoff


#1 - For English only, all the default options

#2 - For English, Ukraine with Ukraine Keyboard, add second keyboard layout Ukraine > Ukrainian
#Install Ukraine language pack

#3 - For English, Ukraine, Russian with Russian Keyboard, add second keyboard Ukraine > Russian Keyboard
#Install Ukraine language pack
#Install Russian (Ukraine) which defaults to russian keyboard

