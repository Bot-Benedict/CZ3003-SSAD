<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class GroupAssignment extends Model
{
    protected $table = 'group_has_assignment';
	  protected $primaryKey = ['groupID','assignmentID'];
    public $incrementing = false;
    protected $fillable = ['groupID','assignmentID'];
}
