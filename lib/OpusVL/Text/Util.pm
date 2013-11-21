package OpusVL::Text::Util;

use 5.006;
use strict;
use warnings;

our @ISA = qw/Exporter/;
our @EXPORT_OK = qw/truncate_text wrap_text string_to_id missing_array_items not_blank split_words line_split/;

use Array::Utils qw/intersect array_minus/;
use Scalar::Util qw/looks_like_number/;

=head1 NAME

OpusVL::Text::Util - Simple text utilities

=head1 VERSION

Version 0.04

=cut

our $VERSION = '0.04';


=head1 SYNOPSIS

This provides a couple of simple methods for playing with text.

    use OpusVL::Text::Util qw/truncate_text wrap_text/;

    my $truncated = truncate_text('a long string really', 10);
    # 'a long...'
    my $wrapped = truncate_text('a long string really', 10);
    $wrapped = "a long\nstring really";

=head1 EXPORT

=head2 truncate_text

This truncates a string close to the limit provided. It tries to
break it on a word break if possible.  It then appends a '...' to
the string.  This isn't included in the calculation of the length,
so you may end up with 3 more characters than you specified.

    my $truncated = truncate_text('a long string really', 10);
    # 'a long...'

=cut

sub truncate_text 
{
    my $string = shift;
    my $length = shift;

    return $string if length($string) < $length;
    if($string =~ /^(.{0,$length}\w\b)/)
    {
        return $1 . '...';
    }
    else
    {
        return substr $string, 0, $length;
    }
}

=head2 wrap_text

This method has a go at wrapping a line of text.  Note that it
isn't designed to work on multiple lines of text.  It will attempt
to split at convenient points within the required width and if
that fails it will simply display what is there.  All the text
should be displayed with this method.

You can also specify the linefeed characters as the last parameter.

    my $wrapped = wrap_text('a long string really', 10);
    # "a long\nstring\nreally"
    my $wrapped = wrap_text('a long string really', 10, "\r\n");
    # "a long\r\nstring\r\nreally"

=cut

sub wrap_text
{
    my $string = shift;
    my $length = shift;
    my $separator = shift || "\n";

    return $string if length($string) < $length;
    my @lines = $string =~ /\G(.{0,$length}\w\b|.*\w\b)\s*/g;
    return join $separator, @lines;
}

=head2 string_to_id

Makes a string safe to use as an HTML id.  Converts all non safe characters to _.

    string_to_id('thuds-!this') # 'thuds__this'

=cut

sub string_to_id
{
    my $text = shift;
    my $r = $text =~ s/\s+/_/gr;
    $r =~ s/[^\w_]//g;
    return lc $r;
}

=head2 line_split

Splits a string on line breaks.  Accounts for all 3 types of line break, DOS, MAC and Unix.

    line_split("a\nb\r\nc") # qw/a b c/

=cut

sub line_split
{
    my $text = shift;
    my @lines = split /\r\n|\r|\n/, $text;
    return @lines
}

=head2 missing_array_items

Returns the list of items missing.

    $mandatory = [qw/a b c/];
    $cols = [qw/a b d e f/];
    missing_array_items($mandatory, $cols); # ['c']

=cut

sub missing_array_items
{
    my ($mandatory_fields, $actual_fields) = @_;

    my @mand_found = intersect(@$mandatory_fields, @$actual_fields);
    unless(scalar @mand_found == scalar @$mandatory_fields)
    {
        my @missing = array_minus(@$mandatory_fields, @mand_found);
        return \@missing;
    }
    return;
}

=head2 not_blank

Returns true if the string provided is not blank.

    not_blank('0') # 0
    not_blank('')  # 1

=cut

sub not_blank
{
    my $value = shift;
    return 1 if $value;
    if(looks_like_number($value))
    {
        return 1;
    }
    return 0;
}

=head2 split_words

Splits a list of words in a string.  Looks for commas to split the list and strips whitespace.

    split_words('veh1,veh2,veh3') #  qw/veh1 veh2 veh3/

=cut

sub split_words
{
    my $value = shift;
    return split /[\s,]+/, $value;
}


=head1 AUTHOR

OpusVL, C<< <colin at opusvl.com> >>


=head1 LICENSE AND COPYRIGHT

Copyright 2012 OpusVL.

This software is licensed according to the "IP Assignment Schedule" provided with the development project.


=cut

1; # End of OpusVL::Text::Util
