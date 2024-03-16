@extends('layouts.app')

@section('content')
<h2 class="white-font">Create Feature</h2>
<div class="general">
  <div class="crt-feature-div">
    <form method="POST" action="{{ route('createEventFeature', $event_id) }}" class="white-font">
        {{ csrf_field() }}

        <label for="feature" class="white-font">Feature (*)</label>
        <input id="feature" type="text" name="feature" value="{{ old('feature') }}" required>
        @if ($errors->has('feature'))
          <span class="error">
              {{ $errors->first('feature') }}
          </span>
        @endif

        <small class="white-font">(*) Required fields</small>

        <div class="crt-feature">
          <button type="submit" class="crt-feature-btn">
            Confirm
          </button>
        </div>
    </form>
  </div>
</div>
@endsection
