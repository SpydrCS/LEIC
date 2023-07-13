@extends('layouts.statics')

@section('content')

<div class="faq-bg">
    <h2>
        FAQ
    </h2>
</div>

<div id="content" class="faq-section">
    <nav class="faq-btns-container">
        <a href="#abt-pe-title">
            <div class="faq-btn">
                About PowerEvents
            </div>
        </a>
        <a href="#reg-title" class="mgi10">
            <div class="faq-btn">
                Registration
            </div>
        </a>
        <a href="#canc-title">
            <div class="faq-btn">
                Cancellations
            </div>
        </a>
    </nav>
    <div class="all-faqs new-font">
        <div class="main-faq">
            <a onclick="showFAQ('abt-pe', 1)">
                <div class="faq-intro">
                    <h2 class="white-font mgl10" id="abt-pe-title">
                        <i class="fas fa-angle-right"></i> ABOUT POWEREVENTS
                    </h2>
                </div>
            </a>
            <section class="specific-faqs mgl10" id="abt-pe">
                <div class="faq">
                    <h3 class="faq-title">
                        What is PowerEvents?
                    </h3>
                    <p class="faq-text">
                        PowerEvents is a platform that allows you to create and attend events. You can create events and invite your friends to attend them. You can also attend events created by other users.
                    </p>
                </div>
                <div class="faq">
                    <h3 class="faq-title">
                        How do I create an event?
                    </h3>
                    <p class="faq-text">
                        To create an event, you must be logged in. Once you are logged in, you can click on the "Create Event" button on the navigation bar. You will then be redirected to the event creation page. Fill in the required information and click on the "Create Event" button.
                    </p>
                </div>
                <div class="faq">
                    <h3 class="faq-title">
                        How do I attend an event?
                    </h3>
                    <p class="faq-text">
                        To attend an event, you must be logged in. Once you are logged in, you can click on the "Events" button on the navigation bar. You will then be redirected to the events page. You can then click on the "Attend" button on the event you wish to attend.
                    </p>
                </div>
                <div class="faq">
                    <h3 class="faq-title">
                        How do I cancel my attendance to an event?
                    </h3>
                    <p class="faq-text">
                        To cancel your attendance to an event, you must be logged in. Once you are logged in, you can click on the "Events" button on the navigation bar. You will then be redirected to the events page. You can then click on the "Cancel Attendance" button on the event you wish to cancel your attendance to.
                    </p>
                </div>
                <div class="faq">
                    <h3 class="faq-title">
                        How do I cancel an event?
                    </h3>
                    <p class="faq-text">
                        To cancel an event, you must be logged in. Once you are logged in, you can click on the "Events" button on the navigation bar. You will then be redirected to the events page. You can then click on the "Cancel Event" button on the event you wish to cancel
                    </p>
                </div>
            </section>
        </div>
        <div class="main-faq">
            <a onclick="showFAQ('reg', 2)">
                <div class="faq-intro">
                    <h2 class="white-font mgl10" id="reg-title">
                        <i class="fas fa-angle-right"></i> REGISTRATION
                    </h2>
                </div>
            </a>
            <section class="specific-faqs mgl10" id="reg">
                <div class="faq">
                    <h3 class="faq-title">
                        How much does PowerEvents cost to use?
                    </h3>
                    <p class="faq-text">
                        PowerEvents is free to use! Just sign up and start creating and attending events!
                    </p>
                </div>
                <div class="faq">
                    <h3 class="faq-title">
                        What is the payment policy for events?
                    </h3>
                    <p class="faq-text">
                        You can add funds in your profile page and when you join an event, the funds will be deducted from your account. If you cancel your attendance to an event, the funds will be added back to your account.
                    </p>
                </div>
            </section>
        </div>
        <div class="main-faq">
            <a onclick="showFAQ('canc', 3)">
                <div class="faq-intro">
                    <h2 class="white-font mgl10" id="canc-title">
                        <i class="fas fa-angle-right"></i> CANCELLATIONS
                    </h2>
                </div>
            </a>
            <section class="specific-faqs mgl10" id="canc">
                <div class="faq">
                    <h3 class="faq-title">
                        What is the cancellation policy?
                    </h3>
                    <p class="faq-text">
                        You can cancel you attendance by going to your profile page and clicking the bin button next to the event. If you cancel your attendance to an event, the funds will be added back to your account.    
                    </p>
                </div>
            </section>
        </div>
    </div>
</div>

@endsection