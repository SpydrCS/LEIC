<!DOCTYPE html>
<html lang="{{ app()->getLocale() }}">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- CSRF Token -->
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <title>{{ config('app.name', 'Laravel') }}</title>

    <!-- Styles -->
    <link href="{{ asset('css/milligram.min.css') }}" rel="stylesheet">
    <link href="{{ asset('css/app.css') }}" rel="stylesheet">
    <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.12.1/css/all.min.css'>
    <link href="//db.onlinewebfonts.com/c/d1a880e08bdb2140abd96f8f8d2d9515?family=Bloc" rel="stylesheet" type="text/css">

    <!-- <link href="https://fonts.googleapis.com/css?family=Lato:300,400,700,900&display=swap" rel="stylesheet">
    <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.1.3/css/bootstrap.min.css'>
    Only for demo purpose - no need to add.-->

    <script>
        // Fix for Firefox autofocus CSS bug
        // See: http://stackoverflow.com/questions/18943276/html-5-autofocus-messes-up-css-loading/18945951#18945951
    </script>
    <script src={{ asset('js/app.js') }} defer></script>
    <script src={{ asset('js/ajax.js') }} defer></script>
  </head>
  <body>
    <main>
      <header>
        <h1><a href="{{ url('/events/all') }}">PowerEvents</a></h1>
        @if (Auth::check())
        @if (!Auth::user()->is_admin)
        <span class="white-font" id="header-balance-{{ Auth::user()->id}}">
          €{{ number_format(Auth::user()->wallet_balance,2) }}
        </span>
        @endif
        <div class="al-btnz">
          <div class="lgt-btn">
            <a class="button lgt-btn-real" href="{{ url('/logout') }}">Logout</a>
          </div>
          <div class="profile-btn">
            <a class="button profile-btn-real" href="/users/{{ Auth::user()->id }}"> {{ Auth::user()->name }} </a>
          </div>
        </div>
        @else
        <div class="al-btnz">
          <div class="lgt-btn">
            <a class="button lgt-btn-real" href="{{ url('/login') }}">Login</a>
          </div>
          <div class="profile-btn">
            <a class="button profile-btn-real" href="{{ url('/register') }}">Register</a>
          </div>
        </div>
        @endif
      </header>
      <section id="content">
        @yield('content')
      </section>
    </main>
    <footer class="main-footer mgt20 pdb5">
      <span class="footer-content">
        © PowerEvents 2022
      </span>
      <div class="footer-links">
        <a href="/about">About Us</a>
        <a href="/contacts">Contacts</a>
        <a href="/faq">FAQ</a>
      </div>
    </footer>
  </body>
</html>