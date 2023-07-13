<?php

namespace App\Models;

use Illuminate\Notifications\Notifiable;
use Illuminate\Foundation\Auth\User as Authenticatable;

class PollFile extends Authenticatable
{
    use Notifiable;

    protected $table = 'poll_file';

    // Don't add create and update timestamps in database.
    public $timestamps  = false;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'poll_id', 'file',
    ];

    /**
     * The Feature belongs to Event.
     */

    public function poll() {
        return $this->belongsTo(Poll::class, 'poll_id');
    }
}
