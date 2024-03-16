<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Favorite extends Model
{

    protected $table = 'favorite';

    // Don't add create and update timestamps in database.
    public $timestamps  = false;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'users_id', 'event_id',
    ];

    /**
     * The Feature belongs to Event.
     */

    public function user() {
        return $this->belongsTo(Users::class, 'users_id');
    }

    public function event() {
        return $this->belongsTo(Event::class, 'event_id');
    }

}
