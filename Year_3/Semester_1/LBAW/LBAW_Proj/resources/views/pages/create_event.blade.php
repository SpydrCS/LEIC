@extends('layouts.app')

@section('content')
<h2 class="white-font">Create Event</h2>
<form method="POST" action="{{ route('createEvent') }}" enctype="multipart/form-data" class="white-font crt-evt-form">
    {{ csrf_field() }}

    <label for="name">Name (*)</label>
    <input id="name" type="text" name="name" value="{{ old('name') }}" required>
    @if ($errors->has('name'))
      <span class="error">
          {{ $errors->first('name') }}
      </span>
    @endif

    <label for="description">Description (*)</label>
    <input id="description" type="text" name="description" value="{{ old('description') }}" required>
    @if ($errors->has('description'))
      <span class="error">
          {{ $errors->first('description') }}
      </span>
    @endif

    <label for="tag">Tags (separate by space) (*)</label>
    <input id="tag" type="text" name="tag" value="{{ old('tag') }}" required>
    @if ($errors->has('tag'))
      <span class="error">
          {{ $errors->first('tag') }}
      </span>
    @endif

    <label for="start_datetime">Starting Date (*)</label>
    <input type="datetime-local" id="start_datetime"
           name="start_datetime" required>
    @if ($errors->has('start_datetime'))
      <span class="error">
          {{ $errors->first('start_datetime') }}
      </span>
    @endif

    <label for="end_datetime">Ending Date (*)</label>
    <input type="datetime-local" id="end_datetime"
           name="end_datetime" required>
    @if ($errors->has('end_datetime'))
      <span class="error">
          {{ $errors->first('end_datetime') }}
      </span>
    @endif

    <label for="price">Ticket Price (*)</label>
    <input id="price" type="text" name="price" value="{{ old('price') }}" required>
    @if ($errors->has('price'))
      <span class="error">
          {{ $errors->first('price') }}
      </span>
    @endif

    <label for="max_capacity">Event Capacity (*)</label>
    <input id="max_capacity" type="text" name="max_capacity" value="{{ old('max_capacity') }}" required>
    @if ($errors->has('max_capacity'))
      <span class="error">
          {{ $errors->first('max_capacity') }}
      </span>
    @endif

    <label for="location">Location (*)</label>
    <input id="location" type="text" name="location" value="{{ old('location') }}" required>
    @if ($errors->has('location'))
      <span class="error">
          {{ $errors->first('location') }}
      </span>
    @endif

    <label for="image">Image</label>
    <input id="image" type="file" name="image" accept="image/jpeg, image/png" class="black-font">
    @if ($errors->has('image'))
      <span class="error">
          {{ $errors->first('image') }}
      </span>
    @endif
    <div class="img-holder"></div>

    <label for="is_private" class="white-font">Privacy (*)</label>
    <select id="is_private" name="is_private" class="white-font" required>
        <option value="" disabled selected>-- select one --</option>
        <option value="is_public">Public</option>
        <option value="is_private">Private</option>
    </select>
    @if ($errors->has('is_private'))
      <span class="error">
          {{ $errors->first('is_private') }}
      </span>
    @endif

    <small class="white-font">(*) Required fields</small>

    <div class="crt-evt">
      <button type="submit" class="crt-evt-btn">
        Confirm
      </button>
    </div>
</form>
@if (session('error_ms'))
  <p class="red-font">
    {{ session('error_ms') }}
  </p>
@endif
@endsection
