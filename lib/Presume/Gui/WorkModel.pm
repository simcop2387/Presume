package Presume::Gui::WorkModel;

use strict;
use warnings;

use Data::Dumper;
use Gtk2 -init;
use Glib ':constants';

use Presume::Gui::ModelMatch;

use constant {COLUMN_TEXT => 0, COLUMN_BUTTON => 2, COLUMN_SELECTED=>1};

sub initcombomodels
{
	my $self=shift;

  foreach my $data ([qw(one two three four five)],
                    [qw(red orange yellow green blue indigo violet)],
                    [qw(george john paul ringo)],
                    [qw(north south east west)]) 
	{
    my $model = Gtk2::ListStore->new (qw(Glib::String));
    foreach my $string (@$data) 
	  {
      $model->set ($model->append, 0, $string);
    }
    push @{$self->{combo_models}}, $model;
  }
}

sub init
{
	my $class = shift;
	my $guio = shift; #Presume::Gui object

	my $self = {};
	bless $self, $class;

	$self->initcombomodels();

	my $model = Gtk2::ListStore->new("Glib::String", "Glib::String","Gtk2::ListStore");
	$self->{model} = $model;

  my $treeview = $guio->get_widget('workexp');
  $treeview->set_model($model);

foreach my $data (
    { name => 'Fred', current => 1, model => $self->{combo_models}->[0] },
    { name => 'Barney', current => 2, model => $self->{combo_models}->[0] },
    { name => 'Wilma', current => 3, model => $self->{combo_models}->[0] },
    { name => 'Betty', current => 0, model => $self->{combo_models}->[0] },
    { name => 'Pebbles', current => 2, model => $self->{combo_models}->[0] },
    { name => 'Bam-Bam', current => 3, model => $self->{combo_models}->[0] },)
	{

    $data->{current} = $data->{model}->get ($data->{model}->iter_nth_child (undef, $data-> {current}), 0);
     
		$model->set ($model->append,
                 COLUMN_TEXT, $data->{name},
                 COLUMN_SELECTED, $data->{current},
                 COLUMN_BUTTON, $data->{model});
	}

	my $tcell = Gtk2::CellRendererText->new;
	$tcell->set(editable=>TRUE);
	my $tcolumn = Gtk2::TreeViewColumn->new_with_attributes('My Column',
                                                       $tcell,
                                                       text => COLUMN_TEXT);

	my $brend = Gtk2::CellRendererCombo->new;
  $brend->set(text_column => 0, editable=>TRUE);


	$brend->signal_connect (edited => 
		sub 
		{
			  my $datamodel=$self->{combo_models}->[0];
        my ($cell, $text_path, $new_text) = @_;
				my $iter=Presume::Gui::ModelMatch::exists($datamodel, 0, $new_text);

				$datamodel->set($datamodel->append, 0, $new_text) unless defined($iter);
        $model->set ($model->get_iter_from_string ($text_path), COLUMN_SELECTED, $new_text);
		});
  my $bcolumn = Gtk2::TreeViewColumn->new_with_attributes('My Column',
                                                       $brend,
                                                       text => COLUMN_SELECTED, model=>COLUMN_BUTTON);

  $treeview->append_column($tcolumn);
	$treeview->append_column($bcolumn);
}

1;
