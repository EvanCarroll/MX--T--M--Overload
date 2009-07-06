use inc::Module::Install;

name     'MooseX-Types-Moose-Overload';
author   'Evan Carroll <me@evancarroll.com>';
license  'perl';
perl_version '5.008';
all_from 'lib/MooseX/Types/Moose/Overload.pm';

requires 'Moose';
requires 'MooseX::Types';
requires 'overload';

build_requires 'Test::More';

repository 'git://github.com/EvanCarroll/MX--T--M--Overload.git';
homepage 'http://github.com/EvanCarroll/MX--T--M--Overload';

auto_install;

WriteAll;

