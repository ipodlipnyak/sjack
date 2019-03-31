<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>{{ title }}</title> {% block head %}
<link rel="icon" href="/favicon.svg" type="image/svg+xml" sizes="50x50">
<!-- Tell the browser to be responsive to screen width -->
<meta
	content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"
	name="viewport">
<link rel="stylesheet"
	href="/node_modules/bootstrap/dist/css/bootstrap.min.css">
<!-- Font Awesome -->
<link rel="stylesheet"
	href="https://use.fontawesome.com/releases/v5.4.1/css/all.css"
	integrity="sha384-5sAR7xN1Nv6T6+dT2mhtzEpVJvfS3NScPQTrOxhwjIuvcA67KV2R5Jz6kr4abQsz"
	crossorigin="anonymous">
<!-- Ionicons -->
<link href="https://unpkg.com/ionicons@4.4.6/dist/css/ionicons.min.css"
	rel="stylesheet">
<!-- Theme style -->
<link rel="stylesheet" href="/assets/dist/css/AdminLTE.min.css">
<!-- AdminLTE Skins. We have chosen the skin-blue for this starter
        page. However, you can choose any other skin. Make sure you
        apply the skin class to the body tag so the changes take effect. -->
<link rel="stylesheet" href="/assets/dist/css/skins/skin-blue.min.css">

<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
<!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  <![endif]-->

<!-- Google Font -->
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700,300italic,400italic,600italic">
<link rel="stylesheet"
	href="/node_modules/vue-wysiwyg/dist/vueWysiwyg.css">

{% endblock %}

<base>
</head>
<!--
BODY TAG OPTIONS:
=================
Apply one or more of the following classes to get the
desired effect
|---------------------------------------------------------|
| SKINS         | skin-blue                               |
|               | skin-black                              |
|               | skin-purple                             |
|               | skin-yellow                             |
|               | skin-red                                |
|               | skin-green                              |
|---------------------------------------------------------|
|LAYOUT OPTIONS | fixed                                   |
|               | layout-boxed                            |
|               | layout-top-nav                          |
|               | sidebar-collapse                        |
|               | sidebar-mini                            |
|---------------------------------------------------------|
-->
<body class="hold-transition skin-blue sidebar-mini">
	<div class="wrapper">

		<!-- Main Header -->
		<header class="main-header">

			<!-- Logo -->
			<a href="/" class="logo"> <!-- mini logo for sidebar mini 50x50 pixels -->
				<span class="logo-mini"><img alt="" src="/favicon.svg"></span> <!-- logo for regular state and mobile devices -->
				<span class="logo-lg">Dashboard</span>
			</a>

			<!-- Header Navbar -->
			<nav class="navbar navbar-static-top" role="navigation">
				<!-- Sidebar toggle button-->
				<a href="#" class="sidebar-toggle" data-toggle="push-menu"
					role="button"> <span class="sr-only">Toggle navigation</span>
				</a>


{% set _block = block('info') %}
{% if _block is not empty %}
      <div class="navbar-custom-menu">
        <ul class="nav navbar-nav">
          <!-- Messages: style can be found in dropdown.less-->
          <li class="dropdown messages-menu">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
              <i class="fa fa-question"></i>
            </a>
            <ul class="dropdown-menu">
              <li class="header">{% block info %}{% endblock %}</li>
            </ul>
          </li>
          
        </ul>
      </div>
{% endif %}

			</nav>
		</header>

		<!-- Left side column. contains the logo and sidebar -->
		<aside class="main-sidebar">

			<!-- sidebar: style can be found in sidebar.less -->
			<section class="sidebar">

				<!-- Sidebar user panel (optional) -->
				<div class="user-panel">
					<div class="pull-left image">
						<!--           <img src="/assets/dist/img/user2-160x160.jpg" class="img-circle" alt="User Image"> -->
						<img src="/assets/images/Material_Person_150_w.svg"
							class="img-circle" alt="User Image">
					</div>
					<div class="pull-left info">
						<p>{{ login }}</p>
          				<a><i class="fa fa-circle text-success"></i> Online</a>
					</div>
				</div>

				<!-- search form (Optional)
      <form action="#" method="get" class="sidebar-form">
        <div class="input-group">
          <input type="text" name="q" class="form-control" placeholder="Search...">
          <span class="input-group-btn">
              <button type="submit" name="search" id="search-btn" class="btn btn-flat"><i class="fa fa-search"></i>
              </button>
            </span>
        </div>
      </form>
      /.search form -->

				<!-- Sidebar Menu -->
				<ul class="sidebar-menu" data-widget="tree">
					<li class="header">Разделы</li>
					<!-- Optionally, you can add icons to the links -->

					{% for link in menu_links %}
					<li class="{{ link.class }}">
						<a href="{{ link.url }}"><i class="fa fa-circle"></i> <span>{{ link.name }}</span>
						{% if link.nested_ul %}
						<span class="pull-right-container">
                        	<i class="fa fa-angle-left pull-right"></i>
                		</span>
                		{% endif %}
						</a>
						{% if link.nested_ul %}
						<ul class="treeview-menu">
						{% for nested_link in link.nested_ul %}
						<li class="{{ nested_link.class }}">
						<a href="{{ nested_link.url }}"><i class="fa fa-circle"></i> <span>{{ nested_link.name }}</span></a>
						</li>
						{% endfor %}
        				</ul>
						
						{% endif %}
					</li>
					{% endfor %}

				</ul>
				<!-- /.sidebar-menu -->
			</section>
			<!-- /.sidebar -->
		</aside>

		<!-- Content Wrapper. Contains page content -->
		<div class="content-wrapper">
			<!-- Content Header (Page header) -->
			<section class="content-header">
				<h1>
					{{ title }}
					<!--         <small>Optional description</small> -->
				</h1>
				<!-- Breadcrumbs
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Level</a></li>
        <li class="active">Here</li>
      </ol>
       -->
			</section>

			<!-- Main content -->
			<section id="main-content" class="content container-fluid">

      <!--------------------------
        | Your Page Content Here |
        -------------------------->

				{% block content %}{% endblock %}

			</section>
			<!-- /.content -->
		</div>
		<!-- /.content-wrapper -->

		<!-- Main Footer -->
		<footer class="main-footer">
			<!-- To the right -->
			<div class="pull-right hidden-xs">
				<!--       Anything you want -->
			</div>
			<!-- Default to the left -->
			<strong><a href="">Foo Corp.</a></strong> 
			{% block footer %}
			<script type="text/javascript" src="/assets/js/app_main.js"></script>
			{% endblock %}
		</footer>

	</div>
	<!-- ./wrapper -->

</body>
</html>
