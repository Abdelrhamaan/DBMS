#!/bin/bash
# this script is used to create simple database, i hope you enjoy withus.
# making helping functions 
function sep {
	echo -e "\n######################################"
}

function welcomeMsg {
	echo  "we will help you to create simple database, let's go :)"
}

function choice {
	echo -e "Enter your choice :)"
}

function errorMsg {
	echo "Inavlid choice, please enter right choice"
}

PS3="be happy:)"

#======================================================
# function to check dir 
function checkDir {
	 if [[ -d ./DBMS ]];then
				cd ./DBMS 2>/dev/null
	 else 
				mkdir ./DBMS 2>/dev/null
				cd ./DBMS 2>/dev/null
			fi
	dbMenu
}


# create menu function 

function dbMenu {
       welcomeMsg
       echo  "-------welcome to Main menu-------";
       choice
       echo  "1)----- Create Database -----";
       echo  "2)----- list Databases  -----";
       echo  "3)-----Connect  Database-----";
       echo  "4)-----  Drop Database  -----"; 
       echo  "5)-----       Exit      -----";
       choice
       read ch
       case $ch in 
	       1) createDB ;;
	       2) listDb ;;
	       3) connectDb ;;
	       4) dropDb ;;
	       5) exit ;;
	       *) errorMsg 
		  dbMenu ;;
	esac

}


# create db function 

function createDB {
	echo -e "Enter Name of DB :)\c"
	read db
	cd ./DBMS/ 2>/dev/null
	mkdir $db
	# check if exit status of the pervious command 
	if [[ $? -eq 0 ]]; 
	then 
		echo "DB created succeffully"
	else 
		echo "Error happened while creating $dbname"
	fi 
	dbMenu
}

# list db function 

function listDb {
	cd ./DBMS 2>/dev/null
	# check if varaible is empty 
	if [[ -z $(ls) ]];then
	 echo "There is no DB to list "
	else	  
	 echo "list all databases :)"
	 ls -d ./*
	fi
	dbMenu
}

# connect db function 

function connectDb {
	echo -e "Enter name of db :)"
	read db
	cd $HOME/SHELL PROJECT/DBMS/$db 2>/dev/null
	$(PWD) 
	if [[ -d $db ]];then
	  cd $(pwd)/$db 2>/dev/null
	  $(pwd)
	  echo "You now connected on $db db :)"
	  #pwd
	  dbConn
	 else 
	  echo "This $db db is not found" 
	 dbMenu
	 fi
}

# drop db function 

function dropDb {
	echo -e "Enter the name of DB you want to drop : \c"
	read  db
	cd ./DBMS 2> /dev/null
	rm -r $db 2> /dev/null
	if [[ $? -eq 0 ]];then 
		echo "DB dropped successfully "
	else 
		echo " DB not founded "
	fi  
	dbMenu
}

# main menu db function 

function dbConn {
	echo "1)----    Create Table     ----"
	echo "2)----    List Tables      ----"
	echo "3)----     Drop Table      ----"
	echo "4)----    Update Table     ----"
	echo "5)----  Insert Into Table  ----"
	echo "6)----  Select From Table  ----"
	echo "7)----  Delete From Table  ----"
	echo "8)----         Exit        ----"
	choice
	read selection
        case $selection in 
	       1) createTable ;;
	       2) listTable ;;
	       3) dropTable ;;
	       4) updateTable ;;
	       5) insertInto ;;
	       6) clear;selectMenu ;;
	       7) deleteFrom ;;
	       8) exit ;;
	       *) errorMsg 
		  dbConn ;;
	esac
}

# create new table db function 


function createTable {
echo "table name shouldnt start with special chara or numbers"
	### handling table name 
	read -p " Enter table name " tbName 
	regex="^[a-zA-Z]*$"
	if [[ ! $tbName =~ $regex ]];then
		echo "table name is not valid"
		createTable
	else
		if [[ -f $tbName ]];then
	 	echo "This table is already existed, change table name"
	 	dbConn
	 fi
	fi
	 read -p "Enter num of columns : )" colNum;
	 count=1
	 tbSep="|"
	 newl="\n"
	 pkey=""
	 metaData="Col"$tbSep"type"$tbSep"key"

 	while [ $count -le $colNum ]
	do
	read -p "Enter Column Name Num $count: )" colName
	if [[ ! $colName =~ $regex ]];then
		echo "Col name is not valid"
	read -p "Enter Column Name Num $count: )" colName
	else
	echo -e "choose type of $colName :)"
	select choose in "int" "str"
	do  
	case $choose in
	int) colType="int";break;;
	str) colType="str";break;;
	*) echo "invalid choice";;
	esac
	done
	fi
	if [[ $pkey == "" ]];then
		echo -e "Make PK ? "
		select choice in "Yes" "No"
		do 
		case $choice in 
		Yes) pkey="PK";
		metaData+=$newl$colName$tbSep$colType$tbSep$pkey;
		break;;
		No)
		metaData+=$newl$colName$tbSep$colType$tbSep"";
		break;;
		*) echo "invalid choice";;
		esac
		done
	else
		metaData+=$newl$colName$tbSep$colType$tbSep"";
	fi
	if [[ $count == $colNum ]];then
	    temp=$temp$colName
    else
      	temp=$temp$colName$tbSep
    fi
    ((count++))
  done
  chmod -R 777 $db/$tbName 2>/dev/null
  cd ./DBMS 2>/dev/null
  touch $db/.$tbName"meta_data" 2> /dev/null
  echo -e $metaData  >> .$tbName"meta_data"
  touch $db/$tbName 2> /dev/nul
  echo -e $temp >> $tbName
  if [[ $? == 0 ]];
  then
    echo "Table Created "
    dbConn
  else
    echo "Error while Creating Table $tbName"
    dbConn
  fi
}

# list all tables function 


function listTable {
	ls -a 
	dbConn
}

# drop all tables function 


function dropTable {
  read -p "Enter table name ? :)" tbName
  rm $tbName .$tbName"meta_data" 2>> /dev/null
  if [[ $? == 0 ]]
  then
    echo "Table Dropped "
  else
    echo "Error while Dropping Table $tbName"
  fi
  dbConn
}


# update table function 


function updateTable {
    echo -e "Enter Table Name: \c"
    read tbName
    echo -e "Enter Condition Column name: \c"
    read field
    fid=$(awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$field'") print i}}}' $tbName)
    if [[ $fid == "" ]]
    then
        echo "Not Found"
        dbConn
    else
        echo -e "Enter Condition Value: \c"
        read val
        res=$(awk 'BEGIN{FS="|"}{if ($'$fid'=="'$val'") print $'$fid'}' $tbName 2>>/dev/null)
        if [[ $res == "" ]]
        then
            echo "Value Not Found"
            dbConn
        else
            echo -e "Enter FIELD name to set: \c"
            read setField
            setFid=$(awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$setField'") print i}}}' $tbName)
            if [[ $setFid == "" ]]
            then
                echo "Not Found"
                dbConn
            else
                colType=$(awk -F "|" '{if ($1=="'$setField'") print $2}' ".$tbName"meta_data)
                echo -e "Enter new Value to set: \c"
                read newValue
                # check if new values not int 
                if [[ $colType == "int" ]] && ! [[ $newValue =~ ^[0-9]*$ ]]; then
                    echo "Invalid data type for column $setField. Please enter an integer value."
                    dbConn
                # check if new values not str 
                elif [[ $colType == "str" ]] && [[ $newValue =~ ^[0-9]*$ ]]; then
                    echo "Invalid data type for column $setField. Please enter a string value."
                    dbConn
                else
                    NR=$(awk 'BEGIN{FS="|"}{if ($'$fid' == "'$val'") print NR}' $tbName 2>>/dev/null)
                    oldValue=$(awk 'BEGIN{FS="|"}{if(NR=='$NR'){for(i=1;i<=NF;i++){if(i=='$setFid') print $i}}}' $tbName 2>>/dev/null)
                    echo $oldValue
                    sed -i ''$NR's/'$oldValue'/'$newValue'/g' $tbName 2>>/dev/null
                    echo "Row Updated Successfully"
                    dbConn
                fi
            fi
        fi
    fi
}

# Insert New values function 


function insertInto {
	echo -e "Table Name: \c"
  read tableName
  if ! [[ -f $tableName ]]; then
    echo "Table $tableName isn't existed ,choose another Table"
    dbConn
  fi
  colsNum=`awk 'END{print NR}' .$tableName"meta_data"`
  sep="|"
  rSep="\n"
  for (( i = 2; i <= $colsNum; i++ )); do
    colName=$(awk 'BEGIN{FS="|"}{ if(NR=='$i') print $1}' .$tableName"meta_data")
    colType=$( awk 'BEGIN{FS="|"}{if(NR=='$i') print $2}' .$tableName"meta_data")
    colKey=$( awk 'BEGIN{FS="|"}{if(NR=='$i') print $3}' .$tableName"meta_data")
    echo -e "$colName ($colType) = \c"
    read data

    # Validate Input
    if [[ $colType == "int" ]]; then
      while ! [[ $data =~ ^[0-9]*$ ]]; do
        echo -e "invalid DataType !!"
        echo -e "$colName ($colType) = \c"
        read data
      done
    fi

    if [[ $colKey == "PK" ]]; then
      while [[ true ]]; do
        if [[ $data =~ ^[`awk 'BEGIN{FS="|" ; ORS=" "}{if(NR != 1)print $(('$i'-1))}' $tableName`]$ ]]; then
          echo -e "invalid input for Primary Key !!"
        else
          break;
        fi
        echo -e "$colName ($colType) = \c"
        read data
      done
    fi

    #-----------Set new row------------
    if [[ $i == $colsNum ]]; then
      row=$row$data$rSep
    else
      row=$row$data$sep
    fi
  done
  echo -e $row"\c" >> $tableName
  if [[ $? == 0 ]]
  then
    echo "Data Inserted Successfully"
  else
    echo "Error Inserting Data into Table $tableName"
  fi
  row=""
  dbConn
}




# -----------delete function--------------- 
function deleteFrom {
  read -p "Enter Table Name:)" tbName
  echo -e "Enter Condition Column name: \c"
  read field
  fid=$(awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$field'") print i}}}' $tbName)
  if [[ $fid == "" ]]
  then
    echo "Not Found"
    dbConn
  else
    echo -e "Enter Condition Value: \c"
    read val
    res=$(awk 'BEGIN{FS="|"}{if ($'$fid'=="'$val'") print $'$fid'}' $tbName 2>>/dev/null)
    if [[ $res == "" ]]
    then

      echo "Value Not Found"
      dbConn
    else
      NR=$(awk 'BEGIN{FS="|"}{if ($'$fid'=="'$val'") print NR}' $tbName 2>>/dev/null)
      sed -i ''$NR'd' $tbName 2>>/dev/null
      echo "Row Deleted Successfully"
      dbConn
    fi
  fi 	
}

#---------------- select main menu---------

function selectMenu {
  echo -e "-----------------Hello from Select Menu-----------------"
  echo "1)----------  Select All Columns of a Table-------------"
  echo "2)--------- Select Specific Column from a Table---------"
  echo "3)---------  Select From Table under condition----------"
  echo "4)----------------Back To Tables Menu-------------------"
  echo "5)-----------------Back To Main Menu--------------------"
  echo "6)------------------------Exit--------------------------"
  echo "========================================================"
  echo -e "Enter Choice: \c"
  read ch
  case $ch in
    1) selectAll ;;
    2) selectCol ;;
    3) clear; selectCon ;;
    4) clear; dbConn ;;
    5) clear; cd ../.. 2>>/dev/null; dbMenu ;;
    6) exit ;;
    *) echo " Wrong Choice " ; selectMenu;
  esac
}


function selectAll {
  echo -e "Enter Table Name:)\c"
  read tbName
  column -t -s '|' $tbName 2>>/dev/null
  if [[ $? != 0 ]]
  then
    echo "Error Displaying Table $tbName"
  fi
  selectMenu
}

function selectCol {
  echo -e "Enter Table Name:) \c"
  read tbName
  echo -e "Enter Column Number:) \c"
  read colNum
  awk 'BEGIN{FS="|"}{print $'$colNum'}' $tbName
  selectMenu
}



function selectCon {
  echo -e "Select specific column from TABLE Where FIELD(OPERATOR)VALUE \n"
  echo -e "Enter Table Name: \c"
  read tName
  echo -e "Enter required FIELD name: \c"
  read field
  fid=$(awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$field'") print i}}}' $tName)
  if [[ $fid == "" ]]
  then
    echo "Not Found"
    selectCon
  else
    echo -e "\nSupported Operators: [==, !=, >, <, >=, <=] \nSelect OPERATOR: \c"
    read op
    if [[ $op == "==" ]] || [[ $op == "!=" ]] || [[ $op == ">" ]] || [[ $op == "<" ]] || [[ $op == ">=" ]] || [[ $op == "<=" ]]
    then
      echo -e "\nEnter required VALUE: \c"
      read val
      res=$(awk 'BEGIN{FS="|"; ORS="\n"}{if ($'$fid$op$val') print $'$fid'}' $tName 2>>/dev/null |  column -t -s '|')
      if [[ $res == "" ]]
      then
        echo "Value Not Found"
        selectCon
      else
        awk 'BEGIN{FS="|"; ORS="\n"}{if ($'$fid$op$val') print $'$fid'}' $tName 2>>/dev/null |  column -t -s '|'
        selectCon
      fi
    else
      echo "Unsupported Operator\n"
      selectCon
    fi
  fi
}

checkDir

