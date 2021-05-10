<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Builder;

class UCL extends Model
{
    protected $table = 'UCL';
	protected $primaryKey = ['uclID','userId','questionId'];
    public $incrementing = false;
    protected $fillable = ['userId', 'uclID', 'questionId', 'uclName', 'uclDesc', 'questionTitle', 'option1', 'option2', 'option3', 'option4', 'correctOption'];
	
	protected function setKeysForSaveQuery(Builder $query)
    {
        $query
            ->where('userId', '=', $this->getAttribute('userId'))
            ->where('uclID', '=', $this->getAttribute('uclID'))
			->where('questionId', "=", $this->getAttribute('questionId'));
        return $query;
    }
}
