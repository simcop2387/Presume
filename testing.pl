
#!/usr/bin/perl -w
use strict;
use Gtk2 -init;
use Glib ':constants';

#

# create a bunch of models to hold the appropriate choices for the various rows

#
my @combo_models;
foreach my $data ([qw(one two three four five)],
                  [qw(red orange yellow green blue indigo violet)],
                  [qw(george john paul ringo)],
                  [qw(north south east west)]) {
    my $model = Gtk2::ListStore->new (qw(Glib::String));
    foreach my $string (@$data) {
        $model->set ($model->append, 0, $string);
    }
    push @combo_models, $model;
}

#
# create and populate the main list
#
use constant NAME_COLUMN => 0;
use constant CURRENT_COLUMN => 1;
use constant MODEL_COLUMN => 2;
my @column_types;
$column_types[NAME_COLUMN] = 'Glib::String';
$column_types[CURRENT_COLUMN] = 'Glib::String';
$column_types[MODEL_COLUMN] = 'Gtk2::ListStore';
my $model = Gtk2::ListStore->new (@column_types);
foreach my $data (
    { name => 'Fred', current => 1, model => $combo_models[0] },
    { name => 'Barney', current => 2, model => $combo_models[1] },
    { name => 'Wilma', current => 3, model => $combo_models[2] },
    { name => 'Betty', current => 0, model => $combo_models[3] },
    { name => 'Pebbles', current => 2, model => $combo_models[0] },
    { name => 'Bam-Bam', current => 3, model => $combo_models[1] },
) {
    $data->{current} =
            $data->{model}->get

($data->{model}->iter_nth_child (undef, $data-> {current}), 0);

    $model->set ($model->append,
                 NAME_COLUMN, $data->{name},
                 CURRENT_COLUMN, $data->{current},
                 MODEL_COLUMN, $data->{model});
}

#
# create a view for that model.
#
my $treeview = Gtk2::TreeView->new ($model);

$treeview->insert_column_with_attributes
        (-1, 'Name', Gtk2::CellRendererText->new, text => NAME_COLUMN);

my $combo_renderer = Gtk2::CellRendererCombo->new;

$combo_renderer->set (text_column => 0, # col in combo model with text to display
                     editable => TRUE); # without this, it's just a text renderer

$combo_renderer->signal_connect (edited => sub {
        my ($cell, $text_path, $new_text) = @_;
        $model->set ($model->get_iter_from_string ($text_path),
                     CURRENT_COLUMN, $new_text);
});
$treeview->insert_column_with_attributes
        (-1, 'Selection', $combo_renderer,
         text => CURRENT_COLUMN, model => MODEL_COLUMN);

#
# put all that on the screen
#
my $window = Gtk2::Window->new;
$window->signal_connect (destroy => sub { Gtk2->main_quit });
$window->add ($treeview);
$window->show_all;
Gtk2->main;
