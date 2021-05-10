<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Builder;
class Level extends Model
{
    protected $table = 'level';
	protected $primaryKey = ['levelID','worldID'];
    public $incrementing = false;
    protected $fillable = ['levelID','levelStage','levelName','levelDescription','worldID'];
	
	protected function setKeysForSaveQuery(Builder $query)
    {
        $query
            ->where('levelID', '=', $this->getAttribute('levelID'))
            ->where('worldID', '=', $this->getAttribute('worldID'));
        return $query;
    }
	
}
