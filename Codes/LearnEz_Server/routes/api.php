<?php

use Illuminate\Http\Request;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/
/*
Route::middleware('auth:api')->get('/user', function (Request $request) {
    return $request->user();
});*/

#Account Manager Routes

#Get User By ID
Route::get('user/{id}', 'ApiController@getUser');
#Get all Users
Route::get('user', 'ApiController@getAllUsers');
#Verify User with ID and Password
Route::get('user/{id}/{password}', 'ApiController@verifyUser');
#Update User Password
Route::put('user/{id}', 'ApiController@updateUserPassword');
#Update User Avatar
Route::put('user/updateAvatar/{id}','ApiController@updateUserAvatar');
#Get Reset Password Link
Route::get('user/resetpassword/link/{id}','ApiController@resetPasswordLink');
#Reset User's Password
Route::get('user/resetpassword/link/reset/{id}','ApiController@resetPassword');
#Update Currency
Route::put('user/currency/update/{id}','ApiController@updateUserCurrency');

# Performance Report
Route::get('group/{id}', 'ApiController@getTeacherGroups');
Route::get('group/students/{groupID}','ApiController@getStudentsInGroup');
Route::get('group/students/score/{groupID}','ApiController@getStudentsScore');
Route::get('group/students/score/generatereport/{groupID}','ApiController@generateReport');
Route::get('group/students/{userID}/{worldID}','ApiController@getStudentScoreByWorld');
Route::get('group/students/indv/score/generatereport/{userID}','ApiController@generateStudentReport');

/* Get All UCL */
Route::get('ucl/{id}', 'ApiController@getUCL');
Route::get('ucl/all/all', 'ApiController@getAllUCL');
Route::post('ucl/{id}', 'ApiController@postUCL');

/* Discussion */
Route::post('discussion/{id}', 'ApiController@postDiscussion');
Route::get('discussion/all', 'ApiController@getAllDiscussion');
Route::get('discussion/{id}', 'ApiController@getDetailedDiscussion');
Route::get('discussion/numOfComments/{id}', 'ApiController@getNumOfComments');
Route::get('discussion/comments/{id}', 'ApiController@getDiscussionComments');
Route::post('discussion/comments/{id}', 'ApiController@postComment');

/* Assignment */
Route::get('assignment/student/{id}', 'ApiController@getStudentAssignment');
Route::get('assignment/teacher/{id}', 'ApiController@getTeacherAllAssignment');
Route::get('assignment/teacher/group/{id}', 'ApiController@getTeacherGroupAssignment');
Route::get('assignment/teacher/file/all', 'ApiController@getAllFile');
Route::post('assignment/teacher/{id}', 'ApiController@postAssignment');

/* Get all Worlds */
Route::get('world/all', 'ApiController@getAllWorlds');
Route::get('UserUnlockWorld/{id}','ApiController@getUserUnlockedWorlds');

/* Get Levels */
Route::get('level/{id}' , 'ApiController@getLevelsInWorld');
Route::get('userunlocklevels/{userId}/{worldID}' , 'ApiController@getUserUnlockedLevels');

/* Powerups*/
Route::get('powerup/all' , 'ApiController@getPowerupsInfo');
Route::get('userpowerup/{id}' , 'ApiController@getUserInventory');
Route::put('userpowerup/{userid}' , 'ApiController@updateUserInventory');
Route::put('userpowerup/gameInventory/{userid}','ApiController@updateUserInventoryAfterGame');

# Get level leaderboard
Route::get('level/leaderboard/{levelId}', 'ApiController@getLevelLeaderboard');
Route::get('level/user/highestLevelScore/{userID}', 'ApiController@getUserHighestLvl');

#Leaderboard Controller */
Route::put('UserUnlockWorld/{worldID}','ApiController@getLeaderboard');

#Questions
Route::get('question/{levelID}/{worldID}','ApiController@getQuestions');

#UpdateUserGameClear
Route::put('UserUnlockWorld/game/updateUser/{userID}','ApiController@updateUserGameClear');
