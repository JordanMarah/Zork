    org $1000

*-------------------------------------------------------
*Choose to be Evil Wizard or New Romancers
*-------------------------------------------------------

*-------------------------------------------------------
*Validation values to be used, modify as needed
*Add additional validation values as required
*-------------------------------------------------------
exit        EQU 0      used to exit assembly program
min_feed    EQU 100    min feed requirement
min_horses  EQU 1      min number of horses
max_horses  EQU 9      max number of horses
min_soldier EQU 6      min soldiers
min_charge  EQU 1      min rate of fuel use based of speed (oats for horses)
max_charge  EQU 5      max rate e.g. Flank       
hit_point   EQU 5      points accumilated on castle (objective) strike
miss_point  EQU 8      points deducted for ordinace miss

mine_loc    EQU 100    example for a hit


*Start of Game
start:
    ;move.b  #100,$4000 put score/health in memory location $4000
    ;lea     $4000,A3   assign address A3 to that memory location


    bsr     welcome    branch to the welcome subroutine
    ;bsr     input      branch to the input subroutine
    bsr     game       branch to the game subroutine
*Game loop
    org     $3000      the rest of the program is to be located from 3000 onwards

*-------------------------------------------------------
*-------------------Game Subroutine---------------------
*-------------------------------------------------------
game:
    bsr     gameloop   branch to gameloop subroutine
    rts                return from game: subroutine
          
end:
    simhalt

*-------------------------------------------------------
*-------------------Welcome Subroutine------------------
*-------------------------------------------------------
welcome:
    bsr     endl            branch to endl subroutine
    lea     welcome_msg,A1  assign message to address register A1
    move.b  #14,D0          move literal 14 to DO
    trap    #15             trap and interpret value in D0
    bsr     endl            branch to endl subroutine
    rts                     return from welcome: subroutine

*-------------------------------------------------------
*---------Gameplay Input Values Subroutine--------------
*-------------------------------------------------------    
input:
    bsr     feed            branch to feed input subroutine
    bsr     horses          branch to ship input subroutine
    bsr     rate            branch to rate (charging speed) input subroutine
    bsr     distance        branch to mission distance/location input subroutine
    bsr     soldiers        branch to soldiers input subroutine
    rts

*-------------------------------------------------------
*----------------Gameloop (main loop)-------------------
*------------------------------------------------------- 
gameloop:
    bsr     update          branch to update game subroutine 
    bsr     clear_screen    clears the screen         
    bsr     draw            branch to draw screen subroutine
    bsr     clear_screen    clears the screen
    bsr     gameplay        branch to gameplay subroutine
    bsr     clear_screen    clears the screen
    bsr     hud             branch to display HUD subroutine
    bsr     clear_screen    clears the screen
    bsr     replay          branch to replay game subroutine
    bsr     clear_screen    clears the screen
    rts                     return from gameloop: subroutine

*-------------------------------------------------------
*---------------Update Mission Progress-----------------
*  Move to battle location, engage enemy, fire and take
*  fire, complete mission and return to base
*------------------------------------------------------- 
update:
    bsr     endl            print a CR and LF
    bsr     decorate        decorate with dots using a loop
    lea     update_msg,A1   
    move.b  #14,D0
    trap    #15
    bsr     decorate
    rts
*-------------------------------------------------------
*---------------Draw Mission Updates--------------------
* Draw the game progress information, status regarding
* mission
*------------------------------------------------------- 
draw:
    bsr     endl
    bsr     decorate
    lea     draw_msg,A1
    move.b  #14,D0
    trap    #15
    bsr     decorate
    rts
*-------------------------------------------------------
*-----------------------Horse feed-----------------------
* Input the feed load for each horse. Feed costs money
* For an advanced mark you need to manage this resource
*------------------------------------------------------- 
feed:
    bsr     endl
    bsr     decorate
    lea     feed_msg,A1
    move.b  #14,D0
    trap    #15
    bsr     decorate
    rts

*-------------------------------------------------------
*--------------------Horses Inventory---------------------
* Number of horses to be allocated to a mission 
*------------------------------------------------------- 
horses:
    bsr     endl
    bsr     decorate
    lea     horses_msg,A1
    move.b  #14,D0
    trap    #15
    bsr     decorate
    rts

*-------------------------------------------------------
*-------------------Horse(s) Charge Speed---------------
* horses speed to and from a mission
*------------------------------------------------------- 
rate:
    bsr     endl
    bsr     decorate
    lea     rate_msg,A1
    move.b  #14,D0
    trap    #15
    bsr     decorate
    rts

*-------------------------------------------------------
*------------------Mission Distance---------------------
* Distance to battle location
*------------------------------------------------------- 
distance:
    bsr     endl
    bsr     decorate
    lea     distance_msg,A1
    move.b  #14,D0
    trap    #15
    bsr     decorate
    rts

*-------------------------------------------------------
*-----------------------Soldiers----------------------
* Number of soldiers
*-------------------------------------------------------   
soldiers:
    bsr     endl
    bsr     decorate
    lea     soldiers_msg,A1
    move.b  #14,D0
    trap    #15
    bsr     decorate
    rts

*-------------------------------------------------------
*---Game Play (Mission Progress, Battle Maneuvers)------
*------------------------------------------------------- 
gameplay:
    bsr     endl
    bsr     decorate
    ;lea     gameplay_msg,A1
   ; move.b  #14,D0
   ; trap    #15
    bsr     opening
    bsr     returnToCamp
    bsr     littleGirl
    bsr     amuletTalk
    bsr     town
    bsr     leaveShop
    bsr     decorate
    rts
    
 *--------------------------
 *Opening
 *-------------
 opening:
    move.b  #100,D4
    bsr     endl
    bsr     decorate
    lea     opening_msg,A1
    bsr     display
    bsr     decorate
    lea     opening_question,A1
    bsr     user
    cmp     #1,D1
    beq     field
    cmp     #2,D1
    beq     lake
    rts
 field:
    bsr     endl
    bsr     decorate
    lea     field_para,A1
    bsr     display
    bsr     user
    cmp     #1,D1
    beq     goblinattack
    cmp     #2,D1
    beq     goblinsneak
   
    
 
 lake:
     bsr     endl
    bsr     decorate
    lea     lake_para,A1
     bsr     display
    bsr     user
    cmp     #1,D1
    beq     skeletonattack
    cmp     #2,D1
    beq     skeletonsneak
   
goblinattack:
     bsr     endl
    bsr     decorate
    lea     goblin_attack,A1
    bsr     display
 
    add     #10,D5
    sub     #10,D4
    rts

goblinsneak:
    bsr     endl
    bsr     decorate
    lea     goblin_sneak,A1
     bsr     display
 
    add     #5,D5
    rts
skeletonattack:
     bsr     endl
    bsr     decorate
    lea     skeleton_attack,A1
 
    bsr     display
    add     #10,D5
    sub     #10,D4
    rts
skeletonsneak:
    bsr     endl
    bsr     decorate
    lea     skeleton_sneak,A1
   
    bsr     display
    add     #5,D5
    rts
    
 *-------------------------------------------------------
*---Scene2------
*------------------------------------------------------- 
returnToCamp:
    bsr     hud
    bsr     endl
    bsr     decorate
    lea     return_camp,A1
    bsr     display
    lea     young_girl,A1
    bsr     display
    bsr     endl
    bsr     decorate
    lea     young_girl_response,A1
    bsr     display
    bsr     user
    rts
littleGirl:
    lea     young_girl_leaving,A1
    bsr     display
    bsr     user
    cmp     #1,D1
    beq     leave
    cmp     #2,D1
    beq     stay
leave:
    bsr     endl
    bsr     decorate
    lea     girlLeaves,A1
    bsr     display
    bsr     user
    rts
stay:
     bsr    endl
    bsr     decorate
    lea     girlStay,A1
    bsr     display
    bsr     user
    rts
amuletTalk:
    bsr endl
    bsr decorate
    lea askWizardAndPrincess,A1
    bsr display
    bsr     user
    rts
    
 *-------------------------------------------------------
*---Town------
*------------------------------------------------------- 

town:
    bsr endl
    bsr decorate
    lea moveToTown,A1
    bsr display
    bsr user
    cmp #0,D1
    beq buy3Mercinaries
    cmp #1,D1
    beq buy2Mercinaries
    cmp #2,D1
    beq buy1Mercinaries
    cmp #3,D1
    ;beq leaveTown
    rts
    
buy1Mercinaries:
    lea mercinaries1,A1
    bsr display
    rts
buy2Mercinaries:
   lea mercinaries2,A1
   bsr display
   rts
buy3Mercinaries:
   lea mercinaries2,A1
   bsr display
   rts
leaveShop:  
    bsr endl
    bsr decorate
    lea leaveTown,A1
    bsr display
    bsr user
      
*-------------------------------------------------------
*-----------------Heads Up Display (Score)--------------
* Retrieves the score from memory location
*-------------------------------------------------------   
hud:

    bsr     endl
    bsr     decorate
    lea     hud_msg,A1
    move.b  #14,D0
    trap    #15
    move.b  D5,D1     retrieve the value A5 point to and move to D1
    move.b  #3,D0       move literal 3 to D0
    trap    #15         intrepret value in D0, which 3 which displays D1
    lea     hud_msg2,A1
    move.b  #14,D0
    trap    #15
    move.b  D4,D1     retrieve the value A3 point to and move to D1
    move.b  #3,D0       move literal 3 to D0
    trap    #15   
    bsr     decorate
    rts

*-------------------------------------------------------
*-----------------------Taking Fire---------------------
* This could be used for collision detection, if 
*-------------------------------------------------------
collision:
    move.b  #mine_loc,D1
    cmp     #100,D1 is( x == 100)?
	bne     collision_miss if x is equal to 100, then hit
collision_hit:
    *hit
    lea     hit_msg,A1
    move    #14,D0
    trap    #15
    rts
    
collision_miss:
    *miss
    lea     miss_msg,A1
    move    #14,D0
    trap    #15
    rts
display:	
    MOVE	#14,D0
	TRAP	#15
	MOVEM.L	D0/A1,-(A7)
	MOVE	#14,D0
	LEA	crlf,A1
	TRAP	#15
	MOVEM.L	(A7)+,D0/A1
	RTS
user:
    move.b  #4,D0
    trap    #15
*-------------------------------------------------------
*--------------------------Loop-------------------------
*-------------------------------------------------------
loop:
    move.b  #5, D3 loop counter D3=5
next:
    lea     loop_msg,A1
    move.b  #14,D0
    trap    #15
	sub     #1,D3   decrement loop counter
    bne     next    repeat until D0=0

*-------------------------------------------------------
*------------------Screen Decoration--------------------
*-------------------------------------------------------
decorate:
    move.b  #60, D3
    bsr     endl
out:
    lea     loop_msg,A1
    move.b  #14,D0
    trap    #15
	sub     #1,D3   decrement loop counter
    bne     out	    repeat until D0=0
    bsr     endl
    rts
    
clear_screen: 
    move.b  #11,D0      clear screen
    move.w  #$ff00,D1
    trap    #15
    rts
*-------------------------------------------------------
*------------------------Replay-------------------------
*-------------------------------------------------------
replay:
    bsr     endl
    lea     replay_msg,A1
    move.b  #14,D0
    trap    #15
    
    move.b  #4,D0
    trap    #15

    cmp     #exit,D1
    beq     end         if SR Z register contains 1 beq => Branch Equals
    bsr     gameloop

endl:
    movem.l D0/A1,-(A7)
    move    #14,D0
    lea     crlf,A1
    trap    #15
    movem.l (A7)+,D0/A1
    rts
    
*-------------------------------------------------------
*-------------------Data Delarations--------------------
*-------------------------------------------------------

crlf:           dc.b    $0D,$0A,0
welcome_msg:    dc.b    '************************************************************'
                dc.b    $0D,$0A
                dc.b    'ZorkQuest: Assault on Egreth Castle'
                dc.b    $0D,$0A
                dc.b    '************************************************************'
                dc.b    $0D,$0A,0
opening_msg:    dc.b    'Suddenly, you awake in an unfamiliar part of the woods.'
                dc.b    $0D,$0A
                dc.b    'Your friends are nowhere to be seen. All you have on your'
                dc.b    $0D,$0A
                dc.b    'person is your sword and your bow. You hear the faint screams'
                dc.b    $0D,$0A
                dc.b    'of your friends, perhaps? But you cant make out if its coming'
                dc.b    $0D,$0A
                dc.b    'from the nearby fields or the lake.'
                dc.b    $0D,$0A
opening_question dc.b   '1. Field     2. Lake',0

field_para      dc.b    'You sprint as fast as you can towards the field as the screaming'
                dc.b    $0D,$0A
                dc.b    'gets louder, its a male voice. It could be the wizards apprentice'
                dc.b    $0D,$0A
                dc.b    'as you approach you see 2 hobgoblins attacking the boy'
                dc.b    $0D,$0A
                dc.b    '1. Charge at them with your sword      2. Sneak and take them out with bow',0
lake_para      dc.b    'You sprint as fast as you can towards the lake as the screaming'
                dc.b    $0D,$0A
                dc.b    'gets louder, its a male voice. It could be the cart driver'
                dc.b    $0D,$0A
                dc.b    'as you approach you see 2 skeletons attacking the driver'
                dc.b    $0D,$0A
                dc.b    '1. Charge at them with your sword      2. Sneak and take them out with bow',0
goblin_attack   dc.b    'You charge at the goblins and slice through the first with ease.'
                dc.b    $0D,$0A
                dc.b    'The other goblin slashes at you with a dagger before you cut him down'
                dc.b    $0D,$0A
                dc.b    'You save the boy but you have been wounded (-10 Health)(+10 Score)',0
skeleton_attack   dc.b   'You charge at the skeletons and slice through the first with ease.'
                dc.b    $0D,$0A
                dc.b    'The other skeleton slashes at you with a dagger before you cut him down'
                dc.b    $0D,$0A
                dc.b    'You save the boy but you have been wounded (-10 Health)(+10 Score)',0
goblin_sneak   dc.b    'You quietly equip your bow and take the first goblin out'
                dc.b    $0D,$0A
                dc.b    'Before the other can react, you put an arrow in its skull'
                dc.b    $0D,$0A
                dc.b    'The boy is hurt, you take him back to the camp to regroup (+5 Score)',0
skeleton_sneak   dc.b   'You quietly equip your bow and take the first skeleton out'
                dc.b    $0D,$0A
                dc.b    'Before the other can react, you put an arrow in its skull'
                dc.b    $0D,$0A
                dc.b    'The boy is hurt, you take him back to the camp to regroup (+5 Score)',0
return_camp     dc.b    'You return to the camp to find everything has been ransacked but'
                dc.b    $0D,$0A
                dc.b    'everyone appears to be unscathed, nobody knows why this has happened.'
                dc.b    $0D,$0A
                dc.b    'Suddenly there is a rumbling in the bushes, everyone turns to face the expected foe'
                dc.b    $0D,$0A
                dc.b    '...........'
                dc.b    $0D,$0A
                dc.b    'A young girl walks out..',0
young_girl      dc.b   'She approaches you, looking frightened',0
young_girl_response
                dc.b    '"I think this is for you, I found it on one of the bodies you slayed"'
                dc.b    $0D,$0A
                dc.b    'She hands you a parchment with your name and face on it, information'
                dc.b    $0D,$0A
                dc.b    'about the princess that is travelling with you and a picture of'
                dc.b    $0D,$0A
                dc.b    'the amulet that she wears',0
young_girl_leaving      dc.b   'The  little girl begins to walk away'
                dc.b    $0D,$0A
                dc.b    '1. Let her leave  2. Ask her to join you, the driver, the princess,' 
                dc.b     $0D,$0A
                dc.b    'the warrior, the wizard and his apprentice',0 
girlLeaves      dc.b   'She walks away into the darkness',0
   
girlStay      dc.b   'The girl nods her head and sits on the ground waiting for something to happen',0

askWizardAndPrincess dc.b 'You go into the princesses tent where you see her crying, she tells you that'
                    dc.b  $0D,$0A
                    dc.b   'the amulet was passed down from her mother and shes desperate to get it back.'
                     dc.b  $0D,$0A
                     dc.b   'You tell her you will get it back (you are infatuated with her after all)'
                      dc.b  $0D,$0A
                      dc.b  'You leave her tent and the wizard approaches you and asks to speak in private'
                       dc.b  $0D,$0A
                       dc.b 'He tells you that her amulet is the source of a great deal of magical energy'
                        dc.b  $0D,$0A
                        dc.b 'and he believe its been taken to Egreth Castle by Evil Wizard who lives there.'
                         dc.b  $0D,$0A
                         dc.b  '"We must retrieve the amulet, or else, we could be in grave danger"',0
moveToTown dc.b 'You decide that you and your gang will move toward Egreth Castle...'
                    dc.b  $0D,$0A
                    dc.b   'The next day you all start moving toward Egreth Castle.'
                     dc.b  $0D,$0A
                     dc.b   'There is a village on the way, you stop to prepare for the attack'
                      dc.b  $0D,$0A
                      dc.b  'There is a tavern in the town, the wizard, the warrior and yourself'
                       dc.b  $0D,$0A
                       dc.b 'enter the tavern. You ask the innkeeper about mercinaries,horses'
                        dc.b  $0D,$0A
                        dc.b 'and weapons. You have 300 gold between you. A horse costs 100 and a'
                         dc.b  $0D,$0A
                         dc.b  'mercinary costs 100'
                         dc.b '"How many horses would you like?"',0 
mercinaries1:       dc.b    'You decide to buy two horses and 1 mercinary',0  
mercinaries2:       dc.b    'You buy a horse and two mercinaries',0 
mercinaries3:       dc.b    'You dont want a horse? You buy 3 mercinarie',0 

leaveTown     dc.b   'You all leave the town together and hope to get to Egreth Castle by night',0
                                 
feed_msg:       dc.b    'Feed load (each horse needs at least 100 units of feed)'
                dc.b    $0D,$0A
                dc.b    'Enter feed load : ',0
horses_msg:      dc.b    'Number of horses : ',0
rate_msg:       dc.b    'One Third[1], Two Thirds[2], Standard Charge[3], ' 
                dc.b    $0D,$0A
                dc.b    'Full Charge[4], Flank Charge[5] units feed per click'
                dc.b    $0D,$0A
                dc.b    'Enter Speed : ',0
distance_msg:   dc.b    'Mission distance e.g. 40 (with 100 units of feed  '
                dc.b    $0D,$0A
                dc.b    'One Third speed 20 units remain for manuvouirs) horses '
                dc.b    $0D,$0A
                dc.b    'Horses without feed are lost.'
                dc.b    $0D,$0A
                dc.b    'Enter mission distance : ',0
soldiers_msg:       dc.b    'Each horses need at least 1 Knight and an Stable Hand'
                dc.b    $0D,$0A
                dc.b    'minimum requirement is 2 i.e. Stable Hand x 1 and Knight x 1.'
                dc.b    $0D,$0A
                dc.b    'Enter # of soldiers : ',0
gameplay_msg:   dc.b    'Add Gameplay !',0
update_msg:     dc.b    'Update Gameplay !',0
draw_msg:       dc.b    'Draw Screen !',0
hit_msg:        dc.b    'Strike!',0
miss_msg:       dc.b    'Miss!',0
loop_msg:       dc.b    '.',0
replay_msg:     dc.b    'Enter 0 to Quit any other number to replay : ',0
hud_msg:        dc.b    ' Score : ',0
hud_msg2:       dc.b    ' Health : ',0

health:     ds.w    1
score:      ds.w    1 reserve space for score

    end start







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
