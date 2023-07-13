<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;

use App\Models\Notification;
use App\Models\Event;
use App\Models\Users;
use App\Models\Attendee;

class NotificationController extends Controller
{
    public function list($id)
    {
      if (!Auth::check()) return redirect('/login');

      $notifications = Notification::where('sent_users_id', $id)->orWhere('receiver_users_id', $id)->orderBy('id')->get();

      return view('pages.my_notifications', ['notifications' => $notifications]);
    }

    public function accept($notification_id)
    {
      if (!Auth::check()) return redirect('/login');

      $notification = Notification::find($notification_id);
      $notification->status = 'accepted';
      $notification->save();

      $event_id = $notification->event_id;
      $users_id = $notification->sent_users_id;

      $attendee = AttendeeController::create($event_id, $users_id);

      Users::find($users_id)->decrement('wallet_balance', Event::find($notification->event_id)->price);

      return redirect('/notifications/' . Auth::user()->id);
    }

    public function acceptInvite($notification_id)
    {
      if (!Auth::check()) return redirect('/login');

      $notification = Notification::find($notification_id);
      $notification->status = 'accepted';
      $notification->save();

      $event_id = $notification->event_id;
      $users_id = Auth::user()->id;

      $attendee = AttendeeController::create($event_id, $users_id);

      return redirect('/notifications/' . Auth::user()->id);
    }

    public function reject($notification_id)
    {
      if (!Auth::check()) return redirect('/login');

      $notification = Notification::find($notification_id);
      $notification->status = 'declined';
      $notification->save();

      return redirect('/notifications/' . Auth::user()->id);
    }

    public function rejectInvite($notification_id)
    {
      if (!Auth::check()) return redirect('/login');

      $notification = Notification::find($notification_id);
      $notification->status = 'declined';
      $notification->save();

      return redirect('/notifications/' . Auth::user()->id);
    }

    public static function create($event_id, $sender_id, $receiver_id)
    {
        if (!Auth::check()) return redirect('/login');

        $notification = new Notification();

        $highest = DB::table('notification')->max('id');

        $id = $highest + 1;

        $notification->id = $id;
        $notification->event_id = $event_id;
        $notification->sent_users_id = $sender_id;
        $notification->receiver_users_id = $receiver_id;
        $notification->status = 'pending';

        $notification->save();

        return $notification;
    }

    public function delete(Request $request, $id)
    {
      Notification::destroy($id);

      return redirect('/notifications/' . Auth::user()->id);
    }
}
