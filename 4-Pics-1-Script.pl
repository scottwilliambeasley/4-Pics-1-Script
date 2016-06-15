#!/usr/bin/perl
use 5.10.0;
use strict;
use warnings;
use diagnostics;
use Algorithm::Permute;
use Array::Utils qw(:all);
use Cwd;


my $dictionaryDir = cwd;

# Attempt to change into the directory supplied by @ARGV, if any.

my $numberOfCommandLineArguments = $#ARGV + 1;

if ($numberOfCommandLineArguments == 1){
	$dictionaryDir = pop @ARGV;

	chdir $dictionaryDir or
		die "Folder pathway given, ".$dictionaryDir." is not accessible";

} elsif ($numberOfCommandLineArguments > 1){
	die "Usage: 4-Pics-1-Script.pl [PATH TO FOLDER CONTAINING words]";
}

# Make sure that the dictionary file exists and is accessible in directory.

my $dictionaryPath = $dictionaryDir."/words";

if ( -f $dictionaryPath) {
	open ("dictionary", '<', 'words') or
		die "Lacking proper permissions to open file handle for dictionary.";
} else {
	die "words file not present in ".cwd;
}

# Query the user repeatedly for the number of letters the answer must have
#  until he supplies a valid number of letters.

my $validNumberOfLettersGiven = 0;
my $numberOfLettersInAnswer;

until ($validNumberOfLettersGiven == 1){
	say "\nPlease input how many letters are in the answer:\n\n";
	chomp ($numberOfLettersInAnswer = <>);
	say "";

	if ($numberOfLettersInAnswer =~ /^[3-9]$/){
		$validNumberOfLettersGiven = 1;
		say "A proper number of letters, ".$numberOfLettersInAnswer.", was entered. ";
		say "";
		say "Now solving for words with exactly ".$numberOfLettersInAnswer." letters.";
		say "-----" x 10 . "\n";
		next;
	}

	say "An -invalid- input was given. You may only enter a single digit, from 3 to 9.";
	say "Try again.";
	say "-----" x 10 . "\n";

}

# Ask the user to input letters until 12 valid letters are given. Store these in an array.

my @useableLettersForAnswer;
my $givenLetterCount = 0;
my $currentLetterGiven;

say "Please enter each useable letter, followed by the ENTER key, one by one.";

while ($givenLetterCount!=12){
	chomp ($currentLetterGiven = <>);

	if ($currentLetterGiven =~ /^[a-zA-Z]$/){
		$currentLetterGiven = lc ($currentLetterGiven);
		$givenLetterCount++;
		say "Character #".$givenLetterCount." is ".$currentLetterGiven;
		push @useableLettersForAnswer, $currentLetterGiven;
	} else {
		say "That is not a single letter. Please try again and enter another letter found on your game screen.";
		redo;
	}

}

# Parse the entire dictionary file using the file handle. For every word matching the correct
#  size, add it to the list of potential answers, then close the file handle.

my @dictionaryWordsOfCorrectSize;

foreach (<dictionary>){
	if (/^[a-zA-Z]{$numberOfLettersInAnswer}$/){
		chomp $_;
		push @dictionaryWordsOfCorrectSize, $_;
	}
}

close "dictionary" or die $!;

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

	$numberOfUndupedPermutations++;
	$joinedPermutationOfLetters= join '', @permutatedListOfLetters;
	say "permutation $numberOfUndupedPermutations: @permutatedListOfLetters";

	push @listOfCompleteUndupedPermutations, $joinedPermutationOfLetters;
	$dedupedPotentialWords{$joinedPermutationOfLetters}="";
}

# Count the total duplicates made by subtracting the number of deduped words from the
#  total number of raw permutations created.

my $numberOfDuplicatePermutations = $numberOfUndupedPermutations-keys %dedupedPotentialWords ;

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

