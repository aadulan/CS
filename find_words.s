
#INF2C- Introduction to Computer Systems
#Coursework Assignment 1 - Task A 


.data                                                      #starts the sata segment of the program 

enter_input:      .asciiz "\nEnter input: "                #loads the the string "Enter input"
my_sentence :     .space 1001                              #reserve 1000 bytes for the sentence and an extra byte for the null character 
out_put:          .asciiz "\noutput:"                      #
new_line :        .asciiz "\n"                             #loads a new line
word:             .word  50                                #where the loop stores the word that needs to be outputter
null_character:   .asciiz "\0"                             #the null charatcer 
 


.globl main                                                #int main() 
                                                           #this is where the actual program starts

.text                                                      #starts the text segment of the program 
          
                                                           #define false 0
                                                           #define true 1
                                                           #checks wheather the character is a hypen
                      
                                                           #checks wheather it is a valid character
                                                           #int is_valid_character(char ch)
                                                           #

is_valid_character:                                        #else if(ch>= 'A' && ch<='Z') {return true;}
                     slti $t0,$t1, 91                      #if the ascii value is less than 91, then set  $t0 to 1
                     sge  $t0,$t1, 65                      #if the ascii value is greater or equal to 65  then set $t0 to 1
                     bne  $t0, $zero, process_input        #if not equal to 0 go to process input 
                    
                                                           #if(ch>= 'a' && ch<= 'z'){return true;}
                     slti $t0,$t1,123                      #if the ascii value is less than 123, then set $t0 to 1 
                     sge  $t0,$t1,97                       #if the ascii value is greater or equal to 97 then set $t0 to 1.
                     bne  $t0,$zero, process_input         #if not equal to go 0 go to process input 
                    
                                                           #else {return false}
                     beq $t0,$zero, process_input          #if false return to process _input
                    
                     jr $ra                                #return to main
                       
                                                           #checks wheather it is a hypen
                                                           #int is_hypen(char ch)

is_hypen:                    
                                                           #translated C code - if(ch =='-'){
                     slti $t0,$t1, 46                      #if the ascii value is less than 46, then set $t0 to 1.
                     sge $t0,$t1 ,45                       #if the ascii value us greater or equal to 45 set $t0 to 1
                                                           #translated C code- return true
                     bne $t0, $zero, process_input         # if not equal to 0 go to process input
                                                           # return false
                     beq $t0, $zero, process_input         #if not equal to 1 go to process input 
            
                     jr $ra                                #return to main 
                     
                     
output:                                                    #printing a new line 
                    li $v0, 4                              #load immediate, printing the string 
                    la $a0, new_line                       #loading the string address of new_line
                    syscall
                    
                                                           #printing a new word
                    li $v0,  4                             #load immediate, printing the string
                    la $a0, word                           #loading the string address of word
                    syscall 
        

main:    # Entry point of the program 
          
                                                          #prints out the string enter_input
                     la $a0, enter_input                  #load string address - make $a0 to where the message is 
                     li $v0, 4                            #load immediate  - prints the string "Enter input"
                     syscall                              # Calls the OS to print the message  
                                                          #Translated C code - print_string("\nEnter input: ");
                               
                                                          #Get the sentence from the user
                                                          #{fgets(s,size, stdin);}
                     la $a0, my_sentence                  #read_input(input_sentence);
                     li $a1, 1001 
                     li $v0, 8                            #load the string the user inputs into $s0
                     syscall
                     move $s0,$a1                         # moves the string input to $s0
                     
                     
          
                                                          #output sentence for the word
                     li $v0,4                             #loading the string address
                     la $a0, out_put                      #load the string address into $a0 and print it out  
                     syscall                              #print_string("\noutput:\n");
                     
                     jal process_input                    #go to process input 
                     beq $t0,1,out_put                    #if(word_found ==true) output(word);
                                                           
                                                          # checking every character 
process_input:     
                     
                     la   $t4, null_character             #char cur_char = '\0';
                     li   $t5, 0                          #int is_valid_ch = false; 
                     addi $t3, $zero, -1                  #int char_inex =-1;
                     beq  $t2, 0 ,  while                 #while(end_of_sentence == false)
                     
                     lw $t1, 0($s0)                       #load the first byte from the string which is in address in     
                     
                     li $t0, 0                            #returning false - return false;
                     
                     jr $ra
                     
                     


while:                                                   # while loop of process input
                                                         # loop runs until end of an input sentence is encoutnred or a valid word is extracted
                    li $s2, 0                            # int input_index
                    la  $t6,0($s0)                       #cur_char = inp[input_index];
                    addi $s2,$s2, 1                      #input+index++;
                    addi $s0,$s0,1                       #increasing the incriment by one.
                    
                    jal is_valid_character               #is_valid_ch = is_valid_character(cur_char);
                    beq $t0, 1, if                       # if it is a valid character then branch to if
                    
                    la   $t9, new_line                   #loading address of new line into $t9
                    seq  $t7, $t6, $t9                   #set $t7 to true if the current character equal
                    
                    la  $t9, null_character              #loading address of null_character into $t9
                    seq $t8, $t6, $t9                    #set $t7 to true if the currennt character is equal to the nyl
                    or  $t7, $t7,$t8                     #if(cur_char == '\n' || cur_char == '\0')
                    beq $t7, 1, end                      #if the if statement is true then jump to function end 
                    
                    bge $t3, 0 , if2                     #if( char_index >= 0) the go to if2 
                    
                    la  $s3,word                         #loading the address of word into $s3
                    la  $t9, null_character              #loading address of null _character into $t9
                    la   $t0,0($t9)                        #setting the first letter of the word as the null character
                    addi $t3,$zero, -1                   #char_index =-1;

                                                          
if:                 la $s3, word                          #loading word into $s3
                    la $s3, 0($t4)                          #w[++char_index] = cur_char;
                    
                    jr $ra
                    
if2:                                                      #w has accumlated some valid charatcers.Thus,punctuation mark indicates a possible end of word.
                    jal is_hypen                          # checks wheather the letter is a hypen
                    jal is_valid_character                #checks wheather the next letter is a valid charatcer
                    
                                                          #if(is_hypen(cur_char) == true && is_valid_character(input[input_index]))
                    and $t9,$t0, $t1                      #checks wheather the current character is a hypen and wheather the next character is a letter 
                    
                    beq $t9,1, next_char                  #if it is equal to one then do this 
                    
                    addi $t3,$t3, 1                        #char_index++;
                    la   $s3,word                          #loading word into $s3
                    la   $t5,null_character                #loading address of null character into $t5
                    la   $s3,0($t5)                        #w[char_index]='\0';
                    
                    jr $ra
                    
next_char:          la $s3,word                           #loading word into $s3
                    sll $s3,$s3, 1                        #shifting $s3 by 1 to fill in the next chacter.
                    la $s3 ,($t4)                           #storing the next character  -w[++char_index] =cur_char;
                    
                   
                    
                    
                    
                    addi $t0, $zero, 1                     #return true;
                    j while                                #continue;
                    
                                                           #indicates the end of an input sentence
end:                addi $t2,$t2, 1                        #end _of_sentence = true; 
                    jr $ra
    
          
          
          
                                                           #Exit the program 
                     li $v0, 10 
                     syscall
          
          
          
                               
          

  
