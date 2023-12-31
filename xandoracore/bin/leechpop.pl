#!/usr/bin/perl
#
# LeechPOP - save ONLY attachments from a POP3 mailbox, with filtering.
# Part of the Leecharoo suite - for all those hard to leech places.
# http://disobey.com/d/code/ or contact morbus@disobey.com.
#
# This code is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
#
# 1.0 (2003-05-20)
#   * Initial release.
#

use warnings;
use strict; $|++;
my $VERSION = "1.0";
use Getopt::Long;
my %opts;

# make sure we've got the modules we need, else die peacefully.
eval("use Net::POP3;"); die "[err] Net::POP3 is not installed.\n" if $@;
eval("use MIME::Parser;"); die "[err] MIME::Parser is not installed.\n" if $@;

# define our command line flags (long and short versions).
GetOptions(\%opts, 'server|s=s',      # the POP3 server to use.
                   'username|u=s',    # the POP3 username to use.
                   'password|p=s',    # the POP3 password to use.
                   'begin|b=i',       # what msg number to start at.
);

# at the very least, we need our login information.
die "[err] POP3 server missing, use --server or -s.\n" unless $opts{server};
die "[err] Username missing, use --username or -u.\n"  unless $opts{username};
die "[err] Password missing, use --password or -p.\n"  unless $opts{password};

# try an initial connection to the server.
print "-" x 76, "\n"; # merely a visual seperator.
my $conn = Net::POP3->new( $opts{server} )
  or die "[err] There was a problem connecting to the server.\n";
print "Connecting to POP3 server at $opts{server}.\n";

# and now the login information.
$conn->login( $opts{username}, $opts{password} )
  or die "[err] There was a problem logging in (.poplock? credentials?).\n";
print "Connected successfully as $opts{username}.\n";

# purdy stats about our mailbox.
my ($msg_total, $mbox_size) = $conn->popstat();
if ($msg_total eq 0)  { print "No new emails are available.\n"; exit; }
if ($msg_total eq '0E0')  { print "No new emails are available.\n"; exit; }
print "You have $msg_total messages totalling ", commify($mbox_size), "k.\n";

# the list of valid file extensions. we do extensions not
# mime-types because they're easier to understand from
# an end-user perspective (no research is required).
my $valid_exts = "jpg jpeg png";
my %msg_ids; # used to keep track of seen emails.
my $msg_num = $opts{begin} || 1; # user specified or 1.

# create a sub-directory based on today's date.
my ($d,$m,$y) = (localtime)[3,4,5]; $y += 1900; $m++;
$d = sprintf "%02.0d", $d; $m = sprintf "%02.0d", $m;
print "Using directory '$y-$m-$d' for newly downloaded files.\n";
my $savedir = "$y-$m-$d"; 
#mkdir($savedir, 0777);

# if we started at a number greater than one,
# delete all the messages preceding that number.
print "Beginning downloads, starting at message $msg_num.\n";
for (my $i=1; $i < $msg_num; $i++) { $conn->delete($i); }

# begin looping through each msg.
print "-" x 76, "\n"; # merely a visual seperator.
while ($msg_num <= $msg_total) {

    # the size of the individual email.
    my $msg_size = $conn->list($msg_num);

    # get the header of the message
    # so we can check for duplicates.
    my $headers = $conn->top($msg_num);

    # print / store the good bits.
    my ($msg_subj, $msg_id);
    foreach my $header (@$headers) {

        # print subject line and size.
        if ($header =~ /^Subject: (.*)/) {
            $msg_subj = substr($1, 0, 50); # trim subject down a bit.
            print "Msg $msg_num / ",commify($msg_size),"k / $msg_subj...\n";
        }

        # save message-id for duplicate comparison.
        elsif ($header =~ /^Message-ID: <(.*)>/i) {
            $msg_id = $1; $msg_ids{$msg_id}++;
        }

        # move on to the filtering.
        elsif ($msg_subj and $msg_id) { last; }

    }

    # if the message size is too small, then it
    # could be a reply or something low-quality.
    if (defined($msg_size) and $msg_size < 40000) {
        print "  Skipping - message size is smaller than our threshold.\n";
        $conn->delete($msg_num); $msg_num++; next;
    }

    # check for matching Message-ID. If found,
    # skip and delete this message. This will help
    # eliminate crossposting and duplicate downloads.
    if (defined($msg_id) and $msg_ids{$msg_id} >= 2) {
        print "  Skipping - we've already seen this Message-ID.\n";
        $conn->delete($msg_num); $msg_num++; next;
    }

    # get the message to feed to MIME::Parser.
    my $msg = $conn->get($msg_num);

    # create a MIME::Parser object to
    # extract any attachments found within.
    my $parser = new MIME::Parser;
    $parser->output_dir();
    my $entity = $parser->parse_data($msg);

    # extract our mime parts
    # and go through each one.
    my @parts = $entity->parts;
    foreach my $part (@parts) {

        # determine the path to the file in question.
        my $path = ($part->bodyhandle) ? $part->bodyhandle->path : undef;

        # move on if it's not defined,
        # else, figure out the extension.
        next unless $path; $path =~ /\w+\.([^.]+)$/;
        my $ext = $1; next unless $ext;

        # we only continue if our extension is correct.
        # my $continue; $continue++ if $valid_exts =~ /$ext/i;

        # delete the blasted thing.
        unless ($valid_exts =~ /$ext/) {
           print "  Removing unwanted filetype ($ext): $path\n";
           unlink $path or print " > Error removing file at $path: $!.";
           next; # move on to the next attachment or message.
        }

        # a valid file type. yummy!
        print "  Keeping valid file: $path.\n";

    }

    # mark this message for deletion and increase
    # our counter. note that the message isn't 
    # truly deleted until we close the connection
    $conn->delete($msg_num); $msg_num++;
}

# cleanup and delete.
$conn->quit; print "Email(s) have been deleted.\n";

# now, jump into our savedir and remove all msg-*
# files which are message bodies saved by MIME::Parser.
chdir ($savedir); opendir(SAVE, "./") or die $!;
my @dir_files = grep !/^\.\.?$/, readdir(SAVE); closedir(SAVE);
foreach (@dir_files) { unlink if $_ =~ /^msg-/; }

# cookbook 2.17.
sub commify {
    my $text = reverse $_[0];
    $text =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
    return scalar reverse $text;
}

