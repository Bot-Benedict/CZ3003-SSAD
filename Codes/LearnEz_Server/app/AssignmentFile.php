<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class AssignmentFile extends Model
{
    protected $table = 'assignment_file';
	  protected $primaryKey = 'file_id';
    public $incrementing = false;
    protected $fillable = ['file_id', 'file_url', 'file_name'];
}
