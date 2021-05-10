<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Builder;
class UserPowerup extends Model
{
    protected $table = 'user_has_powerup';
	protected $primaryKey = ['userID','powerID'];
    public $incrementing = false;
    protected $fillable = ['userID','powerID','quantity'];
	
	protected function setKeysForSaveQuery(Builder $query)
    {
        $query
            ->where('userID', '=', $this->getAttribute('userID'))
            ->where('powerID', '=', $this->getAttribute('powerID'));
        return $query;
    }
	
}
