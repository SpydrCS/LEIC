<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Comment extends Model
{

    protected $table = 'comment';

    // Don't add create and update timestamps in database.
    public $timestamps  = false;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'users_id', 'poll_id', 'content', 'image', 'likes', 'dislikes',
    ];

    /**
     * The Feature belongs to Event.
     */

    public function poll() {
        return $this->belongsTo(Poll::class, 'poll_id');
    }

    public function user() {
        return $this->belongsTo(Users::class, 'users_id');
    }

}
