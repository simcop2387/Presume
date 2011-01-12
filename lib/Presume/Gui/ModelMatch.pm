package Presume::Gui::ModelMatch;

use strict;
use warnings;

sub _exists
{
	my $model = shift;
	my $path = shift;
	my $iter = shift;
	my $userdata = shift;
  
  my $data = $model->get($iter, $userdata->{col});
	my $string = $userdata->{string};
	my $self = $userdata->{self};

  if ($data eq $string)
	{
		$self->{iter} = $iter;
    return 1;
	}

	return 0;
}

sub exists
{
  my $self = {};
  my $model = shift;
	my $colm = shift;
  my $string = shift;

	$self->{iter} = undef;
	$model->foreach(\&_exists, {self=>$self, col=>$colm, string=>$string});

  return $self->{iter};
}
1;
