@extends('layouts.app')

@section('content')
<h2 class="white-font">Update Event</h2>
<form method="POST" action="{{ route('updateEvent', $event->id) }}" class="white-font update-evt-form">
    {{ csrf_field() }}

    <label for="name">Name</label>
    <input id="name" type="text" name="name" value="{{ $event->name }}">
    @if ($errors->has('name'))
      <span class="error">
          {{ $errors->first('name') }}
      </span>
    @endif

    <label for="start_datetime">Starting Date</label>
    <input id="start_datetime" type="datetime-local" name="start_datetime" value="{{ $event->start_datetime }}">
    @if ($errors->has('start_datetime'))
      <span class="error">
          {{ $errors->first('start_datetime') }}
      </span>
    @endif

    <label for="end_datetime">Ending Date</label>
    <input id="end_datetime" type="datetime-local" name="end_datetime" value="{{ $event->end_datetime }}">
    @if ($errors->has('end_datetime'))
      <span class="error">
          {{ $errors->first('end_datetime') }}
      </span>
    @endif

    <label for="price">Ticket Price</label>
    <input id="price" type="number" name="price" value="{{ $event->price }}">
    @if ($errors->has('price'))
      <span class="error">
          {{ $errors->first('price') }}
      </span>
    @endif

    <label for="max_capacity">Event Capacity</label>
    <input id="max_capacity" type="number" name="max_capacity" value="{{ $event->max_capacity }}">
    @if ($errors->has('max_capacity'))
      <span class="error">
          {{ $errors->first('max_capacity') }}
      </span>
    @endif

    <label for="location">Location</label>
    <input id="location" type="text" name="location" value="{{ $event->location }}">
    @if ($errors->has('location'))
      <span class="error">
          {{ $errors->first('location') }}
      </span>
    @endif

    <label for="is_private" class="white-font">Privacy</label>
    <select id="is_private" name="is_private" class="white-font">
      <option value="is_public" {{ $event->is_private == false ? 'selected' : '' }}>Public</option>
      <option value="is_private" {{ $event->is_private == true ? 'selected' : '' }}>Private</option>
    </select>
    @if ($errors->has('is_private'))
      <span class="error">
          {{ $errors->first('is_private') }}
      </span>
    @endif

    <small class="white-font">(*) Required fields</small>

    <div class="crt-feature">
      <button type="submit" class="crt-feature-btn">
        Confirm
      </button>
    </div>
</form>
@endsection
