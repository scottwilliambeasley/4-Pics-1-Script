#!/usr/bin/perl
use 5.10.0;
use strict;
use warnings;
use diagnostics;
use Algorithm::Permute;
use Array::Utils qw(:all);

chdir "/home/wolverine/workspace/Learning\ Perl/Pet\ Projects";


TAKING_INPUT_VARS:
#DEFINING KEY VARIABLES
my @placeholder;
my %letters;
my @permutations;
my $permuted_text;
my @list_of_answers;

#DEFINING NUMBER OF LETTERS IN ANSWER
print "\nPlease input how many letters are in the answer\n\n";
chomp (my $number = <>);

say "-----" x 10 . "\n";

#TAKING INPUT LETTERS, STORING THEM IN HASH
print "Please input all letters line-by-line.\nLeave a blank line and press ENTER when done.\n\n";

	my $counter=0;
	while (<>) {
	chomp $_;
	last unless ($_);
	$counter++;
	$letters{$counter}="$_";
				}
							
#OPENING DICTIONARY FILE
open ("DIC", '<', 'words');

#PARSING DICTIONARY, REMOVING NONMATCHING VALUES
		
		#REMOVING ALL ENTRIES THAT DON'T MATCH WORD SIZE
		my @array_sorted_by_size;
		
		foreach (<DIC>){
			if (/^[a-zA-Z]{$number}$/){
				push @array_sorted_by_size, $_;
							 }
						}
		#chomping array to remove linebreaks				
		chomp @array_sorted_by_size;				
		
		#enumerating the dictionary entries that match the size				
		say "Your sized letters are..\n";
		foreach (@array_sorted_by_size){say $_}
		say"";				
		
		#CREATING PERMUTATION OF ALL KNOWN ELEMENTS IN SETS OF NUMS
		my $permutations;
		my %answers; #creating a hash to store unique answers
		
		#creating the permutations
		my $permutate_me= new Algorithm::Permute ([values %letters], $number);
		while (my @permutator=$permutate_me->next)
		{
		$permutations++;					  #getting total number of unduped ppermutations
		$permuted_text= join '', @permutator; #joining the list input into a single variable
		push @permutations, $permuted_text;   #pushing the joined variable to an array that stores every permutation
		$answers{$permuted_text}="";	      #duping permutations via hash keys
		}
		
		my $dupes = $permutations-keys %answers ;
		
		my @keyholder;
		foreach (keys %answers){
		push @keyholder, $_;	
		}
		
		say "You have $permutations permutations, $dupes of which are duplicates.\n";
		say "Your permutations are..";
		my $permutations2;
		foreach (@permutations){$permutations2++;say"$permutations2 $_"}
		say "";
		
		#COMPARING PERMUTATIONS OF LETTERS, TO SORTED ENTRIES
		
		say "Your answers are..";
		
		my @answers = intersect(@array_sorted_by_size, @keyholder);
		
		
		foreach (@answers){say $_};
