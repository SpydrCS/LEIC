@extends('layouts.app')

@section('title', 'Events')

@section('content')

<h2 class="white-font">
    Event Participants
</h2>

<div class="event-attendees">
    @foreach ($attendees as $attendee)
        <div class="specific-evnt-attendee white-font">
        <span>
            Name: {{ $attendee->user->name }}
        </span>
        <br>
        <span>
            Join Date: {{ substr($attendee->join_datetime,0,16) }}
        </span>
        <form action="{{ route('removeAttendee', ['event_id' => $attendee->event_id, 'attendee_id' => $attendee->user->id]) }}" method="POST">
            {{ csrf_field() }}
            <button type="submit" class="btn btn-danger">Remove</button>
        </form>
    </div>
    @endforeach
</div>

@endsection