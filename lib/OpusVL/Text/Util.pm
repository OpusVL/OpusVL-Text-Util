package OpusVL::Text::Util;

use 5.014;
use strict;
use warnings;

our @ISA = qw/Exporter/;
our @EXPORT_OK = qw/truncate_text wrap_text string_to_id missing_array_items not_blank split_words line_split mask_text/;

use Array::Utils qw/intersect array_minus/;
use Scalar::Util qw/looks_like_number/;

# ABSTRACT: Simple text utilities

our $VERSION = '0.08';


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

=head2 mask_text

Mask text field contents using a simple regex.

    mask_text('*', '(\d{4}).*(\d{3})', '456456564654654');
    # '4564********654'

Specify a fill character, a regex (as a string), and the text to mask out.

This does not guard against rogue regexes.  Capture the parts you expect to
be retained.

=cut

sub mask_text
{
    my ($fill_char, $regex, $text) = @_;

    # fudge the regex.
    my @values = $text =~ /$regex/;
    unless(@values)
    {
        return $fill_char x length($text);
    }
    my @chars;
    my $group = 1;
    my $group_inserted = 0;
    my $start = $-[$group];
    my $end = $+[$group];
    for (my $i = 0; $i < length($text); $i++)
    {
        if($i > $end)
        {
            $group++;
            $group_inserted = 0;
            if($group > scalar @values)
            {
                $start = length($text) + 1;
                $end = $start +1;
            }
            else
            {
                $start = $-[$group];
                $end = $+[$group];
            }
        }
        if($i >= $start && $i < $end)
        {
            unless($group_inserted)
            {
                $group_inserted = 1;
                push @chars, $values[$group-1];
            }
        }
        else
        {
            push @chars, $fill_char;
        }
    }
    return join '', @chars;
}


1; # End of OpusVL::Text::Util
