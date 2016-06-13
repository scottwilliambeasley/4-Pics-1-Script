#!/usr/bin/perl
use 5.10.0;
use strict;
use warnings;
use diagnostics;
use Algorithm::Permute;
use Array::Utils qw(:all);


# Change the directory to the one which contains the dictionary file.

chdir "/home/technomage/Migration/Programming\ Files/Learning\ Perl/Pet\ Projects";

# Define the number of letters the answer must have.

print "\nPlease input how many letters are in the answer\n\n";
chomp (my $numberOfLettersInAnswer = <>);
say "-----" x 10 . "\n";

# Retrieve useable letters from standard input, storing them in a hash using ascending
# numerical key values until an empty value is given.

my @useableLettersForAnswer;

say "Please enter each useable letter, followed by the ENTER key, one by one.";
say "Press ENTER without inputting a letter to finish.";

while (<>) {
	chomp $_;
	last unless ($_);
    push @useableLettersForAnswer, $_ ;
}

# Open a file handle to allow reading from the dictionary, exit if this operation fails.

open ("dictionary", '<', 'words')
	or die "Could not open file handle for dictionary.";

# Parse the entire dictionary file. For every word matching the correct size, add it to the list of potential answers.

my @dictionaryWordsOfCorrectSize;

foreach (<dictionary>){
	if (/^[a-zA-Z]{$numberOfLettersInAnswer}$/){
		chomp $_;
		push @dictionaryWordsOfCorrectSize, $_;
	}
}

# Enumerate all dictionary entries found to contain the correct number of letters.

say "The dictionary words that match the answer's correct size are the following:\n";

foreach (@dictionaryWordsOfCorrectSize){
	say $_;
}

say""; #extra linebreak for readability

# Instantiate an object that is capable of generating permutations from our useable letters, of the correct length.

my $permutationCreator= new Algorithm::Permute ([@useableLettersForAnswer], $numberOfLettersInAnswer);

my $numberOfUndupedPermutations = 0;
my @listOfCompleteUndupedPermutations;
my $joinedPermutationOfLetters;
my %dedupedPotentialWords;

# While the object is still able to generate fresh permutations, increment unduped permutation count,
# create single strings from permutations, and add these strings to a list of fully formed and unduped permutations.

while (my @permutatedListOfLetters=$permutationCreator->next){
	#--DEBUG--
	say "one iteration: @permutatedListOfLetters";
	#--DEBUG--
	$numberOfUndupedPermutations++;
	$joinedPermutationOfLetters= join '', @permutatedListOfLetters;
	# might want to reconsider storing -everything- in an array. code complexity is a bitch.
	push @listOfCompleteUndupedPermutations, $joinedPermutationOfLetters;

	# can we separate the bottom into its own for list? it's a completely differnt operation, deduping.
	# we just push this list of unduped words directly into a hash as part of the method
	# if that goes well, we can move dedupedPotentialWords declaration down here, or encapsulate it
	# alltogether, as the array of dedupes is what's really needed, not this hash.
	$dedupedPotentialWords{$joinedPermutationOfLetters}="";
}


# Count the total duplicates made by subtracting the number of deduped words from the
#  total number of raw permutations created.

my $numberOfDuplicatePermutations = $numberOfUndupedPermutations-keys %dedupedPotentialWords ;

         #!! We should switch the order of the section above and below.
         #!! We should get the array -first-before we start counting the number of duplicates found,
         #!! and then get the

# Transfer the deduped permutations from the hash into an array for iteration.

my @potentialWordsFromPermutations;

foreach (keys %dedupedPotentialWords){
	push @potentialWordsFromPermutations, $_;
}

# Count off the number of permutations and dupes, and iterate through all the dedupes.

say "You have $numberOfUndupedPermutations permutations, $numberOfDuplicatePermutations of which are duplicates.\n";
say "Your permutations are..";

my $dedupedPermutationsCount = 0;

foreach (@listOfCompleteUndupedPermutations){
	$dedupedPermutationsCount++;
	say "$dedupedPermutationsCount $_";
}

say "";

# Our final list of answers will be composed of words that are found in -both- the
# deduped permutations list AND the dictionary words list. We print each one.

my @possibleAnswers = intersect(@dictionaryWordsOfCorrectSize, @potentialWordsFromPermutations);

say "Your possible answers for this game are the following words..\n";

foreach (@possibleAnswers){
	say $_;
};

