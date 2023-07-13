<?php

namespace App\Models;

use Illuminate\Notifications\Notifiable;
use Illuminate\Foundation\Auth\User as Authenticatable;

class Users extends Authenticatable
{
    use Notifiable;

    // Don't add create and update timestamps in database.
    public $timestamps  = false;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'name', 'email', 'password', 'gender', 'date_of_birth', 'nationality',
    ];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [
        'password',
    ];

    /**
     * The cards this user owns.
     */

    public function events() { // events where user is the owner
        return $this->hasMany(Event::class, 'owner_id');
    }

    public function attendees() {
        return $this->hasMany(Attendee::class, 'users_id');
    }

    public function sent_notifications() {
        return $this->hasMany(Notification::class, 'sent_users_id');
    }

    public function received_notifications() {
        return $this->hasMany(Notification::class, 'receiver_users_id');
    }

    public function comments() {
        return $this->hasMany(Comment::class, 'users_id');
    }

    public function reports() {
        return $this->hasMany(Report::class, 'users_id');
    }

    public function favorites() {
        return $this->hasMany(Favorite::class, 'users_id');
    }
}
