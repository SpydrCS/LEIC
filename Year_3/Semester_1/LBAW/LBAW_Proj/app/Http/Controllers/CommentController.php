<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;

use App\Models\Comment;
use App\Models\Users;

class CommentController extends Controller
{
  public function userComments($id)
    {
      if (!Auth::check()) return redirect('/login');
      if ($id != Auth::user()->id && !Auth::user()->is_admin) return redirect('/users/' . strval(Auth::user()->id));
      $profile_find = Users::find($id);
      return view('pages.my_comments', ['comments' => $profile_find->comments]);
    }

    public function addLikes(Request $request) {
      $comment_id = $request->input('id');

      $comment = Comment::find($comment_id);

      $comment->increment('likes');

      return $comment->likes;
    }

    public function addDislikes(Request $request) {
      $comment_id = $request->input('id');

      $comment = Comment::find($comment_id);

      $comment->increment('dislikes');

      return $comment->dislikes;
    }

    public function create(Request $request, $poll_id)
    {
      if (!Auth::check()) return redirect('/login');

      $comment = new Comment();

      $highest = DB::table('comment')->max('id');

      $id = $highest + 1;

      $comment->id = $id;
      $comment->users_id = Auth::user()->id;
      $comment->poll_id = $poll_id;
      $comment->content = $request->comment;
      $comment->image = "http://dummyimage.com/198x100.png/ff4444/ffffff";
      $comment->likes = 0;
      $comment->dislikes = 0;

      $comment->save();

      return redirect('/poll/' . $poll_id);
    }

    public function update(Request $request, $id)
    {
      if (!Auth::check()) return redirect('/login');

      $comment = Comment::find($id);

      $comment->content = $request->comment;

      $comment->save();

      return redirect('/poll/' . $comment->poll_id);
    }

    public function delete(Request $request, $id = null)
    {
      if (!Auth::check()) return redirect('/login');

      if ($id == null) {
        $id = $request->input('id');
      }

      $comment = Comment::find($id);

      if(Auth::user()->id != $comment->users_id) return redirect('/');

      Comment::destroy($id);

      return $id;
    }
}
