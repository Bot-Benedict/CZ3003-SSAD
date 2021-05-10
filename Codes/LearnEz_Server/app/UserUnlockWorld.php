<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Builder;
class UserUnlockWorld extends Model
{
    protected $table = 'user_unlock_world';
	protected $primaryKey = ['userID','worldID'];
    public $incrementing = false;
    protected $fillable = ['userID', 'worldID','unlock','score'];
	
	protected function setKeysForSaveQuery(Builder $query)
    {
        $query
            ->where('userID', '=', $this->getAttribute('userID'))
			->where('worldID', "=", $this->getAttribute('worldID'));
        return $query;
    }
	

}
