use Test::More;

use OpusVL::Text::Util qw/truncate_text wrap_text/;

is truncate_text('a long string really', 10), 'a long...', 'Pod example';
is truncate_text('short one', 10), 'short one';
is truncate_text('awkwardnopunctuationnospaces', 10), 'awkwardnop';
is truncate_text('a longstringawkwardonereally', 10), 'a...', 'Boundary check';

is wrap_text('a long string really', 10), "a long\nstring\nreally", 'Pod example';
is wrap_text('a long string really', 10, "\r\n"), "a long\r\nstring\r\nreally", 'Pod example';
is wrap_text('awkwardnopunctuationnospaces', 10), 'awkwardnopunctuationnospaces';
is wrap_text("a longstringawkwardonereally", 10), "a\nlongstringawkwardonereally", "Boundary check";
is wrap_text('short one', 10), 'short one';
done_testing;
