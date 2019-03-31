{% extends theme %}

{% block head %}
    {{ parent() }}
    <style type="text/css">
    </style>
{% endblock %}

{% block info %}
<span>На этой странице работают горячие клавиши:</span>
<ul>
  <li> Enter - сохранить </li>
  <li> Alt+r - сбросить поля формы </li>
</ul>
{% endblock %}

{% block content %}

<div class="box box-primary" @keyup.enter="save_page" @keyup.alt.82="refresh_form">
	<!-- /.box-header -->
	<div class="box-body pad">

		<div id='name' :class="css_name" class="form-group">
			<label>Имя</label> <input v-model="name" type="text" class="form-control"
				placeholder="test name">
		</div>
		
		<div id='protocol' :class="css_protocol" class="form-group">
			<label>Протокол</label> <input v-model="protocol" type="text" class="form-control"
				placeholder="http">
		</div>
		
		<div id='hostname' :class="css_hostname" class="form-group">
			<label>Домен</label> <input v-model="hostname" type="text" class="form-control"
				placeholder="domain.com">
		</div>
		
		<div id="url" :class="css_url" class="form-group">
			<label>URL</label> <input v-model="url" type="text" class="form-control"
				placeholder="/path/to/page.html">
		</div>

	</div>
	<!-- /.box-body -->
	<div class="box-footer">
		<button v-on:click="save_page()" class="btn btn-primary">Сохранить
			изменения</button>
	</div>
	<!-- box-footer -->
	<div v-if='save_inprogress_app == 1' class="overlay">
  		<i class="fa fa-sync-alt fa-spin"></i>
	</div>
</div>

{% endblock %}

{% block footer %}
    <script type="text/javascript" src="/assets/js/app_sm_new_page.js"></script>
{% endblock %}