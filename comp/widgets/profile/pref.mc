<%doc>
###############################################################################

=head1 NAME

/widgets/profile/preferences.mc - Processes submits from Preferences Profile.

=head1 VERSION

$Revision: 1.11 $

=head1 DATE

$Date: 2003-02-16 00:32:05 $

=head1 SYNOPSIS

  $m->comp('/widgets/profile/preferences.mc', %ARGS);

=head1 DESCRIPTION

This element is called by /widgets/profile/callback.mc when the data to be
processed was submitted from the Preferences Profile page.

</%doc>

%#-- Once Section --#
<%once>;
my $type = 'pref';
my $disp_name = get_disp_name($type);
</%once>

<%args>
$widget
$param
$field
$obj
</%args>

<%init>;
return unless( $field eq "$widget|save_cb" );
my $pref = $obj;
my $name = $pref->get_name;
$pref->set_value($param->{value});
$pref->save;
log_event('pref_save', $pref);
add_msg($lang->maketext("$disp_name [_1] updated.","&quot;$name&quot;"));
set_redirect('/admin/manager/pref');
</%init>