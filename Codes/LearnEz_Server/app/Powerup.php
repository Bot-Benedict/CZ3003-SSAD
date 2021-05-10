<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Powerup extends Model
{
    protected $table = 'powerup';
	protected $primaryKey = 'powerID';
    public $incrementing = false;
    protected $fillable = ['powerID', 'cost','description','name'];
}
