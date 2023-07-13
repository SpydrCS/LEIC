@extends('layouts.app')

@section('title', 'Event Statistics')

@section('content')

<h2 class="white-font mgl10">
    <a href="/event/{{ $event->id }}"> {{ $event->name }}'s</a> Reports
</h2>
<p class="white-font mgl10">
    Total of {{ count($reports) }} reports
</p>

<div class="all-my-reports">
    @foreach($reports as $report)
    <div class="my-specific-event" id="report-{{ $report->id }}">
        <p class="white-font">
            <a href="/users/{{ $report->user->id }}"> {{ $report->user->name }} </a> reported <a href="/event/{{ $report->event->id }}"> {{ $report->event->name }} </a>
        </p>
        <p class="white-font">
            Reason: {{ $report->description }}
        </p>
        <p class="delete-report-btn">
            <a onclick="deleteReport({{ $report->id }})" class="white-font pdi5">Delete</a>
        </p>
    </div>
    @endforeach
</div>

@endsection