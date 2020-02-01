
#INF2C- Introduction to Computer Systems
#Coursework Assignment 1 - Task A


.data                                       #starts the sata segment of the program

enter_input:      .asciiz "\nEnter input: " #loads the the string "Enter input"
my_sentence:      .space 1001               #reserve 1000 bytes for the sentence and an extra byte for the null character
output_sentence:  .space 3001               #output_sentence
out_put:          .asciiz "\noutput:"       #is the output sentence before words are found
sentence_length:  .word 1000                #sentence length exlcuding the null character 1000
word_length:      .word 50                  #word length set to 50
new_line:         .asciiz "\n"              #loads a new line
word:             .space  50                #where the loop stores the word that needs to be outputter
null_character:   .ascii "\0"               #the null charatcer
hyphen:           .asciiz "-"               #the hyphen
vowels:           .ascii "AEIOUaeiou"       #vowel string
pig_latin:        .space 52                 #pig_latin array


.globl main                                 #int main()
                                            #this is where the actual program starts
.text                                       #starts the text segment of the program
                                            #define false 0
                                            #define true 1
main:                                       # Entry point of the program
    li $s0, 0                               #int input_index = 0;
    li $s1, -1                              #int char_index = -1
    li $s4,0                                #output_index
                                            #prints out the string enter_input
    la $a0, enter_input                     #load string address - make $a0 to where the message is
    li $v0, 4                               #load immediate  - prints the string "Enter input"
    syscall                                 #Calls the OS to print the message
                                            #Translated C code - print_string("\nEnter input: ");
                                            #Get the sentence from the user
                                            #{fgets(s,size, stdin);}
    la $a0, my_sentence                     #read_input(input_sentence);
    li $a1, 1001
    li $v0, 8
    syscall
                                            #output sentence for the word
    li $v0,4                                #loading the string address
    la $a0, out_put                         #load the string address into $a0 and print it out
    syscall                                 #print_string("\noutput:\n");

process_input:                              #process_input(char* inp,char* out)      #REGISTERS ARE CONFUSED

    li $s3,0                                #int word_found =  false
    li $s1,-1                               #char_index=-1

find_a_word:                                #checking every character

    lb $a0, my_sentence($s0)                #cur_char = inp[input_index];
    addi $s0,$s0,1                          #input index ++
    jal is_valid_character                  #is_valid_ch =is_valid_character(cur_char);
    beq $v0,1 , set_character               #if(is_valid_ch)
    jal  is_new_line                        #checks whether it is a new line
    jal  is_null_character                  #checks whether it is a null character
    or $s7,$v0,$v1                          #if(cur_char == '\n' || cur_char == '\0')
    beq $s7,1,end_of_sentence               #branches to end of sentence if $s7 is 0
    bge $s1,0, is_a_word                    #if(char>= 0)
    lb $t0, null_character                  #load address of null_character
    sb $t0,word($zero)                      #w[0]='\0';
    sb $a0,output_sentence($s4)             #output_sentence[output_index++]=cur_char;
    addi $s4,$s4,1                          #output_index++
    li $s1,-1                               #char_index = -1;
    j find_a_word                           #jumps to find a word
                                            #checks wheather it is a valid character
                                            #int is_valid_character(char ch)
is_valid_character:                         #else if(ch>= 'A' && ch<='Z') {return true;}
    slti $t0,$a0, 91                        #if the ascii value is less than 91, then set  $t0 to 1
    sge  $t1,$a0, 65                        #if the ascii value is greater or equal to 65  then set $t0 to 1
    and  $t0,$t0, $t1                       #checking whether the two conditions hold
                                            #if(ch>= 'a' && ch<= 'z'){return true;}
    slti $t1,$a0,123                        #if the ascii value is less than 123, then set $t0 to 1
    sge  $t2,$a0,97                         #if the ascii value is greater or equal to 97 then set $t0 to 1.
    and  $t1,$t1,$t2                        #checking whether the two conditions hold
    or   $v0,$t0,$t1                        #checks whether either condition holds

    jr $ra                                  #return to main

set_character:
    addi $s1, $s1,1                         #++char_index
    sb   $a0,word($s1)                      #w[++char_index] = cur_char;
    j find_a_word                           #jump back to process input

is_new_line:
    lb  $t0, new_line                       #loading address of new_line into $t0
    seq $v0,$a0,$t0                         #if the character is a new line, set to true

    jr $ra                                  #return to process input

is_null_character:
    lb  $t0, null_character                 #loading address of null_character into $t0
    seq $v1,$a0,$t0                         #if the character is a new line, set to true

    jr $ra                                  #return to process input

end_of_sentence:
    bgt $s1,-1, turn_pig_latin              #if the char index is greater than -1 than go to turn pig latin
    li $s3,0                                #word_found=false
    sb $zero,word                           #store null character in first element
    j output                                #jump to output

is_a_word:
    li $s3,1                                #return true
    jal is_hyphen                           #checks wheather the current character is a hypen
    lb $a0,my_sentence($s0)                 #loading the next character
    jal is_valid_character                  #checks whether the next character is a valid character
    addi $t0,$s0,-1                         #finding the orginal index of input_index
    lb $a0, my_sentence($t0)                #going back to the original character
    and $t0,$v0,$v1                         #check whether both conditions hold
    beq $t0,1, next_character               #if(is_hyphen(cur_char) == true && is_valid_character(inp[input_index]))
    addi $s1, $s1, 1                        #char_index++
    lb   $t0, null_character                #loading address of null_character
    sb   $t0,word($s1)                      #stores the current character into the character_index of word
    j  turn_pig_latin                       #found a word so convert it to pig latin

next_character:
    addi $s1,$s1,1                          #++char_index
    sb   $a0,word($s1)                      #w[++char_index] = cur_char;
    j find_a_word                           #continue;

is_hyphen:                                  #is_hyphen(char ch)-checking whether the character is a hyphen
    lb  $t0, hyphen                         #loads address of hyphen in $t0
    seq $v1, $a0,$t0                        #translated C code - if(ch =='-')
    jr $ra                                  #return to main

is_vowel:                                   #checks whether the character is a vowel
    lb $t1,vowels($t0)                      #loads a vowel into the the register
    seq $v0, $a0,$t1                        #checks on whether the character is a vowel
    beqz $v0 is_vowel_loop                  #goes to incriment the loop
    jr $ra                                  #return to the main

is_vowel_loop:
    beq   $t0,-1, no_vowel                  #branch as this means there is no vowel
    addi, $t0,$t0,-1                        #decrease the loop
    j is_vowel                              #goes back to the loop

no_vowel:
    li $v0, 0                               #set $v0 to 0 as there is no vowel
    jr $ra                                  #return to main

change_to_lower:                            #changes a uppercase character to a lowercase character
                                            #int change_to_lower(char ch)
                                            #ch = ch+ 32
    addi $v0,$a0, 32                        #adds 32 to the ascii value
    jr $ra                                  #return to main

change_to_upper:                            #changes a lowercase character to a uppercase character
                                            #int change_to_upper(char ch)
    addi $v0,$a0,-32                        #ch = ch-32
    jr $ra                                  #return to main

turn_pig_latin:                             #turning the word into pig latin
                                            #void turn_pig_latin(char* w)

    li $s2,0                                #word_length=0;
    jal w_length                            #finding out the length of the word
    lb $a0,word($zero)                      #loading first element of word
    beqz $a0, output                        #output the sentence
    beq  $a0, 10,output                     #output the sentence
    jal is_capital_character                #int is_capital = is_capital_character(word[0]);
    add $s6,$v0,$zero                       #move is_capital_character else where
    jal is_all_capital                      #checking whether all of them are capital

    li $s5,0                                #int vowel_index=0;
    li $t0,0                                #loop counter-loading zero for the vowel
    li $t2,0                                #loading the word length in $t2 as a loop counter
    jal find_a_vowel                        #while loop to find the vowel index
    add $s5,$zero,$v0                       #moves vowel_index from $v0 to $s5

    li $t0,0                                #int n =0;
    li $t1,0                                #int m =0;
    add $t2,$s5,$zero                       #int o= vowel_index;
    jal input_after_vowel                   #put characters into pig_latin after vowel
    jal input_before_vowel                  #input charcters after the vowel into pig_latin
    seq $v0, $v1,0
    and $v0,$v0,$s6                         #if(is_capital && (is_all_capital ==0)
    beq $v0, 1,change_cases                 #branch if this is the case.
    beq $v1,1, append_AY                    #if(is_all_capital)- append AY

    beqz $v1,  append_ay                    #just append ay

w_length:                                   #loop which finds out the length of the word
    lb $t0, word($s2)                       #loading first element of word
    lb $t1, null_character                  #loading the address in $t1
    bne $t0, $t1, add_length                #increase the loop counter if the element does not equal the null character
    jr $ra                                  #return back to pig_latin
add_length:
    addi $s2,$s2,1                          #increase the loop counter
    j w_length                              #go back to the loop

is_capital_character:                       #checks whether the character is capital
                                            #int is_capital_letter(char ch)
                                            #if (ch >= 'A' && ch <= 'Z')
    slti $t0,$a0, 91                        #if the ascii value is less than 91, then set  $t0 to 1
    sge  $t1,$a0, 65                        #if the ascii value is greater or equal to 65  then set $t0 to 1
    and  $v0,$t0, $t1                       #checks whether the two conditions hold -returns true or false
    jr   $ra                                #returns to caller function

is_all_capital:                             #checks whether the word is capital
    addi $sp,$sp,-4                         #move sp down
    sw   $ra,0($sp)                         #save ra on top of stack
    lb $a0,word($zero)                      #is_capital_character(w[0])
    addi $sp,$sp,-4                         #move sp down
    sw   $ra,0($sp)                         #stores stack pointer
    jal is_capital_character                #checks whether it is a capital
    lw  $ra,0($sp)                          #fetch value from stack
    addi $sp,$sp,4                          #move stack by 4
    add $t2,$v0,$zero                       #move it to $t2
    add $t0,$s2,-1                          #word_length-1
    lb $a0, word($t0)                       #loads the last element of the word
    addi $sp,$sp,-4                         #move sp down
    sw   $ra,0($sp)                         #store stack value
    jal is_capital_character                #is_capital_character(w[word_length-1])
    lw  $ra,0($sp)                          #fetch value from stack
    addi $sp,$sp,4                          #move by 4
    and $v1,$t2,$v0                         #is_capital_character(w[0]) && is_capital_character(w[word_length-1])
    lw  $ra,0($sp)                          #fetch value from stack
    addi $sp,$sp,4                          #move sp up
    jr $ra                                  #return to main

find_a_vowel:                               #finding the first index of the vowel
    addi $sp,$sp,-4                         #move sp down
    sw   $ra,0($sp)                         #save ra on top of stack
    lb $a0,word($t2)                        #loading an element of word into $t1
    li $t0,9                                #loads the loop counter
    jal is_vowel                            #if(is_vowel(w[i])
    lw  $ra,0($sp)                          #fetch value from stack
    addi $sp,$sp,4                          #move sp up
    beq $v0,1,vowel_index                   #branches if it is a vowel
    sub  $t3,$s2,1                          #word_length-1
    beq  $t2,$t3,find_no_vowel              #find_no_vowel
    blt  $t2, $s2, find_v_loop              #if less than word_length incriment the loop

    jr $ra                                  #go back to turn_pig_latin

find_no_vowel:
    addi $sp,$sp,-4                         #move sp down
    sw   $ra,0($sp)                         #save ra on top of stack
    li $v0,0                                #set $v0 to 0 as there is no vowel
    lw  $ra,0($sp)                          #fetch value from stack
    addi $sp,$sp,4                          #move sp up
    jr $ra                                  #return to main

find_v_loop:
    addi $t2,$t2, 1                         #increase loop counter
    j find_a_vowel                          #go back to find a vowel

vowel_index:
    move $v0, $t2                           #no vowel in the word
    jr $ra                                  #go back to find_ a_vowel

change_cases:                               #changes the cases
    li   $t0, 0                             #load 0 into a register
    lb   $a0, pig_latin($zero)
    beq  $s5,0, append_ay                   #if the vowel index is 0 append ay
    addi $sp, $sp,-4                        #move sp down
    lw   $ra, 0($sp)
    jal change_to_upper                     #load first element of piglatin into $t1
    sb   $v0, pig_latin($zero)              #pig_latin[0]=chnage_to_upper(pig_latin[0]);
    sub  $t0, $s2,$s5                       #word_length-vowel_index
    lb   $a0, pig_latin($t0)                #pig_latin[word_length-vowel_index]
    jal change_to_lower                     #turns character into lower case
    sub  $t0, $s2,$s5                       #word_length-vowel_index
    sb  $v0,pig_latin($t0)                  #pig_latin[word_length-vowel_index]=change_to_lower(pig_latin[word_length-vowel_index]);

    j append_ay                             #jump back to caller function

append_AY:                                  #appends AY to the end of pig_latin
    li $t0,'A'                              #loading A into a register
    li $t1, 'Y'                             #loading Y into a register
    sb $t0,pig_latin($s2)                   #pig_latin[word_length++] = 'A'
    addi $s2,$s2,1                          #word_length++
    sb $t1,pig_latin($s2)                   #pig_latin[word_length++] = 'Y'
    addi $s2,$s2,1                          #word_length++
    li $t1,0
    j put_in_output

append_ay:                                  #void turn_pig_latin(char* w)
    li $t0, 'a'                             #loading a into a register
    li $t1, 'y'                             #loading y into a register
    sb $t0,pig_latin($s2)                   #pig_latin[word_length++] = 'a'
    addi $s2,$s2,1                          #word_length++
    sb $t1,pig_latin($s2)                   #pig_latin[word_length++] = 'y'
    addi $s2,$s2,1
    li $t1,0
    j put_in_output

put_in_output:

    lb $t0,pig_latin($t1)                   #pig_latin[a];
    sb $t0,output_sentence($s4)             #output_sentence[output_index] = pig_latin [a];
    add $s4, $s4,1                          #output_index++
    add $t1,$t1,1                           #a++
    blt $t1,$s2, put_in_output              #while(a < word_length)


    move  $t0,$s0                           #load address of input_index
    addi $t0,$t0,-1                         #input_index-1
    lb $t1,my_sentence($t0)                 #input_sentence[input_index-1]
    sb   $t1,output_sentence($s4)           #output_sentence[output_index++]=input_sentence[input_index-1];
    addi $s4,$s4,1                          #output_index ++
    li $s1,-1                               #char_index=-1
    beq  $s3,1 ,find_a_word                 #jump back to find_a_word to find more words
    j output                                #print the output_sentence

input_after_vowel:
    lb $t3, word($t2)                       #w[0];
    sb $t3,pig_latin($t0)                   #pig_latin[n]=w[0];
    addi $t0, $t0,1                         #n++;
    addi $t2,$t2,1                          #o++;
    blt  $t2,$s2 input_after_vowel          #while(o< word_length)

    jr $ra                                  #return to main

input_before_vowel:
    lb $t3, word($t1)                       #w[m];
    sb  $t3,pig_latin($t0)                  #pig_latin[n]=w[m];
    addi $t0,$t0,1                          #n++
    addi $t1,$t1,1                          #m++
    blt  $t1,$s5, input_before_vowel        #while (m< vowel_index)

    jr $ra                                  #return to main

output:                                     #printing a new line
    li $v0, 11                              #load immediate, printing the string
    li $a0, ' '                             #loading the string address of new_line
    syscall
                                            #printing a new word
    li $v0,  4                              #load immediate, printing the string
    la $a0, output_sentence                 #loading the string address of word
    syscall

    beq $s3,0, exit                         #exit the program if it is at the end of sentence

    li $s1, -1                              #int char_index = -1- setting back the index to -1 once we found a new word
    j find_a_word                           #jumps back to process_input

word_found:
    li $s3,1                                #word_found= false
    jal turn_pig_latin                      #turn the last word into pig_latin
    j output                                #go and print out the output sentence

exit:
    li $v0, 10                              #exits the program
    syscall
