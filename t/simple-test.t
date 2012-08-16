use Test::More;

use OpusVL::Text::Util qw/truncate_text/;

is truncate_text('a long string really', 10), 'a long...', 'Pod example';
is truncate_text('short one', 10), 'short one';
is truncate_text('awkwardnopunctuationnospaces', 10), 'awkwardnop';
is truncate_text('a longstringawkwardonereally', 10), 'a...', 'Boundary check';

done_testing;
