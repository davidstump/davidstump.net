---
layout: articles
title: Talks and Articles
description: Conference Talks and Articles by David Stump
image: assets/images/elixirconf.jpg
nav-menu: yes
---

<!-- Banner -->
<!-- Note: The "styleN" class below should match that of the header element. -->
<section id="banner" class="style2">
	<div class="inner">
		<span class="image">
			<img src="{{ site.baseurl }}/{{ page.image }}" alt="" />
		</span>
		<header class="major">
			<h1>Conference Talks and Articles</h1>
		</header>
		<div class="content">
			<p>{{ page.description }}</p>
		</div>
	</div>
</section>

<!-- Main -->
<div id="main">

{% for post in site.posts %}
    {% if post.title %}
        <!-- One -->
        <section id="one">
            <div class="inner post">
                <header class="major">
                    <a href="{{ post.url }}">
                        <h2>{{ post.title }}</h2>
                    </a>
                </header>
                {% if post.image %}
                    <a href="{{ post.url }}" class="image">
                        <img src="{{ post.image }}" alt="" data-position="center center" />
                    </a>
                {% endif %}
                <div class="excerpt">
                  {{ post.excerpt }}
                  <a href="{{ post.url }}">Read More &raquo;</a>
              </div>
            </div>
        </section>
    {% endif %}
{% endfor %}

<!-- Two -->
<!-- <section id="two" class="spotlights"> -->
<!-- 	<section> -->
<!-- 		<a href="generic.html" class="image"> -->
<!-- 			<img src="assets/images/pic08.jpg" alt="" data-position="center center" /> -->
<!-- 		</a> -->
<!-- 		<div class="content"> -->
<!-- 			<div class="inner"> -->
<!-- 				<header class="major"> -->
<!-- 					<h3>Orci maecenas</h3> -->
<!-- 				</header> -->
<!-- 				<p>Nullam et orci eu lorem consequat tincidunt vivamus et sagittis magna sed nunc rhoncus condimentum sem. In efficitur ligula tate urna. Maecenas massa sed magna lacinia magna pellentesque lorem ipsum dolor. Nullam et orci eu lorem consequat tincidunt. Vivamus et sagittis tempus.</p> -->
<!-- 				<ul class="actions"> -->
<!-- 					<li><a href="generic.html" class="button">Learn more</a></li> -->
<!-- 				</ul> -->
<!-- 			</div> -->
<!-- 		</div> -->
<!-- 	</section> -->
<!-- 	<section> -->
<!-- 		<a href="generic.html" class="image"> -->
<!-- 			<img src="assets/images/pic09.jpg" alt="" data-position="top center" /> -->
<!-- 		</a> -->
<!-- 		<div class="content"> -->
<!-- 			<div class="inner"> -->
<!-- 				<header class="major"> -->
<!-- 					<h3>Rhoncus magna</h3> -->
<!-- 				</header> -->
<!-- 				<p>Nullam et orci eu lorem consequat tincidunt vivamus et sagittis magna sed nunc rhoncus condimentum sem. In efficitur ligula tate urna. Maecenas massa sed magna lacinia magna pellentesque lorem ipsum dolor. Nullam et orci eu lorem consequat tincidunt. Vivamus et sagittis tempus.</p> -->
<!-- 				<ul class="actions"> -->
<!-- 					<li><a href="generic.html" class="button">Learn more</a></li> -->
<!-- 				</ul> -->
<!-- 			</div> -->
<!-- 		</div> -->
<!-- 	</section> -->
<!-- 	<section> -->
<!-- 		<a href="generic.html" class="image"> -->
<!-- 			<img src="assets/images/pic10.jpg" alt="" data-position="25% 25%" /> -->
<!-- 		</a> -->
<!-- 		<div class="content"> -->
<!-- 			<div class="inner"> -->
<!-- 				<header class="major"> -->
<!-- 					<h3>Sed nunc ligula</h3> -->
<!-- 				</header> -->
<!-- 				<p>Nullam et orci eu lorem consequat tincidunt vivamus et sagittis magna sed nunc rhoncus condimentum sem. In efficitur ligula tate urna. Maecenas massa sed magna lacinia magna pellentesque lorem ipsum dolor. Nullam et orci eu lorem consequat tincidunt. Vivamus et sagittis tempus.</p> -->
<!-- 				<ul class="actions"> -->
<!-- 					<li><a href="generic.html" class="button">Learn more</a></li> -->
<!-- 				</ul> -->
<!-- 			</div> -->
<!-- 		</div> -->
<!-- 	</section> -->
<!-- </section> -->

<!-- Three -->
<!-- <section id="three"> -->
<!-- 	<div class="inner"> -->
<!-- 		<header class="major"> -->
<!-- 			<h2>Massa libero</h2> -->
<!-- 		</header> -->
<!-- 		<p>Nullam et orci eu lorem consequat tincidunt vivamus et sagittis libero. Mauris aliquet magna magna sed nunc rhoncus pharetra. Pellentesque condimentum sem. In efficitur ligula tate urna. Maecenas laoreet massa vel lacinia pellentesque lorem ipsum dolor. Nullam et orci eu lorem consequat tincidunt. Vivamus et sagittis libero. Mauris aliquet magna magna sed nunc rhoncus amet pharetra et feugiat tempus.</p> -->
<!-- 		<ul class="actions"> -->
<!-- 			<li><a href="generic.html" class="button next">Get Started</a></li> -->
<!-- 		</ul> -->
<!-- 	</div> -->
<!-- </section> -->

</div>
