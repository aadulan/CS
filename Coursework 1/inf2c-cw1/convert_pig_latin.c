// ==========================================================================
// PigLatin Converter
// ==========================================================================
// Convert all words in a sentence using PigLatin rules

// Inf2C-CS Coursework 1. Task B
// PROVIDED file, to be used to complete the task in C and as a model for writing MIPS code.

// Instructor: Boris Grot
// TA: Priyank Faldu
// 10 Oct 2017

//---------------------------------------------------------------------------
// C definitions for SPIM system calls
//---------------------------------------------------------------------------
#include <stdio.h>

void read_string(char* s, int size) {
	fgets(s, size, stdin);
}

void print_char(char c) {
	printf("%c", c);
}
void print_int(int num) {
	printf("%d", num);
}
void print_string(const char* s) {
	printf("%s", s);
}

#define false 0
#define true 1

// Maximum characters in an input sentence excluding terminating null character
#define MAX_SENTENCE_LENGTH 1000

// Maximum characters in a word excluding terminating null character
#define MAX_WORD_LENGTH 50

// Global variables
// +1 to store terminating null character
char input_sentence[MAX_SENTENCE_LENGTH + 1];
char output_sentence[(MAX_SENTENCE_LENGTH * 3) + 1];

void read_input(const char* inp) {
	print_string("Enter input: ");
	read_string(input_sentence, MAX_SENTENCE_LENGTH + 1);
}

void output(const char* out) {
	print_string(out);
	print_string("\n");
}

// Do not modify anything above
//
//
// Define your global variables here
// Global index that points to the next character to be processed in "input_sentence"
// Retains its value across function calls
//Modified from find_word.c
int input_index = 0;
//Modified from find_words.c
// Marks if the sentence is processed
int end_of_sentence = false;
//Modified fron find_words.c
// Indicates how many elements in "w" contains valid word characters
int char_index = -1;
// tells you where you are in the output_sentence
int output_index = 0;
//Modified from find_words.c
//contains the word in which has to be converted into pig latin
char word[MAX_WORD_LENGTH + 1];
char pig_latin[MAX_WORD_LENGTH + 1];

// Modified from find_words.c
//returns true if an input character is a valid world character
//returns false if the input character is a punctunation mark (including an hypen)
int is_valid_character(char ch) {
	if (ch >= 'a' && ch <= 'z') {
		return true;
	} else if (ch >= 'A' && ch <= 'Z') {
		return true;
	} else {
		return false;
	}
}
//Modified from find_word.c
//returns true if the input character is an hypen
int is_hyphen(char ch) {
	if (ch == '-') {
		return true;
	} else {
		return false;
	}
}
//returns true if the input character is a vowel
//returns false if the input character is not a vowel
//uses if statment to check wheather the character is a vowel
int is_vowel(char ch) {
	if (ch == 'a' || ch == 'e' || ch == 'i' || ch == 'o' || ch == 'u'
			|| ch == 'A' || ch == 'E' || ch == 'I' || ch == 'O' || ch == 'U') {
		return true;
	} else {
		return false;
	}
}
//returns true if the input character is a capital letter
//returns false if input character  is not a capital letter
//uses id statment to check wheather it is  capital letter
int is_capital_character(char ch) {
	if (ch >= 'A' && ch <= 'Z') {
		return true;
	} else {
		return false;
	}
}
//changes the lower case character to upper case character
//checks the ascii value to make sure it is lower and subtracts 32 to the ascii value
char change_to_lower(char ch) {
	if (ch >= 'A' && ch <= 'Z')
		ch = ch + 32;
	return ch;
}
//changes the uppercase character to a lowercase character
//checks the ascii value to make sure it is upper and adds 32 to it
char change_to_upper(char ch) {
	if (ch >= 'a' && ch <= 'z')
		ch = ch - 32;
	return ch;

}
//takes the word from process_input and turns into PigLatin
void turn_pig_latin(char* word) {

	//gives the number of elements in the word
	int word_length = 0;
	while (word[word_length] != '\0') {
		word_length++;
	}

	//returns if the first letter is a capital letter
	int is_capital = is_capital_character(word[0]);
	int is_all_capital = 0;
	//loop counter

	//Finding out whether all the characters are capital letters

		is_all_capital = (is_capital_character(word[0]) && is_capital_character(word[1]))||(is_capital_character(word[0])&& is_capital_character(word[3]));

	int vowel_index = 0;
	//loop counter
	int i = 0;
	//loop to find where the first vowel is


	while (i < word_length) {
		if (is_vowel(word[i])) {
			vowel_index = i;
			break;
		}
		i++;
	}

	// if (vowel_index != -1) {

			//if the first character is a capital then change the new one to a capital letter

			int n = 0; //index of word
			int m = 0; //index of
			int o = vowel_index;

			while (o < word_length) {
				pig_latin[n] = word[o];
				n++;
				o++;
			}

			// n++;
			while (m < vowel_index) {
				pig_latin[n] = word[m];
				m++;
				n++;
			}

		// }
        if(is_capital){
            pig_latin[0] = change_to_upper(pig_latin[0]);
            pig_latin[word_length-vowel_index] = change_to_lower(pig_latin[word_length-vowel_index]);
        }

	//appends 'ay' or 'AY' to the the end of the word depending on whether it is capital
	if (is_all_capital) {
		pig_latin[word_length++] = 'A';
		pig_latin[word_length++] = 'Y';

	} else {

        pig_latin[word_length++] = 'a';
		pig_latin[word_length++] = 'y';

	}


	int a = 0;

	//puts the word into output sentence
	while (a < word_length ) {
		output_sentence[output_index] = pig_latin[a];
		a++;
		output_index++;
	}
	// output_sentence[output_index] = ' ';


}

//Modified from find_words.c
int find_a_word(char* inp, char* w) {
	char cur_char;
	int is_valid_ch = false;

	while (end_of_sentence == false) {
		// This loop runs until end of an input sentence is encountered or a valid word is extracted
		cur_char = inp[input_index];
		input_index++;

		// Check if it is a valid character
		is_valid_ch = is_valid_character(cur_char);

		if (is_valid_ch) {
			w[++char_index] = cur_char;
		} else {
			if (cur_char == '\n' || cur_char == '\0') {
				// Indicates an end of an input sentence
				end_of_sentence = true;
			}
			if (char_index >= 0) {
				// w has accumulated some valid characters. Thus, punctuation mark indicates a possible end of a word
				if (is_hyphen(cur_char) == true
						&& is_valid_character(inp[input_index])) {
					// check if the next character is also a valid character to detect hyphenated word.
					w[++char_index] = cur_char;
					continue;
				}
				// w has accumulated some valid characters. Thus, punctuation mark indicates an end of a word
				// char_index++;
				// w[char_index] = '\0';
				return true;
			}
			// skip the punctuation mark
			// w[0] = '\0';
			char_index = -1;
		}
	}
	return false;
}
//finds words in the input sentence and uses a function call turn_pig_latin
//Modified from find_words.c
void process_input(char* inp, char* out) {
	int word_found = false;

	do {
		word_found = find_a_word(inp, word);

		if (word_found == true) {
			turn_pig_latin(word);
		}

	} while (word_found == true);

}

// Do not modify anything below
int main() {

	read_input(input_sentence);

	print_string("\noutput:\n");

	output_sentence[0] = '\0';
	process_input(input_sentence, output_sentence);
	output(output_sentence);

	return 0;
}

//---------------------------------------------------------------------------
// End of file
//---------------------------------------------------------------------------
