<?php

namespace App\Http\Controllers\Static;

use App\Http\Controllers\Controller;
use Illuminate\Foundation\Auth\AuthenticatesUsers;

class StaticPagesController extends Controller
{

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function faq()
    {
        return view('static.faq');
    }

    public function contacts(){
        return view('static.contactS');
    }

    public function about() {
        return view('static.about');
    }

}
