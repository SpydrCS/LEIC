@extends('layouts.app')

@section('title', 'Event Statistics')

@section('content')

<h2 class="white-font mgl10">
    All Polls
</h2>
<p class="white-font mgl10">
    Total of {{ count($polls) }} polls
</p>

<div class="all-my-reports">
    @foreach($polls as $poll)
    <div class="my-specific-event" id="poll-{{ $poll->id }}">
        <p class="white-font">
            Poll:<a href="/poll/{{ $poll->id }}"> {{ $poll->poll_title }} </a>
        </p>
        <p class="white-font">
            For event:<a href="/event/{{ $poll->event_id }}"> {{ $poll->event->name }} </a>
        </p>
        <p class="white-font">
            Has {{ count($poll->comments) }} comments
        </p>
        <div class="report-actions">
            <p class="delete-event-btn">
                <a onclick="deletePoll({{ $poll->id }})" class="white-font pdi5">Delete</a>
            </p>
        </div>
    </div>
    @endforeach
</div>

@endsection