<?php

namespace App\Models;

use Illuminate\Notifications\Notifiable;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Database\Eloquent\Model;

class EventFeature extends Authenticatable
{
    use Notifiable;

    protected $table = 'event_features';

    // Don't add create and update timestamps in database.
    public $timestamps  = false;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'event_id', 'feature',
    ];

    /**
     * The cards this user owns.
     */

    public function event() {
      return $this->belongsTo(Event::Class, 'event_id');
    }
}
