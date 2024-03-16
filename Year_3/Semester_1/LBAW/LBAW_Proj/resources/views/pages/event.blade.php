@extends('layouts.app')

@section('title', 'Events')

@section('content')

@foreach ($event as $one)
<script>
  function showCountdown(date) {
    var countDownDate = new Date(date).getTime();

    var x = setInterval(function() {

      var now = new Date().getTime();

      var distance = countDownDate - now;

      if (distance < 1000 * 60 * 60 * 24 * 7) {
        document.getElementById("demo").classList.add("red-font");
      } else {
        document.getElementById("demo").classList.add("green-font");
      }

      var months = Math.floor(distance / (1000 * 60 * 60 * 24 * 30));
      var weeks = Math.floor((distance % (1000 * 60 * 60 * 24 * 30)) / (1000 * 60 * 60 * 24 * 7));
      var days = Math.floor((distance % (1000 * 60 * 60 * 24 * 7)) / (1000 * 60 * 60 * 24));
      var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
      var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
      var seconds = Math.floor((distance % (1000 * 60)) / 1000);

      document.getElementById("demo").innerHTML = months + "m " + weeks + "w " + days + "d " + hours + "h " + minutes + "m " + seconds + "s ";

      if (distance < 0) {
        clearInterval(x);
        document.getElementById("demo").innerHTML = "EVENT STARTED";
      }
    }, 1000);
  }
  
  showCountdown("{{ $one->start_datetime }}");
</script>
@endforeach

<div class="status-messages" id="status-messages">
  <div class="success-msg bggreen pdi5" id="accepted-msg">
    <span>You have successfully joined the event!</span>
  </div>
  <div class="error-msg bgred pdi5" id="rejected-msg">
    <span>Something went wrong!</span>
  </div>
</div>

<div class="status-messages" id="report-status">
  <div class="success-msg bggreen pdi5" id="accepted-report">
    <span>You have successfully joined the event!</span>
  </div>
  <div class="error-msg bgred pdi5" id="rejected-report">
    <span>Something went wrong!</span>
  </div>
</div>

<div class="event-img">
  @foreach ($event as $one)
  <div class="event-image">
    @if (file_exists('storage/images/' . $one->image))
      <img src="{{ asset('storage/images/' . $one->image)}}" alt="Event Image" class="white-font" height="200">
    @else
      <img src="{{ asset('images/events_default.jpg')}}" alt="Event Image" class="white-font" height="200">
    @endif
  </div>
  @endforeach
</div>

<div class="main-page">
  <div class="main-info">
    <div class="event-main">
      @each('partials.event', $event, 'event')
      <div class="pdl1em pdb10">
        <span class="white-font">Event starts in: </span>
        <span id="demo" class=""></span>
      </div>
    </div>

    <section class="event-infos">
      <div class="event-features">
        <div class="event-features-title">
          <h2 class="list-title">
              Event Features
          </h2>
          @foreach($event as $one)
          @if (Auth::check() && Auth::user()->id == $one->owner_id)
            <a href="{{ route('createFeature', $one->id) }}" class="add-feature">
              <div class="add-feature-icon">
                +
              </div>
            </a>
            <a href="{{ route('deleteFeature', $one->id) }}" class="delete-feature">
              <div class="delete-feature-icon add-feature-icon">
                <i class="fas fa-trash"></i>
              </div>
            </a>
          @endif
          @endforeach
        </div>
        <ul class="features-list pdl1em ovflw">
            @if (count($features) > 0)
            @foreach ($features as $feature)
              <li class="feature" data-id="{{$feature->id}}">
                <?php echo ucfirst($feature->feature) ?>
              </li>
            @endforeach
            @else
              <li class="feature">
                No features yet
              </li>
            @endif
        </ul>
      </div>
      <div class="event-features">
        <h2 class="list-title">
            Event Details
        </h2>
        <ul class="features-list pdl1em ovflw">
          @foreach ($event as $one)
          <li>Start-date:{{ substr($one->start_datetime,0,16) }}</li>
          <li>End-date: {{ substr($one->end_datetime,0,16) }} </li>
          <li>Event Location: {{ ucfirst($one->location) }} </li>
          @endforeach
        </ul>
        <div class="cover-bar"></div>
      </div>
        <div class="event-features">
          <div class="event-features-title">
            <h2 class="list-title">
              Attendee list
            </h2>
            @each('partials.invite_attendee', $event, 'event')
          </div>
          <ul class="attendee-list pdl1em ovflw">
            @if (count($attendees) > 0)
            @foreach ($attendees as $attendee)
              <li> {{ $attendee->user->name }} </li>
            @endforeach
            @else
              <li> No attendees yet </li>
            @endif
          </ul>
      </div>
    </section>
  </div>

  <div class="ticket-area">
    <div class="main-ticket">
      <h2 class="ticket-title">
        Save your spot right now!
      </h2>
      <span class="spots-txt">
        Limited spots available
      </span>
      @each('partials.event_capacity', $event, 'event')
      <div class="ticket-div">
        @foreach ($event as $one)
        <span class="white-font">
          @if ($one->price == 0)
              Free
          @else
              Standard Ticket - €{{ $one->price }}
          @endif
        </span>
        @endforeach
      </div>
      @if ((Auth::check() && !Auth::user()->is_admin) || !Auth::check())
        @each('partials.event_ticket', $event, 'event')
      @endif
      @if (session('error_ms'))
        <p class="red-font">
          {{ session('error_ms') }}
        </p>
      @endif
      @if (session('request_ms'))
        <p class="green-font">
          {{ session('request_ms') }}
        </p>
      @endif
    </div>
  </div>
</div>
@foreach ($event as $one)
@if (Auth::check() && (in_array(Auth::user()->id, $attendees_id) || Auth::user()->id == $one->owner_id))
<div class="event-polls-div">
  <h2 class="polls-title mgt20 mgl10 white-font no-margin">
    Event Polls
  </h2>
    @foreach ($event as $one)
      @if (Auth::check() && $one->owner_id == Auth::user()->id)
        <a href="#show-crt-form" onclick="showCreatePoll()" class="white-font crt-poll-btn" id="show-crt-form">+</a>
        <div class="crt-poll-form" id="crt-poll-form">
          <form method="POST" action="{{ route('createPoll', $one->id) }}">
            {{ csrf_field() }}
            <input type="text" class="form-control white-font" name="title" placeholder="Poll Title">
            <button type="submit" class="btn btn-primary crt-poll-form-btn new-font">Submit</button>
          </form>
        </div>
      @endif
    @endforeach
</div>
  <div class="event-polls mgt20">
    @foreach ($polls as $poll)
    <div class="specific-poll mgl10">
      <a href="{{ route('eventPoll', $poll->id) }}" id="poll-title-{{ $poll->id }}">
        <span class="poll-title white-font">
          {{ $poll->poll_title }}
        </span>
      </a>
      @if (Auth::check() && $poll->event->owner_id == Auth::user()->id)
      <form method="POST" action="{{ route('updatePoll', $poll->id) }}" id="update-poll-{{ $poll->id }}" class="mgt3 update-poll-page">
        {{ csrf_field() }}
        <input type="text" class="form-control white-font" name="title" placeholder="Poll Title" value="{{ $poll->poll_title }}">
        <button type="submit" class="btn btn-primary crt-poll-form-btn new-font mgb3 nmgl">Submit</button>
      </form>
      <button onclick="editPoll({{ $poll->id }})" class="edit-poll-btn">
        <i class="fas fa-edit"></i>
      </button>
      <form method="POST" action="{{ route('deletePoll', $poll->id) }}">
        {{ csrf_field() }}
        <button type="submit" class="edit-poll-btn">
          <i class="fas fa-trash"></i>
        </button>
      </form>
      @endif
    </div>
    @endforeach
  </div>
@endif
@endforeach

@endsection
