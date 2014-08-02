Grumboz_Lottory_System
====================

Ok Guyz here it is:
Grumbo'z Lottery System

this is a fun system.
players can go to a lottory vendor and enter the lottery multiple times if they can affor it.
all the currency spent on entries will go into a pot.
the timer will trigger a script 'tally' to fire
this will choose at random a player who has entered the lottery :
  IF the player exsists AND IF the player is online then they will recieve the pot plus a multiplier for there own entries and all entries will be flushed.
  otherwise a new timer will start with the previous entries included.

the multiplier max value can be changed in the sql table lotto.settings.rndmax .
the minimum required players can be changed in the sql table lotto.settings.require .
system can be turned on/off in the sql table lotto.settings.operation
the custom currency id can also be changed within the sql table.
the amount of currency required can be changed within the sql table.
the way it operates can be changed in the sql table.
