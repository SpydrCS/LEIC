<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;

use App\Models\Favorite;
use App\Models\Users;
use App\Models\Event;

class FavoriteController extends Controller
{
    public function userFavorites($user_id)
    {
      if (!Auth::check()) return redirect('/login');

      $favorites = Users::find($user_id)->favorites->sortBy('id');

      return view('pages.my_favorites', ['favorites' => $favorites]);
    }

    public function create(Request $request)
    {
        $user_id = $request->input('users_id');
        $event_id = $request->input('event_id');

        $exists = DB::table('favorite')->where('users_id', $user_id)->where('event_id', $event_id)->get();
        if (count($exists) > 0) {
          return 'This event is already in your favorites!';
        }

        $favorite = new Favorite();

        $highest = DB::table('favorite')->max('id');

        $id = $highest + 1;

        $favorite->id = $id;
        $favorite->users_id = $user_id;
        $favorite->event_id = $event_id;

        $favorite->save();

        return 'You have added ' . $favorite->event->name .' to your favorites!';
    }

    public function delete(Request $request)
    {
      Favorite::destroy($request->input('id'));

      return $request->input('id');
    }
}
