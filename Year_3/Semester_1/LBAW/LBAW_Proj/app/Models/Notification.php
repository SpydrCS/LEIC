<?php

namespace App\Models;

use Illuminate\Notifications\Notifiable;
use Illuminate\Foundation\Auth\User as Authenticatable;

class Notification extends Authenticatable
{
    use Notifiable;

    protected $table = 'notification';

    // Don't add create and update timestamps in database.
    public $timestamps  = false;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'event_id', 'sent_users_id', 'receiver_users_id', 'status',
    ];

    /**
     * The cards this user owns.
     */

    public function sent_user() {
        return $this->belongsTo(Users::class, 'sent_users_id');
    }

    public function receiver_user() {
        return $this->belongsTo(Users::class, 'receiver_users_id');
    }

    public function event() {
        return $this->belongsTo(Event::class, 'event_id');
    }
}
