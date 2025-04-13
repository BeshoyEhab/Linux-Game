#!/bin/bash

source ./.menu.sh

## Initialize the game
tmp_dir=$(mktemp -d -t 'game.XXX')
cp -r ./game/* $tmp_dir
cd $tmp_dir

## Commands stories
cd_story="Captain Flint 'Blackfin Drake' was a fearsome pirate. But he was different, he is an online pirate who searches for online treasures. He was known for his cunning and ruthlessness. His ship, the Crimson_Tide, was a ghostly shadow on the high seas. Which command should he use to enter the folder named 'Crimson_Tide'"
find_story='One stormy night, Blackfin discovered a map leading to the legendary Emerald Skull. Search for the island named "Chala". Which command should he use (search through many files with different island names)'
rm_story="As they sailed through treacherous waters, a rival ship, the Siren's Wrath, ambushed them. Cannons roared, and the sea turned red with battle. Remove the sirens, ASAP! Save the captain!"
mv_story='Blackfin outsmarted his foes, using the storm to his advantage. The *Crimson Tide* emerged victorious, though scarred and weary. Take the ship and put near the Main_Land'
chmod_story="At the island, traps and riddles guarded the treasure. He kept trying to evade and save the crew but he got trapped in a temple. Give him the permissions to be able to open the gate"

  ## Need to be added
  touch_story="Blackfin's wit and blade proved sharper than any curse. With the Emerald Skull in hand, Blackfin set sail again, his legend growing. The sea was his home, and adventure his only mistress. Put your flag on the island to show the world that could take the treasure"
  tar_story="After years of sailing through the seas of the internet, Blackfin had collected countless digital treasures. But he needed a way to store them all in one place. Which command should he use to archive the treasure in a digital chest to protect it from other pirates?"
  zip_story="The files were too many, and carrying them slowed down the digital ship. Blackfin needed a way to make them smaller and more efficient. Which command should he use to compress the treasure to make it lighter and easier to transport?"
  chown_story="While dividing the loot, Blackfin decided to grant some treasures to his loyal crew. But he needed to change the owner of certain digital files. Which command should he use to give the crew ownership of some of the treasures?"
  su_story="On a secret mission, Blackfin needed to infiltrate an enemy database, but he couldn’t enter under his usual identity. Which command should he use to switch the user and sneak in unnoticed?"
  sudo_story="Blackfin found a locked digital gate that required special permission to open. Which command should he use to grant himself the captain’s authority and unlock the digital door?"
  curl_story="While exploring the map of the internet, Blackfin needed to download important documents from remote servers. Which command should he use to fetch the files from the depths of the internet?"
  grep_story="The map was filled with scattered information, but Blackfin needed to find only the treasure coordinates. Which command should he use to search for the required text inside the available files? (I think we need to specify the coodinates or something)"
  pipeline_story=""
  mkdir_story="Upon reaching a new digital island, Blackfin needed to create a new hideout for his treasures. Which command should he use to create a new directory for the digital loot?"
  echo_story="Blackfin wanted to leave a warning message for any pirate who dared to steal his treasure. Which command should he use to print a threat message for enemies?"
  variables_story="To manage his vast treasures, Blackfin needed a system to store important information. Which command should he use to store data in a variable to use it easily later?"
  pwd_story="After wandering through many digital directories, Blackfin lost track of his location. Which command should he use to find out his current position in the digital sea?"
  diff_story="Blackfin had two versions of the treasure map but wasn’t sure what was different between them. Which command should he use to find the difference between the two versions to know which one is updated?"
  git_story="Blackfin knew that his legend would only live on if he shared his adventures with the world. So, he created a digital repository where he could document and update all his journeys. Which command should he use to save the history of his adventures and share them with his crew?"
  
## Commands tests
cd_test="; pwd > ../.cd.txt ; cd $tmp_dir; diff .cd.txt .cd_sol"
find_test=" > .find.txt ; cd $tmp_dir; diff .find.txt .find_sol"
rm_test="; test -f Chala | tee ./.rm.txt ; cd $tmp_dir"
mv_test="; test -d Chala | tee ./.mv.txt ; cd $tmp_dir"

## Commands solutions
echo "$tmp_dir/Crimson_Tide" >.cd_sol
find . -name Chala >.find_sol

show_text() {
  delay=0.03
  text=$1
  for ((j = 0; j < ${#text}; j++)); do
    echo -n "${text:$j:1}"
    if [ "${text:$j:1}" == "." ]; then
      sleep $(echo "$delay * 15" | bc)
    fi
    sleep $delay
  done
  echo
}

cheat() {
  clear
  how_cd="How wonderful the way you go from place to another and faces the wind and the sea,
cd is like that you can use it to change your current directory
\`cd [directory]\`
Example \`cd ./Downloads\`"

  how_find="Hey you give me the binoculars to search for the treasure,
find the way you will search about treasure [file] is your disk and have a lot of options (you can find them in \`man find\`)
\`find [place to search in] [option]\`
Example \`find . -name my_file\`"

  how_rm="Ready, Set, Fire! Let's see how you can destroy the pirates
rm is the Cannons used to remove files and directories 
\`rm [option] (file|directory)\`
Example \`rm ./my_file\`"

  how_mv="Herry we must move all this treasure to the ship before the storm comes
mv is used to move file or directory from place to another and also to rename files [Stole it 🙂]
\`mv (file|directory) (place)\`
\`mv (old_file_name) (new_file_name)\`
Example \`mv my_file Downloads/\`
        \`mv my_file MyFile\`"

  how_chmod="Hey, I only want you to fire the cannons and see the treasure not to take it
chmod is used to changeing file or directory permissions [read execute write] (find more in \`man chmod\`)
\`chmod (permissions) (file)\`
Example \`chmod 755 my_file\`"

  how_touch="What to do with those thieves. Oh, I know, I'll make fake cave so they can't find the treasure
touch is command used for creating new files
\`touch (file_name[s])\`
Example \`touch my_file1 my_file2 my_file3\`"

  MENUPROMPT="Oh I see you stuck now, let me help you with that"
  OPTIONS=('cd' 'find' 'rm' 'mv' 'chmod' 'touch' 'exit')
  MENU "${MENUPROMPT}" $OPTIONS

  RESULT=${OPTIONS[$?]}
  case $RESULT in
  'cd')
    show_text "$how_cd"
    ;;
  'find')
    show_text "$how_find"
    ;;
  'rm')
    show_text "$how_rm"
    ;;
  'mv')
    show_text "$how_mv"
    ;;
  'chmod')
    show_text "$how_chmod"
    ;;
  'touch')
    show_text "$how_touch"
    ;;
  'exit')
    break
    ;;
  esac

}

parts=("$cd_story" "$find_story" "$rm_story" "$mv_story" "$chmod_story" "$touch_story")
tests=("$cd_test" "$find_test" "$rm_test" "$mv_test" "$chmod_test" "$touch_test")
part=0
while [[ part -le $((${#parts[@]} - 1)) ]]; do
  clear
  e=false
  while [[ "$e" == 'false' ]]; do
    show_text "${parts[$part]}"
    MENUPROMPT="What will you do? "
    OPTIONS=('do' 'secret' 'exit')
    MENU "${MENUPROMPT}" $OPTIONS
    r=${OPTIONS[$?]}
    case "$r" in
    'do')
      clear
      read -p "Ok do it write the command you will use: " -r cho
      command "$cho${tests[$part]}"
      if [[ $? -eq 0 ]]; then
        e=true
        break
      fi
      ;;
    'secret')
      clear
      cheat
      ;;
    'exit')
      exit 1
      ;;
    esac
  done
  part=$((part + 1))
done
