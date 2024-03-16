<?php

namespace App\Models;

use Illuminate\Notifications\Notifiable;
use Illuminate\Foundation\Auth\User as Authenticatable;

class Attendee extends Authenticatable
{
    use Notifiable;

    protected $table = 'attendee';

    // Don't add create and update timestamps in database.
    public $timestamps  = false;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'users_id', 'event_id', 'join_datetime',
    ];

    /**
     * The cards this user owns.
     */

    public function user() {
        return $this->belongsTo(Users::class, 'users_id');
    }

    public function event() {
        return $this->belongsTo(Event::class, 'event_id');
    }
}
