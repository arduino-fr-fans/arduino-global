#!/opt/local/bin/perl
use GD;
use GD::Simple;
use Data::Dumper;

$multiplicator = 2;
$imgwidth = $imgheight = 8*$multiplicator;
$fontname='./slkscr.ttf';

# create a new imag
$img = GD::Simple->new($imgwidth, $imgheight);
$img->font($fontname);
$black = $img->colorAllocate(0,0,0);

# draw a red rectangle with blue borders
$img->bgcolor('white');
$img->fgcolor('black');

$fontsize = 1;
$str = "$ARGV[0]";
@metrics = $img->fontMetrics();
#print Dumper(\@metrics);

do {
  $img->fontsize($fontsize++);
  @metrics = $img->fontMetrics();
  $maxheight = $imgheight - $metrics[0]{'descent'};
} while( ($img->stringBounds($str))[0] < $imgwidth && ($img->stringBounds($str))[1] < $maxheight );



$posX = ($imgwidth - ($img->stringBounds($str))[0])/2;
$posY = ($img->stringBounds($str))[1] ;
#$posY -= $metrics[0]{'descent'} if $str =~ /(g|j|p|q|y)/i;


#$img->moveTo($posX, $posY);
$img->stringFT(-$black,$fontname,$fontsize,0,$posX,$posY,"$str");


print $img->png;

