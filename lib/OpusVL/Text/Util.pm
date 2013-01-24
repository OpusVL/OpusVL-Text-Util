package OpusVL::Text::Util;

use 5.006;
use strict;
use warnings;

our @ISA = qw/Exporter/;
our @EXPORT_OK = qw/truncate_text wrap_text/;


=head1 NAME

OpusVL::Text::Util - Simple text utilities

=head1 VERSION

Version 0.03

=cut

our $VERSION = '0.03';


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

=head1 AUTHOR

OpusVL, C<< <colin at opusvl.com> >>


=head1 LICENSE AND COPYRIGHT

Copyright 2012 OpusVL.

This software is licensed according to the "IP Assignment Schedule" provided with the development project.


=cut

1; # End of OpusVL::Text::Util
