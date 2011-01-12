package Presume::Gui;

use strict;
use warnings;

use Data::Dumper;

use Gtk2 -init;
use Gtk2::GladeXML;
use Presume::Gui::WorkModel;

our $AUTOLOAD;

sub AUTOLOAD
{
	my $name = $AUTOLOAD;
	$name =~ s/^.*:://;
	warn "Unhandled Signal: $name\n";
}

sub DESTROY
{
	#dummy
}


sub new
{
  my $self = {};
  my $class = shift;

  bless $self, $class;
  
  $self->{gladexml} = Gtk2::GladeXML->new('gui.glade');
  $self->{gladexml}->signal_autoconnect_from_package($self);
  my $win = $self->get_widget('Mainwin');
  $win->show_all;
  $self->inittrees();

  return $self;
}

sub get_widget
{
	my $self = shift;
	return $self->{gladexml}->get_widget(shift);
}

sub inittrees
{
	my $self = shift;

	print "Called inittrees\n";

	$self->{workmodel} = Presume::Gui::WorkModel->init($self);

}

sub run
{
  Gtk2->main;
}

#--------signal handlers
sub openwin
{
	print Dumper(\@_);
  #?
  $_[2]->show_all unless $_[2] eq '';
}

sub closewin
{
	print Dumper(\@_);
	$_[2]->hide_all unless $_[2] eq '';
}

sub quit
{
	Gtk2->main_quit(); #more fun than exit();
}

1;
