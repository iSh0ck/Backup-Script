#!/bin/sh
clear
echo $emplacement_script $*
choix=0

if [ ! -d /home/backups ]
	then
		mkdir /home/backups
		apt-get install zip -y
		clear
fi
cd /

echo "Script réalisé par Minarox (Mathis) & iSh0ck (Lucas)"
echo "https://dedigo.fr"
sleep 2

clear
echo "Choisissez le format d'enregistrement de votre backup :"
echo "[\033[32m1\033[0m] - Archive zip"
echo "[\033[32m2\033[0m] - FTP distant"
read choix

if [ $choix = 1 ] #Choix 1 - Archive
	then
		clear
		echo "Vous avez sélectionné le format : \033[31mArchive zip\033[0m"
		echo "Veuillez indiquer ou se trouve le dossier à archiver (Ex: /home ou /var/www):"
		read emplacement #Emplacement de la sauvegarde
		if [ ! -d $emplacement ]	#Vérification du dossier
			then
				echo "\033[31mLe dossier n'existe pas.\033[0m"
				echo "\033[31mFermeture du script.\033[0m"
				exit
		fi

		echo "Veuillez indiquer le nom de l'archive (Ex: backup.zip):"
		read nom_archive #Nom de la backup
		if [ ! -e $nom_archive ] #Vérification du zip
        		then
				echo "\033[32mCréation de la backup en cours...\033[0m"
   				zip -r $nom_archive $emplacement #Création de la backup
			    	mv /$nom_archive /home/backups/	#Déplacement de la backup dans le dossier backups
		    		echo "\033[32mBackup terminée !\033[0m"
				echo "\033[32mEmplacement de la backup : \033[1m/home/backups/$nom_archive\033[0m"
			else
				echo "\033[31mLe fichier existe déjà.\033[0m"
				rm /$nom_archive
		                echo "\033[31mLe fichier exitant a été supprimé\033[0m"
				echo "\033[31mFermeture du script.\033[0m"
				exit
		fi

elif [ $choix = 2 ] #Choix 2 - Envoi FTP
	then
		apt-get install ncftp -y
  		clear
		echo "Vous avez sélectionné le format : \033[31mFTP Distant\033[0m"
        echo "Veuillez indiquer où se trouve le dossier à archiver (depuis la racine) :"
    	read emplacement #Emplacement de la sauvegarde
        if [ ! -d $emplacement ]	#Vérification du dossier
        	then
          		echo "Le dossier n'existe pas."
				echo "Fermeture du script."
				exit
      	fi

        echo "Veuillez indiquer le nom de l'archive (Ex: backup.zip):"
        read nom_archive #Nom de la backup

        if [ ! -e $nom_archive ] #Vérification du zip
        		then
        		clear
                echo "Veuillez indiquer le serveur FTP :"
      			read serveur #Adresse du serveur
                echo "Veuillez indiquer l'utilisateur FTP :"
      			read user #Nom de l'utilisateur
                echo "Veuillez indiquer le mot de passe de l'utilisateur :"
      			read pass #Password de l'utilisateur

		echo "\033[32mCréation de la backup en cours...\033[0m"
   		zip -r $nom_archive $emplacement #Création de la backup
		echo "\033[32mArchive créée !\033[0m"
		echo "\033[32mConnexion au serveur FTP ...\033[0m"

ncftp -u"$user" -p"$pass" $serveur <<EOF
mkdir -p backups
cd backups
put $nom_archive
bye
EOF
		echo "\033[32mVotre fichier a bien été transféré.\033[0m"
		echo "\033[31m$emplacement \033[0m\033[35m=>\033[0m Dossier de <$user> \033[32m./backups/$nom_archive.\033[0m"
		echo "\033[31mDéconnexion du serveur.\033[0m"
		rm /$nom_archive

				else
					echo "\033[31mLe fichier existe déjà.\033[0m"
					rm /$nom_archive
		       	    echo "\033[31mLe fichier exitant a été supprimé\033[0m"
					echo "\033[31mFermeture du script.\033[0m"
					exit
		fi

	else
		echo "\033[31mErreur dans la séléction.\033[0m"
		echo "\033[31mFermeture du script.\033[0m"
		exit
fi