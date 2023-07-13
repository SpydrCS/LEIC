<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;

use App\Models\Event;

class EventApiController extends Controller
{
    public function show($id = null, $start_datetime = null, $location = null, $paid = null)
    {
      if ($start_datetime != null && $id != null) {
            $event = DB::table('event')->where('id', $id)->where('start_datetime', '<=', $start_datetime)->get();
        }
      else if ($start_datetime != null) {
            $event = DB::table('event')->where('start_datetime', '<=', $start_datetime)->get();
        }
      else if ($id != null) {
            $event = DB::table('event')->where('id', $id)->get();
        }
      else {
            $event = DB::table('event')->get(); 
            }
      return view('pages.apievent', ['event' => $event]);
    }

    public function list()
    {
      if (!Auth::check()) return redirect('/login');

      $events = DB::table('event')->orderBy('id')->get();
      return view('pages.apievents', ['events' => $events]);
    }
}
