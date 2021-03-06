<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Avatar extends Model
{
    protected $table = 'avatar';
	protected $primaryKey = 'avatarID';
	public $incrementing = false;
    protected $fillable = ['avatarID', 'avatarURL'];
}
