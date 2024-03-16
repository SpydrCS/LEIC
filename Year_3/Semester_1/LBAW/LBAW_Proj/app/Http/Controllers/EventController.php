<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

use App\Models\Users;
use App\Models\Event;
use App\Models\Poll;
use App\Models\Comment;
use App\Models\Attendee;
use App\Models\Report;
use App\Models\EventFeature;
use App\Models\Notification;
use App\Models\PollFile;

class EventController extends Controller
{
  public function home() {
    return redirect()->route('events', ['date' => 'all']);
  }

  public function show($id)
  {
    EventController::setCount($id);

    $event = DB::table('event')->where('id', $id)->get();
    $event_find = Event::find($id);
    $attendees_id = array();
    foreach ($event_find->attendees as $attendee) {
      array_push($attendees_id, $attendee->users_id);
    }
    #$user_id = Auth::user()->id;
    return view('pages.event', ['event' => $event, 'features' => $event_find->features, 'attendees' => $event_find->attendees, 'attendees_id' => $attendees_id, 'polls' => $event_find->polls]);
  }

  public function setCount($id)
  {
    $attendees = DB::table('attendee')->where('event_id', $id)->get();
    $event = Event::find($id);
    $event->attendee_counter = count($attendees);
    $event->save();
    return $event;
  }

  public function showDate($id)
  {
    $event = Event::find($id);
    $event_date = $event->start_datetime;
    return (strtotime($event_date) - strtotime(date('Y-m-d H:i:s'))) / 86400;
  }

  public function list($date = 'all')
  {

    if (!Auth::check()) {
      $events = DB::table('event')->where('is_private', false)->orderBy('id')->get();
    }
    else {
      $events = DB::table('event')->where('start_datetime', '>', date('Y-m-d H:i:s'))->orderBy('id')->get();
    }

    $new_events = collect();

    if ($date == 'all') {
      $new_events = $events;
    }

    foreach ($events as $event) {
      $distance = EventController::showDate($event->id);
      if ($date == 'today') {
        if ($distance <= 1) {
          $new_events->push($event);
        }
      }
      elseif ($date == 'this_week') {
        if ($distance <= 7) {
          $new_events->push($event);
        }
      }
      elseif ($date == 'this_month') {
        if ($distance <= 30) {
          $new_events->push($event);
        }
      }
      elseif ($date == 'this_year') {
        if ($distance <= 365) {
          $new_events->push($event);
        }
      }
    }

    $all_tags = array();
    foreach ($new_events as $event) {
      $tags = explode(' ', $event->tag);
      foreach ($tags as $tag) {
        if (!in_array(ucfirst($tag), $all_tags)) {
          array_push($all_tags, $tag);
        }
      }
    }

    $all_locations = array();
    foreach ($new_events as $event) {
      if (!in_array(ucfirst($event->location), $all_locations)) {
        array_push($all_locations, ucfirst($event->location));
      }
    }

    return view('pages.events', ['events' => $new_events->sortBy('start_datetime'), 'tags' => $all_tags, 'locations' => $all_locations]);
  }

  public function allEvents() {
    if (!Auth::check()) return redirect('/login');

    if (!Auth::user()->is_admin) return redirect('/');

    $events = Event::all()->sortby('owner_id');

    return view('pages.all_events', ['events' => $events]);
  }

  public function updateEvent($id) 
  {
    if (!Auth::check()) return redirect('/login');

    $event = Event::find($id);

    if ($event->owner_id != Auth::user()->id) return redirect('/');

    return view('pages.update_event', ['event' => $event]);
  }

  public function updatePrivacy(Request $request) {
    $event = Event::find($request->input('event_id'));

    if ($request->input('is_checked') == 'true') {
      $event->is_private = 'true';
      $event->save();
      return 'true';
    }
    else {
        $event->is_private = 'false';
        $event->save();
        return 'false';
    }
    return 'not working';
  }

  public function createEvent() 
  {
    if (!Auth::check()) return redirect('/login');

    return view('pages.create_event');
  }

  public function joinEvent(Request $request)
  {
    if (!Auth::check()) return redirect('/login');

    $event_id = $request->input('id');
    $users_id = Auth::user()->id;

    $exists = DB::table('attendee')->where('users_id', $users_id)->where('event_id', $event_id)->get();
    if (count($exists) > 0) {
      return 102; # 'You are already attending this event!'
    }

    if (Users::find($users_id)->wallet_balance < Event::find($event_id)->price) {
      return 101; # 'You do not have enough money to join this event.'
    }

    Users::find($users_id)->decrement('wallet_balance', Event::find($event_id)->price);

    $attendee = AttendeeController::create($event_id, $users_id);

    return 1; # 'You have successfully joined this event!'
  }

  public function requestJoinEvent(Request $request) 
  {
    if (!Auth::check()) return redirect('/login');

    $event_id = $request->input('id');

    $user_id = Auth::user()->id;
    $owner_id = Event::find($event_id)->owner_id;

    $exists = DB::table('notification')->where('sent_users_id', $user_id)->where('receiver_users_id', $owner_id)->where('event_id', $event_id)->get();

    if (count($exists) > 0) {
      return 103; # 'You have already requested to join this event!'
    }

    if (Users::find($user_id)->wallet_balance < Event::find($event_id)->price) {
      return 101; # 'You do not have enough money to join this event.'
    }
    
    $notification = NotificationController::create($event_id, $user_id, $owner_id);

    return 2; # 'You have successfully requested to join this event!'
  }

  public function inviteFriend(Request $request)
  {
    if (!Auth::check()) return redirect('/login');

    $event_id = $request->input('event_id');
    $invite_id = $request->input('invite_id');
    $user_id = $request->input('user_id');

    $exists = DB::table('notification')->where('sent_users_id', $user_id)->where('receiver_users_id', $invite_id)->where('event_id', $event_id)->get();

    if (count($exists) > 0) {
      return 4; # 'You have already requested to join this event!'
    }
    
    $notification = NotificationController::create($event_id, $user_id, $invite_id);

    return 3; # 'You have successfully requested to join this event!'
  }

  public function inviteAttendee($event_id)
  {
    if (!Auth::check()) return redirect('/login');

    return view('pages.invite_attendee', ['event_id' => $event_id]);
  }

  public function inviteEventAttendee(Request $request)
  {
    if (!Auth::check()) return redirect('/login');

    $event_id = $request->input('event_id');
    $user_id = $request->input('user_id');
    $owner_id = Event::find($event_id)->owner_id;

    $exists = DB::table('notification')->where('sent_users_id', $owner_id)->where('receiver_users_id', $user_id)->where('event_id', $event_id)->get();
    if (count($exists) > 0) {
      return 'You have already invited this user to your event!';
    }

    $notification = NotificationController::create($event_id, $owner_id, $user_id);

    return 'You have successfully invited ' . Users::find($user_id)->name . ' to your event!';
  }

  public function manageParticipants($id) {
    if (!Auth::check()) return redirect('/login');

    $event = Event::find($id);

    if ($event->owner_id != Auth::user()->id) {
      return redirect('/events/all');
    }

    return view('pages.manage_participants', ['event' => $event, 'attendees' => $event->attendees]);
  }

  public function changeStatus(Request $request) {
    if (!Auth::check()) return redirect('/login');

    $event = Event::find($request->input('id'));

    if (!Auth::user()->is_admin && Auth::user()->id != $event->owner_id) return redirect('/events/all');

    if ($event->is_full) {
      $event->is_full = 'false';
      $event->save();
      return 1; # open event
    }
    else {
      $event->is_full = 'true';
      $event->save();
      return 2; #close event
    }
  }

  public function create(Request $request)
  {
    $event = new Event();

    $highest = DB::table('event')->max('id');

    $id = $highest + 1;

    $event->id = $id;
    $event->name = $request->input('name');
    $event->description = $request->input('description');
    $event->tag = $request->input('tag');
    $event->start_datetime = $request->input('start_datetime');
    $event->end_datetime = $request->input('end_datetime');
    $event->price = $request->input('price');
    $event->max_capacity = $request->input('max_capacity');
    $event->location = $request->input('location');

    if ($request->input('image') != null) {
      $request->validate(['image' => 'image']);
      $request->file('image')->store('images');
      $event->image = $request->file('image')->hashName();
    }
    else {
      $event->image = 'default.jpg';
    }

    if ($request->input('is_private') == "is_private") {
      $event->is_private = 'true';
    }
    else {
      $event->is_private = 'false';
    }
    $event->owner_id = Auth::user()->id;

    $event->save();

    return redirect('/events/all');
  }

  public function update(Request $request, $id)
  {
    $event = Event::find($id);

    if ($request->input('name') != null) {
      $event->name = $request->input('name');
    }
    if ($request->input('start_datetime') != null) {
      $event->start_datetime = $request->input('start_datetime');
    }
    if ($request->input('end_datetime') != null) {
      $event->end_datetime = $request->input('end_datetime');
    }
    if ($request->input('price') != null) {
      $event->price = $request->input('price');
    }
    if ($request->input('max_capacity') != null) {
      $event->max_capacity = $request->input('max_capacity');
    }
    if ($request->input('location') != null) {
      $event->location = $request->input('location');
    }
    
    if ($request->input('is_private') == "is_private") {
      $event->is_private = 'true';
    }
    else {
      $event->is_private = 'false';
    }

    $event->save();

    return redirect('/event/' . $id);
  }

  public function adminDelete(Request $request)
  {
    $id = $request->input('id');

    $name = Event::find($id)->name;

    $destroy_polls = DB::table('poll')->where('event_id', $id)->get();
      foreach ($destroy_polls as $destroy_poll) {
        $destroy_comments = DB::table('comment')->where('poll_id', $destroy_poll->id)->get();
        foreach ($destroy_comments as $destroy_comment) {
          Comment::destroy($destroy_comment->id);
        }
        $destroy_files = DB::table('poll_file')->where('poll_id', $destroy_poll->id)->get();
        foreach ($destroy_files as $destroy_file) {
          PollFile::destroy($destroy_file->id);
        }
        Poll::destroy($destroy_poll->id);
      }

    $destroy_attendees = DB::table('attendee')->where('event_id', $id)->get();
    foreach ($destroy_attendees as $destroy_attendee) {
      Attendee::destroy($destroy_attendee->id);
      Users::find($destroy_attendee->users_id)->increment('wallet_balance', Event::find($id)->price);
    }

    $destroy_features = DB::table('event_features')->where('event_id', $id)->get();
    foreach ($destroy_features as $destroy_feature) {
      EventFeature::destroy($destroy_feature->id);
    }

    $destroy_notifications = DB::table('notification')->where('event_id', $id)->get();
    foreach ($destroy_notifications as $destroy_notification) {
      Notification::destroy($destroy_notification->id);
    }

    $destroy_reports = DB::table('report')->where('event_id', $id)->get();
    foreach ($destroy_reports as $destroy_report) {
      Report::destroy($destroy_report->id);
    }

    Event::destroy($id);

    return $id;
  }

  public function delete(Request $request, $id)
  {
    $destroy_polls = DB::table('poll')->where('event_id', $id)->get();
      foreach ($destroy_polls as $destroy_poll) {
        $destroy_comments = DB::table('comment')->where('poll_id', $destroy_poll->id)->get();
        foreach ($destroy_comments as $destroy_comment) {
          Comment::destroy($destroy_comment->id);
        }
        $destroy_files = DB::table('poll_file')->where('poll_id', $destroy_poll->id)->get();
        foreach ($destroy_files as $destroy_file) {
          PollFile::destroy($destroy_file->id);
        }
        Poll::destroy($destroy_poll->id);
      }

    $destroy_attendees = DB::table('attendee')->where('event_id', $id)->get();
    foreach ($destroy_attendees as $destroy_attendee) {
      Attendee::destroy($destroy_attendee->id);
      Users::find($destroy_attendee->users_id)->increment('wallet_balance', Event::find($id)->price);
    }

    $destroy_features = DB::table('event_features')->where('event_id', $id)->get();
    foreach ($destroy_features as $destroy_feature) {
      EventFeature::destroy($destroy_feature->id);
    }

    $destroy_notifications = DB::table('notification')->where('event_id', $id)->get();
    foreach ($destroy_notifications as $destroy_notification) {
      Notification::destroy($destroy_notification->id);
    }

    $destroy_reports = DB::table('report')->where('event_id', $id)->get();
    foreach ($destroy_reports as $destroy_report) {
      Report::destroy($destroy_report->id);
    }

    $user_id = Event::find($id)->owner_id;

    Event::destroy($id);
    if (Auth::user()->is_admin) {
      return redirect('/users/' . strval($user_id));
    }
    else {
      return redirect('/users/' . strval(Auth::user()->id));
    }
  }

  public static function scheduleDelete($id) {
    $destroy_polls = DB::table('poll')->where('event_id', $id)->get();
    foreach ($destroy_polls as $destroy_poll) {
      $destroy_comments = DB::table('comment')->where('poll_id', $destroy_poll->id)->get();
      foreach ($destroy_comments as $destroy_comment) {
        Comment::destroy($destroy_comment->id);
      }
      $destroy_files = DB::table('poll_file')->where('poll_id', $destroy_poll->id)->get();
      foreach ($destroy_files as $destroy_file) {
        PollFile::destroy($destroy_file->id);
      }
      Poll::destroy($destroy_poll->id);
    }

    $destroy_attendees = DB::table('attendee')->where('event_id', $id)->get();
    foreach ($destroy_attendees as $destroy_attendee) {
      Attendee::destroy($destroy_attendee->id);
      Users::find($destroy_attendee->users_id)->increment('wallet_balance', Event::find($id)->price);
    }

    $destroy_features = DB::table('event_features')->where('event_id', $id)->get();
    foreach ($destroy_features as $destroy_feature) {
      EventFeature::destroy($destroy_feature->id);
    }

    $destroy_notifications = DB::table('notification')->where('event_id', $id)->get();
    foreach ($destroy_notifications as $destroy_notification) {
      Notification::destroy($destroy_notification->id);
    }

    $destroy_reports = DB::table('report')->where('event_id', $id)->get();
    foreach ($destroy_reports as $destroy_report) {
      Report::destroy($destroy_report->id);
    }

    $user_id = Event::find($id)->owner_id;

    Event::destroy($id);
  }
}
