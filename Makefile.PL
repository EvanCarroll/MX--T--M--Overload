use inc::Module::Install;

name     'MooseX-Types-Moose-Overload';
all_from 'lib/MooseX/Types/Moose/Overload.pm';
author   'Evan Carroll <me@evancarroll.com>';
license  'perl';

requires 'Moose';
requires 'MooseX::Types';
requires 'overload';

build_requires 'Test::More';

auto_install;

WriteAll;

