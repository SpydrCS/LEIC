<?php

namespace App\Models;

use Illuminate\Notifications\Notifiable;
use Illuminate\Foundation\Auth\User as Authenticatable;

class Event extends Authenticatable
{
    use Notifiable;

    protected $table = 'event';

    // Don't add create and update timestamps in database.
    public $timestamps  = false;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'owner_id', 'name', 'description', 'tag', 'start_datetime', 'end_datetime','price', 'max_capacity', 'attendee_counter', 'location', 'image', 'is_private', 'is_full',
    ];

    /**
     * The cards this user owns.
     */

    public function owner() {
        return $this->belongsTo(Users::class, 'owner_id');
    }

    public function polls() {
        return $this->hasMany(Poll::class, 'event_id');
    }

    public function features() {
        return $this->hasMany(EventFeature::class, 'event_id');
    }

    public function attendees() {
        return $this->hasMany(Attendee::class, 'event_id');
    }

    public function reports() {
        return $this->hasMany(Report::class, 'event_id');
    }

    public function notifications() {
        return $this->hasMany(Notification::class, 'event_id');
    }

    public function favorites() {
        return $this->hasMany(Favorite::class, 'event_id');
    }
}
