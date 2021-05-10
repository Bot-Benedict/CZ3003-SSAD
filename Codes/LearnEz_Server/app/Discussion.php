<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Discussion extends Model
{
    protected $table = 'thread';
	  protected $primaryKey = 'threadID';
    public $incrementing = false;
    protected $fillable = ['threadID', 'time_created', 'title', 'details', 'userID'];
}
