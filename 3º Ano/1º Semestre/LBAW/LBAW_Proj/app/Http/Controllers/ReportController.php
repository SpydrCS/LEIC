<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;

use App\Models\Users;
use App\Models\Event;
use App\Models\Attendee;
use App\Models\Notification;
use App\Models\Report;

class ReportController extends Controller
{

    public function show($id)
    {
      $report = Report::find($id);
      return view('pages.report', ['report' => $report]);
    }

    public function eventReports($event_id)
    {
      if (!Auth::check()) return redirect('/login');

      $event = Event::find($event_id);
      $reports = $event->reports->sortBy('id');
      
      return view('pages.event_reports', ['event' => $event, 'reports' => $reports]);
    }

    public function userReports($user_id = null)
    {
      if (!Auth::check()) return redirect('/login');

      $reports = Users::find($user_id)->reports->sortBy('id');

      return view('pages.my_reports', ['reports' => $reports, 'is_admin' => false]);
    }

    public function allReports() {
      if (!Auth::check()) return redirect('/login');

      if (Auth::user()->is_admin) {
        $reports = Report::all();
        return view('pages.my_reports', ['reports' => $reports, 'is_admin' => true]);
      }
      else {
        return redirect('/');
      }
    }

    public function create(Request $request)
    {
      $user_id = $request->input('user_id');
      $event_id = $request->input('event_id');
      
      $exists = DB::table('report')->where('users_id', $user_id)->where('event_id', $event_id)->get();
      if (count($exists) > 0) {
        return 2; # 'You have already reported this event!'
      }

      $report = new Report();

      $highest = DB::table('report')->max('id');

      $id = $highest + 1;

      $report->id = $id;
      $report->users_id = $user_id;
      $report->event_id = $event_id;
      $report->description = $request->input('description');
      
      $report->save();

      return 1; # 'Event reported!'
    }

    public function update(Request $request, $id)
    {
      $report = Report::find($id);
      $report->description = $request->input('description');
      $report->save();

      return redirect('/my_reports/' . strval(Auth::user()->id));
    }

    public function delete(Request $request)
    {
      Report::destroy($request->input('id'));

      return $request->input('id');
    }
}
