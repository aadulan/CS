#Prints a number in binary



 .data # starts the data segment of the program
 promtp1:        .asciiz  "Enter a number.\n" #loads a string, first word is the name of the string
 outmsg:        .asciiz  " The number in binary is:\n" #loads a strimg,first word is the name of the string
 
         .global main #declares the golbal symbols of this variable
         
         .text
         
main:
       #prompt for user to input a number
       li $v0, 4 #printing the string promt1 loading immediate
       la $a0  promtp1 #loading the string address
       syscall
       
       #get a number from a user
       li $v0,5 # reading the int
       syscall
       
       add $s0, $zero, $v0 #keep the number in $s0
       
       #output message
       li $v0, 4 #printing the message
       la $a0,outmsg
       syscall 
       
       #sets the loop counter
        li   $t0, 32  #  32-bit number when the user inputs the number it comes as a string- reads the string


       #shift to the right yto get the first bit and print it out 
loop:      srl $t1, $s0, 31 
        j print 

 
         
        


print:  li $v0, 1
       add $a0, $zero,$t1 # puts the value of t1 into a0
       syscall #prints the ascii character 
       
            #prepare for the next iteration in the loop 
             sll  $s0,$s0, 1 # shifting to the left by one bit to the get the next digit
             addi $t0, $t0, -1 # decreasing the loop by minus one 
             bne $t0,$0, loop # Still not 0?, go to loop if the two values are not equal then go back to the loop
              
              
              #end of the program 
              li $v0, 10 #exit the program
              syscall
                     