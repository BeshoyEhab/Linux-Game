#!/bin/bash

source ./.menu.sh

## Initialize the game
if [ -d ".game"] 
then
	rm -rf ./.game
fi

mkdir .game
tmp_dir="$(realpath .game)"

cd $tmp_dir

## Commands stories
cd_story="Captain Flint 'Blackfin Drake' was a fearsome pirate. But he was different, he is an online pirate who searches for online treasures. He was known for his cunning and ruthlessness. His ship, the Crimson_Tide, was a ghostly shadow on the high seas. Which command should he use to enter the folder named 'Crimson_Tide'"
find_story='One stormy night, Blackfin discovered a map leading to the legendary Emerald Skull. Search for the island named "Chala". Which command should he use (search through many files with different island names)'
rm_story="As they sailed through treacherous waters, a rival ship, the Siren's Wrath, ambushed them. Cannons roared, and the sea turned red with battle. Remove the sirens, ASAP! Save the captain!"
mv_story='Blackfin outsmarted his foes, using the storm to his advantage. The *Crimson Tide* emerged victorious, though scarred and weary. Take the ship and put near the Main_Land'
chmod_story="At the island, traps and riddles guarded the treasure. He kept trying to evade and save the crew but he got trapped in a temple. Give him the permissions to be able to open the gate"
touch_story="Blackfin's wit and blade proved sharper than any curse. With the Emerald Skull in hand, Blackfin set sail again, his legend growing. The sea was his home, and adventure his only mistress. Put your flag on the island to show the world that could take the treasure"

## Need to be added

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

# Command setup
cd_setup="mkdir -p Crimson_Tide"
find_setup="touch Chala"                  # Create the Chala file to find
rm_setup="touch sirens"                   # Create a sirens file to remove
mv_setup="mkdir -p Main_Land; touch ship" # Create destination and ship
chmod_setup="touch $tmp_dir/gate; chmod 000 $tmp_dir/gate"  # Create a gate with no permissions
touch_setup="mkdir -p island"             # Create an island to put flag on

## Commands tests
cd_test="; pwd | grep $tmp_dir/Crimson_Tide > /dev/null"
find_test=" | tee $tmp_dir/.find.txt ; cd $tmp_dir; diff $tmp_dir/.find.txt $tmp_dir/.find_sol; cd $tmp_dir"
rm_test="; test ! -f $tmp_dir/sirens; echo $? | tee $tmp_dir/.rm.txt ;diff $tmp_dir/.rm.txt $tmp_dir/.rm_sol.txt; cd $tmp_dir"
mv_test="; test -f $tmp_dir/Main_Land/ship ; echo $? >> $tmp_dir/.mv.txt; test ! -f $tmp_dir/ship ; echo $? >> $tmp_dir/.mv.txt ;diff $tmp_dir/.mv.txt $tmp_dir/.mv_sol.txt; cd $tmp_dir"
chmod_test=";test -r $tmp_dir/gate && test -w $tmp_dir/gate && test -x $tmp_dir/gate; echo $? | tee $tmp_dir/.chmod.txt ;diff $tmp_dir/.chmod.txt $tmp_dir/.chmod_sol.txt; cd $tmp_dir"
touch_test=""

## Commands solutions
cd_sol="echo "$tmp_dir/Crimson_Tide" >$tmp_dir/.cd_sol"
find_sol="find . -name Chala >$tmp_dir/.find_sol"
rm_sol="echo "0" >$tmp_dir/.rm_sol.txt"
mv_sol="echo "0" >>$tmp_dir/.mv_sol.txt; echo "0" >> $tmp_dir/.mv_sol.txt"
chmod_sol="echo "0" >$tmp_dir/.chmod_sol.txt"
touch_sol=""




show_text() {
  delay=0.001
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

run() {
  
  text=$1
  # Split commands by semicolon, trimming whitespace and ignoring empty
  IFS=';' read -ra coms <<<"$text"
  success=true
  echo $coms
  
  for com in "${coms[@]}"; do
    com_trimmed=$(echo "$com" | xargs)  # Trim whitespace
    [[ -z "$com_trimmed" ]] && continue # Skip empty commands

    if [[ "$com_trimmed" == *"diff"* ]]; then
      eval "$com_trimmed" 
      diff_exit_code=$?
      if [ $diff_exit_code -ne 0 ]; then
        success=false
      fi
    else
      eval "$com_trimmed" 
      if [ $? -ne 0 ]; then
        success=false
      fi
    fi
  done

  if [ "$success" = true ]; then
    echo -e "\033[1;32mTest passed!\033[0m"

    read -p "Press Enter to continue..."
    return 0
  else
    echo -e "\033[1;31mTest failed! Try again.\033[0m"
    read -p "Press Enter to try again..."

    return 1
  fi

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

  how_tar="Ahoy! To keep all yer treasures safe and sound in one chest, use the tar command. It bundles files into a single archive.
\`tar [options] [archive_name] [files_or_directories]\`
Example \`tar -cvf treasure_chest.tar ./treasures\`"

  how_zip="Shiver me timbers! If yer files be too heavy, use zip to make 'em lighter and easier to carry.
\`zip [options] [archive_name] [files_or_directories]\`
Example \`zip -r compressed_treasure.zip ./treasures\`"

  how_chown="Arrr! When ye need to grant yer loyal crew ownership of some treasures, use chown.
\`chown [new_owner] [file_or_directory]\`
Example \`chown crewmate treasure_map.txt\`"

  how_su="Blimey! Need to sneak into enemy territory? Use su to switch users and move unseen.
\`su [username]\`
Example \`su enemy_pirate\`"

  how_sudo="Yo ho ho! When ye need the captain’s authority to unlock forbidden gates, use sudo.
\`sudo [command]\`
Example \`sudo open_secret_gate\`"

  how_curl="Avast! Fetchin’ files from distant servers? Use curl to download treasures from the depths of the internet.
\`curl [options] [URL]\`
Example \`curl -O https://piratebay.com/treasure_map.txt\`"

  how_grep="Land ho! Need to find specific coordinates in a sea of text? Use grep to search files for hidden clues.
\`grep [options] [pattern] [file]\`
Example \`grep 'Emerald Skull' maps/*.txt\`"

  how_mkdir="Ahoy, matey! Need a new hideout for yer loot? Use mkdir to create a fresh directory.
\`mkdir [directory_name]\`
Example \`mkdir ./hidden_treasure\`"

  how_echo="Dead men tell no tales, but echo lets ye leave messages for foolish pirates who dare cross ye.
\`echo [message]\`
Example \`echo 'Trespassers will walk the plank!' > warning.txt\`"

  how_variables="By Davy Jones' locker! Store important info in variables to use later in yer scripts.
\`variable_name=value\`
Example \`treasure_location='/maps/emerald_skull'\`"

  how_pwd="Lost in the digital seas? Use pwd to find out where ye be.
\`pwd\`
Example \`pwd\` (outputs: /home/blackfin/Crimson_Tide)"

  how_diff="Two maps but unsure which one’s updated? Use diff to spot the differences.
\`diff [file1] [file2]\`
Example \`diff map_v1.txt map_v2.txt\`"

  how_git="To preserve yer legend, use git to document and share yer adventures with the crew.
\`git [command] [options]\`
Example \`git commit -m 'Added Emerald Skull coordinates'\`"

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
setups=("$cd_setup" "$find_setup" "$rm_setup" "$mv_setup" "$chmod_setup" "$touch_setup")
tests=("$cd_test" "$find_test" "$rm_test" "$mv_test" "$chmod_test" "$touch_test")
solutions=("$cd_sol" "$find_sol" "$rm_sol" "$mv_sol" "$chmod_sol" "$touch_sol")
part=0
while [[ part -le $((${#parts[@]} - 1)) ]]; do
  clear
  cd $tmp_dir
  e=false
  while [[ "$e" == 'false' ]]; do
    now_part=${parts[$part]}
    show_text "$now_part"
    MENUPROMPT="What will you do? "
    OPTIONS=('do' 'secret' 'exit')
    MENU "$now_part\n\n${MENUPROMPT}" $OPTIONS
    r=${OPTIONS[$?]}
    case "$r" in
    'do')
      clear
      echo -e "$now_part\n\n"
      read -p "Ok do it write the command you will use: " -r cho
      eval "${setups[$part]}"
      eval "${solutions[$part]}"
      run "$cho${tests[$part]}"
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



