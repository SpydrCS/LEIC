@extends('layouts.app')

@section('title', 'Event Statistics')

@section('content')

<h2 class="white-font mgl10">
    My Favorites
</h2>

<div class="all-my-reports">
    @foreach($favorites as $favorite)
    <div class="my-specific-report" id="favorite-{{ $favorite->id }}">
        <p class="white-font">
            <a href="/event/{{ $favorite->event->id }}" class="white-font">
                {{ $favorite->event->name }}
            </a>
        </p>
        <div class="report-actions">
            <p class="delete-report-btn">
                <a onclick="deleteFavorite({{ $favorite->id }})" class="white-font pdi5">Delete</a>
            </p>
        </div>
    </div>
    @endforeach
</div>

@endsection