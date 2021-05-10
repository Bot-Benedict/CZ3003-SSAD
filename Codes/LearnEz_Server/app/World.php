<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class World extends Model
{
    protected $table = 'world';
	protected $primaryKey = 'worldID';
    public $incrementing = false;
    protected $fillable = ['worldID', 'worldName'];
}
