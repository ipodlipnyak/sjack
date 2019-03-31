{% extends theme %}

{% block head %}
    {{ parent() }}
{% endblock %}

{% block content %}
<div class="row">
<div class="col-md-6">
<div class="box box-primary">
	<div class="box-header">
		<h3 class="box-title">
			Настройки профиля
		</h3>
		<div class="pull-right box-tools">
		</div>
	</div>
	<!-- /.box-header -->
	<div class="box-body pad">
		<div class="form-group">
			<label>Login</label> <input v-model="user.login" type="text" class="form-control"
				placeholder="some@email.com">
		</div>

		<div class="form-group">
			
			<label>Email</label> <input v-model="user.email" type="email" class="form-control"
				placeholder="some@email.com">
		</div>

	</div>
	<!-- /.box-body -->
	<div class="box-footer">
		<button v-on:click="save_user()" class="btn btn-primary">Сохранить
			изменения</button>
	</div>
	<!-- box-footer -->
	<div v-if='save_inprogress_user == 1' class="overlay">
  		<i class="fa fa-sync-alt fa-spin"></i>
	</div>
</div>
</div>
<div class="col-md-6">
<div class="box box-primary">
	<div class="box-header">
		<h3 class="box-title">
			Сменить пароль
		</h3>
		<div class="pull-right box-tools">
		<span v-if="pass_confirmed == 0">Пароли не совпадают</span>
		</div>
	</div>
	<!-- /.box-header -->
	<div class="box-body pad">
		<div class="form-group" v-bind:class="[pass_confirmed ? 'has-success' : 'has-error']">
			<label>Новый пароль</label> <input v-model="new_password" type="password" class="form-control">
		</div>
		
		<div class="form-group" v-bind:class="[pass_confirmed ? 'has-success' : 'has-error']">
			<label>Подтвердить пароль</label> <input v-model="password_confirmation" type="password" class="form-control">
		</div>

	</div>
	<!-- /.box-body -->
	<div class="box-footer">
		<button v-on:click="save_password()" class="btn btn-primary">Сохранить
			изменения</button>
	</div>
	<!-- box-footer -->
	<div v-if='save_inprogress_password == 1' class="overlay">
  		<i class="fa fa-sync-alt fa-spin"></i>
	</div>
</div>
</div>
</div>

<div class="box box-primary">
	<div class="box-header">
		<h3 class="box-title">
			Общие настройки сайта
		</h3>
		<div class="pull-right box-tools">
		</div>
	</div>
	<!-- /.box-header -->
	<div class="box-body pad">

		<div class="form-group">
			<label>Доменное имя сайта</label> <input v-model="app_config.app_hostname" type="text" class="form-control"
				placeholder="some@email.com">
		</div>
		
		<div class="form-group">
			<label>Протокол</label> <input v-model="app_config.app_protocol" type="text" class="form-control"
				placeholder="some@email.com">
		</div>
		
		<div class="checkbox">
			<label>
            	<input v-model="app_config.app_secure"   true-value="true" false-value="false" type="checkbox"> Включить принудительное требование SSL при авторизации
        	</label>
		</div>

	</div>
	<!-- /.box-body -->
	<div class="box-footer">
		<button v-on:click="save_app()" class="btn btn-primary">Сохранить
			изменения</button>
	</div>
	<!-- box-footer -->
	<div v-if='save_inprogress_app == 1' class="overlay">
  		<i class="fa fa-sync-alt fa-spin"></i>
	</div>
</div>

{% endblock %}

{% block footer %}
    <script type="text/javascript" src="/assets/js/app_config.js"></script>
{% endblock %}