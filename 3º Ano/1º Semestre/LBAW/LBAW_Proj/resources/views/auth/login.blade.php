@extends('layouts.login')

@section('content')
<form method="POST" action="{{ route('login') }}" class="mgt13em">
    {{ csrf_field() }}

    <label for="email" class="white-font">E-mail (*)</label>
    <input id="email" type="email" name="email" value="{{ old('email') }}" required autofocus>
    @if ($errors->has('email'))
        <span class="error">
          {{ $errors->first('email') }}
        </span>
    @endif

    <label for="password" class="white-font">Password (*)</label>
    <input id="password" type="password" name="password" required>
    @if ($errors->has('password'))
        <span class="error">
            {{ $errors->first('password') }}
        </span>
    @endif

    <small class="white-font pdbl10">(*) Required fields</small>

    <section class="all-btns">
        <div class="btn-div">
            <button type="submit" class="btnz">
                Login
            </button>
        </div>
        <div class="mgn"></div>
        <div class="btn-div">
            <a href="{{ route('register') }}" class="btnz button">
                Register
            </a>
        </div>
        <div class="mgn"></div>
        <div class="btn-div">
            <a href="/events/all" class="btnz button">
                Homepage
            </a>
        </div>
    </section>
</form>
@endsection
