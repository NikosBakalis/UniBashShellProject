#!/bin/bash


#COMMENTS IN GREEK!!!


#arxikopoiw bool metablites pou tha xrisimopoiw san "flags" mesa stis if
boolf=false
boolid=false
boolfn=false
boolln=false
boolbs=false
boolbu=false
boolsm=false
#arxikopoiw to filename
filename=""

#ksekinaw thn while sthn opoia ta arguments tha pairnoun briskontai se theseis megaluteres tou 0
#p.x. sthn thesi 0 tha brisketai to "./tool.sh" sthn 1 to "-f" sthn 2 to "dates.dat"
while [ $# -gt 0 ]; do
#arxikopoiw to key kai to bazw sthn thesi 1
	key="$1"

#ksekinaw thn case me tis periptwseis
	case $key in
	"-f")
#to filename tha brisketai sthn thesi 2
		filename=$2
#energopoiw to boolf wste na to xrisimopoihsw swsta sthn if
		boolf=true
#xrisimopoiw to shift gia na allaksw thesi ta arguments metaksu tous
		shift
#Mias kai xrisimopoiw tis theseis 1 kai 2 gia thn "-f dates.dat" tha xrisimopoihsw 2 shift
		shift
		continue;;

#omoiws gia kathe case mesa sthn while
	"-id")
		id=$2
		boolid=true
		shift
		shift
		continue;;

	"--firstnames")
		firstnames=$2
		boolfn=true
		shift
		continue;;

	"--lastnames")
		lastnames=$2
		boolln=true
		shift
		continue;;

	"--born-since")
		bornsince=$2
		boolbs=true
		shift
		shift
		continue;;

	"--born-until")
		bornuntil=$2
		boolbu=true
		shift
		shift
		continue;;

	"--socialmedia")
		boolsm=true
		shift
		continue;;

#sthn edit xrisimopoiw perissotera shift analoga me ta arguments pou exw
	"--edit")
		id=$2
		column=$3
		value=$4
		boole=true
		shift
		shift
		shift
		shift
		continue;;

#case gia to ti tha ginei an pliktrologisw kati allo pera apo ta apo panw
	*)
		echo Invalid Arguments
		echo Choose between:
		echo -f
		echo -id
		echo --firstnames
		echo --lastnames
		echo --born-since
		echo --born-until
		echo --socialmedia
		echo --edit
		exit 1;;
	esac

done


#stis if pou akolouthoun energopoiw ta flags gia na kanw tis antistoixes diadikasies
#arxika an exw pliktrologisei "-f dates.dat"
if [ "$boolf" = true ]; then

#meta an mazi me to "-f dates.dat" pliktrologisw kai "-id ..."
	if [ "$boolid" = true ]; then
#awk pou diabazei apo to dates.dat kai tupwnei tis stiles 2 3 kai 5 MONO stis grammes opou to id einai iso me to id pou pliktologisame sto antistoixo argument
		awk -F "|" -v id="$id" '!/^ *#/ && NF && $1 == id { print $2" "$3" "$5 }' $filename
		exit
	fi
#omoiws gia ta upoloipa if statements
	if [ "$boolfn" = true ]; then
		awk -F "|" '!/^ *#/ && NF { print $3 }' $filename | sort -u
		exit
	fi

	if [ "$boolln" = true ]; then
		awk -F "|" '!/^ *#/ && NF { print $2 }' $filename | sort -u
		exit
	fi

	if [ "$boolbs" = true ] && [ "$boolbu" = true ]; then
		awk -F "|" -v bu="$bornuntil" -v bs="$bornsince" '!/^ *#/ && NF && $5<=bu && $5>=bs { print }' $filename
		exit
	fi

	if [ "$boolbs" = true ] && [ "$boolbu" = false ]; then
		awk -F "|" -v bs="$bornsince" '!/^ *#/ && NF && $5>=bs { print }' $filename
		exit
	fi

	if [ "$boolbs" = false ] && [ "$boolbu" = true ]; then
		awk -F "|" -v bu="$bornuntil" '!/^ *#/ && NF && $5<=bu { print }' $filename
		exit
	fi

	if [ "$boolsm" = true ]; then
		awk 'BEGIN{FS="|"} /^[^#]/ {print $9}' $filename | sort | uniq -c | tr -dc '[:print:]\n' |awk '{print $2" "$1}'
		exit
	fi

#stin sugkekrimenh if uparxei h sed h opoia einai upeuthinei wste na kanei tis aparetites allages
	if [ "$boole" = true ]; then
#while gia na diabasei olo to arxeio
		while IFS='|' read -r line || [[ -n "$line" ]]; do
#an to periexomeno tou line einai idio me tou id
			if [[ "$line" = "$id|"* ]]; then
#spaei to dates.dat se columns ana "|" kai apothikeuei sto current tin twrinh timh 
#tis thesis tou column
				currnet=$(echo $line|cut -d "|" -f $column | tr "|" " ")
#an to column den einai to id column kai to value den einai keno
				if [ "$column" -ne "1" ] && [ "$column" -le "9" ] && [ "$value" != "" ]; then
#allazei to periexomeno tou current me to value pou balame emeis ws argument
					sed -i "s/^\($id|.*\)$currnet/\1""$value/g" $filename
					echo Done!
					echo File changed.
#an afisoume to argument value keno den to epitrepei kathws tha uparxei problima me ta columns
				elif [ "$column" -ne "1" ] && [ "$column" -le "9" ] && [ "$value" == "" ]; then
					echo Your new value must NOT be NULL
					echo File not changed.
#kai den epitrepei na allaksoume to id column
				else
					echo You cannot interupt with $column column
					echo Try columns between 2 and 9
					echo File not changed.
				fi
			fi	
		done < "$filename"
		exit
	fi

#tupwnei to dates.dat xwris ta comments
	grep -o '^[^#]*' $filename;

#else if gia thn periptwsh pou den baloume "-f dates.dat"
elif [ "$boolf" = false ] && [ "$boolid" = true ] || [ "$boolfn" = true ] || [ "$boolln" = true ] || [ "$boolbs" = true ] || [ "$boolbu" = true ] || [ "$boolsm" = true ] || [ "$boole" = true ]; then
	echo "You have to enter the -f <filename> too."

#else tupwnei ta AM mas
else
	echo "1054316 - 1058085"
fi
