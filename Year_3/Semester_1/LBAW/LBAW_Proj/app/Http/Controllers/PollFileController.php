<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;

use App\Models\Poll;
use App\Models\PollFile;

class PollFileController extends Controller
{
    public function create(Request $request, $poll_id)
    {
        if (!Auth::check()) return redirect('/login');

        $file = new PollFile();

        $highest = DB::table('poll_file')->max('id');

        $id = $highest + 1;

        $file->id = $id;
        $file->poll_id = $poll_id;

        $request->validate(['poll_file' => 'required|file|max:2048']);

        $request->file('poll_file')->storeAs('poll_files/' . $poll_id . '/', $request->file('poll_file')->getClientOriginalName());
        $file->file = $request->file('poll_file')->getClientOriginalName();

        $file->save();

        return redirect('/poll/' . $poll_id);
    }

    public function update(Request $request, $id)
    {
      if (!Auth::check()) return redirect('/login');

      $poll = Poll::find($id);

      $poll->poll_title = $request->input('title');

      $poll->save();

      return redirect('/event/' . $poll->event_id);
    }

    public function delete(Request $request, $id)
    {
      $poll = Poll::find($id);

      Poll::destroy($id);

      return redirect('/event/' . $poll->event_id);
    }
}
