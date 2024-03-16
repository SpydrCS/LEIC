@extends('layouts.app')

@section('title', 'Event Statistics')

@section('content')

<h2 class="white-font mgl10">
    @if ($is_admin)
        All Reports
    @else
        My Reports
    @endif
</h2>
@if ($is_admin)
<p class="white-font mgl10">
    Total of {{ count($reports) }} reports
</p>
@endif

<div class="all-my-reports">
    @foreach($reports as $report)
    <div class="my-specific-report" id="report-{{ $report->id }}">
        @if(!$is_admin)
        <p class="white-font">
            You reported <a href="/event/{{ $report->event->id }}"> {{ $report->event->name }} </a>
        </p>
        @else
        <p class="white-font">
            <a href="/users/{{ $report->user->id }}">{{ $report->user->name }} </a>reported <a href="/event/{{ $report->event->id }}"> {{ $report->event->name }} </a>
        </p>
        @endif
        <div class="white-font edit-report-div" id="edit-report-{{ $report->id }}">
            <span>
                Reason:
            </span>
            <form action="{{ route('updateReport', $report->id) }}" method="POST" class="edit-report-form">
                {{ csrf_field() }}
                <input type="text" name="description" value="{{ $report->description }}" class="white-font edit-report-text">
                <input type="submit" value="Confirm" class="edit-report-form-btn white-font">
            </form>
        </div>
        <p class="white-font" id="report-description-{{ $report->id }}">
            Reason: {{ $report->description }}
        </p>
        <div class="report-actions">
            @if(!$is_admin)
            <p class="edit-report-btn">
                <a onclick="showEditReport({{ $report->id }})" class="white-font pdi5" id="edit-report-btn-{{ $report->id }}">Edit</a>
            </p>
            <p class="delete-report-btn mgl10">
            @else
            <p class="delete-report-btn">
            @endif
                <a onclick="deleteReport({{ $report->id }})" class="white-font pdi5">Delete</a>
            </p>
        </div>
    </div>
    @endforeach
</div>

@endsection