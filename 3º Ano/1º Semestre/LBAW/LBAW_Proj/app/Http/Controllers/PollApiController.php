<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;

use App\Models\Poll;

class PollApiController extends Controller
{
    public function show($id)
    {
      $poll = DB::table('poll')->where('event_id', $id)->get();
      return view('pages.apipoll', ['poll' => $poll]);
    }
}
