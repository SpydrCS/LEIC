@extends('layouts.app')

@section('title', 'Events')

@section('content')

@foreach ($events as $event)
<script>
  function showCountdown(date = "") {

    var countDownDate = new Date(date).getTime();

    var x = setInterval(function() {

      var now = new Date().getTime();

      var distance = countDownDate - now;

      var months = Math.floor(distance / (1000 * 60 * 60 * 24 * 30));
      var weeks = Math.floor((distance % (1000 * 60 * 60 * 24 * 30)) / (1000 * 60 * 60 * 24 * 7));
      var days = Math.floor((distance % (1000 * 60 * 60 * 24 * 7)) / (1000 * 60 * 60 * 24));
      var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
      var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
      var seconds = Math.floor((distance % (1000 * 60)) / 1000);

      document.getElementById("date-" + "{{ $event->id }}").innerHTML = "<i class='fas fa-calendar-alt'></i> " +   months + "m " + weeks + "w " + days + "d " + hours + "h " + minutes + "m " + seconds + "s ";

      if (distance < 0) {
        clearInterval(x);
        document.getElementById("date-" + "{{ $event->id }}").innerHTML = "EVENT STARTED";
      }
    }, 1000);
  }
  
  showCountdown("{{ $event->start_datetime }}");
</script>
@endforeach

<div class="title-section">
  <h2 class="filters-title">Filters</h2>
  @if (Auth::check())
  <div class="event-filters">
    <select class="event-filter-options white-font new-font" onchange="showEvents(value)">
      <option value="all" selected>Privacy</option>
      <option value="public">Public</option>
      <option value="private">Private</option>
    </select>
  </div>
  @endif
  <div class="event-tags event-filters mgl10">
    <select class="event-filter-options white-font new-font" onchange="showTags(value)">
      <option value="all" selected>Tags</option>
      @foreach ($tags as $tag)
        <option value="{{ $tag }}">{{ $tag }}</option>
      @endforeach
    </select>
  </div> 
  <div class="event-tags event-filters mgl10">
    <select class="event-filter-options white-font new-font" onchange="showLocations(value)">
      <option value="all" selected>Locations</option>
      @foreach ($locations as $location)
        <option value="{{ $location }}">{{ ucfirst($location) }}</option>
      @endforeach
    </select>
  </div> 
  <div class="event-tags event-filters mgl10">
    <select class="event-filter-options white-font new-font" onchange="redirectPage(value)">
      <option value="all" selected>Date</option>
      <option value="5">All</option>
      <option value="1">Today</option>
      <option value="2">This Week</option>
      <option value="3">This Month</option>
      <option value="4">This Year</option>
    </select>
  </div> 
  <div class="event-tags event-filters190 mgl230">
    <input type="text" class="event-filter-options white-font new-font search-bar" value="" placeholder="Search" onchange="showName(this.value)">
  </div>
  @if (Auth::check())
    @if (!Auth::user()->is_admin)
    <div class="create-event">
      <a class="button mgt100 rgt" href="/create_event/">Create Event</a>
    </div>
    @endif
  @endif
</div>

<div class="everything">
  <div class="status-messages" id="status-messages">
    <div class="accepted-message bggreen pdr10" id="accepted-msg">
      <span class="accepted-message-title white-font pdl5">
        You have been accepted to the event.
      </span>
    </div>
    <div class="rejected-message bgred pdr10" id="rejected-msg">
      <span class="rejected-message-title white-font pdl5">
        You have been rejected from the event.
      </span>
    </div>
  </div>  

  <div class="events">
    @if (count($events) == 0)
      <div class="no-events">
        <span class="no-events-title white-font">
          There are no events yet.
        </span>
      </div>
    @endif
    <div id="no-events" class="pdt50">
      <span class="no-events-title white-font">
        There are no events with that name or tag yet.
      </span>
    </div>
    @each('partials.events', $events, 'event')
  </div>
</div>

@endsection
