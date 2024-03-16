@extends('layouts.app')

@section('title', 'Event Statistics')

@section('content')

<h2 class="white-font">
    {{ $event->name }} - Statistics
</h2>

<section class="event-infos">
  <div class="event-features specific-stat">
    <h2 class="list-title">
      Attendee list
    </h2>
    <ul class="attendee-list pdl1em ovflw">
      @foreach ($attendees as $attendee)
      <li> {{ $attendee->user->name }} | {{ $attendee->user->email }} | {{ $attendee->user->nationality }} </li>
      @endforeach
    </ul>
  </div>
  <div class="event-features specific-stat">
    <h2 class="list-title">
      Male Attendees
    </h2>
    <span>{{ $male_user }}</span>
  </div>
  <div class="event-features specific-stat">
    <h2 class="list-title">
      Female Attendees
    </h2>
    <span>{{ $female_user }}</span>
  </div>
  <div class="event-features specific-stat">
    <h2 class="list-title">
      Other Gender Attendees
    </h2>
    <span>{{ $other_user }}</span>
  </div>
  <div class="event-features specific-stat">
    <h2 class="list-title">
      Average Attendee Date of Birth
    </h2>
    <span>{{ $average_age }}</span>
  </div>
  <div class="event-features specific-stat">
    <h2 class="list-title">
      Average Attendee Join Date
    </h2>
    <span>{{ $average_join_date }}</span>
  </div>
  <div class="event-features specific-stat">
    <h2 class="list-title">
      Money Earned
    </h2>
    <span>{{ $money_earned }}€</span>
  </div>
  <div class="event-features specific-stat">
    <h2 class="list-title">
        Poll Count
    </h2>
    <span>{{ $poll_count }}</span>
  </div>
  <div class="event-features specific-stat">
    <h2 class="list-title">
        Comment Count
    </h2>
    <span>{{ $comment_count }}</span>
  </div>
  <div class="event-features specific-stat">
    <h2 class="list-title">
        Different Nationalities
    </h2>
    <ul class="attendee-list pdl1em ovflw">
      @foreach ($countries as $country)
        <li> {{ ucfirst($country) }} </li>
      @endforeach
    </ul>
  </div>
</section>

@endsection