#!/bin/sh

timestamp() {
  date +"%T"
}

echo ""
echo "______                   _     _  __    ___  ___          _ "
echo "|  ___|                 | |   (_)/ _|   |  \/  |         | |"
echo "| |_ __ _ _ __ _ __ ___ | |    _| |_ ___| .  . | ___   __| |"
echo "|  _/ _\` | '__| '_ \` _ \| |   | |  _/ _ \ |\/| |/ _ \ / _\` |"
echo "| || (_| | |  | | | | | | |___| | ||  __/ |  | | (_) | (_| |"
echo "\_| \__,_|_|  |_| |_| |_\_____/_|_| \___\_|  |_/\___/ \__,_|"
echo ""

MOD_PATH=~/Library/Application\ Support/Steam/steamapps/common/7\ Days\ To\ Die/Mods/FarmLife2Mod/Localization.txt

if [ -e "$MOD_PATH" ]; then
  echo "Found mod's Localization.txt 👍"
else
  MOD_FILE_PATH=~/Library/Application\ Support/Steam/steamapps/common/7\ Days\ To\ Die/Mods/FarmLife2Mod
  echo "🚨🚨🚨\nCan't find mod, needs to be installed in:\n$MOD_FILE_PATH\n🚨🚨🚨"
  exit 1
fi

APP_PATH=~/Library/Application\ Support/Steam/steamapps/common/7\ Days\ To\ Die/7DaysToDie.app/Data/Config

if [ -d "$APP_PATH" ]; then
  echo "Found 7 Days to Die 👍"
else
  echo "Was looking for $APP_PATH..."
  echo "🚨🚨🚨 Can't find your 7 Days to Die folder 🚨🚨🚨"
  exit 1
fi

pushd "${APP_PATH}" > /dev/null

START_MARKER=`grep FARMLIFE_START Localization.txt`
if [ -n "$START_MARKER" ]; then
  echo "Found existing Localization strings, removing them..."

  END_MARKER=`grep FARMLIFE_SENTINEL Localization.txt`
  if [ -n "$END_MARKER" ]; then
    echo "Localization.txt integrity check passed, removing old strings..."

`sed -e 's/FARMLIFE.*//g' Localization.txt | sed -e 's/farmLife.*$//g' | sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba' | sed '/^$/d' > new_loc_file.txt`

  else
    echo "🚨🚨🚨 FARMLIFE_SENTINEL not found. There is a problem and you should verify files in Steam and then retry. 🚨🚨🚨"
    exit 1
  fi

else
  echo 'No existing Localization strings, adding new strings...'
  cat Localization.txt > new_loc_file.txt
fi

echo "Installing new mod strings..."

cat ../../../Mods/FarmLife2Mod/Localization.txt >> new_loc_file.txt

TIME_STAMP=$(date +%s)
mv Localization.txt Localization_$TIME_STAMP.txt
echo "Backing up Localization.txt Localization_$TIME_STAMP.txt..."

mv new_loc_file.txt Localization.txt

echo "All strings installed 👍"

popd > /dev/null
