@extends('layouts.app')

@section('title', 'Event Statistics')

@section('content')

<h2 class="white-font mgl10">
    All Events
</h2>
<p class="white-font mgl10">
    Total of {{ count($events) }} events
</p>

<div class="all-my-reports">
    @foreach($events as $event)
    <div class="my-specific-event" id="event-{{ $event->id }}">
        <p class="white-font">
            Event:<a href="/event/{{ $event->id }}"> {{ $event->name }} </a>
        </p>
        <p class="white-font">
            Created by:<a href="/users/{{ $event->owner_id }}"> {{ $event->owner->name }} </a>
        </p>
        <p class="white-font">
            {{ count($event->polls) }} created
        </p>
        <p class="white-font">
            Reported <a href="/admin/{{ $event->id }}/reports"> {{ count($event->reports) }} </a> times
        </p>
        <div class="report-actions">
            <p class="delete-event-btn">
                <a onclick="deleteEvent({{ $event->id }})" class="white-font pdi5">Delete</a>
            </p>
        </div>
    </div>
    @endforeach
</div>

@endsection