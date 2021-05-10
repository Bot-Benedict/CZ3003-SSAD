<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Assignment extends Model
{
    protected $table = 'assignment';
	  protected $primaryKey = 'assignmentID';
    public $incrementing = false;
    protected $fillable = ['assignmentID', 'title', 'details', 'due_date', 'userID'. 'fileID'];
}
