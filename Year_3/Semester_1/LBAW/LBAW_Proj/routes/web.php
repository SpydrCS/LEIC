<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/
// Home
Route::get('/', 'EventController@home');

// Admin
Route::get('admin/all_events', 'EventController@allEvents')->name('allEvents');
Route::get('admin/all_reports', 'ReportController@allReports')->name('allReports');
Route::get('admin/all_users', 'ProfileController@allUsers')->name('allUsers');
Route::get('admin/all_polls', 'PollController@allPolls')->name('allPolls');
Route::get('admin/{id}/reports', 'ReportController@eventReports')->name('eventReports');

Route::post('adminDeleteEvent', 'EventController@adminDelete')->name('adminDeleteEvent');
Route::post('adminDeleteUser', 'ProfileController@adminDelete')->name('adminDeleteUser');
Route::post('addFunds', 'ProfileController@addFunds')->name('addFunds');

// Static Pages
Route::get('about', 'Static\StaticPagesController@about');
Route::get('contacts', 'Static\StaticPagesController@contacts');
Route::get('faq', 'Static\StaticPagesController@faq');

// Events
Route::get('events/{date}', 'EventController@list')->name('events');
Route::get('events/today', 'EventController@list');
Route::get('events/this_week', 'EventController@list');
Route::get('events/this_month', 'EventController@list');
Route::get('events/this_year', 'EventController@list');
Route::get('event/{id}', 'EventController@show');
Route::get('update_event/{id}', 'EventController@updateEvent');
Route::get('create_event', 'EventController@createEvent');
Route::get('invite_attendee/{event_id}', 'EventController@inviteAttendee')->name('inviteAttendee');
Route::get('manage_participants/{event_id}', 'EventController@manageParticipants')->name('manageParticipants');

Route::post('joinEvent', 'EventController@joinEvent')->name('joinEvent');
Route::post('updateEvent/{id}', 'EventController@update')->name('updateEvent');
Route::post('updateEventPrivacy', 'EventController@updatePrivacy')->name('updateEventPrivacy');
Route::post('deleteEvent/{id}', 'EventController@delete')->name('deleteEvent');
Route::post('createEvent', 'EventController@create')->name('createEvent');
Route::post('requestJoinEvent', 'EventController@requestJoinEvent')->name('requestJoinEvent');
Route::post('inviteEventAttendee', 'EventController@inviteEventAttendee')->name('inviteEventAttendee');
Route::post('changeEventStatus', 'EventController@changeStatus')->name('changeEventStatus');
Route::post('inviteFriend', 'EventController@inviteFriend')->name('inviteFriend');

// Statistics
Route::get('event_statistics/{event_id}', 'EventStatisticsController@show');

// Features
Route::get('create_feature/{event_id}', 'EventFeatureController@createFeature')->name('createFeature');
Route::get('event_features/{event_id}', 'EventFeatureController@deleteFeature')->name('deleteFeature');

Route::post('createFeature/{event_id}', 'EventFeatureController@create')->name('createEventFeature');
Route::post('deleteFeature/{feature_id}', 'EventFeatureController@delete')->name('deleteEventFeature');
Route::post('updateFeature/{feature_id}', 'EventFeatureController@update')->name('updateEventFeature');

// Attendees
Route::post('leaveEvent/{event_id}/{users_id}', 'AttendeeController@delete')->name('leaveEvent');
Route::post('removeAttendee/{event_id}/{attendee_id}', 'AttendeeController@removeAttendee')->name('removeAttendee');

// Polls
Route::get('poll/{poll_id}', 'PollController@show')->name('eventPoll');

Route::post('createPoll/{event_id}', 'PollController@create')->name('createPoll');
Route::post('updatePoll/{poll_id}', 'PollController@update')->name('updatePoll');
Route::post('deletePoll/{poll_id}', 'PollController@delete')->name('deletePoll');

// Poll Files
Route::post('download-zip/{id}', 'ZipController@downloadZip')->name('downloadZip');
Route::post('addPollFile/{poll_id}', 'PollFileController@create')->name('addPollFile');

// Comments
Route::get('my_comments/{id}', 'CommentController@userComments')->name('userComments');

Route::post('createComment/{poll_id}', 'CommentController@create')->name('createComment');
Route::post('updateComment/{comment_id}', 'CommentController@update')->name('updateComment');
Route::post('deleteComment/{id?}', 'CommentController@delete')->name('deleteComment');
Route::post('addLikes', 'CommentController@addLikes')->name('addLikes');
Route::post('addDislikes', 'CommentController@addDislikes')->name('addDislikes');

// Users
Route::get('users/{id}', 'ProfileController@show');
Route::get('update_profile/{id}', 'ProfileController@updateProfile');

Route::post('updateProfile/{user_id}', 'ProfileController@update')->name('updateProfile');
Route::post('deleteAccount/{id}', 'ProfileController@delete')->name('deleteAccount');
Route::post('updateProfileImage/{user_id}', 'ProfileController@updateProfileImage')->name('updateProfileImage');

// Notifications
Route::get('my_notifications/{id}', 'NotificationController@list')->name('userNotifications');

Route::post('acceptNotification/{notification_id}', 'NotificationController@accept')->name('acceptNotification');
Route::post('rejectNotification/{notification_id}', 'NotificationController@reject')->name('rejectNotification');
Route::post('acceptInvite/{notification_id}', 'NotificationController@acceptInvite')->name('acceptInvite');
Route::post('rejectInvite/{notification_id}', 'NotificationController@rejectInvite')->name('rejectInvite');
Route::post('deleteNotification/{notification_id}', 'NotificationController@delete')->name('deleteNotification');

// Reports
Route::get('my_reports/{id?}', 'ReportController@userReports')->name('userReports');

Route::post('reportEvent', 'ReportController@create')->name('reportEvent');
Route::post('updateReport/{report_id}', 'ReportController@update')->name('updateReport');
Route::post('deleteReport', 'ReportController@delete')->name('deleteReport');

// Favorites
Route::get('my_favorites/{id}', 'FavoriteController@userFavorites')->name('userFavorites');

Route::post('addFavorite', 'FavoriteController@create')->name('addFavorite');
Route::post('deleteFavorite', 'FavoriteController@delete')->name('deleteFavorite');

// API
Route::get('api/events', 'EventApiController@list');
Route::get('api/events/{id?}/{start_datetime?}', 'EventApiController@show');
Route::get('api/comments/{id}', 'CommentApiController@show');
Route::get('api/polls/{id}', 'PollApiController@show');

// Authentication
Route::get('login', 'Auth\LoginController@showLoginForm')->name('login');
Route::post('login', 'Auth\LoginController@login');
Route::get('logout', 'Auth\LoginController@logout')->name('logout');
Route::get('register', 'Auth\RegisterController@showRegistrationForm')->name('register');
Route::post('register', 'Auth\RegisterController@register');
