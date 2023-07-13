<?php

namespace App\Models;

use Illuminate\Notifications\Notifiable;
use Illuminate\Foundation\Auth\User as Authenticatable;

class Poll extends Authenticatable
{
    use Notifiable;

    protected $table = 'poll';

    // Don't add create and update timestamps in database.
    public $timestamps  = false;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'event_id', 'poll_title',
    ];

    /**
     * The cards this user owns.
     */


    public function comments() {
        return $this->hasMany(Comment::class, 'poll_id');
    }

    public function files() {
        return $this->hasMany(PollFile::class, 'poll_id');
    }

    public function event() {
        return $this->belongsTo(Event::class, 'event_id');
    }
}
