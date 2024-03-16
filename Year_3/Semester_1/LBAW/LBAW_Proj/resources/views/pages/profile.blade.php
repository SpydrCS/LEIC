@extends('layouts.app')

@section('title', 'Profile')

@section('content')

<h2 class="white-font">My Profile</h2>

<div class="big-div">
  <nav class="profile-menu-options">
    <div class="profile-menu-option" id="profile-info-option">
      <a class="menu-option white-font" onclick="profileMenu(1)">Profile Info</a>
    </div>
    <div class="profile-menu-option" id="my-events-option">
      <a class="menu-option white-font" onclick="profileMenu(2)">My Events</a>
    </div>
    <div class="profile-menu-option" id="personal-events-option">
      <a class="menu-option white-font" onclick="profileMenu(3)">Attending Events</a>
    </div>
  </nav>

  <div class="pdl100">
    <div id="profile-info">
      @each('partials.profile', $profile, 'profile')
    </div>

    @foreach ($profile as $user)
    @if (!$user->is_admin)
    <div class="all-personal-events">
      <div id="my-events" style="display:none">
        <div class="personal-events">
          <span class="personal-events-title personal-info-title">
            My Events:
          </span>
          @if (!Auth::user()->is_admin)
          <a href="/create_event/" class="">
            <div class="crt-event">
              +
            </div>
          </a>
          @endif
        </div>
        <div class="flexin-them">
          <div class="personal-events-list">
            @if (count($events) == 0 && !Auth::user()->is_admin)
            <div class="no-events">
              <span class="no-events-title white-font">
                You have not created any events yet.
              </span>
            </div>
            @elseif (count($events) == 0 && Auth::user()->is_admin)
            <div class="no-events">
              <span class="no-events-title white-font">
                This user has not created any events yet.
              </span>
            </div>
            @endif
            @each('partials.profile_my_events', $events, 'event')
          </div>
          <div class="legends mgl100">
            <div class="legend">
              <i class="fas fa-door-closed white-font mgb3"></i>
              <span class="legend-title white-font mgl10">
                Event is closed (click to open)
              </span>
            </div>
            <div class="legend">
              <i class="fas fa-door-open white-font mgb3"></i>
              <span class="legend-title white-font mgl10">
                Event is open (click to close)
              </span>
            </div>
            <div class="legend">
              <i class="fas fa-signal white-font mgb3"></i>
              <span class="legend-title white-font mgl10">
                Event statistics
              </span>
            </div>
            <div class="legend">
              <i class="fas fa-pencil-alt pencil-edit"></i>
              <span class="legend-title white-font mgl10">
                Edit event
              </span>
            </div>
            <div class="legend">
              <i class="fas fa-trash white-font"></i>
              <span class="legend-title white-font mgl10">
                Delete event
              </span>
            </div>
          </div>
        </div>
      </div>

      <div id="personal-events" style="display:none">
        <div class="upcoming-events">
          <div class="personal-events">
            <span class="personal-events-title personal-info-title">
              Upcoming Events:
            </span>
          </div>
          <div class="personal-events-list">
            @if (count($upcoming_events) == 0 && !Auth::user()->is_admin)
            <div class="no-events">
              <span class="no-events-title white-font">
                You have not signed up for any future events yet.
              </span>
            </div>
            @elseif (count($upcoming_events) == 0 && Auth::user()->is_admin)
            <div class="no-events">
              <span class="no-events-title white-font">
                This user has not signed up for any future events yet.
              </span>
            </div>
            @endif
            @each('partials.profile_event_list', $upcoming_events, 'attendee')
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
@endif
@endforeach

@endsection
