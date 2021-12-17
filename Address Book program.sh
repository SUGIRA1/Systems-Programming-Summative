#!/bin/bash

# This phone book program will help user add contacts, delete contacts and search 
#By Serge Sugira

Contact()
{
	echo
	while true
	do
		echo "Add. Follow this format to enter Name,Email, and Phone:"
		echo "The Format: \"Last_Name,First_Name,Email, and Phone number\" ."
		echo "Input your data data Click X if you wish ti Quit"
		read aInput
		if [ "$aInput" == 'x' ]
			then
			break
		fi
		echo
		echo $aInput >> addressbook.csv			# Saving information as contact.
		echo "The New contact was added"
		echo
	done
}


DisplayContacts()							   # Displaying the contacts
{
	echo
	echo "All contacts."
	echo
	cat addressbook.csv
	echo
}


# searching and displaying Contacts.

searchContact()
{
	echo
	while true
	do
		echo "Enter last_Name."		# We are asking for the user's last name
		echo "Or Click X to quit"
		read dInput
		if [ "$dInput" == 'x' ]
			then
			break
		fi
		echo
		echo "The Contacts for \"$dInput\":"
		grep ^"$dInput" addressbook.csv
		RETURNSTATUS=`echo $?`
		if [ $RETURNSTATUS -eq 1 ]
			then
			echo "We couldn't findThe contact you're looking for  \"$dInput\"."
		fi
		echo
	done
}

# search for a record and edit it - no parameters
# search using either email or last name
editContact()
{
	echo
	while true
	do
		echo "Enter any search term, e.g. last name or email address."
		echo "Enter data or q to quit"
		read eInput
		if [ "$eInput" == 'q' ]
			then
			break
		fi
		echo
		echo "Listing contacts for \"$eInput\":"
        # searching for a record
		grep -n "$eInput" addressbook.csv
		RETURNSTATUS=`echo $?`
        # did not find anything
		if [ $RETURNSTATUS -eq 1 ]
			then
			echo "No contacts found for \"$eInput\""
        # found some records
		else
			echo
			echo "Enter the line number that you'd like to edit."
			read lineNumber
			echo
            # loop and display the results
			for line in `grep -n "$eInput" addressbook.csv`
			do
				number=`echo "$line" | cut -c1`
				if [ $number -eq $lineNumber ]
					then
					echo "What would you like to change it to? Use the format:"
					echo "\"Last name,first name,email,phone number\" (no quotes or spaces)."
					read edit
					lineChange="${lineNumber}s"
					sed -i -e "$lineChange/.*/$edit/" addressbook.csv
					echo
					echo "Contact updated successfully!"
				fi
			done
		fi
		echo
	done		
}

# delete a record - no parameters
# search using either email or last name
deleteContact()
{
	echo 
	while true
	do
		echo "Enter any search term, e.g. last name or email address."
		echo "Enter data or q to quit"
		read rInput
		if [ "$rInput" == 'q' ]
			then
			break
		fi
		echo
		echo "Listing contacts for \"$rInput\":"
        # searching for a record
		grep -n "$rInput" addressbook.csv
		RETURNSTATUS=`echo $?`
        # did not find anything
		if [ $RETURNSTATUS -eq 1 ]
			then
			echo "No contacts found for \"$rInput\""
        # found some records
		else
			echo
			echo "Enter the line number (the first number of the entry) of the record you want to remove."
			read lineNumber
            echo
            # loop and display the results
			for line in `grep -n "$rInput" addressbook.csv`
			do
				number=`echo "$line" | cut -c1`
				if [ $number -eq $lineNumber ]
					then
					lineRemove="${lineNumber}d"
					sed -i -e "$lineRemove" addressbook.csv
					echo "Contact removed from the address book."
				fi
			done
		fi
		echo
	done
}


# start of program

# checking to make sure the .csv file ends with newline character
echo
lastCharOfFile=`tail -c 1 addressbook.csv`
if [ -n "$lastCharOfFile" ]
	then
	echo >> addressbook.csv
fi
# instructions
echo "Hey, welcome to your address book!"
echo "Select an action to perform:"
echo "add) to add a record"
echo "search) to search 1 or more contacts"
echo "edit) to edit a record"
echo "remove) to remove a single record"
echo "all) display all contacts"
echo
read input

# switch statement to determine what to do
case $input in
	add) Contact;;
	search) searchContact;;
	edit) editContact;;
	remove) deleteContact;;
	all) displayAll;;
esac

# end of program
echo
cat <<EOF   
Changed saved and address book closed. Bye!
EOF
echo
