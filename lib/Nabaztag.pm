package Nabaztag;

use warnings;
use strict;

use base qw/Class::AutoAccess/ ;

use Carp ;

use LWP::Simple ;

=head1 NAME

Nabaztag - A module to interface your nabaztag!

=head1 VERSION

Version 0.01

=head1 ABOUT

Nabaztag.pm  complies with nabaztag API V01 from violet company:

http://www.nabaztag.com/vl/FR/nabaztag_api_version01.pdf

=cut

our $VERSION = '0.01';
our $BASE_URL = "http://www.nabaztag.com/vl/FR/api.jsp" ;
our $ID_APP = 11 ;

=head1 DESCRIPTION

This module is designed to allow you to control a nabaztag with perl programming language.
See ABOUT section to know which api it fits.

It has been tested with my own nabaztag and seems to work perfectly.

It also provide a simple command line tool to try your nabaztag: nabaztry (see SYNOPSIS).
This tool is install in /usr/bin/

It makes great use of LWP::Simple to interact with the rabbit.
PROXY issues:

 If you're behind a proxy, see LWP::Simple proxy issues to know how to deal with that.


=head1 SYNOPSIS

Commandline:

    $ nabaztry.pl MAC TOKEN POSLEFT POSRIGHT

Perl code:


    use Nabaztag;

    
    my $nab = Nabaztag->new();
    
    # MANDATORY
    $nab->mac($mac);
    $nab->token($tok);
   
    # See new function to have details about how to get these properties.
 
    $nab->leftEarPos($left);
    $nab->rightEarPos($right);

    $nab->syncState();

Gory details :

You can access or modify BASE_URL by accessing:
   $Nabaztag::BASE_URL ;

For application id :
   $Nabaztag::ID_APP ; 


=head1 FUNCTIONS

=head2 new

Returns a new software nabaztag.

It has following properties:

  mac : MAC Adress of nabaztag - equivalent to Serial Number ( SN ). Written at the back
        of your nabaztag !!
  token :  TOKEN Given by nabaztag.com to allow interaction with you nabaztag. See
           http://www.nabaztag.com/vl/FR/api_prefs.jsp to obtain yours !!
  leftEarPos : position of left ear.
  rightEarPos : position of right ear.


=cut

sub new {
    my ($class) = @_ ;
    
    my $self = {
	'mac' => undef , # MAC Adress of nabaztag - equivalent to Serial Number ( SN )
	'token' => undef , # TOKEN Given by nabaztag.com to allow interaction with you nabaztag
	'leftEarPos' => undef , # Position of left ear
	'rightEarPos' => undef  # Position of right ear
	};
    
    return bless $self, $class ;
}

=head2 leftEarPos

Get/Sets the left ear position of the nabaztag.

Usage:
    $nab->leftEarPos($newPos);

The new position has to be between 0 (vertical ear) and 16 included

=cut

sub leftEarPos{
    my ($self, $pos) = @_ ;
    if( defined $pos ){
	if ( ( $pos >= 0 )  && ( $pos <= 16 )){
	    return $self->{'leftEarPos'} = $pos ;
	}else{
	    confess("Position has to be between 0 and 16");
	}
    }
    return $self->{'leftEarPos'} ;
}


=head2 rightEarPos

 See leftEarPos. Same but for right.

=cut

sub rightEarPos{
    my ($self, $pos) = @_ ;
    if( defined $pos ){
	if ( ( $pos >= 0 )  && ( $pos <= 16 )){
	    return $self->{'rightEarPos'} = $pos ;
	}else{
	    confess("Position has to be between 0 and 16");
	}
    }
    return $self->{'rightEarPos'} ;
}


=head2 sendMessageNumber

Given a message number, sends this message to this nabaztag.

To obtain message numbers, go to http://www.nabaztag.com/vl/FR/messages-disco.jsp and
choose a message !!

Usage:
    $nab->sendMessageNumber($num);

=cut

sub sendMessageNumber{
    my ($self, $num ) = @_ ;
    
    my $url =  $BASE_URL.'?idapp='.$ID_APP ;

    $self->_assume('mac');
    $self->_assume('token');
    unless( defined $num ){
	confess("No message number given");
    }
             
    $url .= '&sn='.$self->mac() ;
    $url .= '&token='.$self->token() ;

    $url .= '&idmessage='.$num ;

    print "Accessing URL : $url\n";

    my $content = get($url);
    
    unless( defined $content ){
	confess("An error occured while processing request");
    }
}


=head2 syncState

Synchronise the current state of the soft nabaztag with the hardware one.
Actually sends the state to the hardware nabaztag.

Usage:
    
    $nab->syncState();

=cut

sub syncState{
    my ($self) = @_ ;
    
    my $url =  $BASE_URL.'?idapp='.$ID_APP ;
    
    $self->_assume('mac');
    $self->_assume('token');
       
    $url .= '&sn='.$self->mac() ;
    $url .= '&token='.$self->token() ;

    if( defined $self->leftEarPos() ){
	$url .=	'&posleft='.$self->leftEarPos() ;
    }
    if( defined $self->rightEarPos() ){
	$url .= '&posright='.$self->rightEarPos();
    }

    my $content = get($url);
    unless( defined $content ){
	confess("An error occured while processing request");
    }
    
}


sub _assume{
    my ($self, $propertie ) = @_ ;
    unless( defined $self->$propertie() ){
	confess($propertie." is not set in $self\n Please set it first !");
    }
}

=head1 AUTHOR

Jerome Eteve, C<< <jerome@eteve.net> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-nabaztag@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Nabaztag>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2005 Jerome Eteve, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Nabaztag
