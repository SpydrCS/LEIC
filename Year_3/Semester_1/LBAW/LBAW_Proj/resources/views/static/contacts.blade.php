@extends('layouts.statics')

@section('content')

<div class="faq-bg">
    <h2>
        Contacts
    </h2>
</div>

<div class="about-row">
    <div class="contact-colum">
        <div>
            <img src="/images/phone-call.png" alt="Nils Image" class="white-font" style="width:25%">
            <div class="contact-cards">
                <h2>Call us</h2>
                <a href="tel:+3519123456789" style="font-size: x-large">09123 456789</a>
            </div>
        </div>
    </div>
    <div class="contact-colum">
        <div>
            <img src="/images/e-mail.png" alt="Nils Image" class="white-font" style="width:25%">
            <div class="contact-cards">
                <h2>Mail us</h2>
                <a href="mailto:info@powerevents.com" style="font-size: x-large">info@powerevents.com</a>
            </div>
        </div>
    </div>
</div>


@endsection
