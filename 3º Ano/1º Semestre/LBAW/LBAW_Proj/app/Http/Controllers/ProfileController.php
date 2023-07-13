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

class ProfileController extends Controller
{
    public function show($id)
    {
      if (!Auth::check()) return redirect('/login');
      if ($id != Auth::user()->id && !Auth::user()->is_admin) return redirect('/users/' . strval(Auth::user()->id));
      $profile = DB::table('users')->where('id', $id)->get();
      $events = DB::table('event')->where('owner_id', $id)->get();
      $profile_find = Users::find($id);
      $upcoming_events = array();
      $past_events = array();
      foreach ($profile_find->attendees as $attendee) {
        if ($attendee->event->start_datetime > date('Y-m-d h:i:s')) {
          array_push($upcoming_events, $attendee);
        } else {
          array_push($past_events, $attendee);
        }
      }
      return view('pages.profile', ['profile' => $profile, 'attendees' => $profile_find->attendees, 'events' => $events, 'upcoming_events' => $upcoming_events, 'past_events' => $past_events]);
    }

    public function allUsers() {
      if (!Auth::check()) return redirect('/login');
      if (!Auth::user()->is_admin) return redirect('/users/' . strval(Auth::user()->id));
      $users = Users::all()->sortBy('id');
      return view('pages.all_users', ['users' => $users]);
    }

    public function updateProfile($id)
    {
      if (!Auth::check()) return redirect('/login');
      if ($id != Auth::user()->id && !Auth::user()->is_admin) return redirect('/update_profile/' . strval(Auth::user()->id));

      return view('pages.update_profile', ['user' => Users::find($id)]);
    }

    public function addFunds(Request $request)
    {
      if (!Auth::check()) return redirect('/login');

      $funds = $request->input('funds');

      $user_id = $request->input('id');

      $user = Users::find($user_id);

      $user->increment('wallet_balance', $funds);

      return $user->wallet_balance;
    }

    public function updateProfileImage(Request $request, $user_id)
    {
      if (!Auth::check()) return redirect('/login');

      if ($user_id != Auth::user()->id && !Auth::user()->is_admin) return redirect('/users/' . strval(Auth::user()->id));

      $user = Users::find($user_id);

      $request->validate(['image' => 'required|image|max:2048']);

      $request->file('image')->store('images');

      $user->image = $request->file('image')->hashName();

      $user->save();

      return redirect('/users/' . strval($user_id));
    }

    public function update(Request $request, $user_id)
    {
      $user = Users::find($user_id);
      $input = $request->all();
      $input['password'] = bcrypt($input['password']);
      $user->fill($input)->save();
      return redirect('/users/' . strval($user_id));
    }

    public function adminDelete(Request $request)
    {
      $id = $request->input('id');

      #consoleLog("inside function");

      $destroy_events = DB::table('event')->where('owner_id', $id)->get();
      
      foreach ($destroy_events as $destroy_event) {
        $destroy_polls = DB::table('poll')->where('event_id', $destroy_event->id)->get();
        foreach ($destroy_polls as $destroy_poll) {
          $destroy_comments = DB::table('comment')->where('poll_id', $destroy_poll->id)->get();
          foreach ($destroy_comments as $destroy_comment) {
            Comment::destroy($destroy_comment->id);
          }
          Poll::destroy($destroy_poll->id);
        }
        $destroy_attendees = DB::table('attendee')->where('event_id', $destroy_event->id)->get();
        foreach ($destroy_attendees as $destroy_attendee) {
          Attendee::destroy($destroy_attendee->id);
        }

        $destroy_features = DB::table('event_features')->where('event_id', $destroy_event->id)->get();
        foreach ($destroy_features as $destroy_feature) {
          EventFeature::destroy($destroy_feature->id);
        }

        $destroy_reports = DB::table('report')->where('event_id', $destroy_event->id)->get();
        foreach ($destroy_reports as $destroy_report) {
          Report::destroy($destroy_report->id);
        }

        $destroy_notifications = DB::table('notification')->where('event_id', $destroy_event->id)->get();
        foreach ($destroy_notifications as $destroy_notification) {
          Notification::destroy($destroy_notification->id);
        }

        Event::destroy($destroy_event->id);
      }

      $destroy_attendees = DB::table('attendee')->where('users_id', $id)->get();
      foreach ($destroy_attendees as $destroy_attendee) {
        Attendee::destroy($destroy_attendee->id);
      }

      $destroy_reports = DB::table('report')->where('users_id', $id)->get();
      foreach ($destroy_reports as $destroy_report) {
        Report::destroy($destroy_report->id);
      }

      $destroy_notifications = DB::table('notification')->where('sent_users_id', $id)->orWhere('receiver_users_id', $id)->get();
      foreach ($destroy_notifications as $destroy_notification) {
        Notification::destroy($destroy_notification->id);
      }

      Users::destroy($id);

      return $id;
    }

    public function delete(Request $request, $id)
    {
      $destroy_events = DB::table('event')->where('owner_id', $id)->get();
      
      foreach ($destroy_events as $destroy_event) {
        $destroy_polls = DB::table('poll')->where('event_id', $destroy_event->id)->get();
        foreach ($destroy_polls as $destroy_poll) {
          $destroy_comments = DB::table('comment')->where('poll_id', $destroy_poll->id)->get();
          foreach ($destroy_comments as $destroy_comment) {
            Comment::destroy($destroy_comment->id);
          }
          Poll::destroy($destroy_poll->id);
        }
        $destroy_attendees = DB::table('attendee')->where('event_id', $destroy_event->id)->get();
        foreach ($destroy_attendees as $destroy_attendee) {
          Attendee::destroy($destroy_attendee->id);
        }

        $destroy_features = DB::table('event_features')->where('event_id', $destroy_event->id)->get();
        foreach ($destroy_features as $destroy_feature) {
          EventFeature::destroy($destroy_feature->id);
        }

        $destroy_reports = DB::table('report')->where('event_id', $destroy_event->id)->get();
        foreach ($destroy_reports as $destroy_report) {
          Report::destroy($destroy_report->id);
        }

        $destroy_notifications = DB::table('notification')->where('event_id', $destroy_event->id)->get();
        foreach ($destroy_notifications as $destroy_notification) {
          Notification::destroy($destroy_notification->id);
        }
        
        Event::destroy($destroy_event->id);
      }

      $destroy_attendees = DB::table('attendee')->where('users_id', $id)->get();
      foreach ($destroy_attendees as $destroy_attendee) {
        Attendee::destroy($destroy_attendee->id);
      }

      $destroy_reports = DB::table('report')->where('users_id', $id)->get();
      foreach ($destroy_reports as $destroy_report) {
        Report::destroy($destroy_report->id);
      }

      Users::destroy($id);

      return redirect('/login');
    }
}
