#!/usr/bin/env perl

#	$1 -> Source dir (${ROOT}/application)
#	$2 -> Destination dir (${ROOT}/cdrom)

use Env qw/ROOT/;

my $src_d = $ARGV[0];
my $dest_d = $ARGV[1];
my $index = "$ROOT/index";

my $WIKI2HTML = "$ROOT/scripts/creolewiki/creole2html.py";

sub trim($);
sub readMeta($);
sub nirvikalpa_index_start();
sub nirvikalpa_index_end();

open(HTML_INDEX, "> $dest_d/index.htm") or die "Can't open: $!";

# Read the application index
open(APP_INDEX, "< $index") or die "Can't read index File: $!";
my @LINES = <APP_INDEX>;
close(APP_INDEX);

# Menu items
my $MENU='<div id="menu"><ul id="nav">'."\n".'<li><div class="parent">About the Nirvikalpa CD 2.0</div><ul class="child" style="display:none;">';
$MENU .= '<li class="link" id="nirvikalpa_intro">Introduction</li><li class="link" id="nirvikalpa_howto">How to use the CD</li>';
$MENU .= '<li class="link" id="nirvikalpa_whatisoss">What is Open Source Software?</li><li class="link" id="nirvikalpa_faq">FAQ</li>';
$MENU .= '<li class="link" id="nirvikalpa_help">Help for Open Source programs</li><li class="link" id="nirvikalpa_disclamer">Disclaimer</li>';
$MENU .= '<li class="link" id="nirvikalpa_about_fossnepal">About FOSS Nepal</li><li class="link" id="nirvikalpa_credits">Credits</li></ul></li>'."\n";

$MENU_START=0;
foreach (@LINES)
{       
        if ( /^\*(.*)$/ ) {
                local $APPLICATION;
                local $NAME=trim($1);
                local $META="$src_d/$NAME/meta";
                
                $APPLICATION = readMeta($META);
                $APPLICATION{NAME}=$NAME;
                
                # Add Install and Download links
                open(FILE, ">> $dest_d/site/contents/$APPLICATION{LINUX_NAME}.htm") or die $!;
                print FILE "<div id='buttons'>\n";
                print FILE "<a id='navInstall' href='software/$CATEGORY/$APPLICATION{EXECUTABLE_NAME}'><b>Install / Download</b> $APPLICATION{NAME}</a>\n";
                print FILE "<a id='homepageurl' href='$APPLICATION{HOMEPAGE}' title='$APPLICATION{HOMEPAGE}' >$APPLICATION{NAME} <b>Home&nbsp;Page</b></a>\n";
                print FILE "</div>\n";
                close(FILE);
                
                # Convert the wiki to htmL
                `python $WIKI2HTML < "$src_d/$APPLICATION{NAME}/detail.wiki" | sed s:'images/':'site/images/':g >> "$dest_d/site/contents/$APPLICATION{LINUX_NAME}.htm"`;
                `cp -r "$src_d/$APPLICATION{NAME}/images" "$dest_d/site/"`;
                
                #Add this item  to menu
                $MENU .='<li class="link" id="'.$APPLICATION{LINUX_NAME}.'">'.$APPLICATION{NAME}.'</li>';
                
        }
        else {
           if ( /^(.*)$/ ) {
                if ($MENU_START > 0) { $MENU .='</ul></li>'."\n"; }
                $MENU_START=1;
                $CATEGORY=trim($1);
                $MENU .= '<li><div class="parent">'.$CATEGORY.'</div><ul class="child" style="display:none;">';
                print "Category: '$CATEGORY'\n";
           }
        }
}
$MENU .= '</ul></li>'."\n".'<li><div class="dummy"></div></li></ul></div>'."\n";
nirvikalpa_index_start();
print HTML_INDEX $MENU;
nirvikalpa_index_end();

close(HTML_INDEX);

sub trim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}


sub readMeta($)
{
        my $APPLICATION;
        open(META, "< @_") or die "Can't read index File: $!";
        while (<META>) {
            chomp;                  # no newline
            s/#.*//;                # no comments
            s/^\s+//;               # no leading white
            s/\s+$//;               # no trailing white
            next unless length;     # anything left?
            my ($var, $value) = split(/\s*=\s*/, $_, 2);
            $APPLICATION{$var} = $value;
        }
        return $APPLICATION;
}


sub nirvikalpa_index_start(){
print HTML_INDEX '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta name="Description" content="NirVikalpa - a collection of Free and Open Source Software (FOSS) put together by FOSS Nepal Community with most work derived from the Trinidad and Tobago Computer Society">
<link type="text/css" rel="stylesheet" href="site/css/w.css"/>
<title>Nirvikalpa</title>
<script type="text/javascript" language="Javascript" src="site/js/jquery-1.3.2.min.js"></script>
<script type="text/javascript" language="Javascript" src="site/js/jquery.accordion.js"></script>
<script type="text/javascript" language="Javascript" src="site/js/jquery.custom.js"></script>
</head>
<body>
<p id="loading" style="display:none;">Loading...</p>
<div id="wrap">
<div id="header" title="About Nirvikalpa"><div>..not an alternative but the only way.</div></div>
';
}

sub nirvikalpa_index_end(){
print HTML_INDEX '<div id="core">
<center>
Javascript must be enabled to browse this CD.<br/>
Please Enable the Javascript.<br/><br/><br/>
Or you can simply browse the "software" folder and install required application from there. Yes, it obviously going to be tough. But you dont have any other option. ;)
</center>
</div>
<div id="footer"><a href="http://wiki.fossnepal.org/index.php?title=Nirvikalpa">Nirvikalpa</a> is a product of <a href="http://www.fossnepal.org">FOSS-Nepal</a> and is released under <a href="http://creativecommons.org/licenses/by-nc-sa/2.5/">Creative Commons Attribution-NonCommercial-ShareAlike 2.5 Licence</a>..</div>
<!--
<rdf:RDF xmlns="http://web.resource.org/cc/"
xmlns:dc="http://purl.org/dc/elements/1.1/"
xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<Work rdf:about="">
<dc:title>Nirvikalpa CD 2.0</dc:title>
<dc:date>2009</dc:date>
<dc:description>The Nirvikalpa CD is a CD&amp;#45;ROM that contains various open source software for the Windows platform. The CD contains documentation about the programs on the CD ; a short introduction, key features and useful program related links, all done from a web based interface.</dc:description>
<dc:creator><Agent>
<dc:title>Foss Nepal</dc:title>
</Agent></dc:creator>
<dc:rights><Agent>
<dc:title>Foss Nepal</dc:title>
</Agent></dc:rights>
<dc:type rdf:resource="http://purl.org/dc/dcmitype/Interactive" />
<license rdf:resource="http://creativecommons.org/licenses/by-nc-sa/2.5/" />
</Work>
<License rdf:about="http://creativecommons.org/licenses/by-nc-sa/2.5/">
<permits rdf:resource="http://web.resource.org/cc/Reproduction" />
<permits rdf:resource="http://web.resource.org/cc/Distribution" />
<requires rdf:resource="http://web.resource.org/cc/Notice" />
<requires rdf:resource="http://web.resource.org/cc/Attribution" />
<prohibits rdf:resource="http://web.resource.org/cc/CommercialUse" />
<permits rdf:resource="http://web.resource.org/cc/DerivativeWorks" />
<requires rdf:resource="http://web.resource.org/cc/ShareAlike" />
</License>
</rdf:RDF>
-->
</div>
</body>
</html>';
}
