<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Users extends Model
{
    protected $table = 'user';
	protected $primaryKey = 'userID';
    public $incrementing = false;
    protected $fillable = ['userID', 'name','email','password','role','avatarID','userGroup','currency'];
}
