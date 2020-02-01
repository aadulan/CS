
#INF2C- Introduction to Computer Systems
#Coursework Assignment 1 - Task A


.data                                           #starts the sata segment of the program

enter_input:          .asciiz "\nEnter input: " #loads the the string "Enter input"
my_sentence:          .space 1001               #reserve 1000 bytes for the sentence and an extra byte for the null character
out_put:              .asciiz "\noutput:"       #is the output sentence before words are found
sentence_length:      .word 1000                #sentence length exlcuding the null character 1000
word_length:          .word 50                  #word length set to 50
new_line:             .asciiz "\n"              #loads a new line
word:                 .space  50                #where the loop stores the word that needs to be outputter
null_character:       .ascii "\0"               #the null charatcer
hyphen:               .asciiz "-"               #the hyphen

.globl main                                     #int main()
                                                #this is where the actual program starts

.text                                           #starts the text segment of the program
                                                #define false 0
                                                #define true 1

                                                #checks wheather it is a valid character
                                                #int is_valid_character(char ch)
is_valid_character:                             #else if(ch>= 'A' && ch<='Z') {return true;}
    slti $t0,$a0, 91                            #if the ascii value is less than 91, then set  $t0 to 1
    sge  $t1,$a0, 65                            #if the ascii value is greater or equal to 65  then set $t0 to 1
    and  $t0,$t0, $t1                           #checking whether the two conditions hold

                                                #if(ch>= 'a' && ch<= 'z'){return true;}
    slti $t1,$a0,123                            #if the ascii value is less than 123, then set $t0 to 1
    sge  $t2,$a0,97                             #if the ascii value is greater or equal to 97 then set $t0 to 1.
    and  $t1,$t1,$t2                            #checking whether the two conditions hold

    or   $v0,$t0,$t1                            #checks whether either condition holds

    jr $ra                                      #return to main

is_new_line:
    lb  $t0, new_line                           #loading address of new_line into $t0
    seq $v0,$a0,$t0                             #if the character is a new line, set to true

    jr $ra                                      #return to process input

is_null_character:
    lb  $t0, null_character                     #loading address of null_character into $t0
    seq $v1,$a0,$t0                             #if the character is a new line, set to true

    jr $ra                                      #return to process input

end_of_sentence:
    bgez $s1, output_end                        #checks whether $s1 is 1,if it is then it ouputs the word


 output_end:
                                                #printing a new line
    li $v0, 4                                   #load immediate, printing the string
    la $a0, new_line                            #loading the string address of new_line
    syscall

                                                #printing a new word
    li $v0,  4                                  #load immediate, printing the string
    la $a0, word                                #loading the string address of word
    syscall

    li $v0, 10                                  #exits the program
    syscall

is_a_word:
    jal is_hyphen                               #checks wheather the current character is a hypen

    lb $a0,my_sentence($s0)                     #loading the next character

    jal is_valid_character                      #checks whether the next character is a valid character

    addi $t0,$s0,-1                             #finding the orginal index of input_index
    lb $a0, my_sentence($t0)                    #going back to the original character

    and $t0,$v0,$v1                             #check whether both conditions hold
    beq $t0,1, next_character                   #if(is_hyphen(cur_char) == true && is_valid_character(inp[input_index]))

    addi $s1, $s1, 1                            #char_index++
    lb   $t0, null_character                    #loading address of null_character
    sb   $t0,word($s1)                          #stores the current character into the character_index of word
    bgez $s1, output                            #prints out the word only if $s1 is true

next_character:
    addi $s1,$s1,1                              #++char_index
    sb   $a0,word($s1)                          #w[++char_index] = cur_char;

    j process_input                             #continue;

is_hyphen:                                      #is_hyphen(char ch)
                                                #checking whether the character is a hyphen
    lb  $t0, hyphen                             #loads address of hyphen in $t0
    seq $v1, $a0,$t0                            #translated C code - if(ch =='-')

    jr $ra                                      #return to main

output:                                         #printing a new line
    li $v0, 4                                   #load immediate, printing the string
    la $a0, new_line                            #loading the string address of new_line
    syscall

                                                #printing a new word
    li $v0,  4                                  #load immediate, printing the string
    la $a0, word                                #loading the string address of word
    syscall

    lb $t0, null_character                      #set null character into t0
    sb $t0,word($zero)                          #store the null character into the first eleemtn of word.

    li $s1, -1                                  #int char_index = -1- setting back the index to -1 once we found a new word

    j process_input                             #jumps back to process_input

main:                                           #Entry point of the program

    li $s0, 0                                   #int input_index = 0;
    li $s1, -1                                  #int char_index = -1

                                                #prints out the string enter_input
    la $a0, enter_input                         #load string address - make $a0 to where the message is
    li $v0, 4                                   #Translated C code - print_string("\nEnter input: ");
    syscall

                                                #Get the sentence from the user
                                                #{fgets(s,size, stdin);}
    la $a0, my_sentence                         #read_input(input_sentence);
    li $a1, 1001
    li $v0, 8
    syscall

                                                #output sentence for the word
    li $v0,4                                    #loading the string address
    la $a0, out_put                             #load the string address into $a0 and print it out
    syscall                                     #print_string("\noutput:\n");

    j process_input                             #go to process input
    beq $t0,1,output                            #if(word_found ==true) output(word);

                                                #checking every character
process_input:

    lb $a0, my_sentence($s0)                    #cur_char = inp[input_index];
    addi $s0,$s0,1                              #input index ++

    jal is_valid_character                      #is_valid_ch =is_valid_character(cur_char);

    beq $v0,1 , set_character                   #if(is_valid_ch)

    jal  is_new_line                            #checks whether it is a new line
    jal  is_null_character                      #checks whether it is a null character

    or $t0,$v0,$v1                              #if(cur_char == '\n' || cur_char == '\0')

    beq $t0,1, end_of_sentence                  #end_of_sentence = true;

    bge $s1,0, is_a_word                        #if(char>= 0)

    li  $v0,0                                   #returns false

    j process_input                             #jumps back to process _input

set_character:
    addi $s1, $s1,1                             #++char_index
    sb   $a0,word($s1)                          #w[++char_index] = cur_char;

    j process_input                             #jump back to process input
