use inc::Module::Install;

name     'OpusVL-Text-Util';
all_from 'lib/OpusVL/Text/Util.pm';
author   q{OpusVL <colin@opusvl.com>};
license  'opusvl';

build_requires 'Test::More';

requires 'Array::Utils';

auto_install;
resources (
    repository => {
        url => 'ssh://git/srv/git/OpusVL-Text-Util',
        type => 'git',
    },
);


WriteAll;

