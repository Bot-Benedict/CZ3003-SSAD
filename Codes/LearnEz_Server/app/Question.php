<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Builder;
class Question extends Model
{
    protected $table = 'question';
	protected $primaryKey = ['questionID','levelID','worldID'];
    public $incrementing = false;
    protected $fillable = ['worldID','levelID','questionID','questionTitle','option1','option2','option3','option4','difficulty','correctOption'];
	
	protected function setKeysForSaveQuery(Builder $query)
    {
        $query
            ->where('questionID', '=', $this->getAttribute('questionID'))
            ->where('levelID', '=', $this->getAttribute('levelID'))
			->where('worldID', "=", $this->getAttribute('worldID'));
        return $query;
    }
	
}
