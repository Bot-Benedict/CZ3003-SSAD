<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Comment extends Model
{
    protected $table = 'comment';
	  protected $primaryKey = 'commentID';
    public $incrementing = false;
    protected $fillable = ['commentID', 'time_created', 'content', 'postedBy', 'threadID'];
}
