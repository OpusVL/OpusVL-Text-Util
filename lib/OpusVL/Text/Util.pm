package OpusVL::Text::Util;

use 5.006;
use strict;
use warnings;

our @ISA = qw/Exporter/;
our @EXPORT_OK = qw/truncate_text/;


=head1 NAME

OpusVL::Text::Util - Simple text utilities

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

This provides a couple of simple methods for playing with text.

    use OpusVL::Text::Util qw/truncate_text/;

    my $truncated = truncate_text('a long string really', 10);
    # 'a long...'

=head1 EXPORT

=head2 truncate_text

=cut

sub truncate_text 
{
    my $string = shift;
    my $length = shift;

    return $string if length($string) < $length;
    if($string =~ /^(.{0,$length}\w\b)/)
    {
        return $1 . ' ...';
    }
    else
    {
        return substr $string, 0, $length;
    }
}

=head1 AUTHOR

OpusVL, C<< <colin at opusvl.com> >>


=head1 LICENSE AND COPYRIGHT

Copyright 2012 OpusVL.

This software is licensed according to the "IP Assignment Schedule" provided with the development project.


=cut

1; # End of OpusVL::Text::Util
