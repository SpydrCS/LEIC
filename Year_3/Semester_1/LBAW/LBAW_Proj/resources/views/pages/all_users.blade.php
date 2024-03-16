@extends('layouts.app')

@section('title', 'Event Statistics')

@section('content')

<h2 class="white-font mgl10">
    All Users
</h2>
<p class="white-font mgl10">
    Total of {{ count($users) }} users
</p>

<div class="all-my-reports">
    @foreach($users as $user)
    <div class="my-specific-event" id="user-{{ $user->id }}">
        <p class="white-font">
            User:<a href="/users/{{ $user->id }}"> {{ $user->name }} </a>
        </p>
        <p class="white-font">
            Created {{ count($user->events) }} events
        </p>
        <p class="white-font">
            Attended {{ count($user->attendees) }} events
        </p>
        <p class="white-font">
            Sent <a href="/notifications/{{ $user->id }}"> {{ count($user->sent_notifications) }} </a> notifications
        </p>
        <p class="white-font">
            Received <a href="/notifications/{{ $user->id }}"> {{ count($user->received_notifications) }} </a> notifications
        </p>
        <p class="white-font">
            Commented on <a href="/my_comments/{{ $user->id }}"> {{ count($user->comments) }} </a> polls
        </p>
        <p class="white-font">
            Reported <a href="/my_reports/{{ $user->id }}"> {{ count($user->reports) }} </a> events
        </p>
        <div class="report-actions">
            <p class="delete-event-btn">
                <a onclick="deleteUser({{ $user->id }})" class="white-font pdi5">Delete</a>
            </p>
        </div>
    </div>
    @endforeach
</div>

@endsection