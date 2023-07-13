<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;

use App\Models\Comment;

class CommentApiController extends Controller
{
    public function show($id)
    {
      $comment = DB::table('comment')->where('poll_id', $id)->get();
      return view('pages.apicomment', ['comment' => $comment]);
    }
}
