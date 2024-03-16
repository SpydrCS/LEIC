<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;

use App\Models\Users;
use App\Models\Event;
use App\Models\Poll;
use App\Models\Comment;
use App\Models\Attendee;
use App\Models\Report;
use App\Models\EventFeature;
use App\Models\Notification;

class EventStatisticsController extends Controller
{
    public function show($id)
    {
      if (!Auth::check()) return redirect('/login');

      $event = Event::find($id);

      if ($event->owner_id != Auth::user()->id && !Auth::user()->is_admin) return redirect('/events/all');


      $polls = $event->polls;
      $poll_count = count($polls);
      $users = array();
      $male_user = 0;
      $female_user = 0;
      $other_user = 0;
      $average_age = 0;
      $average_join_date = 0;
      $comment_count = 0;

      $money_earned = $event->price * count($event->attendees);

      $all_countries = array();
      foreach ($event->attendees as $attendee) {
        $nat = $attendee->user->nationality;
        if (!in_array($nat, $all_countries)) {
          array_push($all_countries, $nat);
        }
        
        if ($attendee->user->gender == 'male') {
            $male_user++;
        }
        else if ($attendee->user->gender == 'female') {
            $female_user++;
        }
        else if ($attendee->user->gender == 'other') {
            $other_user++;
        }
        $average_age += strtotime($attendee->user->date_of_birth);
        $average_join_date += strtotime($attendee->join_datetime);
    }
      foreach ($polls as $poll_1) {
        $comment_count += count($poll_1->comments);
      }

      $divisor = count($event->attendees);
      if ($divisor == 0) {
        $divisor = 1;
      }

      $average_age = date("Y-m-d H:i:s", $average_age / $divisor);  
      $average_join_date = date("Y-m-d H:i:s", $average_join_date / $divisor);
      $current_date = date('Y-m-d h:i:s');
      return view('pages.event_statistics', ['event' => $event, 'attendees' => $event->attendees, 'users' => $users, 'male_user' => $male_user, 'female_user' => $female_user, 'other_user' => $other_user, 'average_age' => $average_age, 'average_join_date' => $average_join_date, 'money_earned' => $money_earned, 'poll_count' => $poll_count, 'comment_count' => $comment_count, 'countries' => $all_countries, 'current_date' => $current_date]);
    }
}
