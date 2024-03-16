<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;

use App\Models\Poll;
use App\Models\Comment;

class PollController extends Controller
{
    public function show($id)
    {
      $poll = Poll::find($id);
      return view('pages.poll', ['poll' => $poll, 'comments' => $poll->comments->sortByDesc('likes')]);
    }

    public function allPolls() {
      if (!Auth::check()) return redirect('/login');
      if (!Auth::user()->is_admin) return redirect('/users/' . strval(Auth::user()->id));
      $polls = Poll::all()->sortBy('id');
      return view('pages.all_polls', ['polls' => $polls]);
    }

    public function addFile(Request $request, $id) {
      if (!Auth::check()) return redirect('/login');

      $poll = Poll::find($id);

      $file = $request->file('file');

      $file->move('uploads', $file->getClientOriginalName());

      $poll->poll_file = $file->getClientOriginalName();

      $poll->save();

      return redirect('/poll/' . $id);
    }

    public function create(Request $request, $event_id)
    {
      if (!Auth::check()) return redirect('/login');

      $poll = new Poll();

      $highest = DB::table('poll')->max('id');

      $id = $highest + 1;

      $poll->id = $id;
      $poll->event_id = $event_id;
      $poll->poll_title = $request->input('title');

      $poll->save();

      return redirect('/event/' . $event_id . '#show-crt-form');
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
