@extends('layouts.app')

@section('title', 'Events')

@section('content')
<h2 class="white-font">Event Features</h2>
<div class="all-features">
    @foreach($features as $feature)
    <div class="specific-feature">
        <span class="feature-name white-font" id="feature-title-{{ $feature->id }}">
            {{ $feature->feature }}
        </span>
        <form method="POST" action="{{ route('updateEventFeature', $feature->id) }}" class="update-feature-form" id="update-feature-{{ $feature->id }}">
            {{ csrf_field() }}
            <label for ="feature_{{ $feature->id}}" class="white-font">Feature</label>
            <input type="text" name="feature" id="feature_{{ $feature->id}}" value="{{ $feature->feature }}" class="feature-input white-font">
            <button type="submit" class="update-feature-btn white-font">
                Confirm
            </button>
        </form>
        <div class="feature-actions">
            <a onclick="showEditFeature({{ $feature->id }})" class="edit-feature hovering">
                <i class="fas fa-edit"></i>
            </a>
            <form method="POST" action="{{ route('deleteEventFeature', $feature->id) }}" class="white-font">
                {{ csrf_field() }}
                <button type="submit" class="crt-feature-btn hovering">
                    <i class="fas fa-trash"></i>
                </button>
            </form>
        </div>
    </div>
    @endforeach
</div>

@endsection