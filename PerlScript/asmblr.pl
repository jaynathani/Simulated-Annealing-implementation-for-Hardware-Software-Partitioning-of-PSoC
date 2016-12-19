#!/usr/bin/perl
use strict;
use warnings;
use bignum ;

#use Data::Dumper qw(Dumper);

#open file
my %instructions;
my %nodes;
my $node_exec_time_sw;
my $node_exec_time_hw;
my $node_flash_hit;
my $node_has_mac_opt;
my $node_memory_space;
my $node_nmbr_of_instr;
my $node_nmbr_of_vreg;   #number of virtual registers ie __r0
my @grabnodenumber;
my @grabopcode;
my $savekval;

%instructions = (
	 '09'	=>  {	'instruction'	=>	'adc',
			'layout'	=>	'A,expr',
			'cycles'	=>	'4',
			'bytes'		=>	'2'   },

	 '0A'	=>  {	'instruction'	=>	'adc',
			'layout'	=>	'A,[expr]',
			'cycles'	=>	'6',
			'bytes'		=>	'2'   },
			
	 '0B'	=>  {	'instruction'	=>	'adc',
			'layout'	=>	'A,[X+expr]',
			'cycles'	=>	'7',
			'bytes'		=>	'2'   },
			
	 '0C'	=>  {	'instruction'	=>	'adc',
			'layout'	=>	'[expr],A',
			'cycles'	=>	'7',
			'bytes'		=>	'2'   },
			
	 '0D'	=>  {	'instruction'	=>	'adc',
			'layout'	=>	'[X+expr],A',
			'cycles'	=>	'8',
			'bytes'		=>	'2'   },
			
	 '0E'	=>  {	'instruction'	=>	'adc',
			'layout'	=>	'[expr],expr',
			'cycles'	=>	'9',
			'bytes'		=>	'3'   },
			
	 '0F'	=>  {	'instruction'	=>	'adc',
			'layout'	=>	'[X+expr],expr',
			'cycles'	=>	'10',
			'bytes'		=>	'3'   },
			
	 '01'	=>  {	'instruction'	=>	'add',
			'layout'	=>	'A,expr',
			'cycles'	=>	'4',
			'bytes'		=>	'2'   },
			
	 '02'	=>  {	'instruction'	=>	'add',
			'layout'	=>	'A,[expr]',
			'cycles'	=>	'6',
			'bytes'		=>	'2'   },
			
	 '03'	=>  {	'instruction'	=>	'add',
			'layout'	=>	'A,[X+expr]',
			'cycles'	=>	'7',
			'bytes'		=>	'2'   },
			
	 '04'	=>  {	'instruction'	=>	'add',
			'layout'	=>	'[expr],A',
			'cycles'	=>	'7',
			'bytes'		=>	'2'   },
			
	 '05'	=>  {	'instruction'	=>	'add',
			'layout'	=>	'[X+expr],A',
			'cycles'	=>	'8',
			'bytes'		=>	'2'   },
			
	 '06'	=>  {	'instruction'	=>	'add',
			'layout'	=>	'[expr],expr',
			'cycles'	=>	'9',
			'bytes'		=>	'3'   },
			
	 '07'	=>  {	'instruction'	=>	'add',
			'layout'	=>	'[X+expr],expr',
			'cycles'	=>	'10',
			'bytes'		=>	'3'   },
			
	 '38'	=>  {	'instruction'	=>	'add',
			'layout'	=>	'SP,expr',
			'cycles'	=>	'5',
			'bytes'		=>	'2'   },
			
	 '21'	=>  {	'instruction'	=>	'and',
			'layout'	=>	'A,expr',
			'cycles'	=>	'4',
			'bytes'		=>	'2'   },
			
	 '22'	=>  {	'instruction'	=>	'and',
			'layout'	=>	'A,[expr]',
			'cycles'	=>	'6',
			'bytes'		=>	'2'   },
			
	 '23'	=>  {	'instruction'	=>	'and',
			'layout'	=>	'A,[X+expr]',
			'cycles'	=>	'7',
			'bytes'		=>	'2'   },
			
	 '24'	=>  {	'instruction'	=>	'and',
			'layout'	=>	'[exp],A',
			'cycles'	=>	'7',
			'bytes'		=>	'2'   },
			
	 '25'	=>  {	'instruction'	=>	'and',
			'layout'	=>	'[X+expr],A',
			'cycles'	=>	'8',
			'bytes'		=>	'2'   },
			
	 '26'	=>  {	'instruction'	=>	'and',
			'layout'	=>	'[expr],expr',
			'cycles'	=>	'9',
			'bytes'		=>	'3'   },
			
	 '27'	=>  {	'instruction'	=>	'and',
			'layout'	=>	'[X+expr],expr',
			'cycles'	=>	'10',
			'bytes'		=>	'3'   },
			
	 '70'	=>  {	'instruction'	=>	'and',
			'layout'	=>	'F,expr',
			'cycles'	=>	'4',
			'bytes'		=>	'2'   },
			
	 '41'	=>  {	'instruction'	=>	'and',
			'layout'	=>	'reg[expr],expr',
			'cycles'	=>	'9',
			'bytes'		=>	'3'   },
			
	 '42'	=>  {	'instruction'	=>	'and',
			'layout'	=>	'reg[X+expr],expr',
			'cycles'	=>	'10',
			'bytes'		=>	'3'   },
			
	 '64'	=>  {	'instruction'	=>	'asl',
			'layout'	=>	'A',
			'cycles'	=>	'4',
			'bytes'		=>	'1'   },
			
	 '65'	=>  {	'instruction'	=>	'asl',
			'layout'	=>	'[expr]',
			'cycles'	=>	'7',
			'bytes'		=>	'2'   },
			
	 '66'	=>  {	'instruction'	=>	'asl',
			'layout'	=>	'[X+expr]',
			'cycles'	=>	'8',
			'bytes'		=>	'2'   },
			
	 '67'	=>  {	'instruction'	=>	'asr',
			'layout'	=>	'A',
			'cycles'	=>	'4',
			'bytes'		=>	'1'   },
			
	 '68'	=>  {	'instruction'	=>	'asr',
			'layout'	=>	'[expr]',
			'cycles'	=>	'7',
			'bytes'		=>	'2'   },
			
	 '69'	=>  {	'instruction'	=>	'asr',
			'layout'	=>	'[X+expr]',
			'cycles'	=>	'8',
			'bytes'		=>	'2'   },
			
	 '9X'	=>  {	'instruction'	=>	'call',
			'layout'	=>	'',
			'cycles'	=>	'11',
			'bytes'		=>	'2'   },
			
	 '39'	=>  {	'instruction'	=>	'cmp',
			'layout'	=>	'A,expr',
			'cycles'	=>	'5',
			'bytes'		=>	'2'   },
			
	 '3A'	=>  {	'instruction'	=>	'cmp',
			'layout'	=>	'A,[expr]',
			'cycles'	=>	'7',
			'bytes'		=>	'3'   },
			
	 '3B'	=>  {	'instruction'	=>	'cmp',
			'layout'	=>	'A,[X+expr]',
			'cycles'	=>	'8',
			'bytes'		=>	'2'   },
			
	 '3C'	=>  {	'instruction'	=>	'cmp',
			'layout'	=>	'[expr],expr',
			'cycles'	=>	'8',
			'bytes'		=>	'3'   },
			
	 '3D'	=>  {	'instruction'	=>	'cmp',
			'layout'	=>	'[X+expr],expr',
			'cycles'	=>	'9',
			'bytes'		=>	'3'   },
			
	 '73'	=>  {	'instruction'	=>	'cpl',
			'layout'	=>	'A',
			'cycles'	=>	'4',
			'bytes'		=>	'1'   },
			
	 '78'	=>  {	'instruction'	=>	'dec',
			'layout'	=>	'A',
			'cycles'	=>	'4',
			'bytes'		=>	'1'   },
	 
	 '79'	=>  {	'instruction'	=>	'dec',
			'layout'	=>	'X',
			'cycles'	=>	'4',
			'bytes'		=>	'1'   },
			
	'7A'	=>  {	'instruction'	=>	'dec',
			'layout'	=>	'[expr]',
			'cycles'	=>	'7',
			'bytes'		=>	'2'   },
			
	'7B'	=>  {	'instruction'	=>	'dec',
			'layout'	=>	'[X+expr]',
			'cycles'	=>	'8',
			'bytes'		=>	'2'   },
			
	'74'	=>  {	'instruction'	=>	'inc',
			'layout'	=>	'A',
			'cycles'	=>	'4',
			'bytes'		=>	'1'   },
			
	'75'	=>  {	'instruction'	=>	'inc',
			'layout'	=>	'X',
			'cycles'	=>	'4',
			'bytes'		=>	'1'   },
			
	 '76'	=>  {	'instruction'	=>	'inc',
			'layout'	=>	'[expr]',
			'cycles'	=>	'7',
			'bytes'		=>	'2'   },
			
	 '77'	=>  {	'instruction'	=>	'inc',
			'layout'	=>	'[X+expr]',
			'cycles'	=>	'8',
			'bytes'		=>	'2'   },
			
	 'F'  =>  {	'instruction'	=>	'index',
			'layout'	=>	'',,	
			'cycles'	=>	'13',
			'bytes'		=>	'2'   },
			
	 'E' 	=>  {	'instruction'	=>	'jacc',
			'layout'	=>	'',,	
			'cycles'	=>	'7',
			'bytes'		=>	'2'   },
			
	 'C'  	=>  {	'instruction'	=>	'jc',
			'layout'	=>	'',,	
			'cycles'	=>	'5',
			'bytes'		=>	'2'   },
			
	'8'  	=>  {	'instruction'	=>	'jmp',
			'layout'	=>	'',,	
			'cycles'	=>	'5',
			'bytes'		=>	'2'   },
			
	 'D' 	=>  {	'instruction'	=>	'jnc',
			'layout'	=>	'',,	
			'cycles'	=>	'5',
			'bytes'		=>	'2'   },
			
	 'B' 	=>  {	'instruction'	=>	'jnz',
			'layout'	=>	'',,	
			'cycles'	=>	'5',
			'bytes'		=>	'2'   },
			
	 'A'  	=>  {	'instruction'	=>	'jz',
			'layout'	=>	'',,		
			'cycles'	=>	'5',
			'bytes'		=>	'2'   },
			
	 '7C'	=>  {	'instruction'	=>	'lcall',
			'layout'	=>	'',,	
			'cycles'	=>	'13'	,
			'bytes'		=>	'3'   },
			
	'7D'	=>  {	'instruction'	=>	'ljmp',
			'layout'	=>	'',,		
			'cycles'	=>	'7',
			'bytes'		=>	'3'   },
			
	 '4F'	=>  {	'instruction'	=>	'mov',
			'layout'	=>	'X,SP',
			'cycles'	=>	'4',
			'bytes'		=>	'1'   },
			
	 '50'	=>  {	'instruction'	=>	'mov',
			'layout'	=>	'A,expr',
			'cycles'	=>	'4',
			'bytes'		=>	'2'   },
			
	 '51'	=>  {	'instruction'	=>	'mov',
			'layout'	=>	'A,[expr]',
			'cycles'	=>	'5',
			'bytes'		=>	'2'   },
			
	 '52'	=>  {	'instruction'	=>	'mov',
			'layout'	=>	'A,[X+expr]',
			'cycles'	=>	'6',
			'bytes'		=>	'2'   },
			
	 '53'	=>  {	'instruction'	=>	'mov',
			'layout'	=>	'[expr],A',
			'cycles'	=>	'5',
			'bytes'		=>	'2'   },
			
	 '54'	=>  {	'instruction'	=>	'mov',
			'layout'	=>	'[X+expr],A',
			'cycles'	=>	'6',
			'bytes'		=>	'2'   },
			
	 '55'	=>  {	'instruction'	=>	'mov',
			'layout'	=>	'[expr],expr',
			'cycles'	=>	'8',
			'bytes'		=>	'3'   },
			
	 '56'	=>  {	'instruction'	=>	'mov',
			'layout'	=>	'[X+expr],expr',
			'cycles'	=>	'9',
			'bytes'		=>	'3'   },
			
	 '57'	=>  {	'instruction'	=>	'mov',
			'layout'	=>	'X,expr',
			'cycles'	=>	'4',
			'bytes'		=>	'2'   },
			
	 '58'	=>  {	'instruction'	=>	'mov',
			'layout'	=>	'X,[expr]',
			'cycles'	=>	'6',
			'bytes'		=>	'2'   },
			
	 '59'	=>  {	'instruction'	=>	'mov',
			'layout'	=>	'X,[X+expr]',
			'cycles'	=>	'7',
			'bytes'		=>	'2'   },
			
	 '5A'	=>  {	'instruction'	=>	'mov',
			'layout'	=>	'[expr],X',
			'cycles'	=>	'5',
			'bytes'		=>	'2'   },
			
	 '5B'	=>  {	'instruction'	=>	'mov',
			'layout'	=>	'A,X',
			'cycles'	=>	'4',
			'bytes'		=>	'1'   },
			
	 '5C'	=>  {	'instruction'	=>	'mov',
			'layout'	=>	'X,A',
			'cycles'	=>	'4',
			'bytes'		=>	'1'   },
			
	 '5D'	=>  {	'instruction'	=>	'mov',
			'layout'	=>	'A,reg[expr]',
			'cycles'	=>	'6',
			'bytes'		=>	'2'   },
			
	 '5E'	=>  {	'instruction'	=>	'mov',
			'layout'	=>	'A,reg[X+expr]',
			'cycles'	=>	'7',
			'bytes'		=>	'2'   },
			
	 '5F'	=>  {	'instruction'	=>	'mov',
			'layout'	=>	'[expr],[expr]',
			'cycles'	=>	'10',
			'bytes'		=>	'3'   },
			
	 '60'	=>  {	'instruction'	=>	'mov',
			'layout'	=>	'reg[expr],A',
			'cycles'	=>	'5',
			'bytes'		=>	'2'   },
			
	 '61'	=>  {	'instruction'	=>	'mov',
			'layout'	=>	'reg[X+expr],A',
			'cycles'	=>	'6',
			'bytes'		=>	'2'   },
			
	 '62'	=>  {	'instruction'	=>	'mov',
			'layout'	=>	'reg[expr],expr',
			'cycles'	=>	'8',
			'bytes'		=>	'3'   },
			
	 '63'	=>  {	'instruction'	=>	'mov',
			'layout'	=>	'reg[X+expr],expr',
			'cycles'	=>	'9',
			'bytes'		=>	'3'   },
			
	 '3E'	=>  {	'instruction'	=>	'mvi',
			'layout'	=>	'A,[[expr]++]',
			'cycles'	=>	'10',
			'bytes'		=>	'2'   },
			
	 '3F'	=>  {	'instruction'	=>	'mvi',
			'layout'	=>	'[[expr]++],A',
			'cycles'	=>	'10',
			'bytes'		=>	'2'   },
			
	 '40' 	=>  {	'instruction'	=>	'nop',
			'layout'	=>	'',
			'cycles'	=>	'4',
			'bytes'		=>	'1'   },
			
	 '29'	=>  {	'instruction'	=>	'or',
			'layout'	=>	'A,expr',
			'cycles'	=>	'4',
			'bytes'		=>	'2'   },
			
	 '2A'	=>  {	'instruction'	=>	'or',
			'layout'	=>	'A,[expr]',
			'cycles'	=>	'6',
			'bytes'		=>	'2'   },
			
	 '2B'	=>  {	'instruction'	=>	'or',
			'layout'	=>	'A,[X+expr]',
			'cycles'	=>	'7',
			'bytes'		=>	'2'   },
			
	 '2C'	=>  {	'instruction'	=>	'or',
			'layout'	=>	'[expr],A',
			'cycles'	=>	'7',
			'bytes'		=>	'2'   },
			
	 '2D'	=>  {	'instruction'	=>	'or',
			'layout'	=>	'[X+expr],A',
			'cycles'	=>	'8',
			'bytes'		=>	'2'   },
			
	 '2E'	=>  {	'instruction'	=>	'or',
			'layout'	=>	'[expr],expr',
			'cycles'	=>	'9',
			'bytes'		=>	'3'   },
			
	 '2F'	=>  {	'instruction'	=>	'or',
			'layout'	=>	'[X+expr],expr',
			'cycles'	=>	'10',
			'bytes'		=>	'3'   },
			
	 '43'	=>  {	'instruction'	=>	'or',
			'layout'	=>	'reg[expr],expr',
			'cycles'	=>	'9',
			'bytes'		=>	'3'   },
			
	 '44'	=>  {	'instruction'	=>	'or',
			'layout'	=>	'reg[X+expr],expr',
			'cycles'	=>	'10',
			'bytes'		=>	'3'   },
		
	 '71'	=>  {	'instruction'	=>	'or',
			'layout'	=>	'F,expr',
			'cycles'	=>	'4',
			'bytes'		=>	'2'   },
			
	 '20'	=>  {	'instruction'	=>	'pop',	
			'layout'	=>	'X',
			'cycles'	=>	'5',
			'bytes'		=>	'1'   },
			
	 '18'	=>  {	'instruction'	=>	'pop',	
			'layout'	=>	'A',
			'cycles'	=>	'5',
			'bytes'		=>	'1'   },
			
	 '10'	=>  {	'instruction'	=>	'push',	
			'layout'	=>	'X',
			'cycles'	=>	'4',
			'bytes'		=>	'1'   },
			
	 '08'	=>  {	'instruction'	=>	'push',	
			'layout'	=>	'A',
			'cycles'	=>	'4',
			'bytes'		=>	'1'   },
			
	 '7E'  	=>  {	'instruction'	=>	'reti',	
			'layout'	=>	'',
			'cycles'	=>	'10',
			'bytes'		=>	'1'   },
			
	 '7F' 	=>  {	'instruction'	=>	'ret',	
			'layout'	=>	'',
			'cycles'	=>	'8',
			'bytes'		=>	'1'   },
			
	 '6A'  	=>  {	'instruction'	=>	'rlc',	
			'layout'	=>	'A',
			'cycles'	=>	'4',
			'bytes'		=>	'1'   },
			
	 '6B'	=>  {	'instruction'	=>	'rlc',	
			'layout'	=>	'[expr]',
			'cycles'	=>	'7',
			'bytes'		=>	'2'   },
			
	 '6C'	=>  {	'instruction'	=>	'rlc',	
			'layout'	=>	'[X+expr]',
			'cycles'	=>	'8',
			'bytes'		=>	'2'   },
			
	 '28'   =>  {	'instruction'	=>	'romx',	
			'layout'	=>	'', 
			'cycles'	=>	'11',
			'bytes'		=>	'1'   },
			
	 '6D' 	=>  {	'instruction'	=>	'rrc',	
			'layout'	=>	'A',
			'cycles'	=>	'4',
			'bytes'		=>	'1'   },
			
	 '6E'	=>  {	'instruction'	=>	'rrc',	
			'layout'	=>	'[expr]',
			'cycles'	=>	'7',
			'bytes'		=>	'2'   },
			
	 '6F'	=>  {	'instruction'	=>	'rrc',	
			'layout'	=>	'[X+expr]',
			'cycles'	=>	'8',
			'bytes'		=>	'2'   },
			
	 '19'	=>  {	'instruction'	=>	'sbb',	
			'layout'	=>	'A,expr',
			'cycles'	=>	'4',
			'bytes'		=>	'2'   },
			
	 '1A'	=>  {	'instruction'	=>	'sbb',	
			'layout'	=>	'A,[expr]',
			'cycles'	=>	'6',
			'bytes'		=>	'2'   },
			
	 '1B'	=>  {	'instruction'	=>	'sbb',	
			'layout'	=>	'A,[X+expr]',
			'cycles'	=>	'7',
			'bytes'		=>	'2'   },
			
	 '1C'	=>  {	'instruction'	=>	'sbb',	
			'layout'	=>	'[expr],A',
			'cycles'	=>	'7',
			'bytes'		=>	'2'   },
			
	 '1D'	=>  {	'instruction'	=>	'sbb',	
			'layout'	=>	'[X+expr],A',
			'cycles'	=>	'8',
			'bytes'		=>	'2'   },
			
	 '1E'	=>  {	'instruction'	=>	'sbb',	
			'layout'	=>	'[expr],expr',
			'cycles'	=>	'9',
			'bytes'		=>	'3'   },
			
	 '1F'	=>  {	'instruction'	=>	'sbb',	
			'layout'	=>	'[X+expr],expr',
			'cycles'	=>	'10',
			'bytes'		=>	'3'   },
			
	 '00'  	=>  {	'instruction'	=>	'ssc',	
			'layout'	=>	'',
			'cycles'	=>	'15',
			'bytes'		=>	'1'   },
			
	 '11'	=>  {	'instruction'	=>	'sub',	
			'layout'	=>	'A,expr',
			'cycles'	=>	'4',
			'bytes'		=>	'2'   },
			
	 '12'	=>  {	'instruction'	=>	'sub',	
			'layout'	=>	'A,[expr]',
			'cycles'	=>	'6',
			'bytes'		=>	'2'   },
			
	 '13'	=>  {	'instruction'	=>	'sub',	
			'layout'	=>	'A,[X+expr]',
			'cycles'	=>	'7',
			'bytes'		=>	'2'   },
			
	 '14'	=>  {	'instruction'	=>	'sub',	
			'layout'	=>	'[expr],A',
			'cycles'	=>	'7',
			'bytes'		=>	'2'   },
			
	 '15'	=>  {	'instruction'	=>	'sub',	
			'layout'	=>	'[X+expr],A',
			'cycles'	=>	'8',
			'bytes'		=>	'2'   },

	 '16'	=>  {	'instruction'	=>	'sub',	
			'layout'	=>	'[expr],expr',
			'cycles'	=>	'9',
			'bytes'		=>	'3'   },
			
	 '17'	=>  {	'instruction'	=>	'sub',	
			'layout'	=>	'[X+expr],expr',
			'cycles'	=>	'10',
			'bytes'		=>	'3'   },
			
	 '4B'	=>  {	'instruction'	=>	'swap',	
			'layout'	=>	'A,X',
			'cycles'	=>	'5',
			'bytes'		=>	'1'   },
			
	 '4C'	=>  {	'instruction'	=>	'swap',	
			'layout'	=>	'A,[expr]',
			'cycles'	=>	'7',
			'bytes'		=>	'2'   },
			
	 '5D'	=>  {	'instruction'	=>	'swap',	
			'layout'	=>	'X,[expr]',
			'cycles'	=>	'7',
			'bytes'		=>	'2'   },
			
	 '5E'	=>  {	'instruction'	=>	'swap',	
			'layout'	=>	'A,SP',
			'cycles'	=>	'5',
			'bytes'		=>	'1'   },
			
	 '47'	=>  {	'instruction'	=>	'tst',	
			'layout'	=>	'[expr],expr',
			'cycles'	=>	'8',
			'bytes'		=>	'3'   },
			
	 '48'	=>  {	'instruction'	=>	'tst',	
			'layout'	=>	'[X+expr],expr',
			'cycles'	=>	'9',
			'bytes'		=>	'3'   },
			
	 '49'	=>  {	'instruction'	=>	'tst',	
			'layout'	=>	'reg[expr],expr',
			'cycles'	=>	'9',
			'bytes'		=>	'3'   },
			
	 '4A'	=>  {	'instruction'	=>	'tst',	
			'layout'	=>	'reg[X+expr],expr',
			'cycles'	=>	'10',
			'bytes'		=>	'3'   },
			
	 '72'	=>  {	'instruction'	=>	'xor',	
			'layout'	=>	'F,expr',
			'cycles'	=>	'4',
			'bytes'		=>	'2'   },

	 '31'	=>  {	'instruction'	=>	'xor',	
			'layout'	=>	'A,expr',
			'cycles'	=>	'4',
			'bytes'		=>	'2'   },

	 '32'	=>  {	'instruction'	=>	'xor',	
			'layout'	=>	'A,[expr]',
			'cycles'	=>	'6',
			'bytes'		=>	'2'   },

	 '33'	=>  {	'instruction'	=>	'xor',	
			'layout'	=>	'A,[X+expr]',
			'cycles'	=>	'7',
			'bytes'		=>	'2'   },

	 '34'	=>  {	'instruction'	=>	'xor',	
			'layout'	=>	'[expr],A',
			'cycles'	=>	'7',
			'bytes'		=>	'2'   },

	 '35'	=>  {	'instruction'	=>	'xor',	
			'layout'	=>	'[X+expr],A',
			'cycles'	=>	'8',
			'bytes'		=>	'2'   },

	 '36'	=>  {	'instruction'	=>	'xor',	
			'layout'	=>	'[expr],expr',
			'cycles'	=>	'9',
			'bytes'		=>	'3'   },

	 '37'	=>  {	'instruction'	=>	'xor',	
			'layout'	=>	'[X+expr],expr',
			'cycles'	=>	'10',
			'bytes'		=>	'3'   },

	 '45'	=>  {	'instruction'	=>	'xor',	
			'layout'	=>	'reg[expr],expr',
			'cycles'	=>	'9',
			'bytes'		=>	'3'   },

	 '46'	=>  {	'instruction'	=>	'xor',	
			'layout'	=>	'reg[X+expr],expr',
			'cycles'	=>	'10',
			'bytes'		=>	'3'   }
);

#end of operations table 

#estimate multiplication function that gets called: 
#_mul8:
#	CMP	[X],0		#8
#	JZ	accu    	#5
#	AND	F, 251  	#4
#	RRC	[X]     	#7
#	JNC	shift   	#5
#	ADD	A,[X+16]	#7
#shift:                 
#	ASL	[X+16]  	#8
#	JMP	_mul8   	#5
#accu:                  
#	ADD	[37],A  	#7
#	MOV	A,0     	#4
#	INC	X       	#4
#	INC	[3]     	#7
#	CMP	[3],16  	#8
#	JNZ	_mul8   	#5
#.terminate             
#	RET			#8
#-->estimate execution time: 92
my $mult_sw_exec_time = 92;





my $filename = $ARGV[0];
my $mult_jmp_addr = $ARGV[1];

	print "input file: $filename \n";

	#initialize
	$node_exec_time_sw = 0;
	$node_exec_time_hw = 0;
	$node_memory_space = 0;
	$node_flash_hit	   = 0;
	$node_nmbr_of_vreg = 0;
	$node_has_mac_opt  = 0;
	$node_nmbr_of_instr= 0;

	open (my $logfh, '>', $filename.'_node_values.log'); 
	#create output file
	open (my $node_val, '>', $filename.'_node_values.temp'); 

	#read input file	
	open(IN, "<", $filename) ;
	while(<IN>){
	
	#clear newline character	
	chomp;

	#create area holding string in each element	
	#print "from node file: $_ \n";

	$_ =~ s/^\s+//;			#remove space from beginning of line
	printf $logfh "From input file wo space: $_ \n";

	#check if a new node is found, if yes - close out the previous node with its values
	if($_ =~ /^\*NODE/)
	   {
		#this updated to next node
		@grabnodenumber = split (/:/, $_);
	
		#if its the first node- there was no previous node with values so skip this	
		if ($grabnodenumber[1] != '1') 
		   {
			#save values from previous node

			#update value for hw estimate
			if ($node_has_mac_opt eq 1) 
			{
				$node_exec_time_hw = .1 * $node_exec_time_sw;
			} else {
				$node_exec_time_hw = .7 * $node_exec_time_sw - .6 * $node_nmbr_of_vreg;
			}

			$savekval = $grabnodenumber[1] -1;
			$nodes{$savekval}{'node_exec_time_sw'} 	= $node_exec_time_sw;
			$nodes{$savekval}{'node_exec_time_hw'} 	= $node_exec_time_hw;
			$nodes{$savekval}{'node_flash_hits'} 	= $node_flash_hit;
			$nodes{$savekval}{'node_has_mac_opt'} 	= $node_has_mac_opt;
			$nodes{$savekval}{'node_nmbr_of_vreg'}  = $node_nmbr_of_vreg;
			$nodes{$savekval}{'node_mem_space'} 	= $node_memory_space;
			$nodes{$savekval}{'node_nmbr_of_instr'} = $node_nmbr_of_instr;

			#print to encoded file
			printf $node_val $nodes{$savekval}{'node_exec_time_sw'}."\t";
			printf $node_val $nodes{$savekval}{'node_exec_time_hw'}."\t";
			printf $node_val $nodes{$savekval}{'node_flash_hits'}."\t";
			printf $node_val $nodes{$savekval}{'node_has_mac_opt'}."\t";
			#printf $node_val $nodes{$savekval}{'node_mem_space'}."\t";
			#printf $node_val "**".$nodes{$savekval}{'node_nmbr_of_vreg'}."**";
			#printf $node_val "**".$nodes{$savekval}{'node_nmbr_of_instr'}."**";
			printf $node_val "\n";

			
			#summary of node
			printf $logfh "----------------------------------------------------------\n";
			printf $logfh "Close out last node: 					 \n";
			printf $logfh "		exec_time[sw] [ $node_exec_time_sw ] 		 \n";
			printf $logfh "		exec_time[hw] [ $node_exec_time_hw ] 		 \n";
			printf $logfh "		flash_hits    [ $node_flash_hit    ] 		 \n";
			printf $logfh "		has_mac_opt   [ $node_has_mac_opt  ] 		 \n";
			printf $logfh "		mem_space     [ $node_memory_space ] 		 \n";
			printf $logfh "		instructions  [ $node_nmbr_of_vreg ] 		 \n";
			printf $logfh "		instructions  [ $node_nmbr_of_instr] 		 \n";
			printf $logfh "----------------------------------------------------------\n";
			printf $logfh "\n\n\n";
		   }

		printf $logfh "******Enter New Node: $_ *******\n";
		
		printf $logfh "Node number $grabnodenumber[1] \n";
		printf $logfh  "\n";

		#save new NODE line values
		$nodes{key} = $grabnodenumber[1]; 
		$nodes{$grabnodenumber[1]}{'partition'} = $grabnodenumber[2]; 

		#print node number to file
		printf $node_val "$grabnodenumber[1]\t";			#hash key prints a different value
	
		#reset node execution and memory time
		$node_exec_time_sw = 0;
		$node_exec_time_hw = 0;
		$node_flash_hit	   = 0;
		$node_has_mac_opt  = 0;
		$node_memory_space = 0;
		$node_nmbr_of_vreg = 0;
		$node_nmbr_of_instr= 0;
	  }	

	#instruction 	
	if($_ =~ /^[0-9|A-Z]{4}/) 
	   { 
		# push (@assemblycode, $_);
	 	printf $logfh "Line in Node $grabnodenumber[1] : $_\n";

		#increment number of instructions
		$node_nmbr_of_instr = $node_nmbr_of_instr + 1;

	 	#check if line also has a flash/e2prom read/write
		if ($_ =~ /(flash|e2prom).*(write|read)/i)
		{
			$node_flash_hit = $node_flash_hit + 1;
			printf $logfh "opcode is flash read/write with total: $node_flash_hit hits for this node\n";
		}
			
		if ($_ =~ /$mult_jmp_addr/)
		{
			$node_has_mac_opt  = 1;
			$node_exec_time_sw = $node_exec_time_sw + $mult_sw_exec_time;
			printf $logfh "opcode is calling a multiply task \n";
		}

		if ($_ =~ /__r[0-9]/)
		{
			$node_nmbr_of_vreg = $node_nmbr_of_vreg + 1;
			printf $logfh "opcode uses compilers virtual registers \n";
		}

		@grabopcode = split (/[\s+]/, $_);

		#problem with jumps/unique commands
		if (@grabopcode[1] =~ /8[0-9|A-Z]|A[0-9|A-Z]|B[0-9|A-Z]|C[0-9|A-Z]|D[0-9|A-Z]|E[0-9|A-Z]/) {
			print $logfh "blahhhhhhh $grabopcode[1] \n";
			$grabopcode[1] = substr $grabopcode[1], 0 , 1;
			print $logfh "blahhhhhhh $grabopcode[1] \n";
		}

		#print info to log file
		printf $logfh "opcode is: $grabopcode[1] \n";  #this holds the opcode
		printf $logfh "opcode instruction: $instructions{$grabopcode[1]}{instruction}\n";
		printf $logfh "opcode cycles: $instructions{$grabopcode[1]}{cycles}\n";
	
		#keep adding up values	
		$node_exec_time_sw = $node_exec_time_sw +  $instructions{$grabopcode[1]}{cycles};
		$node_memory_space = $node_memory_space + $instructions{$grabopcode[1]}{bytes};

		#print info to log file
		printf $logfh "-total exec time: $node_exec_time_sw \n";
		printf $logfh "-total mem space: $node_memory_space\n";
		printf $logfh  "-------\n";

	   }
	}	


	#update value for hw estimate
	if ($node_has_mac_opt eq 1) 
	{
		$node_exec_time_hw = .1 * $node_exec_time_sw;
	} else {
		$node_exec_time_hw = .7 * $node_exec_time_sw - .6 * $node_nmbr_of_vreg;
	}

	#save values from previous node -- this applies to last node
	$nodes{$grabnodenumber[1]}{'node_exec_time_sw'} = $node_exec_time_sw;
	$nodes{$grabnodenumber[1]}{'node_exec_time_hw'} = $node_exec_time_hw;
	$nodes{$grabnodenumber[1]}{'node_flash_hits'} 	= $node_flash_hit;
	$nodes{$grabnodenumber[1]}{'node_has_mac_opt'} 	= $node_has_mac_opt;
	$nodes{$grabnodenumber[1]}{'node_mem_space'} 	= $node_memory_space;
	$nodes{$grabnodenumber[1]}{'node_nmbr_of_vreg'} = $node_nmbr_of_vreg;
	$nodes{$grabnodenumber[1]}{'node_nmbr_of_instr'}= $node_nmbr_of_instr;

	printf $node_val $nodes{$grabnodenumber[1]}{'node_exec_time_sw'}."\t";
	printf $node_val $nodes{$grabnodenumber[1]}{'node_exec_time_hw'}."\t";
	printf $node_val $nodes{$grabnodenumber[1]}{'node_flash_hits'}."\t";
	printf $node_val $nodes{$grabnodenumber[1]}{'node_has_mac_opt'}."\t";
	#printf $node_val $nodes{$grabnodenumber[1]}{'node_mem_space'}."\t";
	#printf $node_val "**".$nodes{$grabnodenumber[1]}{'node_nmbr_of_vreg'}."**";
	#printf $node_val "**".$nodes{$grabnodenumber[1]}{'node_nmbr_of_instr'}."**";


	close $node_val;


	print "finished_first_round\n";
	print $grabnodenumber[1]."\n";

	#open file and put number of nodes as the first line
	open my $in,  '<', $filename.'_node_values.temp'   or die "Can't read old file: $!";
	open my $out, '>', $filename.'_node_values.txt' or die "Can't write new file: $!";

		   #$grabnodenumber holds last node
	print $out $grabnodenumber[1]."\n"; # Add this line to the top\n"; # <--- HERE'S THE MAGIC

	while( <$in> )
	    {
	    print $out $_;
	    }

	close $out;

	print "finished\n";

	#for own use 	
	foreach my $k_node (sort keys %nodes) {
	   print $logfh $k_node."\n";
	   print $logfh $nodes{$k_node}{'node_exec_time_sw'}."\n";
	   print $logfh $nodes{$k_node}{'node_exec_time_hw'}."\n";
	   print $logfh $nodes{$k_node}{'node_flash_hits'}."\n";
	   print $logfh $nodes{$k_node}{'node_mem_space'}."\n";
	   print $logfh "\n";
	}




	close $logfh;


