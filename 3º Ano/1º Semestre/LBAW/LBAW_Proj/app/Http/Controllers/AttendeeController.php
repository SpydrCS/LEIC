<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;

use App\Models\Users;
use App\Models\Event;
use App\Models\Attendee;
use App\Models\Notification;

class AttendeeController extends Controller
{
    public function leaveEvent($event_id) {
      if (!Auth::check()) return redirect('/login');

      return view('pages.leave_event', ['event_id' => $event_id]);
    }

    public function removeAttendee($event_id, $user_id) {
      if (!Auth::check()) return redirect('/login');

      DB::table('attendee')->where('event_id', $event_id)->where('users_id', $user_id)->delete();
      DB::table('notification')->where('event_id', $event_id)->where('sent_users_id', $user_id)->delete();
      return redirect('/event/'.$event_id);
    }

    public static function create($event_id, $user_id)
    {
      $attendee = new Attendee();

      $highest = DB::table('attendee')->max('id');

      $id = $highest + 1;

      $attendee->id = $id;
      $attendee->users_id = $user_id;
      $attendee->event_id = $event_id;
      $attendee->save();

      return $attendee;
    }

    public function delete(Request $request, $event_id, $users_id)
    {
      $destroy_attendees = DB::table('attendee')->where('event_id', $event_id)->where('users_id', $users_id)->get();

      foreach ($destroy_attendees as $destroy_attendee) {
        $destroy_attendee = Attendee::find($destroy_attendee->id);
        $destroy_attendee->delete();
      }

      $destroy_notifications = DB::table('notification')->where('event_id', $event_id)->where('sent_users_id', $users_id)->get();

      foreach ($destroy_notifications as $destroy_notification) {
        $destroy_notification = Notification::find($destroy_notification->id);
        $destroy_notification->delete();
      }

      Users::find($users_id)->increment('wallet_balance', Event::find($event_id)->price);

      return redirect('/users/' . strval(Auth::user()->id));
    }
}
