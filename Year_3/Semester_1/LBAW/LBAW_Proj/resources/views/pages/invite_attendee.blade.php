@extends('layouts.app')

@section('content')
<h2 class="white-font">Invite Attendee</h2>
<div class="status-messages" id="status-messages">
  <div class="success-msg bggreen pdi5" id="accepted-msg">
    <span>You have successfully joined the event!</span>
  </div>
  <div class="error-msg bgred pdi5" id="rejected-msg">
    <span>Something went wrong!</span>
  </div>
</div>
<div class="invite-atd-form">
  <div>
    <form class="white-font" id="invite-attendee">
        {{ csrf_field() }}

        <label for="user_id" class="white-font">User ID (*)</label>
        <input id="user_id" type="text" name="user_id" value="" required>
        @if ($errors->has('user_id'))
          <span class="error">
              {{ $errors->first('user_id') }}
          </span>
        @endif

        <input type="hidden" name="event_id" id="event_id" value="{{ $event_id }}">

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
