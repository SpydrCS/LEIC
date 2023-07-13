<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;

use App\Models\EventFeature;
use App\Models\Event;

class EventFeatureController extends Controller
{
    public function createFeature($event_id)
    {
      if (!Auth::check()) return redirect('/login');

      return view('pages.create_feature', ['event_id' => $event_id]);
    }

    public function deleteFeature($event_id)
    {
      if (!Auth::check()) return redirect('/login');

      if (Auth::user()->id != Event::find($event_id)->owner_id) return redirect('/events/all');

      return view('pages.delete_feature', ['features' => Event::find($event_id)->features]);
    }

    public function create(Request $request, $event_id)
    {
      if (!Auth::check()) return redirect('/login');

      $feature = new EventFeature();

      $highest = DB::table('event_features')->max('id');

      $id = $highest + 1;

      $feature->id = $id;
      $feature->event_id = $event_id;
      $feature->feature = $request->feature;
      $feature->save();

      return redirect('/event/' . $event_id);
    }

    public function update(Request $request, $id)
    {
      if (!Auth::check()) return redirect('/login');

      $feature = EventFeature::find($id);
      $feature->feature = $request->feature;
      $feature->save();

      return redirect('/event_features/' . $feature->event_id);
    }

    public function delete(Request $request, $id)
    {
      $event_id = EventFeature::find($id)->event_id;

      EventFeature::destroy($id);

      return redirect('/event_features/' . $event_id);
    }
}
