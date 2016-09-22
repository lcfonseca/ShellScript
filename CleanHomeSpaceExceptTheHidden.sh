##################################################################
# Shellscript:  Public                                           #
# Autor     :   Patrick Reis                                     #
# Data      :   08/07/2016                                       #
# Categoria :   CleanDiskSpace                                   #
# Versão    :   Version 1.0                                      #
##################################################################

#Script created to clean user's /home except hidden files and folders. 

typeset -i error="90"                     #threshold to clean
path="/home"                              #directory to clean
Deletar="/var/log/clean-home-lista.log"   #Create the file that will make the loop to clean.
LOG="/var/log/clean-home.log"             #Create the file that contains the clean log. 
TEMP="/tmp/clean-home.txt"                #File that will have the user's loop to clean their home. Deleted in the end of the script.
DATA=$(date +%F)
HORA=$(date +%T)
STAMP="$DATA $HORA"

#grep all the users in /home and add into the file "/tmp/clean-home.txt" as I said erased at the end of the script
ls /home/ > $TEMP

#Cut the percent of the /home space if u have error here change AWK '{print $5}' to AWK '{print $4}'
export limpa=$(df -h $path | grep -i $path | awk '{ print $5}' | sed 's/%//g') > $LOG

#Condition if the disk is over then 90%
if [ "$limpa" -ge "90" ]; then     
 echo -e "$STAMP Disco /home/ acima de 90% Efetuanto a limpeza" >> $LOG
 
  for i in `cat $TEMP`;do
  
    #Find used to locate all the files except the hidden.
    find /home/$i -not -path '*/\.*' -type f >> $Deletar

  done
	
	#Cat the files in the list "/var/log/clean-home-lista.log" and erase.
  for i in `cat $Deletar`;do
	 
	 rm -rf $i
	done
fi

echo "$STAMP Final de limpeza de arquivos." >> $LOG
echo "" >> $LOG
rm -f $TEMP
