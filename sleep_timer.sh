#! /bin/bash

#-------------------------------------------
#Created by Johan van der Merwe (2021/05/20)
#Last Updated (2021/05/20)
#
#[DESCRIPTION]
#Use date to calculate the next day and set a user-defined time to wake up the next day using rtcwake
#
#[USAGE]
# sleep_scheduler [hh] [mm]
# sleep_scheduler 08 00
#-------------------------------------------

#Set year/month/day/century/hour values using `date`s built-in format options
YY=`date +%y`
MM=`date +%m`
DD=`date +%d`
CC=`date +%C`
HH=`date +%H`

#Log file
LOGF=.sleep_scheduler.txt
printf "Log File -\n" > $LOGF

#Print ran date to log file
echo -e "Ran date is\t\t : $CC$YY-$MM-$DD [notcalculated] | (CCYY-MM-DD) " >> $LOGF

#Reset Month and Date Function
function resetMonth {
	DD=1
	MM=$((MM + 1))	
}

#Checks if the wake-up date is the same day
if ((HH <= $1)) 
then
	DD=$DD
else
	if (($1 < HH)) || (($1 != HH))
	then
		DD=$((DD+1))
	fi
fi

#Check for Feb Leap Year
if (($MM == 2))
then
	if (($YY % 4 == 0))
	then
		if (($DD >= 30))
		then
			resetMonth
		fi
	else
		if (($DD >= 29))
		then
			resetMonth
		fi
	fi
fi

#Check 31st month
if (($MM == 1)) || (($MM == 3)) || (($MM == 5)) || (($MM == 7)) || (($MM == 8)) || (($MM == 10))
then
	if (($DD >= 32)) 
	then
		resetMonth
	fi
else
	if (($DD >= 31)) && (($MM != 12))
	then
		resetMonth
	fi
fi

#Check year end switch
if (($MM >= 12)) && ((DD >= 31)) 
then
	YY=$((YY + 1))
	MM=1
	DD=1
fi

#check century end
if (($YY >= 100))
then
	CC=$((CC + 1))
	YY=00
fi

#set final formatted date
CALDATE="$CC$YY-$MM-$DD $1:$2"


#log calculated date and rtcwake command
echo -e "Calculated date is\t : $CALDATE | (CCYY-MM-DD)" >> $LOGF
echo -e "sudo rtcwake -l --date $CALDATE -m mem" >> $LOGF

#rtcwake command
#options using [-l, local time] [--date, for wake date] [-m mem, for suspend to memory]
sudo rtcwake -l --date "$CALDATE" -m mem 1>> $LOGF