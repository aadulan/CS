# Prints a number in hexadecimal, digit by digit.
# 
# Written by Aris Efthymiou, 16/08/2005
# Based on hex.s program from U. of Manchester for the ARM ISA

        .data    # starts the data segment of the program
prompt1:        .asciiz  "Enter decimal number.\n"     # loads a string   first word here is the name of the string
outmsg:         .asciiz  "The number in hex representation is:\n"    # loads a string 
minus:            .asciiz   "-"   #negative sign

        .globl main

        .text
main:   
        # prompt for input
        li   $v0, 4 # printing the string prompt1 loading immediate
        la   $a0, prompt1 # loading the string address
        syscall

        # Get number from user
        li   $v0, 5 # reading the int
        syscall

        add  $s0, $zero, $v0  # Keep the number in $s0,

        # Output message
        li   $v0, 4 # printing the message 
        la   $a0, outmsg
        syscall
        
        #print sign if needed 
        slti  $t2, $s0, 0    #set less than immediate, checks if the digit is less than 0 -if its true put 1 in the register
        beq   $t2, $zero, norm            #branch if the two numbers are equal - then do the everything normally
        li    $v0, 4 #printing the string negative sign 
        la    $a0, minus # loading the string address
        syscall
        
        #deals with negative
        lui $t3, 0xffff # load upper immediate , 16 bits all 1s , only the bottom half 
        ori $t3, $t3 , 0xffff #bitwise or immediate, creating another 16s
        xor  $s0, $t3, $s0    # xor it and place it into register flipping each bit 
        addi $s0, $s0, 1 # adding 1 to to create 2's complement 
        j norm     # jump to normal
        

 norm:       # set up the loop counter variable
        li   $t0, 8  # 8 hex digits in a 32-bit number when the user inputs the number it comes as a string- reads the string
        
        li   $t5, 0,  # loading immediate, checking for zeros 

        # Main loop
loop:   srl  $t1, $s0, 28  # get leftmost digit by shifting it   shifting the number by 28 bits
                           # to the 4 least significant bits of $t1
                           

        # The following instructions convert the number to a char
        slti $t2, $t1, 10  # t2 is set to 1(true) if $t1( 4 bit number) < 10,  
        beq  $t2, $0,  over10  # branches(excutes an instruction) to over10 if the two quantites are equal 
        addi  $t1, $t1, 48 # ASCII for '0' is 48 adding the number 48 to what is in register $t1 ( if the number is under 10)
        j    print # jumps to the address at print 
over10: addi  $t1, $t1, 55 # convert to ASCII for A-F
                           # ASCII code for 'A' is 65
                           # Use 55 because $t1 is over 10

        # Print one digit
print:  beq  $t5, 1  print0 # branch if equal to not leading zeros
        beq  $t1, 48 print2 # branch if equal to ASCII zero
        
print0: li $t5 , 1 #load immediate adds an 1 
        
        li   $v0, 11 # prints the char
        add  $a0, $zero, $t1 # puts the value of $t1 into $a0
        syscall            # Print ASCII char in $a0
        
print2:         

        # Prepare for next iteration
        sll  $s0, $s0, 4   # Drop current leftmost digit shift left logical.
        addi $t0, $t0, -1  # Update loop counter- starts from 8 -1 as the counter is decreasing
        bne  $t0, $0, loop # Still not 0?, go to loop if the two values are not equal then go back to the loop

        # end the program
        li   $v0, 10 # exit the program
        syscall
