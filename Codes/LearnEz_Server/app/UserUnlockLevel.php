<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Builder;
class UserUnlockLevel extends Model
{
    protected $table = 'user_unlock_level';
	protected $primaryKey = ['userID','levelID','worldID'];
    public $incrementing = false;
    protected $fillable = ['userID','levelID','worldID','unlock','score'];
	
	protected function setKeysForSaveQuery(Builder $query)
    {
        $query
            ->where('userID', '=', $this->getAttribute('userID'))
            ->where('levelID', '=', $this->getAttribute('levelID'))
			->where('worldID', "=", $this->getAttribute('worldID'));
        return $query;
    }
	
}
