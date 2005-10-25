use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Nabaztag',
    AUTHOR              => 'Jerome Eteve <jerome@eteve.net>',
    VERSION_FROM        => 'lib/Nabaztag.pm',
    ABSTRACT_FROM       => 'lib/Nabaztag.pm',
    PL_FILES            => {},
    EXE_FILES           => [ 'bin/nabaztry.pl' ],
    PREREQ_PM => {
        'Test::More' => 0,
	'Class::AutoAccess' => 0.02,
	'LWP::Simple' => 1.41
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Nabaztag-*' },
);
