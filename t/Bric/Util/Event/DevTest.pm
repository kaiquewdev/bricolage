package Bric::Util::Event::DevTest;
use strict;
use warnings;
use base qw(Bric::Test::DevBase);
use Test::More;
use Bric::Util::Event;

sub table { 'event' }

my $et_key = 'user_new';
my $et = Bric::Util::EventType->lookup({ key_name => $et_key });
my $user = Bric::Biz::Person::User->lookup({ id => __PACKAGE__->user_id });
my $et_key2 = 'user_save';
my $et2 = Bric::Util::EventType->lookup({ key_name => $et_key2 });

my %event = ( obj  => $user,
              user => $user,
              et   => $et );

##############################################################################
# Test constructors.
##############################################################################
# Test the lookup() method.
sub test_lookup : Test(10) {
    my $self = shift;

    # Construct a new event object.
    my %args = %event;
    ok( my $e = Bric::Util::Event->new(\%args), "Construct event" );
    # The even constructor calls save() itself.
    ok( my $eid = $e->get_id, "Get ID" );
    $self->add_del_ids($eid);

    # Make sure it's a good event.
    isa_ok($e, 'Bric::Util::Event');
    isa_ok($e, 'Bric');

    # Check a few attributes.
    is( $e->get_user_id, $user->get_id, "Check user ID" );
    is( $e->get_event_type_id, $et->get_id, "Check ET ID" );
    is( $e->get_obj_id, $user->get_id, "Check object ID" );
    is( $e->get_name, $et->get_name, "Check name" );
    is( $e->get_description, $et->get_description, "Check description" );
    is( $e->get_class, $et->get_class, "Check class" );
}

##############################################################################
# Test list().
sub test_list : Test(30) {
    my $self = shift;

    # Create some test records.
    for my $n (1..5) {
        my %args = %event;
        if ($n % 2) {
            # There'll be three of these.
            $args{et} = $et2;
        } else {
            # There'll be two of these.
        }
        # Make sure the name is unique.
        ok( my $e = Bric::Util::Event->new(\%args), "Create event" );
        ok( $e->save, "Save event" );
        # Save the ID for deleting.
        $self->add_del_ids($e->get_id);
    }

    # Start with the "name" attribute.
    my $name = $et->get_name;
    ok(my @events = Bric::Util::Event->list({ name => $name}),
       "List name '$name'" );
    is(scalar @events, 2, "Check for 2 events");

    $name = $et2->get_name;
    ok(@events = Bric::Util::Event->list({ name => $name}),
       "List name '$name'" );
    is(scalar @events, 3, "Check for 3 events");

    # Try user_id.
    my $uid = $user->get_id;
    ok(@events = Bric::Util::Event->list({ user_id => $uid }),
       "List user_id '$uid'" );
    is(scalar @events, 5, "Check for 5 events");

    # Try obj_id.
    ok(@events = Bric::Util::Event->list({ obj_id => $uid }),
       "List obj_id '$uid'" );
    is(scalar @events, 5, "Check for 5 events");

    # Try class_id.
    my $cid = Bric::Util::Class->lookup({ key_name => 'user' })->get_id;
    ok(@events = Bric::Util::Event->list({ class_id => $cid }),
       "List class_id '$cid'" );
    is(scalar @events, 5, "Check for 5 events");

    # Try class.
    my $class = 'Bric::Biz::Person::User';
    ok(@events = Bric::Util::Event->list({ class => $class }),
       "List class '$class'" );
    is(scalar @events, 5, "Check for 5 events");

    # Try key_name.
    ok(@events = Bric::Util::Event->list({ key_name => $et_key }),
       "List key_name '$et_key'" );
    is(scalar @events, 2, "Check for 2 events");

    ok(@events = Bric::Util::Event->list({ key_name => $et_key2 }),
       "List key_name '$et_key2'" );
    is(scalar @events, 3, "Check for 3 events");

    # Try description.
    my $desc = $et->get_description;
    ok(@events = Bric::Util::Event->list({ description => $desc }),
       "List description '$desc'" );
    is(scalar @events, 2, "Check for 2 events");

    $desc = $et2->get_description;
    ok(@events = Bric::Util::Event->list({ description => $desc }),
       "List description '$desc'" );
    is(scalar @events, 3, "Check for 3 events");
}

##############################################################################
# Test list_ids().
sub test_list_ids : Test(30) {
    my $self = shift;

    # Create some test records.
    for my $n (1..5) {
        my %args = %event;
        if ($n % 2) {
            # There'll be three of these.
            $args{et} = $et2;
        } else {
            # There'll be two of these.
        }
        # Make sure the name is unique.
        ok( my $e = Bric::Util::Event->new(\%args), "Create event" );
        ok( $e->save, "Save event" );
        # Save the ID for deleting.
        $self->add_del_ids($e->get_id);
    }

    # Start with the "name" attribute.
    my $name = $et->get_name;
    ok(my @event_ids = Bric::Util::Event->list_ids({ name => $name}),
       "List IDs name '$name'" );
    is(scalar @event_ids, 2, "Check for 2 event IDs");

    $name = $et2->get_name;
    ok(@event_ids = Bric::Util::Event->list_ids({ name => $name}),
       "List IDs name '$name'" );
    is(scalar @event_ids, 3, "Check for 3 event IDs");

    # Try user_id.
    my $uid = $user->get_id;
    ok(@event_ids = Bric::Util::Event->list_ids({ user_id => $uid }),
       "List IDs user_id '$uid'" );
    is(scalar @event_ids, 5, "Check for 5 event IDs");

    # Try obj_id.
    ok(@event_ids = Bric::Util::Event->list_ids({ obj_id => $uid }),
       "List IDs obj_id '$uid'" );
    is(scalar @event_ids, 5, "Check for 5 event IDs");

    # Try class_id.
    my $cid = Bric::Util::Class->lookup({ key_name => 'user' })->get_id;
    ok(@event_ids = Bric::Util::Event->list_ids({ class_id => $cid }),
       "List IDs class_id '$cid'" );
    is(scalar @event_ids, 5, "Check for 5 event IDs");

    # Try class.
    my $class = 'Bric::Biz::Person::User';
    ok(@event_ids = Bric::Util::Event->list_ids({ class => $class }),
       "List IDs class '$class'" );
    is(scalar @event_ids, 5, "Check for 5 event IDs");

    # Try key_name.
    ok(@event_ids = Bric::Util::Event->list_ids({ key_name => $et_key }),
       "List IDs key_name '$et_key'" );
    is(scalar @event_ids, 2, "Check for 2 event IDs");

    ok(@event_ids = Bric::Util::Event->list_ids({ key_name => $et_key2 }),
       "List IDs key_name '$et_key2'" );
    is(scalar @event_ids, 3, "Check for 3 event IDs");

    # Try description.
    my $desc = $et->get_description;
    ok(@event_ids = Bric::Util::Event->list_ids({ description => $desc }),
       "List IDs description '$desc'" );
    is(scalar @event_ids, 2, "Check for 2 event IDs");

    $desc = $et2->get_description;
    ok(@event_ids = Bric::Util::Event->list_ids({ description => $desc }),
       "List IDs description '$desc'" );
    is(scalar @event_ids, 3, "Check for 3 event IDs");
}

##############################################################################
# Test instance methods.
##############################################################################
# Test save() not necessary, because saving is tested by test_lookup().

1;
__END__
