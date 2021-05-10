<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Users;
use App\Avatar;
use App\Group;
use App\UCL;
use App\Comment;
use App\Discussion;
use App\GroupAssignment;
use App\Assignment;
use App\AssignmentFile;
use App\World;
use App\UserUnlockWorld;
use App\Powerup;
use App\UserPowerup;
use App\Level;
use App\UserUnlockLevel;
use App\Question;
use Mail;
use App\Http\Resources\Users as UsersResource;
use Response;

class ApiController extends Controller
{
	//Find User by their User ID and Password
	public function verifyUser($id,$password){
	if(Users::where('userID', strtoupper($id))->where('password', $password)->exists()) {
		$user = Users::where('userID', strtoupper($id))->where('password',$password)->leftJoin('avatar','user.avatarID','=','avatar.avatarID')->get();
        return response()->json($user[0], 200);
      } else {
        return response()->json([
          "message" => "User not found",
		  "status" => 404
        ], 404);
      }
	}

    public function getUser($id){
		if(Users::where('userID', $id)->exists()) {
        $user = Users::where('userID', $id)->get();
        return response()->json($user[0], 200);
      } else {
        return response()->json([
          "message" => "User not found",
		  "error" => 404
        ], 404);
      }
	}

    //Select Multiple Columns Example
    public function getUserMultiple($id){
		if(Users::where('userID', $id)->exists()) {
        $user = Users::select('name','role')->where('userID', $id)->get()->toJson(JSON_PRETTY_PRINT);
        return response($user, 200);
      } else {
        return response()->json([
          "message" => "User not found"
        ], 404);
      }
	}

	//Update User Password
	public function updateUserPassword(Request $request, $id){
		if (Users::where('userID', $id)->exists()) {
			$user = Users::find($id);
			$user->password = is_null($request->password) ? $user->password : $request->password;
			$user->timestamps = false;
			$user->save();
			return response()->json([
				"message" => "User's password Updated"
			], 200);
        } else {
			return response()->json([
				"message" => "User not found"
			], 404);

		}
	}

	//Send Reset Password Link
	public function resetPasswordLink($id){

		if (Users::where('userID', $id)->exists()) {

			$user = Users::find($id);
			$url = "https://learnez.a2hosted.com/public/api/user/resetpassword/link/reset/".$id;
			$data = array( 'email' => $user->email, 'url' => $url);
			Mail::send([],$data, function ($message) use ($data) {
			  $message->to($data['email'])
				->subject('Reset Password Request')
				->setBody('Please Click on this link to reset your password: '.$data['url']);
			});

			return response()->json([
				"message" => $user->email
			], 200);
        } else {
			return response()->json([
				"message" => "User xneot found"
			], 404);

		}

	}

	//Reset User's Password
	public function resetPassword($id){

		if (Users::where('userID', $id)->exists()) {

			$user = Users::find($id);
			$characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
			$charactersLength = strlen($characters);
			$randomString = '';

			for ($i = 0; $i < 5; $i++) {
				$randomString .= $characters[rand(0, $charactersLength - 1)];
			}

			$user->password = $randomString;
			$user->timestamps = false;
			$user->save();

			$data = array( 'email' => $user->email, 'password' => $randomString);

			Mail::send([],$data, function ($message) use ($data) {
			  $message->to($data['email'])
				->subject('Password has been reset')
				->setBody('Your New Password  is: '.$data['password']);
			});


			return response()->json([
				"message" => "A New Password Has been Sent to your Email"
			], 200);

        } else {
			return response()->json([
				"message" => "User not found"
			], 404);

		}

	}

	//Update User Avatar
	public function updateUserAvatar(Request $request, $id){
		if (Users::where('userID', $id)->exists()) {
			$user = Users::find($id);
			$user->avatarID = is_null($request->avatarID) ? $user->avatarID : $request->avatarID;
			$user->timestamps = false;
			$user->save();
			return response()->json([
				"message" => "User's Avatar Updated"
			], 200);
        } else {
			return response()->json([
				"message" => "User not found"
			], 404);

		}
	}

	//Get Teacher's Groups
	public function getTeacherGroups($id){
		if(Group::where('teacherID', $id)->exists()) {
			$groups = Group::select('groupID')->where('teacherID', $id)->get();
			return response()->json($groups, 200);
		} else {
			return response()->json([
				"message" => "Group not found"
			], 404);
		}
	}

	//Get all students in group
	public function getStudentsInGroup($groupID){

		$students = Users::where('userGroup',$groupID)->get();
		return response()->json($students, 200);

	}

	//Get students score by group
	public function getStudentsScore($groupID){
		$score = Users::where('userGroup',$groupID)->join('user_unlock_level as ul','ul.userID', '=', 'user.userID')->groupBy('worldID','levelID')->selectRaw('sum(score) as score,worldID,levelID')->get();
		return response()->json($score, 200);
	}

	//GenerateReport
	public function generateReport($groupID){
		$reportFront = strval($groupID);
		$reportEnd = "-Performance-Report.csv";
		$reportName = $reportFront.$reportEnd;
		$headers = array(
			"Content-type" => "text/csv",
			"Content-Disposition" => "attachment; filename=".$reportName,
			"Pragma" => "no-cache",
			"Cache-Control" => "must-revalidate, post-check=0, pre-check=0",
			"Expires" => "0"
		);

		$score = Users::where('userGroup',$groupID)->join('user_unlock_level as ul','ul.userID', '=', 'user.userID')->join("world as w","ul.worldID","=","w.worldID")->join("level as l","ul.levelID","=","l.levelID")->groupBy('w.worldName','l.levelName')->selectRaw('sum(ul.score) as score,l.levelName,w.worldName')->get();
		$columns = array('World Name','Level Name','Total Score');

		$callback = function() use ($score, $columns)
		{
			$file = fopen('php://output', 'w');
			fputcsv($file, $columns);

			foreach($score as $score) {
				fputcsv($file, array($score->worldName,$score->levelName,$score->score));
			}
			fclose($file);
		};
		return response()->stream($callback, 200, $headers);
	}

	public function getStudentScoreByWorld($userID,$worldID){
		$score = Users::join('user_unlock_level as ul','ul.userID', '=', 'user.userID')->join("world as w","ul.worldID","=","w.worldID")->join("level as l","ul.levelID","=","l.levelID")->where('user.userID',$userID)->where('l.worldID',$worldID)->get();
		return response()->json($score, 200);
	}

	public function getUCL($id){
		if(UCL::where('uclID', $id)->exists()) {
        $UCL = UCL::where('uclID', $id)->get();
        return response()->json($UCL, 200);
      } else {
        return response()->json([
          "message" => "UCL not found",
		  "error" => 404
        ], 404);
      }
	}

	public function generateStudentReport($userID){
		$reportFront = strval($userID);
		$reportEnd = "-Performance-Report.csv";
		$reportName = $reportFront.$reportEnd;

		$headers = array(
			"Content-type" => "text/csv",
			"Content-Disposition" => "attachment; filename=".$reportName,
			"Pragma" => "no-cache",
			"Cache-Control" => "must-revalidate, post-check=0, pre-check=0",
			"Expires" => "0"
		);

		$score = Users::join('user_unlock_level as ul','ul.userID', '=', 'user.userID')->join("world as w","ul.worldID","=","w.worldID")->join("level as l","ul.levelID","=","l.levelID")->where('user.userID',$userID)->selectRaw('ul.score,l.levelName,w.worldName')->get();
		$columns = array('World Name','Level Name','Total Score');

		$callback = function() use ($score, $columns)
		{
			$file = fopen('php://output', 'w');
			fputcsv($file, $columns);

			foreach($score as $score) {
				fputcsv($file, array($score->worldName,$score->levelName,$score->score));
			}
			fclose($file);
		};
		return response()->stream($callback, 200, $headers);
	}


	public function postUCL(Request $request, $id){

		$UCL = new UCL;
		$UCL->userId = $id;
		$UCL->uclID = $request->uclID;
		$UCL->questionId = $request->questionId;
		$UCL->uclName = $request->uclName;
		$UCL->uclDesc = $request->uclDesc;
		$UCL->questionTitle = $request->questionTitle;
		$UCL->option1 = $request->option1;
		$UCL->option2 = $request->option2;
		$UCL->option3 = $request->option3;
		$UCL->option4 = $request->option4;
		$UCL->correctOption = $request->correctOption;
		$UCL->timestamps = false;
		$UCL->save();
		return response()->json([
				"message" => "UCL Created"
			], 200);
	}

	public function getAllWorlds(){
		$world = World::all();
		return response()->json($world, 200);
	}

	public function getAllDiscussion(){
		$thread = Discussion::leftJoin('user', 'thread.userID', '=', 'user.userID')->get();
		return response()->json($thread, 200);
	}

	public function getNumOfComments($id){
		$numOfComments = Discussion::where('thread.threadID', $id)->join('comment', 'thread.threadID', '=', 'comment.threadID')->count();
		return response()->json($numOfComments, 200);
	}

	public function postDiscussion(Request $request, $id){
		$thread = new Discussion;
		$thread->title = $request->title;
		$thread->details = $request->details;
		$thread->time_created = $request->time;
		$thread->userID = $id;
		$thread->timestamps = false;
		$thread->save();
		return response()->json([
				"message" => "Discussion Posted"
			], 200);
	}

	public function getDetailedDiscussion($id){
		$detailed_thread = Discussion::where('threadID', $id)->leftJoin('user', 'thread.userID', '=', 'user.userID')->get();
		return response()->json($detailed_thread, 200);
	}

	public function getDiscussionComments($id){
		$discussionComments = Discussion::where('thread.threadID', $id)->join('comment', 'thread.threadID', '=', 'comment.threadID')->join('user', 'comment.postedBy', '=', 'user.userID')->get();
		return response()->json($discussionComments, 200);
	}

	public function postComment(Request $request, $id){
		$comment = new Comment;
		$comment->content = $request->content;
		$comment->time_created = $request->time;
		$comment->postedBy = $request->postedBy;
		$comment->threadID = $id;
		$comment->timestamps = false;
		$comment->save();
		return response()->json([
				"message" => "Comment Posted"
			], 200);
	}

	//$id = groupID of the student
	public function getStudentAssignment($id){
		$groupAssignment = GroupAssignment::where('group_has_assignment.groupID', $id)->join('assignment', 'group_has_assignment.assignmentID', '=', 'assignment.assignmentID')->join('user', 'assignment.userID', '=', 'user.userID')->join('assignment_file', 'assignment.fileID', '=', 'assignment_file.file_id')->get();
		return response()->json($groupAssignment, 200);
	}

	//$id = userID of the teacher
	public function getTeacherAllAssignment($id){
		$groupAssignment = Users::where('user.userID', $id)->join('assignment', 'user.userID', '=', 'assignment.userID')->join('assignment_file', 'assignment.fileID', '=', 'assignment_file.file_id')->get();
		return response()->json($groupAssignment, 200);
	}

	//$id = the group that teacher select
	public function getTeacherGroupAssignment($id){
		$groupAssignment = GroupAssignment::where('group_has_assignment.groupID', $id)->join('assignment', 'group_has_assignment.assignmentID', '=', 'assignment.assignmentID')->join('user', 'assignment.userID', '=', 'user.userID')->join('assignment_file', 'assignment.fileID', '=', 'assignment_file.file_id')->get();
		return response()->json($groupAssignment, 200);
	}

	public function getAllFile(){
		$file = AssignmentFile::all();
		return response()->json($file, 200);
	}

	public function postAssignment(Request $request, $id){

		$fileID = AssignmentFile::where('assignment_file.file_name', $request->file_id)->pluck('assignment_file.file_id');

		$assignment = new Assignment;
		$assignment->title = $request->title;
		$assignment->details = $request->details;
		$assignment->due_date = $request->due_date;
		$assignment->userID = $id;
		$assignment->fileID = $fileID[0];
		$assignment->timestamps = false;
		$assignment->save();

		$assignmentID = Assignment::orderBy('assignmentID', 'DESC')->take(1)->pluck('assignment.assignmentID');

		$groupAssignment = new GroupAssignment;
		$groupAssignment->groupID = $request->group_id;
		$groupAssignment->assignmentID = $assignmentID[0];
		$groupAssignment->timestamps = false;
		$groupAssignment->save();

		$fileURL = AssignmentFile::where('assignment_file.file_name', $request->file_id)->pluck('assignment_file.file_url');

		return response()->json([
				"message" => $fileURL
		], 200);

	}

	public function getAllUCL(){
		$UCLList = UCL::all();
		return response()->json($UCLList, 200);
	}

	public function getUserUnlockedWorlds($id){
		$user_unlocked_worlds = UserUnlockWorld::where('userID', $id)->get();
		return response()->json($user_unlocked_worlds, 200);
	}


	/* Get Powerups Info */
	public function getPowerupsInfo(){
		$powerups = Powerup::all();
		return response()->json($powerups, 200);
	}

	/* Get User Inventory */
	public function getUserInventory($id){
		$user_inventory = UserPowerup::where('userID', $id)->get();
		return response()->json($user_inventory, 200);
	}

	/* Update User Currency */
	public function updateUserCurrency(Request $request,$id){

		if (Users::where('userID', $id)->exists()) {
			$user = Users::find($id);
			$user->currency = $request->currency;
			$user->timestamps = false;
			$user->save();
			return response()->json([
				"message" => "User's Currency Updated"
			], 200);
        } else {
			return response()->json([
				"message" => "User not found"
			], 404);

		}
	}



	/*Update User Inventory */
	public function updateUserInventory(Request $request,$userid){
		$user_inventory = UserPowerup::where('userID',$userid)->where('powerID',$request->powerID)->first();
		if($request->add == "True"){
			$user_inventory->quantity++;
		}else{
			$user_inventory->quantity--;
		}
		$user_inventory->timestamps = false;
		$user_inventory->save();

		return response()->json([
				"message" => $user_inventory->quantity
		], 200);
	}

	public function updateUserInventoryAfterGame(Request $request,$userid){
		$user_inventory_ff = UserPowerup::where('userID',$userid)->where('powerID',1)->first();
		$user_inventory_time = UserPowerup::where('userID',$userid)->where('powerID',2)->first();

		$user_inventory_ff->quantity = $request->power1Quantity;
		$user_inventory_time->quantity = $request->power2Quantity;

		$user_inventory_ff->timestamps = false;
		$user_inventory_ff->save();

		$user_inventory_time->timestamps = false;
		$user_inventory_time->save();

		return response()->json([
				"message" => "User Inventory Updated"
		], 200);
	}

	/* Get all the levels in a world*/
	public function getLevelsInWorld($id){
		$level = Level::where('worldID', $id)->get();
		return response()->json($level, 200);
	}

	/* Gets User unlocked status for Levels */
	public function getUserUnlockedLevels($userID,$worldID){
		$user_unlocked_levels = UserUnlockLevel::where('userID', $userID)->where('worldID',$worldID)->get();
		return response()->json($user_unlocked_levels, 200);
	}

    /* Get level leaderboard */
	public function getLevelLeaderboard($levelID){
		$lvl_leaderboard = UserUnlockLevel::where('levelID',$levelID)->orderBy('score', 'DESC')->take(5)->join('user','user.userID','=','user_unlock_level.userID')->get();
		return response()->json($lvl_leaderboard, 200);
	}

	/* User highest level cleared */
	public function getUserHighestLvl($userID){
		$highest_lvl = UserUnlockLevel::where('userID',$userID)->where('unlock',1)->where('score',0)->join('level','user_unlock_level.levelID','=','level.levelID')->get();
		if(sizeof($highest_lvl) == 0){
			$highest_lvl = UserUnlockLevel::where('userID',$userID)->where('unlock',1)->join('level','user_unlock_level.levelID','=','level.levelID')->orderBy('level.levelID', 'DESC')->first();
			$totalScore = UserUnlockLevel::where('userID',$userID)->sum('score');
			$highest_lvl["totalscore"] = $totalScore;
			return response()->json($highest_lvl, 200);
		}else{

			$totalScore = UserUnlockLevel::where('userID',$userID)->sum('score');
			$highest_lvl[0]["totalscore"] = $totalScore;
			return response()->json($highest_lvl[0], 200);
		}
	}

	/* Get World Leaderboard */
	public function getLeaderboard(Request $request,$worldID){
		if($request->type == "class"){
			$ldrboard = Users::where('userGroup',$request->group)->join('user_unlock_world','user_unlock_world.userID', '=','user.userID')->where('worldID',$worldID)->orderBy('score','DESC')->take(5)->get();

			$rank = Users::where('userGroup',$request->group)->join('user_unlock_world as u1','u1.userID','=','user.userID')->where("u1.worldID",$worldID)->get();
			$userRank = Users::where('user.userID',$request->userID)->join('user_unlock_world as u1','u1.userID', '=','user.userID')->where("u1.worldID",$worldID)->get();
			$count = 1;
			foreach ($rank as $i) {
				if((int)$userRank[0]['score'] < (int)$i['score']){
					$count+= 1;
				}
			}
			$user = UserUnlockWorld::where('worldID',$worldID)->where('userID',$request->userID)->get();
			$user[0]['rank'] = $count;
			$ldrboard->push($user[0]);
			return response()->json($ldrboard, 200);
		}else{
			$ldrboard = Users::join('user_unlock_world','user_unlock_world.userID', '=','user.userID')->where('worldID',$worldID)->orderBy('score','DESC')->take(5)->get();
			$rank = UserUnlockWorld::where('user_unlock_world.userID', $request->userID)->join('user_unlock_world as u1','u1.userID','<>','user_unlock_world.userID')->where('u1.worldID',$worldID)->where('user_unlock_world.worldID',$worldID)->join('user_unlock_world as u2','u2.score', '>', 'user_unlock_world.score')->where('u2.worldID'
			,$worldID)->distinct('u2.userID')->count('u2.userID');
			$rank += 1;
			$len = sizeof($ldrboard)-1;

			$user = UserUnlockWorld::where('worldID',$worldID)->where('userID',$request->userID)->get();
			$user[0]['rank'] = $rank;
			$ldrboard->push($user[0]);
			return response()->json($ldrboard, 200);
		}

	}

	/* Get all questions*/
	public function getQuestions($levelID,$worldID){
		$questions = Question::where('levelID',$levelID)->where('worldID',$worldID)->get();
		return response()->json($questions,200);

	}

	public function updateUserGameClear(Request $request,$userID){
		
			$newScore = $request->score;
			$user = Users::find($userID);
			$user->currency += $newScore;
			$user->timestamps = false;
			$user->save();
			
			$user_curr_unlock_level = UserUnlockLevel::where('userID',$userID)->where('levelID',$request->levelID)->first();
			
			$curr_Score = $user_curr_unlock_level->score;
			
			if($newScore > $curr_Score){
				$user_curr_unlock_level->score = $newScore;
				$user_curr_unlock_level->timestamps = false;
				$user_curr_unlock_level->save();

				#$newCalcScore = $newScore - $curr_Score;
				$user_curr_unlock_world = UserUnlockWorld::where('userID',$userID)->where('worldID',$request->worldID)->first();
				$newCalcScore = UserUnlockLevel::where('userID',$userID)->groupBy('worldID')->where('worldID',$request->worldID)->sum('score');
				$user_curr_unlock_world->score = $newCalcScore;
				$user_curr_unlock_world->timestamps = false;
				$user_curr_unlock_world->save();				
			}
			
			$curr_level_id = intval($request->levelID);
			
			$next_level = strval($curr_level_id+=1);
			
			if($next_level != '31'){
				$user_next_unlock_level = UserUnlockLevel::where('userID',$userID)->where('levelID',$next_level)->first();
				$user_next_unlock_level->unlock = 1;
				$user_next_unlock_level->timestamps = false;
				$user_next_unlock_level->save();				
			}

	
			$curr_level_id = intval($request->levelID);
			$curr_world_id = $request->worldID;
			
			$worldName = substr($curr_world_id, 0, 5);
			$worldNum = intval(substr($curr_world_id, 5));
			$worldNum++;
			
			if($worldNum < 7 && ($curr_level_id%5 == 0)){
				$worldName .= strval($worldNum);
				$user_next_unlock_world = UserUnlockWorld::where('userID',$userID)->where('worldID',$worldName)->first();
				$user_next_unlock_world->unlock = 1;
				$user_next_unlock_world->timestamps = false;
				$user_next_unlock_world->save();	
			}
			
			return response()->json([
				"message" => $newCalcScore
		], 200);
	}
}
