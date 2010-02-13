package XML::RSS::PicLens;

use warnings;
use strict;
use Carp;

use base qw( XML::RSS );

=head1 NAME

XML::RSS::PicLens - Create a PicLens compatible RSS feed

=head1 VERSION

This document describes XML::RSS::PicLens version 0.02

=cut

our $VERSION = '0.02';

=head1 SYNOPSIS

    use XML::RSS::PicLens;

    my $feed = XML::RSS::PicLens->new;
    $feed->add_image(
        link      => 'foo.jpg',
        image     => 'foo.jpg',
        thumbnail => 'thumbs/foo.jpg',
        title     => 'An bootiful foo'
    );
    print $feed->as_string;

=head1 DESCRIPTION

PicLens is an immersive media browser that can be launched directly from
a web browser when visiting a supported site. It uses RSS autodiscovery
to locate an RSS feed describing the available media. This module
provides a simple interface for generating such a feed.

See L<http://piclens.com/lite/webmasterguide.php> for more information.

=head1 INTERFACE 

=head2 C<< new >>

Create a new C<XML::RSS::PicLens> object. C<XML::RSS::PicLens> is a
subclass of L<XML::RSS>; any arguments to C<new> are passed to the
superclass's constructor. The RSS version defaults to 2.0.

=cut

sub new {
    my $class = shift;
    my $self = $class->SUPER::new( version => '2.0', @_ );

    $self->add_module(
        prefix => 'media',
        uri    => 'http://search.yahoo.com/mrss'
    );

    return $self;
}

=head2 C<< add_image >>

Add an image to the feed.

    $feed->add_image(
        link      => 'foo.jpg',
        image     => 'foo.jpg',
        thumbnail => 'thumbs/foo.jpg',
        title     => 'An bootiful foo'
    );

At least one of C<image>, C<thumbnail> must be supplied. Optionally you
may supply C<link> and C<title>. If these are omitted they will default
to values based on C<image> or C<thumbnail>.

=cut

sub add_image {
    my $self = shift;
    croak "add_image must be called as a method"
      unless ref $self;
    croak "add_image needs a number of key => value pairs"
      if @_ % 1;
    my %args = @_;

    my $image     = delete $args{image};
    my $thumbnail = delete $args{thumbnail};

    croak "add_image needs at least one of image, thumbnail"
      unless defined $image
          or defined $thumbnail;

    my $default = defined $image ? $image : $thumbnail;

    my $link  = delete $args{link};
    my $title = delete $args{title};

    $link = $default unless defined $link;
    ( $title = $default ) =~ s!.*/!! unless defined $title;

    $self->add_item(
        title => $title,
        link  => $link,
        media => {
            (
                defined $thumbnail
                ? ( thumbnail => { url => $thumbnail } )
                : ()
            ),
            ( defined $image ? ( content => { url => $image } ) : () ),
        },
    );
}

=head2 C<< as_string >>

Gets a string containing the XML for the feed.

=cut

1;
__END__

=head1 CONFIGURATION AND ENVIRONMENT
  
XML::RSS::PicLens requires no configuration files or environment variables.

=head1 DEPENDENCIES

None.

=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-xml-atom-piclens@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.

=head1 AUTHOR

Andy Armstrong  C<< <andy.armstrong@messagesystems.com> >>

=head1 LICENCE AND COPYRIGHT

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

Copyright (c) 2008, Message Systems, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or
without modification, are permitted provided that the following
conditions are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in
      the documentation and/or other materials provided with the
      distribution.
    * Neither the name Message Systems, Inc. nor the names of its
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER
OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
